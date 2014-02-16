//
//  sbCreateViewController.h
//  Gist
//
//  Created by Sacha Best on 2/15/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view

#define kTitleKey       @"title"   // key for obtaining the data source item's title
#define kDateKey        @"date"    // key for obtaining the data source item's date value
#define kInfoKey        @"info"
#define kAssigneeKey    @"assignee"

// keep track of which rows have date cells
#define kDateStartRow   1
#define kDateEndRow     2

static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker"; // the cell containing the date picker
static NSString *kTitleCell = @"titleCell";     // the titleCell
static NSString *kInfoCell = @"infoCell";       // the cell that describes more about the title
static NSString *kAsigneeCell = @"assigneeCell";// the cell that holds assignees

@interface sbCreateViewController : UITableViewController <UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property NSString *titleInput;
@property NSString *infoInput;

@property (assign) NSInteger pickerCellRowHeight;
@property (nonatomic, strong) IBOutlet UINavigationItem *nav;
@property (nonatomic, strong) UIDatePicker *pickerView;
@property NSArray *assignees;


- (void)sendTask;
- (IBAction)showConfirm:(id)sender;
- (UITableViewCell *)createTextEntryCell;
- (UITableViewCell *)create;
- (void)setAssignessAndUpdate:(NSArray *)assignees;
@end
