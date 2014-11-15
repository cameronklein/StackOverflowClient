//
//  NetworkController.m
//  StackOverflowClient
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import "NetworkController.h"
#import "Question.h"
#import "Answer.h"

@implementation NetworkController

static NSString *const stackOverFlowURL = @"https://api.stackexchange.com/2.2/";
static NSString *const postURL = @"https://stackexchange.com/oauth/access_token";


- (void) fetchDataFromURL:(NSURL *)url completionHandler:(void (^)(id value))completionHandler{
  
  NSLog(@"Fetch method called!");
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"GET";
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error != nil){
      NSLog(@"%@", [error localizedDescription]);
      completionHandler(error);
    } else {
      NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse *)response;
      NSInteger statusCode = [httpResponse statusCode];
      NSLog(@"%ld", (long)statusCode);
      switch (statusCode) {
        case 200: {
          NSLog(@"Got 200!!");
          completionHandler(data);
        }
          break;
        default:
          //return error;
          break;
      }
    }
  }];
  
  [dataTask resume];

}

- (NSString *) getAuthenticatedURLQueries {
  
  NSString *urlString = @"&site=stackoverflow";
  urlString = [urlString stringByAppendingString:@"&access_token="];
  urlString = [urlString stringByAppendingString:[[NSUserDefaults standardUserDefaults] valueForKey:@"access_token"]];
  urlString = [urlString stringByAppendingString:@"&key="];
  urlString = [urlString stringByAppendingString:@"4lQBbDlbYN2qTOduOtH*nw(("];
  
  return urlString;
  
}

- (void) fetchQuestionsWithSearchTerm:(NSString *)searchTerm completionHandler:(void (^)(NSArray * result, NSError * error))completionHandler {
  
  NSLog(@"Fetch method called!");
  NSString *urlString = stackOverFlowURL;
  urlString = [urlString stringByAppendingString:@"search?order=desc&sort=activity&filter=withbody&intitle="];
  urlString = [urlString stringByAppendingString:searchTerm];
  urlString = [urlString stringByAppendingString:[self getAuthenticatedURLQueries]];
               
  NSLog(@"%@", urlString);
  NSURL *url = [[NSURL alloc] initWithString:urlString];
  
  [self fetchDataFromURL:url completionHandler:^(id value) {
    NSArray *result = [Question parseJSONIntoQuestions:value];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      completionHandler(result,nil);
    }];
  }];
  
}

- (void) fetchUserImage:(NSString *)avatarURL completionHandler:(void (^)(UIImage * image, NSError * error))completionHandler {
 
  NSURL *url = [NSURL URLWithString:avatarURL];
  
  [self fetchDataFromURL:url completionHandler:^(id value) {
    UIImage *image = [UIImage imageWithData:value];
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      completionHandler(image,nil);
    }];
  }];
  
}

- (void) getCurrentUserWithCompletionHandler:(void (^)(User * user, NSError * error))completionHandler {
  
  NSString *urlString = stackOverFlowURL;
  urlString = [urlString stringByAppendingString:@"me?"];
  urlString = [urlString stringByAppendingString:[self getAuthenticatedURLQueries]];
  NSURL *url = [NSURL URLWithString:urlString];
  
  [self fetchDataFromURL:url completionHandler:^(id value) {
    NSArray *array = [User parseJSONIntoUsers:value];
    completionHandler(array[0], nil);
  }];
  
}

- (void) getAnswersForQuestionID:(NSNumber *)questionID completionHandler:(void (^)(NSArray * answers, NSError * error))completionHandler {
 
  NSString *urlString = stackOverFlowURL;
  urlString = [urlString stringByAppendingString:@"questions/"];
  urlString = [urlString stringByAppendingString:[questionID stringValue]];
  urlString = [urlString stringByAppendingString:@"/answers"];
  urlString = [urlString stringByAppendingString:@"?order=desc"];
  urlString = [urlString stringByAppendingString:[self getAuthenticatedURLQueries]];
  NSLog(@"%@", urlString);
  NSURL *url = [NSURL URLWithString:urlString];
  
  [self fetchDataFromURL:url completionHandler:^(id value) {
    NSError *error;
    NSDictionary *resultDict = [NSJSONSerialization JSONObjectWithData:value options:NSJSONReadingAllowFragments error:&error];
    NSArray *answerArray = resultDict[@"items"];
    NSString *queryString = @"";
    NSInteger numberOfAnswers = MIN(answerArray.count, 15);
    for (NSInteger i = 0; i < numberOfAnswers; i++) {
      NSDictionary *answer = answerArray[i];
      NSNumber *number = answer[@"answer_id"];
      if (![queryString  isEqual: @""]) {
        queryString = [queryString stringByAppendingString:@";"];
      }
      queryString = [queryString stringByAppendingString: [number stringValue]];
    }
    
    NSString *urlString = stackOverFlowURL;
    urlString = [urlString stringByAppendingString:@"answers/"];
    urlString = [urlString stringByAppendingString:queryString];
    urlString = [urlString stringByAppendingString:@"?filter=withbody"];
    urlString = [urlString stringByAppendingString:[self getAuthenticatedURLQueries]];
    
    NSLog(@"%@", urlString);
    NSURL *url = [NSURL URLWithString: urlString];
    
    [self fetchDataFromURL:url completionHandler:^(id value) {
      NSArray *array = [Answer parseJSONIntoAnswers:value];
      [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        completionHandler(array,nil);
      }];
      
    }];
    
  }];
  
}



@end