//
//  SingleQuestionViewController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/11/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "SingleQuestionViewController.h"
#import "QuestionCollectionViewCell.h"
#import "NetworkController.h"

@interface SingleQuestionViewController ()

@property NSDateFormatter* formatter;
@property NSArray* answers;
@property NetworkController* networkController;
@property NSMutableArray* backingArray;
@property NSMutableArray *cells;

@end

@implementation SingleQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  self.backingArray = [NSMutableArray new];
  [self.backingArray addObject:self.question];
  
  self.formatter = [[NSDateFormatter alloc] init];
  [self.formatter setDateStyle:NSDateFormatterShortStyle];
  
  UINib *questionNib = [UINib nibWithNibName:@"QuestionCollectionViewCell" bundle:[NSBundle mainBundle]];
  [self.collectionView registerNib:questionNib forCellWithReuseIdentifier:@"QUESTION_CELL"];
  
  self.networkController = [[NetworkController alloc] init];
  [self.networkController getAnswersForQuestionID:self.question.questionID completionHandler:^(NSArray *answers, NSError *error) {
    self.answers = answers;
    NSLog([self.answers description]);
    [self.backingArray addObjectsFromArray:self.answers];
    NSLog(@"Completion Handler Called!");
    NSLog([self.backingArray description]);
    //[self populateCellArray];
    [self.collectionView reloadData];
  }];

}

//- (void)populateCellArray {
//  
//  self.cells = [[NSMutableArray alloc] init];
//  NSInteger i = 0;
//  for (Question* object in self.backingArray) {
//    NSLog(@"Making cell!");
//    NSUInteger x[] = {0, i};
//    NSIndexPath * path = [[NSIndexPath alloc] initWithIndexes:x length:2];
//    QuestionCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"QuestionCollectionViewCell" forIndexPath:path];
//    
//    cell.titleLabel.text = object.title;
//    cell.usernameLabel.text = object.ownerName;
//    NSTimeInterval interval = (double)object.creationDate;
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
//    cell.dateLabel.text = [self.formatter stringFromDate:date];
//    NetworkController *networkController = [[NetworkController alloc] init];
//    [networkController fetchUserImage:object.ownerAvatarURL completionHandler:^(UIImage *image, NSError *error) {
//      cell.userImage.alpha = 0;
//      cell.userImage.image = image;
//      [UIView animateWithDuration:0.4 animations:^{
//        cell.userImage.alpha = 1;
//      }];
//    }];
//    
//    NSString * string = object.body;
//    string = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
//    string = [string stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
//    
//    cell.bodyLabel.text = string;
//    cell.layer.masksToBounds = false;
//    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
//    cell.layer.shadowRadius = 5;
//    cell.layer.shadowOffset = CGSizeMake(3,3);
//    cell.layer.shadowOpacity = 0.75;
//    [self.cells addObject:cell];
//    i++;
//  }
//  
//  NSLog([self.cells description]);
//  
//}

- (void)viewDidAppear:(BOOL)animated {
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSLog(@"Asking for array count!");
  NSLog(@"%ld",self.backingArray.count);
  return self.backingArray.count;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  NSLog(@"Trying to dequeue cell!");
    
    QuestionCollectionViewCell *questionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
    Question *object = self.backingArray[indexPath.row];
    questionCell.titleLabel.text = object.title;
  
    questionCell.usernameLabel.text = object.ownerName;
    NSTimeInterval interval = (double)object.creationDate;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    questionCell.dateLabel.text = [self.formatter stringFromDate:date];
    
    NetworkController *networkController = [[NetworkController alloc] init];
    [networkController fetchUserImage:object.ownerAvatarURL completionHandler:^(UIImage *image, NSError *error) {
      questionCell.userImage.alpha = 0;
      questionCell.userImage.image = image;
      [UIView animateWithDuration:0.4 animations:^{
        questionCell.userImage.alpha = 1;
      }];
    }];
    
    NSString * string = object.body;
    string = [string stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    
    questionCell.bodyLabel.text = string;
    
    questionCell.layer.masksToBounds = false;
    questionCell.layer.shadowColor = [[UIColor blackColor] CGColor];
    questionCell.layer.shadowRadius = 5;
    questionCell.layer.shadowOffset = CGSizeMake(3,3);
    questionCell.layer.shadowOpacity = 0.75;
  
    [collectionView.collectionViewLayout invalidateLayout];
    
   return questionCell;
  
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
  
  return UIEdgeInsetsMake(10, 10, 10, 10);
  
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  QuestionCollectionViewCell *cell = (QuestionCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
  cell.containerView.frame = CGRectMake(0, 0, self.view.frame.size.width - 40, 500);
  cell.widthConstraint.constant = self.view.frame.size.width - 40;
  [cell.bodyLabel setNeedsLayout];
  [cell.titleLabel setNeedsLayout];
  [cell layoutIfNeeded];
  CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
  NSLog(@"Height:");
  NSLog(@"%f", size.height);
  NSLog(@"Width:");
  NSLog(@"%f", size.width);

  return CGSizeMake(self.view.frame.size.width - 40, size.height);
  
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
  
  
}




@end
