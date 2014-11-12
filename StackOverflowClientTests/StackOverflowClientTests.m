//
//  StackOverflowClientTests.m
//  StackOverflowClientTests
//
//  Created by Cameron Klein on 11/10/14.
//  Copyright (c) 2014 Cameron Klein. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Question.h"

@interface StackOverflowClientTests : XCTestCase

@end

@implementation StackOverflowClientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testQuestionParser {
  NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"json"];
  NSData *data = [NSData dataWithContentsOfFile:path];
  NSArray *array = [Question parseJSONIntoQuestions:data];
  
  XCTAssertNotNil(array, @"No results");
  Question *question = array[0];
  
  XCTAssertTrue([question.title isEqualToString:@"OO Writer Macro in basic to color the font"]);
  
  XCTAssertTrue(array.count == 30);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
