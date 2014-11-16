//
//  Question.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "Question.h"

@interface Question ()

@end

@implementation Question

+ (NSArray *) parseJSONIntoQuestions:(NSData *) jsonData {
  
  NSError* error;
  NSDictionary* resultDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  NSArray* itemsArray = resultDictionary[@"items"];
  
  NSMutableArray* tempArray = [[NSMutableArray alloc] init];
  
  for (NSDictionary *item in itemsArray) {
    Question* question = [[Question alloc] init];
    NSDictionary* ownerDict = item[@"owner"];
    question.tags       = (NSArray *)   item[@"tags"];
    question.questionID = (NSNumber *)  item[@"question_id"];
    question.ownerID    = (NSInteger)   ownerDict[@"user_id"];
    question.ownerName  = (NSString *)  ownerDict[@"display_name"];
    question.title      = (NSString *)  item[@"title"];
    question.isAnswered = (BOOL)        item[@"is_answered"];
    question.creationDate  = [item[@"creation_date"] doubleValue];
    question.ownerAvatarURL  = (NSString *)  ownerDict[@"profile_image"];
    
    NSString *rawString = item[@"body"];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"<pre><code>" withString:@"---BEGIN CODE---\n\n"];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"</code></pre>" withString:@"\n---END CODE---"];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"<blockquote>" withString:@"----------\n\n"];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"</blockquote>" withString:@"\n\n----------"];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"<li>" withString:@"   -"];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"</li>" withString:@""];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"<ul>" withString:@""];
    rawString = [rawString stringByReplacingOccurrencesOfString:@"</ul>" withString:@""];
    question.body = rawString;
    
    [tempArray addObject:question];
  }
  
  NSArray* finalArray = [[NSArray alloc] initWithArray:tempArray];
  return finalArray;
  
}




@end
