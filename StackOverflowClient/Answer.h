//
//  Answer.h
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/14/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Answer : NSObject

+ (NSArray *) parseJSONIntoAnswers:(NSData *) jsonData;

@property NSInteger ownerID;
@property (nonatomic, strong) NSString* ownerName;
@property (nonatomic, strong) NSString* ownerAvatarURL;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* body;
@property double creationDate;

@end
