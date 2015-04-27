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
#import "RewardsServices.h"

@interface RewardsServicesTests : XCTestCase

@property (nonatomic, retain) NSString *userkey;
@property (nonatomic, retain) NSString *loyaltyProgramId;
@property (nonatomic, retain) NSString *loyaltyCardId;
@property (nonatomic, retain) NSString *rewardsId;
@property (nonatomic, retain) NSString *reference;
@property (nonatomic, retain) NSString *withLogo;

@property (nonatomic, retain) NSDictionary *datasourceDict;

@property (nonatomic, assign) int result;

@end

@implementation RewardsServicesTests

#pragma mark - Init

- (void)setUp
{
	[super setUp];
	
	[self initConnection];
	
	[self initResult];
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

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Tests

/*
+ (void)createFidelitizCard:(NSString*)fidelitizId 
 AffiliatedToTheProgramId:(NSString*)loyaltyProgramId 
 withSuccessBlock:(NetworkSuccessBlock)successBlock 
 failureBlock:(NetworkFailureBlock)failureBlock{
 */
- (void)testCreateFidelitizCard {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testCreateFidelitizCard"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"create fidelitiz card succeeded"];
		
		_rewardsId = [aSetOfParams objectForKey:@"rewardsId"];
		_loyaltyProgramId = [aSetOfParams objectForKey:@"loyaltyProgramId"];
		
		XCTAssertNotNil(_rewardsId, @"No rewardsId");
		XCTAssertNotNil(_loyaltyProgramId, @"No loyaltyProgramId");
		
		[RewardsServices createFidelitizCard:_rewardsId	AffiliatedToTheProgramId:_loyaltyProgramId withSuccessBlock:^(id context) {
			NSLog(@"result create fidelitiz card : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [rewardsId : %@ - loyaltyProgramId : %@ ]",_rewardsId,_loyaltyProgramId);
		}];
	}
}

/*
+ (void)createFidelitizCard:(NSString*)fidelitizId
 AffiliatedToTheProgramId:(NSString*)loyaltyProgramId
 PrivateReference:(NSString*)reference
 withSuccessBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock{
 */
- (void)testCreateFidelitizCardWithPrivateProgram {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testCreateFidelitizCardWithPrivateProgram"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"create fidelitiz card with private program succeeded"];
		
		_rewardsId = [aSetOfParams objectForKey:@"rewardsId"];
		_loyaltyProgramId = [aSetOfParams objectForKey:@"loyaltyProgramId"];
		_reference = [aSetOfParams objectForKey:@"reference"];

		
		XCTAssertNotNil(_rewardsId, @"No rewardsId");
		XCTAssertNotNil(_loyaltyProgramId, @"No loyaltyProgramId");
		XCTAssertNotNil(_reference, @"No reference");
		
		[RewardsServices createFidelitizCard:_rewardsId AffiliatedToTheProgramId:_loyaltyProgramId PrivateReference:_reference withSuccessBlock:^(id context) {
			NSLog(@"result create fidelitiz card with private program : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [rewardsId : %@ - loyaltyProgramId : %@ ]",_rewardsId,_loyaltyProgramId);
		}];
	}
}

/*
+ (void)deleteFidelitizCard:(NSString*)fidelitizId
 CardId:(NSString*)loyaltyCardId
 withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testDeleteFidelitizCard {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testDeleteFidelitizCard"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"delete fidelitiz card succeeded"];
		
		_rewardsId = [aSetOfParams objectForKey:@"rewardsId"];
		_loyaltyCardId = [aSetOfParams objectForKey:@"loyaltyCardId"];
		
		
		XCTAssertNotNil(_rewardsId, @"No rewardsId");
		XCTAssertNotNil(_loyaltyCardId, @"No loyaltyCardId");
		
		[RewardsServices deleteFidelitizCard:_rewardsId CardId:_loyaltyCardId withSuccessBlock:^(id context) {
			NSLog(@"result delete fidelitiz card : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [rewardsId : %@ - loyaltyCardId : %@ ]",_rewardsId,_loyaltyCardId);
		}];
	}
}

/*
+ (void)fidelitizCards:(NSString*)fidelitizId
 withSuccessBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testFidelitizCards {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testFidelitizCards"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"fidelitiz cards succeeded"];
		
		_rewardsId = [aSetOfParams objectForKey:@"rewardsId"];
		
		XCTAssertNotNil(_rewardsId, @"No rewardsId");
		
		[RewardsServices fidelitizCards:_rewardsId withSuccessBlock:^(id context) {
			NSLog(@"result fidelitiz cards : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [rewardsId : %@]",_rewardsId);
		}];
	}
}

/*
+ (void)fidelitizCardsWithUserkey:(NSString*)userkey
 withSuccessBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testFidelitizCardsWithUserKey {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testFidelitizCardsWithUserkey"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"fidelitiz cards with userkey succeeded"];
		
		_userkey = [aSetOfParams objectForKey:@"userkey"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		
		[RewardsServices fidelitizCardsWithUserkey:_userkey withSuccessBlock:^(id context) {
			NSLog(@"result fidelitiz cards with userkey : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@]",_userkey);
		}];
	}
}

/*
 + (void)programDetails:(NSString*)loyaltyProgramId
 withLogo:(BOOL)withLogo
 withSuccessBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testProgramsDetails {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testProgramDetails"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"program details succeeded"];
		
		_loyaltyProgramId = [aSetOfParams objectForKey:@"loyaltyProgramId"];
		_withLogo = [aSetOfParams objectForKey:@"withLogo"];
		
		
		XCTAssertNotNil(_loyaltyProgramId, @"No loyaltyProgramId");
		XCTAssertNotNil(_withLogo, @"No withLogo");
		
		[RewardsServices programDetails:_loyaltyProgramId withLogo:[_withLogo boolValue] withSuccessBlock:^(id context) {
			NSLog(@"result program details : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [loyaltyProgramId : %@, withLogo : %@]",_loyaltyProgramId,_withLogo);
		}];
	}
}

/*
+ (void)programsListNotAlreadySuscribe:(NSString*)fidelitizId
 withSuccessBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testProgramsListNotAlreadySuscribe {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testProgramsListNotAlreadySuscribe"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"programs list not already suscribed succeeded"];
		
		_rewardsId = [aSetOfParams objectForKey:@"rewardsId"];
		
		XCTAssertNotNil(_rewardsId, @"No rewardsId");
		
		[RewardsServices programsListNotAlreadySuscribe:_rewardsId withSuccessBlock:^(id context) {
			NSLog(@"result programs list not already suscribed  : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [rewardsId : %@]",_rewardsId);
		}];
	}
}

/*
+ (void)programsListNotAlreadySuscribeWithUserkey:(NSString*)userkey
 withSuccessBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock {
 */
- (void)testProgramsListNotAlreadySuscribeWithUserkey {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testProgramsListNotAlreadySuscribeWithUserkey"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"programs list not already suscribed with userkey succeeded"];
		
		_userkey = [aSetOfParams objectForKey:@"userkey"];
		
		XCTAssertNotNil(_rewardsId, @"No rewardsId");
		
		[RewardsServices programsListNotAlreadySuscribeWithUserkey:_userkey withSuccessBlock:^(id context) {
			NSLog(@"result programs list not already suscribed with userkey : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@]",_userkey);
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
