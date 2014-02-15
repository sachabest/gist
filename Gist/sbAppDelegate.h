//
//  sbAppDelegate.h
//  Gist
//
//  Created by Sacha Best on 2/14/14.
//  Copyright (c) 2014 Sacha Best. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GistParseStorage.h"

@interface sbAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GistParseStorage *parseData;

@end
