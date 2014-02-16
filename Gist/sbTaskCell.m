//
//  sbTaskCell.m
//  Gist
//
//  Created by Sacha Best on 2/15/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import "sbTaskCell.h"

@implementation sbTaskCell



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}
- (void) layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake( 260, 15, 40, 40 );
    self.textLabel.frame = CGRectMake( 20, 0, 222, 44 );
    self.textLabel.font = [UIFont boldSystemFontOfSize:17];
    self.detailTextLabel.frame = CGRectMake( 20, 45, 80, 21 );
    self.detailTextLabel.font = [UIFont italicSystemFontOfSize:15];
    
    // This rounds the image
    CALayer *imageLayer = self.imageView.layer;
    [imageLayer setCornerRadius:20];
    [imageLayer setBorderWidth:1];
    [imageLayer setMasksToBounds:YES];
}
- (void)addTask:(PFObject *)task {
    _task = task;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
