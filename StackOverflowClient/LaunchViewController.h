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

@property (weak, nonatomic) IBOutlet UILabel *mainLabel;
@property (weak, nonatomic) IBOutlet UILabel *subLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UIView *outerWarningView;
@property (weak, nonatomic) IBOutlet UIView *innnerWarningView;

@end
