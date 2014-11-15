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
#import "SingleQuestionViewController.h"

@interface DetailViewController ()

@property NSArray* questions;
@property NSDateFormatter* formatter;
@property NetworkController* networkController;

@end

@implementation DetailViewController

// MARK: - Lifecycle Methods

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  self.searchBar.delegate = self;
  
  [self.tableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CELL"];
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 48.0;
  
  self.networkController = [[NetworkController alloc] init];
  
  self.formatter = [[NSDateFormatter alloc] init];
  [self.formatter setDateStyle:NSDateFormatterShortStyle];
  
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.navigationItem.title = [NSString stringWithFormat:@"Search for %@", self.searchType];
}



// MARK: - Table View DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
  cell.timeLabel.text = [self.formatter stringFromDate:date];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  SingleQuestionViewController *singleVC = [[SingleQuestionViewController alloc] init];
  singleVC.question = self.questions[indexPath.row];
  [self.splitViewController showDetailViewController:singleVC sender:self];
  
}

//MARK: - Search Bar Delegate

- (void)searchBarTextShouldEndEditing:(UISearchBar *)searchBar {
  [self performSearch];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
  [self performSearch];
}

-(void)performSearch {
  [self.networkController fetchQuestionsWithSearchTerm:self.searchBar.text completionHandler:^(NSArray *result, NSError *error) {
    self.questions = result;
    [self.tableView reloadData];
  }];
}

@end
