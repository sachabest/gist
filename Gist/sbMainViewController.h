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
#import <Parse/Parse.h>

@interface sbMainViewController : PFQueryTableViewController <UITableViewDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) sbAppDelegate *appDelegate;



@end
