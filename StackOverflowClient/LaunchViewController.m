//
//  LaunchViewController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/11/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "LaunchViewController.h"
@import WebKit;

@interface LaunchViewController ()

@end

@implementation LaunchViewController

- (void)viewDidLoad {
  [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    [self presentViewController:[storyboard instantiateInitialViewController] animated:true completion:nil];
    
  } else {
    decisionHandler(WKNavigationActionPolicyAllow);
  }
}

@end