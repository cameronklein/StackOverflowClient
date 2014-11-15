//
//  Answer.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/14/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "Answer.h"

@implementation Answer : NSObject

+ (NSArray *) parseJSONIntoAnswers:(NSData *) jsonData {
  
  NSError* error;
  NSDictionary* resultDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  NSArray* itemsArray = resultDictionary[@"items"];
  
  NSMutableArray* tempArray = [[NSMutableArray alloc] init];
  
  for (NSDictionary *item in itemsArray) {
    Answer* answer = [[Answer alloc] init];
    NSDictionary* ownerDict = item[@"owner"];
    answer.ownerID    = (NSInteger)   ownerDict[@"user_id"];
    answer.ownerName  = (NSString *)  ownerDict[@"display_name"];
    answer.title      = (NSString *)  item[@"title"];
    answer.body       = (NSString *)  item[@"body"];
    answer.creationDate  = [item[@"creation_date"] doubleValue];
    answer.ownerAvatarURL  = (NSString *)  ownerDict[@"profile_image"];
    [tempArray addObject:answer];
  }
  
  NSArray* finalArray = [[NSArray alloc] initWithArray:tempArray];
  return finalArray;
  
}


@end
