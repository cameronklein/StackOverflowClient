//
//  LaunchViewController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/11/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "LaunchViewController.h"
#import "QuestionViewController.h"
@import WebKit;

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.searchField.adjustsFontSizeToFitWidth = YES;
  self.searchField.minimumFontSize = 5;
  self.outerWarningView.layer.cornerRadius = 5;
  self.innnerWarningView.layer.cornerRadius = 5;
  self.innnerWarningView.layer.borderColor = [[UIColor redColor] CGColor];
  self.innnerWarningView.layer.borderWidth = 1;
  self.innnerWarningView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
  self.outerWarningView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
  self.view.layer.cornerRadius = 15;
  //self.searchField.layer.cornerRadius = 15;
  self.view.clipsToBounds = true;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear) name:UIKeyboardWillShowNotification object:nil];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.searchField.text = @"";
  if ([[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"] != nil) {
    self.outerWarningView.hidden = YES;
  } else {
    self.outerWarningView.hidden = NO;
  }
  
  self.mainLabel.transform = CGAffineTransformMakeScale(.8, .8);
  self.subLabel.transform = CGAffineTransformMakeScale(.8, .8);
  self.thirdLabel.transform = CGAffineTransformMakeScale(.8, .8);
  self.searchField.transform = CGAffineTransformMakeScale(.8, .8);
  self.searchButton.transform = CGAffineTransformMakeScale(.8, .8);
  
  [UIView animateWithDuration:0.4
                        delay:0.2
                      options:UIViewAnimationOptionAllowUserInteraction
                   animations:^{
                     self.mainLabel.alpha = 1;
                     self.subLabel.alpha = 1;
                     self.thirdLabel.alpha = 1;
                     self.searchButton.alpha = 1;
                     self.searchField.alpha = 1;
                     self.mainLabel.transform = CGAffineTransformMakeScale(1, 1);
                     self.subLabel.transform = CGAffineTransformMakeScale(1, 1);
                     self.thirdLabel.transform = CGAffineTransformMakeScale(1, 1);
                     self.searchField.transform = CGAffineTransformMakeScale(1, 1);
                     self.searchButton.transform = CGAffineTransformMakeScale(1, 1);
                   }
                   completion:^(BOOL finished) {
                     
                   }];

}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonPressed:(id)sender {
  
  WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.frame];
  webView.navigationDelegate = self;
  
  NSString *urlString = @"https://stackexchange.com/oauth/dialog?client_id=3825&scope=no_expiry&redirect_uri=https://stackexchange.com/oauth/login_success";
  NSURL *url = [[NSURL alloc] initWithString:urlString];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  [webView loadRequest:request];
  [self.view addSubview:webView];
  
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
  
  NSURLRequest *request = navigationAction.request;
  NSURL *url = request.URL;
//  NSLog(@"%@", url.description);
//  NSLog(@"%@", url.host);
  if ([url.description containsString:@"access_token"]) {
    [webView removeFromSuperview];
    decisionHandler(WKNavigationActionPolicyAllow);
    
    NSArray *components = [[url description] componentsSeparatedByString:@"="];
    NSLog(@"%@", [components description]);
    NSString *token = components[1];
    
    [[NSUserDefaults standardUserDefaults] setValue:token forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  } else {
    decisionHandler(WKNavigationActionPolicyAllow);
  }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.searchField resignFirstResponder];
}

- (IBAction)searchButtonPressed:(id)sender {
  QuestionViewController *vc = [[QuestionViewController alloc] initWithNibName:@"QuestionViewController" bundle:[NSBundle mainBundle]];
  vc.searchTerm = self.searchField.text;
  [vc.titleBar setItems:@[self,vc]];
  [UIView animateWithDuration:0.4
         delay:0.2
         options:UIViewAnimationOptionAllowUserInteraction
         animations:^{
           self.mainLabel.alpha = 0;
           self.subLabel.alpha = 0;
           self.thirdLabel.alpha = 0;
           self.searchButton.alpha = 0;
           self.searchField.alpha = 0;
         }
         completion:^(BOOL finished) {
            [self presentViewController:vc animated:false completion:nil];
         }];
  
}

-(void) keyboardDidAppear {
  NSLog(@"Keyboard Did Appear Called");
  self.bottomConstraint.constant = 200;
  [self.searchField setNeedsUpdateConstraints];
  [[NSOperationQueue mainQueue] addOperationWithBlock:^{
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                       [self.view layoutSubviews];
                     }
                     completion:^(BOOL finished) {
                       
                     }];
    
  }];
  

}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
