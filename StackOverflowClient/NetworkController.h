//
//  NetworkController.h
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#ifndef StackOverflowClient_NetworkController_h
#define StackOverflowClient_NetworkController_h

@interface NetworkController : NSObject

- (void) fetchQuestionsWithSearchTerm:(NSString *)searchTerm completionHandler:(void (^)(NSArray * result, NSError * error))completionHandler;
- (void) fetchUserImage:(NSString *)avatarURL completionHandler:(void (^)(UIImage * image, NSError * error))completionHandler;
- (void) getCurrentUserWithCompletionHandler:(void (^)(User * user, NSError * error))completionHandler;
- (void) getAnswersForQuestionID:(NSNumber *)questionID completionHandler:(void (^)(NSArray * answers, NSError * error))completionHandler;

@end

#endif
