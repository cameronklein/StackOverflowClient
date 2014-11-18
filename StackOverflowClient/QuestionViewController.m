//
//  QuestionViewController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/14/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "QuestionViewController.h"
#import "NetworkController.h"
#import "Question.h"
#import "Answer.h"
#import "QuestionCell.h"

@interface QuestionViewController ()

@property (nonatomic, strong) NetworkController *netController;
@property (nonatomic, strong) NSArray *questions;
@property NSDateFormatter* formatter;
@property NSMutableArray *shownCellIndexes;
@property NSMutableArray *selectedCellIndexes;
@property UIPanGestureRecognizer *panRecognizer;
@property BOOL resultsCameBack;
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
  
  [self.backButton setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"AvenirNext-UltraLight" size:16.0],NSForegroundColorAttributeName: [UIColor blueColor]} forState:UIControlStateNormal];
  
  self.view.layer.cornerRadius = 15;
  self.view.clipsToBounds = true;

}

-(void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.resultsCameBack = NO;
  //self.titleBar.center = CGPointMake(self.titleBar.center.x, self.titleBar.center.y - 65);
  [self.netController fetchQuestionsWithSearchTerm:self.searchTerm completionHandler:^(NSArray *result, NSError *error) {
    if (error != nil) {
      NSLog(@"Oops!");
    } else {
      self.questions = result;
      [self.tableView reloadData];
      self.resultsCameBack = YES;
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
  if (self.questions.count == 0) {
    return 1;
  }
  return self.questions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  QuestionCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
  
  [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
  if (cell.tag == 1) {
    NSLog(@"Adding constraints!");
    [cell.innerView addConstraint:cell.firstCollapsibleConstraint];
  }
  cell.secondCollapsibleContstraint.constant = 8;
  cell.tag = 0;
  cell.scrollView.contentOffset = CGPointMake(0, 0);
  
  
  if (self.questions.count > 0) {

    Question* question = self.questions[indexPath.row];
    //cell.bodyLabel.text = @"";
    
    
    cell.titleLabel.text = question.title;
    cell.bodyLabel.text = question.body;
    cell.innerTitleLabel.text = @"Question";
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] init];
    [self.panRecognizer addTarget:self action:@selector(didPan:)];
    [cell.innerInnerView addGestureRecognizer:recognizer];
    
    recognizer.delegate = self;
    cell.scrollView.delegate = self;
    
    
    NSString *tags = @"";
    for (NSString *tag in question.tags) {
      tags = [tags stringByAppendingString:@" #"];
      tags = [tags stringByAppendingString:tag];
    }
    cell.tagLabel.text = tags;
    NSTimeInterval interval = (double)question.creationDate;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    cell.timeLabel.text = [self.formatter stringFromDate:date];
    
    [self.shownCellIndexes addObject:indexPath];
      
  } else {
    if (self.resultsCameBack) {
      cell.titleLabel.text = @"No results found";
    } else {
      cell.titleLabel.text = @"Searching...";
    }
  }
  
  if ([self.shownCellIndexes containsObject:indexPath] == NO) {
    cell.transform = CGAffineTransformMakeScale(.8, .8);
    cell.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
      cell.transform = CGAffineTransformMakeScale(1, 1);
      cell.alpha = 1;
    }];
  }
  
  
  
  return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  NSLog(@"Did Select Called!");
  QuestionCell *cell = (QuestionCell *)[tableView cellForRowAtIndexPath:indexPath];
  if (cell.tag != 1) {
    NSLog(@"Made it past if statement!");
    Question* question = self.questions[indexPath.row];
    cell.bodyLabel.text = question.body;
    cell.tag = 1;
    cell.secondCollapsibleContstraint.constant = 32;
    [cell.titleLabel removeConstraint:cell.firstCollapsibleConstraint];
    [cell.innerView removeConstraint:cell.firstCollapsibleConstraint];
    [self.selectedCellIndexes addObject:indexPath];
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    cell.bodyLabel.alpha = 0;
    
    [self getTwoBestAnswersForQuestion:question completionHandler:^(NSArray *answers) {
      NSLog(@"COMPLETION HANDLER TWO");
      BOOL hasFirst = [answers[0] isKindOfClass:[Answer class]];
      BOOL hasSecond = [answers[1] isKindOfClass:[Answer class]];
      if (hasFirst && !hasSecond) {
        Answer *answerOne = answers[0];
        cell.firstAnswerBody.text = answerOne.body;
        cell.firstAnswerTitle.text = @"Highest Rated Answer";
        cell.secondAnswerTitle.text = @"No Accepted Answer";
        cell.firstAnswerBody.alpha = 0;
        cell.firstAnswerTitle.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
          cell.firstAnswerBody.alpha = 1;
          cell.firstAnswerTitle.alpha = 1;
        }];
        
      } else if (hasFirst && hasSecond && answers[0] != answers[1]) {
        Answer *answerOne = answers[0];
        Answer *answerTwo = answers[1];
        cell.firstAnswerBody.text = answerOne.body;
        cell.firstAnswerTitle.text = @"Accepted Answer";
        cell.secondAnswerBody.text = answerTwo.body;
        cell.secondAnswerTitle.text = @"Highest Rated Answer";
        cell.firstAnswerBody.alpha = 0;
        cell.firstAnswerTitle.alpha = 0;
        cell.secondAnswerBody.alpha = 0;
        cell.secondAnswerTitle.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
          cell.firstAnswerBody.alpha = 1;
          cell.firstAnswerTitle.alpha = 1;
          cell.secondAnswerBody.alpha = 1;
          cell.secondAnswerTitle.alpha = 1;
        }];
        
      } else if (hasFirst && hasSecond && answers[0] == answers[1]) {
        Answer *answerOne = answers[0];
        cell.firstAnswerBody.text = answerOne.body;
        cell.firstAnswerTitle.text = @"Highest Rated/Accepted Answer";
        cell.secondAnswerTitle.text = @"";
        cell.firstAnswerBody.alpha = 0;
        cell.firstAnswerTitle.alpha = 0;
        [UIView animateWithDuration:0.4 animations:^{
          cell.firstAnswerBody.alpha = 1;
          cell.firstAnswerTitle.alpha = 1;
        }];
        
        
      } else {
        cell.firstAnswerTitle.text = @"No Answers Yet :(";
        cell.secondAnswerTitle.text = @"No Answers Yet :(";
      }
      
      UILabel *tallestLabel = cell.bodyLabel;
      
      if ([cell.firstAnswerBody intrinsicContentSize].height > [cell.bodyLabel intrinsicContentSize].height) {
        tallestLabel = cell.firstAnswerBody;
      }
      if ([cell.secondAnswerBody intrinsicContentSize].height > [tallestLabel intrinsicContentSize].height) {
        tallestLabel = cell.secondAnswerBody;
      }
      
      CGFloat offset = [tallestLabel intrinsicContentSize].height - [cell.bodyLabel intrinsicContentSize].height;
      NSLog(@"%f", offset);
      cell.scrollViewHeightConstraint.constant = offset;
      [self.tableView beginUpdates];
      [self.tableView endUpdates];
    }];
    
    [UIView animateWithDuration:1.0 animations:^{
      cell.bodyLabel.alpha = 1;
      //cell.closeButton.alpha = 1;
      cell.swipeLabel.alpha = 1;
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

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
  return YES;
}

-(void)getTwoBestAnswersForQuestion:(Question *)question completionHandler:(void (^)(NSArray * answers))completionHandler{
  NSLog(@"BEST ANSWERS CALLED!");
  [self.netController getAnswersForQuestionID:question.questionID completionHandler:^(NSArray *answers, NSError *error) {
    NSLog(@"COMPLETION HANDLER CALLED!");
    Answer *chosenAnswer;
    Answer *highestAnswer = answers[0];
    for (Answer *answer in answers) {
      if (answer.score == highestAnswer.score) {
        highestAnswer = answer;
      }
      if (answer.isAccepted) {
        chosenAnswer = answer;
      }
    }
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      completionHandler(@[highestAnswer,chosenAnswer]);
    }];
  }];
  
}

- (IBAction)backButtonPressed:(id)sender {
  
  self.titleBarTopSpaceConstraint.constant = -65;
  
  [UIView animateWithDuration:0.4 animations:^{
  [self.view layoutSubviews];
  } completion:^(BOOL finished) {
  [UIView animateWithDuration:0.4
  delay:0.1
  options:UIViewAnimationOptionAllowUserInteraction
  animations:^{
  for (QuestionCell *cell in [self.tableView visibleCells]) {
  cell.transform = CGAffineTransformMakeScale(.8, .8);
  cell.alpha = 0;
  }
  }
  completion:^(BOOL finished) {
  [self dismissViewControllerAnimated:NO completion:nil];
  }];
  }];
  
}

@end
