//
//  sbCreateViewController.m
//  Gist
//
//  Created by Sacha Best on 2/15/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import "sbCreateViewController.h"

@interface sbCreateViewController () {
    PFObject *task;
}
@end

@implementation sbCreateViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // setup our data source
    NSMutableDictionary *itemOne = [@{ kTitleKey : @"Task title",
                                       kInfoKey  : @"Brief task description"} mutableCopy];
    NSMutableDictionary *itemThree = [@{ kAssigneeKey : @"Assignees" } mutableCopy];
    NSMutableDictionary *itemTwo = [@{kDateKey : [NSDate date] } mutableCopy];
    self.dataArray = @[itemOne, itemTwo, itemThree];
    
    self.pickerView = [[UIDatePicker alloc] init];
    self.pickerView.datePickerMode = UIDatePickerModeDateAndTime;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}

-(void)dismissKeyboard {
    if ([_infoField isFirstResponder]) {
        [_infoField resignFirstResponder];
        [self textFieldDidEndEditing:_infoField];
    }
    if ([_titleField isFirstResponder]) {
        [_titleField resignFirstResponder];
        [self textFieldDidEndEditing:_titleField];
    }
    if ([_dateInput isFirstResponder]) {
        [_dateInput resignFirstResponder];
        [self textFieldDidEndEditing:_dateInput];
    }
}
#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSString *cellID;
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                cellID = kTitleCell;
            } else {
                cellID = kInfoCell;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                cellID = kDateCellID;
            }
            break;
        case 2:
            cellID = kAsigneeCell;
            break;
    }
    cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        switch (indexPath.section) {
            case 0:
                if (indexPath.row == 0) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTitleCell];
                    CGRect rect = CGRectMake(20, 7, 280, 30);
                    UITextField *title = [[UITextField alloc] initWithFrame:rect];
                    title.delegate = self;
                    title.placeholder = @"Task title";
                    [cell addSubview:title];
                    _titleField = title;
                } else {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kInfoCell];
                    CGRect rect = CGRectMake(20, 7, 280, 30);
                    UITextField *input = [[UITextField alloc] initWithFrame:rect];
                    input.delegate = self;
                    input.placeholder = @"Brief description of the tasK";
                    [cell addSubview:input];
                    _infoField = input;
                }
                break;
            case 1:
                if (indexPath.row == 0) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDateCellID];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    CGRect rect = CGRectMake(20, 7, 280, 30);
                    _dateInput = [[UITextField alloc] initWithFrame:rect];
                    _dateInput.delegate = self;
                    _dateInput.placeholder = [self.dateFormatter stringFromDate:[NSDate date]];
                    [_dateInput setInputView:_pickerView];
                    [cell addSubview:_dateInput];
                }
                break;
            case 2:
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kAsigneeCell];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.textLabel.text = @"Assignees";
                break;
        }
    }
    // roceed to configure our cell
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: // Task title and info
            return 2;
        case 1:
            return 1;
        case 2:
            return 1;
    }
    return 0;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier != kAsigneeCell)
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    else
        [self performSegueWithIdentifier:@"contacts" sender:self];
}


#pragma mark - Actions

- (void)setAssignessAndUpdate:(NSArray *)assignees {
    _assignees = assignees;
    UITableViewCell *assigneeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    NSString *temp = [NSString stringWithFormat:@"%d ", _assignees.count];
    for (PFUser *assignee in _assignees) {
        temp = [temp stringByAppendingString:[assignee objectForKey:@"publicUsername"]];
        temp = [temp stringByAppendingString:@", "];
    }
    if (temp.length > 2)
        temp = [temp substringToIndex:temp.length - 2];
    assigneeCell.textLabel.text = temp;
}
- (IBAction)sendTask:(id)senders {
    task = [[PFObject alloc] initWithClassName:@"Inbox"];
    task[@"creatorID"] = [PFUser currentUser].objectId;
    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Incomplete Input" message:@"Please make sure to fill in all fields" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    if (!_assignees || !_infoInput || !_titleInput) {
        [error show];
        return;
    }
    task[@"possibleAssignees"] = _assignees;
    task[@"title"] = _titleInput;
    task[@"info"] = _infoInput;
    task[@"deadline"] = _due;
    [task saveInBackgroundWithTarget:self selector:@selector(callbackWithResult:error:)];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Task Sent"]) {
        [self goBack:self];
    }
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)callbackWithResult:(NSNumber *)result error:(NSError *)error {
    if (error) {
        NSLog(@"%@", error);
    }
    else {
        PFInstallation *currentInstallation = [PFInstallation currentInstallation];
        [currentInstallation addUniqueObject:task.objectId forKey:@"channels"];
        [currentInstallation saveInBackground];
        UIAlertView *confirm = [[UIAlertView alloc] initWithTitle:@"Task Sent" message:@"Your task has been delivered!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [confirm show];
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _infoField) {
        _infoInput = textField.text;
    }
    else if (textField == _dateInput) {
        _due = _pickerView.date;
        _dateInput.text = [_dateFormatter stringFromDate:_due];
    }
    else
        _titleInput = textField.text;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"contacts"]) {
        FriendsViewController *fvc = segue.destinationViewController;
        fvc.cvc = self;
    }
}
@end
