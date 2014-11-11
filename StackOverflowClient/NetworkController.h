//
//  NetworkController.h
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef StackOverflowClient_NetworkController_h
#define StackOverflowClient_NetworkController_h

@interface NetworkController : NSObject

- (void) fetchQuestionsWithSearchTerm:(NSString *)searchTerm completionHandler:(void (^)(NSArray * result, NSError * error))completionHandler;


@end

#endif
