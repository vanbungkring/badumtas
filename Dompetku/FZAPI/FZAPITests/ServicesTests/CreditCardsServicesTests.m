//
//  TransactionServicesTests.m
//  FZAPI
//
//  Created by Julian Clémot on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConfigForTests.h"
#import "FZResponseLoader.h"
#import "FZDataSource.h"
#import "ConnectionServices.h"
#import "User.h"

//Tested
#import "CreditCardServices.h"


@interface CreditCardsServicesTests : XCTestCase

@property (nonatomic, retain) NSString *userkey;
@property (nonatomic, retain) NSString *cardName;
@property (nonatomic, retain) NSString *cardId;
@property (nonatomic, retain) NSString *amount;
@property (nonatomic, assign) NSString *limit;

@property (nonatomic, retain) NSDictionary *datasourceDict;

@property (nonatomic, assign) int result;

@end

@implementation CreditCardsServicesTests

#pragma mark - Init

- (void)setUp
{
	[super setUp];
	
	[self initConnection];
	
	[self initResult];
}

- (void)tearDown{
	[super tearDown];
	[self disconnect];
}

-(void) initConnection {
	
	if([[ConfigForTests sharedInstance] userkeyClient]== nil || [[[ConfigForTests sharedInstance] userkeyClient] isEqualToString:@""]){
		
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"Connection succeeded"];
		
		[ConnectionServices connect:[[ConfigForTests sharedInstance] emailClientUsed] password:[[ConfigForTests sharedInstance] passwordClientUsed] firstTime:YES withDevice:@"XCodeUnitTests" withDeviceName:@"XCodeUnitTests" successBlock:^(id context) {
			XCTAssertNotNil(context, @"No client userkey");
			[[ConfigForTests sharedInstance] setUserkeyClient:context];
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
		} failureBlock:^(Error *error) {
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertEqual(_result,1,@"");
		}];
		
	}//else userkey client has already been initialised, we don't need to do it again
	
}


-(void) disconnect {
	if([[ConfigForTests sharedInstance] userkeyClient]!= nil || ![[[ConfigForTests sharedInstance] userkeyClient] isEqualToString:@""]){
		
		XCTestExpectation *disconnectionSucceeded = [self expectationWithDescription:@"Connection succeeded"];
		
		[ConnectionServices disconnect:[[ConfigForTests sharedInstance] userkeyClient] successBlock:^(id context) {
			XCTAssertNotNil(context, @"No client userkey");
			[[ConfigForTests sharedInstance] setUserkeyClient:nil];
			[disconnectionSucceeded fulfill];
			
			[self resultSuccess];
		} failureBlock:^(Error *error) {
			[disconnectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertEqual(_result,1,@"");
		}];
		
	}
	
}


-(NSString *)getAppropriateUserkeyWithParameter:(NSString *)parameter {
	if([parameter isEqualToString:[[ConfigForTests sharedInstance] emailClientUsed]]){
		return [[ConfigForTests sharedInstance] userkeyClient];
	} else if ([parameter isEqualToString:[[ConfigForTests sharedInstance] emailMerchantUsed]]){
		return [[ConfigForTests sharedInstance] userkeyMerchant];
	}else{
		return parameter;
	}
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
#pragma mark - Tests

//cannot be tested because of payline implication
/*
 + (void)setCreditCardName:(NSString*)cardName
 WithId:(NSString*)cardId
 WithUserKey:(NSString*)userkey
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
/*- (void)testSetCreditCardName {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testSetCreditCardName"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"set credit card name succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		_cardName =[aSetOfParams objectForKey:@"cardName"];
		_cardId =[aSetOfParams objectForKey:@"cardId"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_cardName, @"No cardName");
		XCTAssertNotNil(_cardId, @"No cardId");
		
		[CreditCardServices setCreditCardName:_cardName WithId:_cardId WithUserKey:_userkey successBlock:^(id context) {
			NSLog(@"result set credit card name : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params");
		}];
	}
}*/

/*
 + (void)registeredCards:(NSString *)userkey
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testRegisteredCards {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testRegisteredCards"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"registered cards succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		
		[CreditCardServices registeredCards:_userkey successBlock:^(id context) {
			NSLog(@"result registered cards : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params");
		}];
	}
}

/*
 + (void)doImmediateRefill:(NSString *)userkey
 Amount:(int) amount
 WithCard:(NSString*)chosenCard
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testDoImmediateRefill {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testDoImmediateRefill"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"do immediate refill succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		_cardName = [aSetOfParams objectForKey:@"cardName"];
		_amount = [aSetOfParams objectForKey:@"amount"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_cardName, @"No cardId");
		XCTAssertNotNil(_amount, @"No amount");
		
		NSLog(@"params :::::::: >>>>> userkey : %@ | cardName %@ | amount : %@",_userkey,_cardName,_amount);
		
		[CreditCardServices doImmediateRefill:_userkey Amount:[_amount intValue] WithCard:_cardName successBlock:^(id context) {
			NSLog(@"result do immediate refill : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params");
		}];
	}
}

/*
 + (void)autoRefill:(NSString *)userkey
 Amount:(int) amount
 Limit:(int) limit
 WithCard:(NSString*)chosenCard
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testAutoRefill {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testAutoRefill"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"auto refill succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		_amount = [aSetOfParams objectForKey:@"amount"];
		_cardName = [aSetOfParams objectForKey:@"cardName"];
		_limit = [aSetOfParams objectForKey:@"limit"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_amount, @"No amount");
		XCTAssertNotNil(_cardName, @"No cardName");
		XCTAssertNotNil(_limit, @"No limit");
		
		[CreditCardServices autoRefill:_userkey Amount:_amount Limit:[_limit integerValue] WithCard:_cardName successBlock:^(id context) {
			NSLog(@"result auto refill : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params");
		}];
	}
}

/*
 + (void)cancelAutoRefill:(NSString *)userkey
 WithCard:(NSString*)chosenCard
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testCancelAutoRefill {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testCancelAutorRefill"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"cancel auto refill succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		_cardName = [aSetOfParams objectForKey:@"cardName"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_cardName, @"No cardName");
		
		[CreditCardServices cancelAutoRefill:_userkey WithCard:_cardName successBlock:^(id context) {
			NSLog(@"result cancel auto refill : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params");
		}];
	}
}

/*
 + (void)retrieveAutoRefillRule:(NSString *)userkey
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testRetrieveAutoRefillRule {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testRetrieveAutoRefillRule"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"retrieve auto refill rule succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		
		[CreditCardServices retrieveAutoRefillRule:_userkey successBlock:^(id context) {
			NSLog(@"result retrieve auto refill rule : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params");
		}];
	}
}

/*
 + (void)deleteCreditCard:(NSString *)userkey
 withId:(NSString*)idCard
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testDeleteCreditCard {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testDeleteCreditCard"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"delete credit card succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		_cardId = [aSetOfParams objectForKey:@"cardId"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_cardId, @"No cardId");
		
		[CreditCardServices cancelAutoRefill:_userkey WithCard:_cardName successBlock:^(id context) {
			NSLog(@"result delete credit card : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params");
		}];
	}
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
