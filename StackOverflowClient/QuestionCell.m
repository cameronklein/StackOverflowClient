//
//  QuestionCell.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "QuestionCell.h"

@implementation QuestionCell

- (void)awakeFromNib {

  self.innerView.layer.cornerRadius = 5;
  self.innerView.clipsToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
