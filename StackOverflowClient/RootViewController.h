//
//  RootViewController.h
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/13/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *reputationLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberSinceLabel;

@end
