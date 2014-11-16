//
//  QuestionCell.h
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionViewController.h"

@interface QuestionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UIView *innerView;
@property (weak, nonatomic) IBOutlet UILabel *innerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *bodyLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstCollapsibleConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondCollapsibleContstraint;
@property (weak, nonatomic) IBOutlet UIView *innerInnerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *firstAnswerView;
@property (weak, nonatomic) IBOutlet UIView *secondAnswerView;
@property (weak, nonatomic) IBOutlet UILabel *firstAnswerBody;
@property (weak, nonatomic) IBOutlet UILabel *secondAnswerBody;
@property (weak, nonatomic) IBOutlet UILabel *firstAnswerTitle;
@property (weak, nonatomic) IBOutlet UILabel *secondAnswerTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UILabel *swipeLabel;

@end
