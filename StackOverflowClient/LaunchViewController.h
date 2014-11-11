//
//  LaunchViewController.h
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/11/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <UIKit/UIKit.h>
@import WebKit;

@interface LaunchViewController : UIViewController <WKNavigationDelegate>

- (IBAction)signInButtonPressed:(id)sender;

@end
