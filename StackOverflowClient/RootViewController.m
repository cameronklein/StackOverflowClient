//
//  RootViewController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/13/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "RootViewController.h"
#import "DetailViewController.h"
#import "NetworkController.h"

@interface RootViewController ()

@property (nonatomic, strong) NSArray *searchTypes;

@end

@implementation RootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  NetworkController *networkController = [NetworkController new];
  [networkController getCurrentUserWithCompletionHandler:^(User *user, NSError *error) {
    [networkController fetchUserImage:user.imageURL completionHandler:^(UIImage *image, NSError *error) {
      self.userImage.image = image;
    }];
    self.usernameLabel.text = user.displayName;
    self.reputationLabel.text = @"Reputation: ";
    self.reputationLabel.text = [self.reputationLabel.text stringByAppendingString: [user.reputation stringValue]];
  }];
  
  self.searchTypes = @[@"Questions",@"Users"];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
  return 2;
  
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
  cell.textLabel.text = self.searchTypes[indexPath.row];
  
  return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
  return @"Search";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
  UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
  DetailViewController *detail = [storyboard instantiateViewControllerWithIdentifier:@"SEARCH"];
  detail.searchType = cell.textLabel.text;
  [self.navigationController pushViewController:detail animated:YES];
}

@end
