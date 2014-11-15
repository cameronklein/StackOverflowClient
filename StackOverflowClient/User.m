//
//  User.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "User.h"

@interface User ()

@end


@implementation User

+ (NSArray *)parseJSONIntoUsers:(NSData *) jsonData {
  
  NSError* error;
  NSDictionary* resultDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
  NSArray* itemsArray = resultDictionary[@"items"];
  
  NSMutableArray* tempArray = [[NSMutableArray alloc] init];
  
  for (NSDictionary *item in itemsArray) {
    
    User* user = [[User alloc] init];
    user.reputation = item[@"reputation"];
    user.displayName = item[@"display_name"];
    user.imageURL = item[@"profile_image"];
    user.creationDate = item[@"creation_date"];
    NSDictionary *medals = item[@"badge_counts"];
    user.bronzeMedals = medals[@"bronze"];
    user.silverMedals = medals[@"silver"];
    user.goldMedals = medals[@"gold"];
    
    [tempArray addObject:user];
  }
  
  NSArray* finalArray = [[NSArray alloc] initWithArray:tempArray];
  return finalArray;

}

@end
