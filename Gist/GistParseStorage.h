//
//  GistParseStorage.h
//  Gist
//
//  Created by Sacha Best on 1/31/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#define kFriends 1;
#define kInbox 2;
#define kOutbox 3;

@interface GistParseStorage : NSObject <UITableViewDataSource>

@property (strong, nonatomic) PFUser *user;
@property (strong, nonatomic) NSArray *inbox;
@property (strong, nonatomic) NSArray *outbox;
@property (strong, nonatomic) NSArray *friends;

-(void)getParseFriends;
-(void)getParseInbox;
-(void)getParseOutbox;
@end
