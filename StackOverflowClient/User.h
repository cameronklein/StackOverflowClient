//
//  User.h
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

+ (NSArray *) parseJSONIntoUsers:(NSData *) jsonData;

@property NSNumber *reputation;
@property NSNumber *userID;
@property NSNumber *bronzeMedals;
@property NSNumber *silverMedals;
@property NSNumber *goldMedals;
@property NSNumber *creationDate;

@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, strong) NSString* profileURL;

@end
