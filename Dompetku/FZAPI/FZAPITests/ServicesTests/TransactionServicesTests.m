//
//  TransactionServicesTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConfigForTests.h"
#import "FZResponseLoader.h"
#import "FZDataSource.h"
#import "ConnectionServices.h"

//Tested
#import "TransactionServices.h"
@interface TransactionServicesTests : XCTestCase

@property (nonatomic, retain) NSString *userkey;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, retain) NSString *invoiceID;
@property (nonatomic, retain) NSString *receiver;
@property (nonatomic, retain) NSString *sender;
@property (nonatomic, retain) NSString *side;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *type;

@property (nonatomic, retain) NSDictionary *datasourceDict;

@property (nonatomic, assign) int result;

@end

@implementation TransactionServicesTests

#pragma mark - Init

- (void)setUp
{
	[super setUp];
	
	NSLog(@"\n\nAssume that tests are on this server : %@\n\n",[ConfigForTests serverUsed]);
	
	[self initResult];
}

#pragma mark - Utils

- (void) initResult {
	_result = -1;
}

- (void) resultSuccess {
	_result = 1;
}

- (void) resultFail {
	_result = 0;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Tests

/*
 + (void)transfertMoney:(NSString *)amount
 withComment:(NSString *)comment
 forUser:(NSString *)reciver
 fromUser:(NSString *)userKey
 withType:(NSString *)type
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testTransferMoney {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testTransferMoney"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"transfer money succeeded"];
		
		_userkey = [aSetOfParams objectForKey:@"userkey"];
		_amount = [aSetOfParams objectForKey:@"amount"];
		_receiver = [aSetOfParams objectForKey:@"forUser"];
		_comment = [aSetOfParams objectForKey:@"comment"];
		_type = [aSetOfParams objectForKey:@"type"];
		
		XCTAssertNotNil(_amount, @"No amount");
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_receiver, @"No receiver");
		XCTAssertNotNil(_comment, @"No comment");
		XCTAssertNotNil(_type, @"No type");
		
		[TransactionServices transfertMoney:_amount withComment:_comment forUser:_receiver fromUser:_userkey withType:_type successBlock:^(id context) {
			NSLog(@"result send money : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [amount : %@ - sender : %@ - receiver : %@ - comment : %@ - type : %@]",_amount,_userkey, _receiver, _comment, _type);
		}];
	}
}

/*
 + (void)executeTransactionsWithId:(NSString *)idTransaction
 forUser:(NSString *)userKey
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testExecuteTransactions {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testExecuteTransactions"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"send money succeeded"];
		
		_userkey = [aSetOfParams objectForKey:@"userkey"];
		_invoiceID = [aSetOfParams objectForKey:@"invoiceId"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_invoiceID, @"No invoiceID");
		
		[TransactionServices executeTransactionsWithId:_invoiceID forUser:_userkey successBlock:^(id context) {
			NSLog(@"result execute transaction : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [id : %@ - userKey : %@]",_invoiceID,_userkey);
		}];
	}
}

/*
 + (void)cancelTransactionsWithId:(NSString *)idTransaction
 forUser:(NSString *)userKey
 andSide:(NSString *)side
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testCancelTransactions {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testExecuteTransactions"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"send money succeeded"];
		
		_userkey = [aSetOfParams objectForKey:@"userkey"];
		_invoiceID = [aSetOfParams objectForKey:@"invoiceId"];
		_side = [aSetOfParams objectForKey:@"side"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_invoiceID, @"No invoiceID");
		XCTAssertNotNil(_side, @"No side");
		
		[TransactionServices cancelTransactionsWithId:_invoiceID forUser:_userkey andSide:_side successBlock:^(id context) {
			NSLog(@"result cancel transaction : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [id : %@ - userKey : %@ - side : %@]",_invoiceID,_userkey,_side);
		}];
	}
}

@end
