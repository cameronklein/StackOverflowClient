//
//  NetworkController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "NetworkController.h"
#import "Question.h"

@implementation NetworkController

static NSString *const stackOverFlowURL = @"https://api.stackexchange.com/2.2/";
static NSString *const postURL = @"https://stackexchange.com/oauth/access_token";

- (void) fetchQuestionsWithSearchTerm:(NSString *)searchTerm completionHandler:(void (^)(NSArray * result, NSError * error))completionHandler {
  NSLog(@"Fetch method called!");
  NSString *urlString = stackOverFlowURL;
  urlString = [urlString stringByAppendingString:@"search?order=desc&sort=activity&filter=withbody&intitle="];
  urlString = [urlString stringByAppendingString:searchTerm];
  urlString = [urlString stringByAppendingString:@"&site=stackoverflow"];
  urlString = [urlString stringByAppendingString:@"&key="];
  urlString = [urlString stringByAppendingString:[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]];
            
  NSLog(@"%@", urlString);

  NSURL *url = [[NSURL alloc] initWithString:urlString];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"GET";
  
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error != nil){
      NSLog(@"%@", [error localizedDescription]);
    } else {
      NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
      NSInteger statusCode = [httpResponse statusCode];
      NSLog(@"%d", statusCode);
      switch (statusCode) {
        case 200: {
          NSLog(@"Got 200!!");
          NSArray *result = [Question parseJSONIntoQuestions:data];
          [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completionHandler(result,error);
          }];
        }
          break;
        default:
          break;
      }
    }
      
  }];
  
  [dataTask resume];

}
  
  

@end