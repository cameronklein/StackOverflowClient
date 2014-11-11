//
//  Question.h
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject

+ (NSArray *) parseJSONIntoQuestions:(NSData *) jsonData;

@property (nonatomic, strong) NSArray* tags;
@property NSInteger ownerID;
@property (nonatomic, strong) NSString* ownerName;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* body;
@property double creationDate;
@property BOOL isAnswered;

@end
