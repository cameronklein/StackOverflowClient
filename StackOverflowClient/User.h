//
//  User.h
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property NSInteger* reputation;
@property NSInteger* userID;

@property (nonatomic, strong) NSString* displayName;
@property (nonatomic, strong) NSString* imageURL;
@property (nonatomic, strong) NSString* profileURL;

@end
