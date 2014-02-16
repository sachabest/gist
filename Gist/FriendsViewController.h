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

@interface FriendsViewController : UITableViewController

@property NSMutableArray *friends;
@property NSMutableArray *contactsWithPhone;
@property UIActivityIndicatorView *loading;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
