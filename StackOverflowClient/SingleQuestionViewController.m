//
//  SingleQuestionViewController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/11/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "SingleQuestionViewController.h"
#import "QuestionCollectionViewCell.h"

@interface SingleQuestionViewController ()

@property NSDateFormatter* formatter;
@property NSArray* answers;

@end

@implementation SingleQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
  self.collectionView.dataSource = self;
  self.collectionView.delegate = self;
  
  self.formatter = [[NSDateFormatter alloc] init];
  [self.formatter setDateStyle:NSDateFormatterShortStyle];
  
  UINib *questionNib = [UINib nibWithNibName:@"QuestionCollectionViewCell" bundle:[NSBundle mainBundle]];
  [self.collectionView registerNib:questionNib forCellWithReuseIdentifier:@"QUESTION_CELL"];
  
  CGSize screenSize = self.view.bounds.size;
  
  UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
  layout.itemSize = CGSizeMake(screenSize.width - 20, 300);
  
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
  NSLog(@"%lu", self.answers.count + 1);
  
  return self.answers.count + 1;
  
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  
  if (indexPath.row == 0) {
    
    NSLog(@"Trying to dequeue question cell!");
    NSLog(@"%@", self.question.title);
    
    QuestionCollectionViewCell *questionCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QUESTION_CELL" forIndexPath:indexPath];
    questionCell.titleLabel.text = self.question.title;
    questionCell.bodyLabel.text = self.question.body;
    questionCell.usernameLabel.text = self.question.ownerName;
    NSTimeInterval interval = (double)self.question.creationDate;
    NSLog(@"%ld", (long)self.question.creationDate);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    questionCell.dateLabel.text = [self.formatter stringFromDate:date];
    //questionCell.answeredLabel.text = self.question.title;
    
    return questionCell;
    
  } else {
    NSLog(@"Trying to dequeue some other cell!");
    return nil;
  };
  return nil;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//  
//  QuestionCollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
//  [cell setNeedsLayout];
//  [cell layoutIfNeeded];
//  CGSize size = [cell systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
//  NSLog(@"Height:");
//  NSLog(@"%f", size.height);
//  NSLog(@"Width:");
//  NSLog(@"%f", size.height);
//  return size;
//  
//}


@end
