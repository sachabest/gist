//
//  sbMainViewController.h
//  Gist
//
//  Created by Sacha Best on 2/14/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sbAppDelegate.h"
#import "sbTaskCell.h"
#import "FriendCell.h"
#import <Parse/Parse.h>

@interface sbMainViewController : PFQueryTableViewController <UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) sbAppDelegate *appDelegate;
@property PFLogInViewController *logIn;

- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info;
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user;
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error;
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController;
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password;

@end
