//
//  QuestionViewController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/14/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "QuestionViewController.h"
#import "NetworkController.h"
#import "QuestionCell.h"
#import "Question.h"
#import <NSString-HTML/NSString+HTML.h>

@interface QuestionViewController ()

@property (nonatomic, strong) NetworkController *netController;
@property (nonatomic, strong) NSArray *questions;
@property NSDateFormatter* formatter;
@property NSMutableArray *shownCellIndexes;
@property NSMutableArray *selectedCellIndexes;
@property UIPanGestureRecognizer *panRecognizer;
@end

@implementation QuestionViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.netController = [NetworkController new];
  
  [self.tableView registerNib:[UINib nibWithNibName:@"QuestionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"QUESTION_CELL"];
  
  self.shownCellIndexes = [NSMutableArray new];
  self.selectedCellIndexes = [NSMutableArray new];

  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.estimatedRowHeight = 30;
  
  self.formatter = [[NSDateFormatter alloc] init];
  [self.formatter setDateStyle:NSDateFormatterShortStyle];
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
  headerView.backgroundColor = [UIColor clearColor];
  self.tableView.tableHeaderView = headerView;
  
  self.panRecognizer = [[UIPanGestureRecognizer alloc] init];
  [self.panRecognizer addTarget:self action:@selector(didPan:)];

}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  //self.titleBar.center = CGPointMake(self.titleBar.center.x, self.titleBar.center.y - 65);
  [self.netController fetchQuestionsWithSearchTerm:self.searchTerm completionHandler:^(NSArray *result, NSError *error) {
    if (error != nil) {
      NSLog(@"Oops!");
    } else {
      self.questions = result;
      [self.tableView reloadData];
    }
  }];
  self.titleBar.topItem.title = [NSString stringWithFormat:@"Results for \"%@\"", self.searchTerm];

}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  self.titleBarTopSpaceConstraint.constant = 0;
  [UIView animateWithDuration:0.4
         delay:0.1
         options:UIViewAnimationOptionAllowUserInteraction
         animations:^{
           [self.view layoutSubviews];
         }
         completion:^(BOOL finished) {
           
         }];
  

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  QuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
  Question* question = self.questions[indexPath.row];
  //cell.bodyLabel.text = @"";
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  if (cell.tag == 1) {
    NSLog(@"Adding constraints!");
    [cell.innerView addConstraint:cell.firstCollapsibleConstraint];
  }
  cell.titleLabel.text = question.title;
  NSString *strippedText = [question.body kv_encodeHTMLCharacterEntities];
  
  cell.bodyLabel.text = strippedText;
  cell.innerTitleLabel.text = @"Question";
  
  UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] init];
  [self.panRecognizer addTarget:self action:@selector(didPan:)];
  
  [cell.innerInnerView addGestureRecognizer:recognizer];
  
  
  NSString *tags = @"";
  for (NSString *tag in question.tags) {
    tags = [tags stringByAppendingString:@" #"];
    tags = [tags stringByAppendingString:tag];
  }
  cell.tagLabel.text = tags;
  NSTimeInterval interval = (double)question.creationDate;
  NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
  cell.timeLabel.text = [self.formatter stringFromDate:date];

  
  if ([self.shownCellIndexes containsObject:indexPath] == NO) {
    cell.transform = CGAffineTransformMakeScale(.8, .8);
    cell.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
      cell.transform = CGAffineTransformMakeScale(1, 1);
      cell.alpha = 1;
    }];
  }
  
  [self.shownCellIndexes addObject:indexPath];
  return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  QuestionCell *cell = (QuestionCell *)[tableView cellForRowAtIndexPath:indexPath];
  if (cell.tag != 1) {
    Question* question = self.questions[indexPath.row];
    cell.bodyLabel.text = question.body;
    cell.tag = 1;
    [cell.titleLabel removeConstraint:cell.firstCollapsibleConstraint];
    [cell.innerView removeConstraint:cell.firstCollapsibleConstraint];
    [self.selectedCellIndexes addObject:indexPath];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    cell.bodyLabel.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
      cell.bodyLabel.alpha = 1;
    }];
  }
}

-(void)didPan:(UIPanGestureRecognizer *)sender {
  NSLog(@"Did pan!");
  CGPoint startPoint;
  UIView *touchedView = sender.view;
  if (sender.state == UIGestureRecognizerStateBegan) {
    startPoint = [sender locationInView:self.view];
  } else if (sender.state == UIGestureRecognizerStateChanged) {
    touchedView.center = CGPointMake([sender translationInView:self.view].x , touchedView.center.y);
  } else if (sender.state == UIGestureRecognizerStateEnded) {
    
  }
  
}






@end
