//
//  sbOpenViewController.h
//  Gist
//
//  Created by Sacha Best on 2/16/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface sbOpenViewController : UITableViewController <UITableViewDelegate>

@property PFObject *task;
@property NSArray *assignees;

- (IBAction)goBack:(id)sender;

@end
