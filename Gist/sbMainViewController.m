//
//  sbMainViewController.m
//  Gist
//
//  Created by Sacha Best on 2/14/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import "sbMainViewController.h"

@implementation sbMainViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // The className to query on
        self.parseClassName = @"Inbox";
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Uncomment the following line to specify the key of a PFFile on the PFObject to display in the imageView of the default cell style
        // self.imageKey = @"image";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
    }
    return self;
}
- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    
    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if (self.objects.count == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    // This should be editable by the user in the view....
    [query orderByDescending:@"priority"];
    
    return query;
}
- (void)logInViewController:(PFLogInViewController *)controller
               didLogInUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES];
    _appDelegate.parseData = [[GistParseStorage alloc] init];
}

- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    UIAlertView *cannotCancel = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must log in to use Gist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [cannotCancel show];
    // user cannot cancel...
}
- (void)signUpiewController:(PFSignUpViewController *)controller
               didLogInUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES];
    _appDelegate.parseData = [[GistParseStorage alloc] init];
}

- (void)signUpViewControllerDidCancelLogIn:(PFSignUpViewController *)logInController {
    UIAlertView *cannotCancel = [[UIAlertView alloc] initWithTitle:@"Error" message:@"You must log in to use Gist" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [cannotCancel show];
    // user cannot cancel...
}
- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tableView.rowHeight = 70;
    PFUser *currentUser = [PFUser currentUser];
    _appDelegate = (sbAppDelegate *) [[UIApplication sharedApplication] delegate];
    if (currentUser) {
        _appDelegate.parseData = [[GistParseStorage alloc] init];
    }
    else {
        PFLogInViewController *logInController = [[PFLogInViewController alloc] init];
        logInController.fields = PFLogInFieldsUsernameAndPassword
                                 | PFLogInFieldsFacebook
                                 | PFLogInFieldsSignUpButton;
        logInController.facebookPermissions = @[@"friends_about_me"];
        logInController.delegate = self;
        UITextField *phone = [[UITextField alloc] init];
        phone.placeholder = @"xxx-xxx-xxxx";
        PFSignUpView *signUp = logInController.signUpController.view;
        logInController.signUpController.view = [[PFSignUpView alloc] initWithFields:PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsAdditional | PFSignUpFieldsSignUpButton];
        [self presentModalViewController:logInController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *cellIdentifier = @"Cell";
    
    sbTaskCell *cell = (sbTaskCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[sbTaskCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier];
    }
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = object[@"name"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",
                                 object[@"priority"]];
    
    return cell;
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
