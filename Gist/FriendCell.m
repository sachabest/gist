//
//  FriendCell.m
//  Many
//
//  Created by Sacha Best on 2/14/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import "FriendCell.h"

@implementation FriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _name = [[UILabel alloc] initWithFrame:CGRectMake(20, 7, 271, 21)];
        [_name setFont:[UIFont boldSystemFontOfSize:17]];
        _number = [[UILabel alloc] initWithFrame:CGRectMake(20, 31, 271, 21)];
        [self addSubview:_name];
        [self addSubview:_number];
    }
    return self;
}

- (void)setFirstName:(NSString *)first lastName:(NSString *)last {
    _firstName = first;
    _lastName = last;
    if (!first) {
        if (!last) {
            return;
        }
        else {
            _name.text = last;
        }
    }
    else {
        if (!last) {
            _name.text = first;
        }
        else {
            _name.text = [[first stringByAppendingString:@" "] stringByAppendingString:last];
        }
    }
}
+ (NSString *)trimNumber:(NSString *)mobile {
    /**
     * This code strips non-numeric characters from the phone number
     **/
    NSMutableString *strippedString = [NSMutableString
                                       stringWithCapacity:mobile.length];
    NSScanner *scanner = [NSScanner scannerWithString:mobile];
    NSCharacterSet *numbers = [NSCharacterSet
                               characterSetWithCharactersInString:@"0123456789"];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
            
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    return strippedString;
}
- (void)setPhoneNumber:(NSString *)number {
    _phoneNumber = number;
    _number.text = number;
}
- (void)seOonParse {
    _onParse = true;
    self.accessoryType = UITableViewCellAccessoryCheckmark;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
