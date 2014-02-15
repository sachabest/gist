//
//  GistParseStorage.m
//  Gist
//
//  Created by Sacha Best on 1/31/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import "GistParseStorage.h"

@implementation GistParseStorage

- (id)init {
    _user = [PFUser currentUser];
    [self getParseFriends];
    return self;
}
- (void)getParseFriends {
    PFQuery *query = [PFQuery queryWithClassName:@"Friends"];
    [query whereKey:@"user" equalTo:_user];
    _outbox= [query findObjects];
}
- (void)getParseInbox {
    PFQuery *query = [PFQuery queryWithClassName:@"Inbox"];
    [query whereKey:@"recipient" equalTo:_user];
    _outbox= [query findObjects];
}
- (void)getParseOutbox {
    PFQuery *query = [PFQuery queryWithClassName:@"SetnMessages"];
    [query whereKey:@"sender" equalTo:_user];
    _outbox= [query findObjects];
}

#pragma mark Table View Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _inbox.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    
    
    return cell;
}


@end
