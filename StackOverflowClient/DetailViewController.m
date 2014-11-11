//
//  ViewController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "DetailViewController.h"
#import "NetworkController.h"
#import "Question.h"
#import "QuestionCell.h"

@interface DetailViewController ()

@property NSArray* questions;
@property NSDateFormatter* formatter;

@end

@implementation DetailViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  
  [self.tableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CELL"];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 48.0;
  
  NetworkController* networkController = [[NetworkController alloc] init];
  
  [networkController fetchQuestionsWithSearchTerm:@"Swift" completionHandler:^(NSArray *result, NSError *error) {
    if (error == nil) {
      self.questions = result;
      [self.tableView reloadData];
    }
  }];
  
  self.formatter = [[NSDateFormatter alloc] init];
  [self.formatter setDateStyle:NSDateFormatterShortStyle];
  
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  NSLog(@"%u", (unsigned int)self.questions.count);
  return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
  Question* question = self.questions[indexPath.row];
  
  cell.titleLabel.text = question.title;
  NSString *tags = @"";
  for (NSString *tag in question.tags) {
    tags = [tags stringByAppendingString:@" #"];
    tags = [tags stringByAppendingString:tag];
  }
  cell.tagLabel.text = tags;
  NSTimeInterval interval = (double)question.creationDate;
  NSLog(@"%ld", (long)question.creationDate);
  //NSLog(@"%f", interval);
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
  //NSLog([date description]);
  cell.timeLabel.text = [self.formatter stringFromDate:date];
  
  
  
  return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

}

@end
