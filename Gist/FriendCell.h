//
//  FriendCell.h
//  Many
//
//  Created by Sacha Best on 2/14/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GistParseStorage.h"

@interface FriendCell : UITableViewCell

@property NSString *firstName;
@property NSString *lastName;
@property NSString *phoneNumber;
@property PFObject *user;
@property bool onParse;

@property UILabel *name;
@property UILabel *number;

+ (NSString *)trimNumber:(NSString *)mobile;
- (void)setFirstName:(NSString *)first lastName:(NSString *)last;
- (void)setOnParse:(PFObject *)user;
- (void)setPhoneNumber:(NSString *)number;
@end
