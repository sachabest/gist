//
//  MasterViewController.m
//  Many
//
//  Created by Sacha Best on 1/26/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import "FriendsViewController.h"

@interface FriendsViewController ()
@end

@implementation FriendsViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        ABAddressBookRef contactBook = ABAddressBookCreateWithOptions(NULL, NULL);
        if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
            ABAddressBookRequestAccessWithCompletion(contactBook, ^(bool granted, CFErrorRef error){
                if (granted) {
                    // First time access has been granted, add the contact
                    [self performSelectorInBackground:@selector(getContactsWithABRef:) withObject:(__bridge id)(contactBook)];
                } else {
                    // User denied access
                    // Display an alert telling user the contact could not be added
                }
            });
        }
        else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
            [self performSelectorInBackground:@selector(getContactsWithABRef:) withObject:(__bridge id)(contactBook)];
        }
    }
    return self;
}
- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super.view addSubview:_loading];
    [_loading startAnimating];
    [super awakeFromNib];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [[self tableView] setRowHeight:60.0];
    /* self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];*/
    sbAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    _friends = [[delegate parseData] friends];
    _contactsWithPhone = [[NSMutableArray alloc] init];
    _loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _loading.hidesWhenStopped = YES;
    _loading.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
    _loading.center = super.view.center;
        UISwipeGestureRecognizer* goBack = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(goBack:)];
    goBack.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:goBack];
}
- (void)getContactsWithABRef:(ABAddressBookRef)ref {
    NSArray *allContacts = (__bridge_transfer NSMutableArray *)(ABAddressBookCopyArrayOfAllPeople(ref));
    CFIndex contactNum = CFArrayGetCount((__bridge CFArrayRef)(allContacts));
    for (int i = 0; i < contactNum; i++) {
        ABRecordRef ref = CFArrayGetValueAtIndex((__bridge CFMutableArrayRef)(allContacts), i);
        NSString *firstName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonFirstNameProperty));
        NSString *lastName = (__bridge NSString *)(ABRecordCopyValue(ref, kABPersonLastNameProperty));
        ABMultiValueRef phones = (__bridge ABMultiValueRef)((__bridge NSString *)ABRecordCopyValue(ref, kABPersonPhoneProperty));
        NSString* mobile=@"";
        NSString* mobileLabel;
        bool hasMobile = false;
        for (CFIndex i = 0; i < ABMultiValueGetCount(phones); i++) {
            hasMobile = false;
            mobileLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phones, i);
            if ([mobileLabel isEqualToString:(NSString *)kABPersonPhoneMobileLabel]) {
                mobile = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
                hasMobile = true;
            }
            else if ([mobileLabel isEqualToString:(NSString*)kABPersonPhoneIPhoneLabel]) {
                mobile = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phones, i);
                hasMobile = true;
                break;
            }
        }
        bool shouldAdd = true;
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        if (!hasMobile)
            continue;
        else {
            mobile = [FriendCell trimNumber:mobile];
        }
        if (firstName)
            [dic setObject:firstName forKey:@"firstName"];
        if (lastName)
            [dic setObject:lastName forKey:@"lastName"];
        if (mobile) {
            [dic setObject:mobile forKey:@"phoneNumber"];
            /**
             * This code checks for duplicates before adding
             **/
            for (NSDictionary *content in _contactsWithPhone) {
                if ([[content objectForKey:@"phoneNumber"] isEqualToString:mobile]) {
                    shouldAdd = false;
                    break;
                }
            }
        }
        if (shouldAdd)
            [_contactsWithPhone addObject:dic];
    }
    NSSortDescriptor *firstDescriptor =
    [[NSSortDescriptor alloc] initWithKey:@"firstName"
                                ascending:YES
                                 selector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *descriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [_contactsWithPhone sortedArrayUsingDescriptors:descriptors];
    NSLog(@"contacts %d", _contactsWithPhone.count);
    _contactsWithPhone = [[NSMutableArray alloc] initWithArray:sortedArray];
    [[self tableView] reloadData];
    [_loading stopAnimating];
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 3;
        case 1:
            return _contactsWithPhone.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCell *cell = [[FriendCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (indexPath.section == 0) {
        // Placeholder
        return cell;
    }
    NSDictionary *friend = [_contactsWithPhone objectAtIndex:indexPath.row];
    [cell setFirstName:[friend objectForKey:@"firstName"] lastName:[friend objectForKey:@"lastName"]];
    [cell setPhoneNumber:[friend objectForKey:@"phoneNumber"]];
    PFQuery *search = [[PFQuery alloc] initWithClassName:@"User"];
    [search whereKey:@"phoneNumber" equalTo:[friend objectForKey:@"phoneNumber"]];
    NSArray *results = [search findObjects];
    if (results.count > 0) {
        [cell setOnParse:results[0]];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *title = [[UILabel alloc] init];
    if (section == 0) {
        title.text = @"Groups";
    }
    else
        title.text = @"Contacts";
    return title;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[tableView cellForRowAtIndexPath:indexPath] setBackgroundColor:[UIColor lightGrayColor]];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        PFObject *object = _friends[indexPath.row];
        //self.detailViewController.detailItem = object;
    }
}
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    //
}
- (IBAction)send:(id)sender {
    _selection = [self sendSelection];
    ((sbCreateViewController *)self.parentViewController).assignees = _selection;
}
- (NSMutableArray *)sendSelection {
    NSArray *selected = [self.tableView indexPathsForSelectedRows];
    NSMutableArray *transposed = [[NSMutableArray alloc] init];
    for (NSIndexPath *path in selected) {
        NSDictionary *temp =  [_contactsWithPhone objectAtIndex:path.row];
        
    }
    return transposed;
}

@end
