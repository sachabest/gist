//
//  FriendsViewController.h
//  Many
//
//  Created by Sacha Best on 2/12/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sbAppDelegate.h"
#import <AddressBook/AddressBook.h>
#import "FriendCell.h"
#import "sbCreateViewController.h"

@class sbCreateViewController;

@interface FriendsViewController : UITableViewController

@property NSMutableArray *friends;
@property NSMutableArray *contactsWithPhone;
@property sbCreateViewController *cvc;
@property UIActivityIndicatorView *loading;

@property NSArray *selection;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (IBAction)send:(id)sender;

@end
