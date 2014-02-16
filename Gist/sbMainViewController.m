//
//  sbMainViewController.m
//  Gist
//
//  Created by Sacha Best on 2/14/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import "sbMainViewController.h"

@interface sbMainViewController() {
    NSString *username;
}

@end
@implementation sbMainViewController

- (id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        _urgent = [[UIColor alloc] initWithRed:228 green:82 blue:52 alpha:1];
        _today = [[UIColor alloc] initWithRed:15 green:145 blue:143 alpha:1];
        _tomorrow = [[UIColor alloc] initWithRed:0 green:159 blue:153 alpha:1];
        _thisWeek = [[UIColor alloc] initWithRed:67 green:170 blue:164 alpha:1];
        _nextWeek = [[UIColor alloc] initWithRed:137 green:203 blue:192 alpha:1];
        _later = [[UIColor alloc] initWithRed:233 green:228 blue:227 alpha:1];
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
        _logIn = [[PFLogInViewController alloc] init];
        _logIn.fields = PFLogInFieldsUsernameAndPassword
                                 | PFLogInFieldsFacebook
                                 | PFLogInFieldsLogInButton
                                 | PFLogInFieldsSignUpButton;
        _logIn.facebookPermissions = @[@"friends_about_me"];
        _logIn.delegate = self;
        PFSignUpViewController *signUp = [[PFSignUpViewController alloc] init];
        signUp.delegate = self;
        signUp.fields = PFSignUpFieldsUsernameAndPassword | PFSignUpFieldsAdditional | PFSignUpFieldsSignUpButton;
        [_logIn setSignUpController:signUp];
        ((PFSignUpView *)_logIn.signUpController.view).additionalField.placeholder = @"Phone";
       // [((PFSignUpView *)_logIn.signUpController.view).signUpButton addTarget:self action:@selector(signUpViewController:shouldBeginSignUp:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissKeyboard)];
        tap.cancelsTouchesInView = NO;
        [_logIn.signUpController.view addGestureRecognizer:tap];
        [self presentModalViewController:_logIn animated:YES];

    }
}
-(void)dismissKeyboard {
    if (_logIn) {
        [((PFSignUpView *)_logIn.signUpController.view).additionalField resignFirstResponder];
        [((PFSignUpView *)_logIn.signUpController.view).usernameField resignFirstResponder];
        [((PFSignUpView *)_logIn.signUpController.view).passwordField resignFirstResponder];
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
    [cell addTask:object];
    cell.textLabel.text = object[@"title"];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Priority: %@",
                                 object[@"priority"]];
    
    return cell;
}


#pragma mark - Parse Login and Signup Delegate Methods

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSLog(@"%@", key);
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
        if ([key isEqualToString:@"username"]) {
            username = [info objectForKey:key];
        }
    }
    if ([info objectForKey:@"additional"]) {
        [info setValue:[FriendCell trimNumber:info[@"additional"]] forKey:@"additional"];
    }
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [PFUser currentUser][@"username"] = username;
    [[PFUser currentUser] saveInBackground];
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
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
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    sbTaskCell *casted = (sbTaskCell *)cell;
    int time = [((NSDate *) casted.task[@"deadline"]) timeIntervalSinceNow];
    int hours = time / 60 / 60;
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = _later;
    if (hours < 336) {
        backgroundView.backgroundColor = _nextWeek;
    }
    if (hours < 168) {
        backgroundView.backgroundColor = _thisWeek;
    }
    if (hours < 48) {
        backgroundView.backgroundColor = _tomorrow;
    }
    if (hours < 24) {
        backgroundView.backgroundColor = _today;
    }
    if (hours < 2) {
        backgroundView.backgroundColor = _urgent;
    }
    backgroundView.opaque = YES;
    [cell setBackgroundView:backgroundView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    sbTaskCell *selected = (sbTaskCell *) [self.tableView cellForRowAtIndexPath:indexPath];
    _selectedTask = selected.task;
    [self performSegueWithIdentifier:@"open" sender:self];
}
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     if ([segue.identifier isEqualToString:@"open"]) {
         sbOpenViewController *ovc = (sbOpenViewController *) segue.destinationViewController;
         ovc.task = _selectedTask;
     }
 }
 


@end
