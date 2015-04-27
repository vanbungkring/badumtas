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
#import "UserServices.h"

@interface UserServicesTest : XCTestCase

@property (nonatomic, retain) NSString *userkey;
@property (nonatomic, retain) User *user;

@property (nonatomic, retain) NSDictionary *datasourceDict;

@property (nonatomic, assign) int result;

@end

@implementation UserServicesTest

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
 + (void)userEditInformation:(User *)user userkey:(NSString *)userkey withSuccesBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock{
 */
- (void)testUserEditInformation {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testUserEditInformation"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"get user information succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		[_user setFirstName:[aSetOfParams objectForKey:@"firstName"]];
		[_user setLastName:[aSetOfParams objectForKey:@"lastName"]];
		[_user setSex:[aSetOfParams objectForKey:@"gender"]];
		[_user setBirthday:[aSetOfParams objectForKey:@"birthDate"]];
		[_user setNationality:[aSetOfParams objectForKey:@"nationality"]];
		[_user setAddress1:[aSetOfParams objectForKey:@"address1"]];
		[_user setCityCode:[aSetOfParams objectForKey:@"zipcode"]];
		[_user setCityName:[aSetOfParams objectForKey:@"city"]];
		[_user setPhoneNumber:[aSetOfParams objectForKey:@"phoneNumber"]];
		
		
		[UserServices userEditInformation:_user userkey:_userkey withSuccesBlock:^(id context) {
			NSLog(@"result user edit informations : %@",context);
			XCTAssertNotNil(context, @"Not sent");
			
			[connectionSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			
			[connectionSucceeded fulfill];
			
			[self resultFail];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			XCTAssertEqual(_result,[[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@ - user : %@ ]",_userkey,_user);
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
