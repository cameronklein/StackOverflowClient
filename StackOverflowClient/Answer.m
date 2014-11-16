//
//  Answer.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/14/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "Answer.h"
#import <NSString-HTML/NSString+HTML.h>

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
    answer.score      = item[@"score"];
    answer.isAccepted = item[@"is_accepted"];
    answer.creationDate  = [item[@"creation_date"] doubleValue];
    answer.ownerAvatarURL  = (NSString *)  ownerDict[@"profile_image"];
    
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
    answer.body = [rawString kv_decodeHTMLCharacterEntities];
    
    [tempArray addObject:answer];
  }
  
  NSArray* finalArray = [[NSArray alloc] initWithArray:tempArray];
  return finalArray;
  
}


@end
