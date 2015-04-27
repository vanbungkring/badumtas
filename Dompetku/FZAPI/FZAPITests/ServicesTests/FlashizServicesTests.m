//
//  FlashizServicesTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "FlashizServices.h"

@interface FlashizServicesTests : XCTestCase

@end

@implementation FlashizServicesTests

#define kTestJsonUrl [NSURL URLWithString:@"http://httpbin.org/post"]
#define kTestJsonServiceName @"testRequest"

#define kTestJsonElementValueFirst @"value1"
#define kTestJsonElementValueTwo @"value2"

#define kTestJsonElementKeyFirst @"key1"
#define kTestJsonElementKeyTwo @"key2"

#pragma mark - Init

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Tests

/*
 + (NSURLRequest *)requestPostForUrl:(NSURL *)url
 withParameters:(NSDictionary *)parameters;
 */
- (void)testRequestPostForUrlWithParameters {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:kTestJsonElementValueFirst forKey:kTestJsonElementKeyFirst];
    [dict setValue:kTestJsonElementValueTwo forKey:kTestJsonElementKeyTwo];
    
    NSURLRequest *rQ = [FlashizServices requestPostForUrl:kTestJsonUrl withParameters:dict];
    
    XCTestExpectation *connectionSucceeded = [self expectationWithDescription:kTestJsonServiceName];
    
    [FlashizServices executeRequest:rQ forService:@"testRequestPostForUrlWithParameters" withSuccessBlock:^(id context) {
        
        NSDictionary *dic = [context valueForKey:@"form"];
        
        XCTAssertTrue([dic count]==2, @"Dictionnary are not the good size as expected");
        
        XCTAssertTrue([[dic valueForKey:kTestJsonElementKeyFirst]isEqualToString:kTestJsonElementValueFirst], @"Not same value as expected");
        XCTAssertTrue([[dic valueForKey:kTestJsonElementKeyTwo]isEqualToString:kTestJsonElementValueTwo], @"Not same value as expected");
        
        [connectionSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        
        [connectionSucceeded fulfill];
        
    }];
    
    
    [dict release],dict = nil;
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
}

/*
 + (NSURLRequest *)requestPostForUrl:(NSURL *)url
 withJsonData:(NSString *)data;
 */
- (void)testrRquestPostForUrlWithJsonData {
    
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:kTestJsonElementValueFirst forKey:kTestJsonElementKeyFirst];
    [dict setValue:kTestJsonElementValueTwo forKey:kTestJsonElementKeyTwo];
    
    NSURLRequest *rQ = [FlashizServices requestPostForUrl:kTestJsonUrl withJsonData:[dict description]];
    
    XCTestExpectation *connectionSucceeded = [self expectationWithDescription:kTestJsonServiceName];
    
    [FlashizServices executeRequest:rQ forService:@"testrRquestPostForUrlWithJsonData" withSuccessBlock:^(id context) {
        
        NSString *value = [context valueForKey:@"data"];
        
        XCTAssertTrue([value isEqualToString:@"{\n    key1 = value1;\n    key2 = value2;\n}"], @"Not same value as expected");
        
        [connectionSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        
        [connectionSucceeded fulfill];
        
    }];
    
    
    [dict release],dict = nil;
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
    
    
}

/*
 + (NSURLRequest *)requestPostCustomForUrl:(NSURL *)url
 withParameters:(NSDictionary *)parameters;
 */
- (void)testRequestPostCustomForUrl {
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:kTestJsonElementValueFirst forKey:kTestJsonElementKeyFirst];
    [dict setValue:kTestJsonElementValueTwo forKey:kTestJsonElementKeyTwo];
    
    NSURLRequest *rQ = [FlashizServices requestPostCustomForUrl:kTestJsonUrl withParameters:dict];
    
    XCTestExpectation *connectionSucceeded = [self expectationWithDescription:kTestJsonServiceName];
    
    [FlashizServices executeRequest:rQ forService:@"testRequestPostCustomForUrl" withSuccessBlock:^(id context) {
        
        NSDictionary *dic = [context valueForKey:@"form"];
        
        XCTAssertTrue([dic count]==2, @"Dictionnary are not the good size as expected");
        
        XCTAssertTrue([[dic valueForKey:kTestJsonElementKeyFirst]isEqualToString:kTestJsonElementValueFirst], @"Not same value as expected");
        XCTAssertTrue([[dic valueForKey:kTestJsonElementKeyTwo]isEqualToString:kTestJsonElementValueTwo], @"Not same value as expected");
        
        [connectionSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        
        [connectionSucceeded fulfill];
        
    }];
    
    
    [dict release],dict = nil;
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
    
}

/*
 + (NSURLRequest *)requestGetForUrl:(NSURL *)url;
 */
- (void)testRequestGetForUrl {
    
    NSURLRequest *rQ = [FlashizServices requestGetForUrl:kTestJsonUrl];
    
    XCTestExpectation *connectionSucceeded = [self expectationWithDescription:kTestJsonServiceName];
    
    [FlashizServices executeRequest:rQ forService:@"testRequestGetForUrl" withSuccessBlock:^(id context) {
        
        [connectionSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        
        [connectionSucceeded fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
    
}

/*
 + (void)executeRequest:(NSURLRequest *)urlrequest
 forService:(NSString *)serviceDescription
 withSuccessBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testExecuteRequestSuccess {
    
    NSURLRequest *rQ = [FlashizServices requestGetForUrl:[NSURL URLWithString:@"http://httpbin.org/get"]];
    
    XCTestExpectation *connectionSucceeded = [self expectationWithDescription:kTestJsonServiceName];
    
    [FlashizServices executeRequest:rQ forService:@"testExecuteRequestSuccess" withSuccessBlock:^(id context) {
        
        [connectionSucceeded fulfill];
        
    } failureBlock:^(Error *error) {
        
        [connectionSucceeded fulfill];
        XCTFail(@"Unexpected result");
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
}

/*
 + (void)executeRequest:(NSURLRequest *)urlrequest
 forService:(NSString *)serviceDescription
 withSuccessBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testExecuteRequestFailed {
    
    NSURLRequest *rQ = [FlashizServices requestGetForUrl:[NSURL URLWithString:@"http://0"]];
    
    XCTestExpectation *connectionSucceeded = [self expectationWithDescription:kTestJsonServiceName];
    
    [FlashizServices executeRequest:rQ forService:@"testExecuteRequestFailed" withSuccessBlock:^(id context) {
        
        [connectionSucceeded fulfill];
        XCTFail(@"Unexpected result");
        
    } failureBlock:^(Error *error) {
        
        [connectionSucceeded fulfill];
        
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        
    }];
}

/*
 + (BOOL)isResultValidForContextDictionary:(NSDictionary *)context;
 */
- (void)testIsResultValidForContextDictionary {
    
    NSDictionary *aDictionary = nil;
    
    aDictionary = [FZResponseLoader readJSONFromFile:@"changePassword" withClass:[NSDictionary dictionary]];
    
    XCTAssertTrue([FlashizServices isResultValidForContextDictionary:aDictionary], @"Result unexpected for isResultValidForContextDictionary");
    
    aDictionary = [FZResponseLoader readJSONFromFile:@"checkPaymentSuccess" withClass:[NSDictionary dictionary]];
    
    XCTAssertTrue([FlashizServices isResultValidForContextDictionary:aDictionary], @"Result unexpected for isResultValidForContextDictionary");
    
    aDictionary = [FZResponseLoader readJSONFromFile:@"checkpayment" withClass:[NSDictionary dictionary]];
    
    XCTAssertFalse([FlashizServices isResultValidForContextDictionary:aDictionary], @"Result unexpected for isResultValidForContextDictionary");
    
    aDictionary = [FZResponseLoader readJSONFromFile:@"getautorefillrule" withClass:[NSDictionary dictionary]];
    
    XCTAssertFalse([FlashizServices isResultValidForContextDictionary:aDictionary], @"Result unexpected for isResultValidForContextDictionary");
}

/*
 +(Error*)retrieveErrorWith:(int)requestStatusCode and:(int)requestErrorCode forService:(NSString *)serviceDescription;
 */
/*- (void)testRetrieveErrorWith {
 // Tested in ErrorTests
 }*/

/*
 +(Error *)errorWithMessage:(NSString *)message code:(FlashizError)code andRequestCode:(int)rCode;
 */
/*- (void)testErrorWithMessage {
 // Tested in ErrorTests
 }*/

@end



