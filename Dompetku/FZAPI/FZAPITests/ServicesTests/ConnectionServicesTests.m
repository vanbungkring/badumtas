//
//  ConnectionServicesTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 09/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConfigForTests.h"
#import "FZResponseLoader.h"
#import "FZDataSource.h"

//Tested
#import "ConnectionServices.h"

@interface ConnectionServicesTests : XCTestCase

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userkey;
@property (nonatomic, retain) NSString *pin;
@property (nonatomic, retain) NSString *sendPin;
@property (nonatomic, retain) NSString *checkPin;
@property (nonatomic, retain) NSString *oldPin;
@property (nonatomic, retain) NSString *neewPin;


@property (nonatomic, retain) NSDictionary *datasourceDict;

@property (nonatomic, assign) int result;

@end

@implementation ConnectionServicesTests

#pragma mark - Init

- (void)setUp
{
	[super setUp];
	
	_email = nil;
	_password = nil;
	_userkey = nil;
	_pin = nil;
	_sendPin = nil;
	_checkPin = nil;
	_oldPin = nil;
	_neewPin = nil;
	[self initConnection];
	
	[self initResult];
}

- (void)tearDown{
	[super tearDown];
	_email = nil;
	_password = nil;
	_userkey = nil;
	_pin = nil;
	_sendPin = nil;
	_checkPin = nil;
	_oldPin = nil;
	_neewPin = nil;
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

#pragma mark - Tests

/*
+ (void)connect:(NSString *)theUser
       password:(NSString *)pwd
      firstTime:(BOOL)firstTime
     withDevice:(NSString *)device
 withDeviceName:(NSString *)name
   successBlock:(NetworkSuccessBlock)successBlock
   failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testConnectPasswordFirstTimeWithDevice {
    
    NSArray *params = [FZResponseLoader readCVSFromFile:@"testConnectPasswordFirstTimeWithDevice"];
    
    XCTAssertNotNil(params, @"\n\nNo params");
    XCTAssertTrue([params count] > 0, @"No params\n\n");
    
    for (NSDictionary *aSetOfParams in params) {
        
        XCTestExpectation *connectionSucceeded = [self expectationWithDescription:@"Connection succeeded"];
        
        _email = [aSetOfParams objectForKey:@"email"];
        _password = [aSetOfParams objectForKey:@"password"];
        
        XCTAssertNotNil(_email, @"\n\nNo email");
        XCTAssertNotNil(_password, @"No password\n\n");
        
        NSLog(@"tested : [email : %@ - password : %@]",_email,_password);
        
        [ConnectionServices connect:_email password:_password firstTime:YES withDevice:@"XCodeUnitTests" withDeviceName:@"XCodeUnitTests" successBlock:^(id context) {
			
			NSLog(@"response tested : [email : %@ - password : %@]",_email,_password);
			
            XCTAssertNotNil(context, @"\n\nNo userkey\n\n");
            
            [connectionSucceeded fulfill];
            
            [self resultSuccess];
            
        } failureBlock:^(Error *error) {
            [connectionSucceeded fulfill];
            
            [self resultFail];
        }];
        
        [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
            XCTAssertNil(error);
            XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"\n\nFail for params' set [email : %@ - password : %@\n\n]",_email,_password);
        }];
    }
}

/*
+ (void)sendPIN:(NSString *)PIN
    withUserKey:(NSString *)userKey
      withToken:(NSString *)token
   successBlock:(NetworkSuccessBlock)successBlock
   failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testSendPINWithUserkeyWithToken {
	
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testSendPINWithUserkeyWithToken"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *sendPINSucceeded = [self expectationWithDescription:@"Send PIN succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		_pin = [aSetOfParams objectForKey:@"pin"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_pin, @"No pin");
		
		[ConnectionServices sendPIN:_pin withUserKey:_userkey withToken:@"" successBlock:^(id context) {
			
			XCTAssertNotNil(context, @"Send PIN failure");
			
			[sendPINSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			[sendPINSucceeded fulfill];
			
			[self resultFail];
		}];
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@ - pin : %@ ]",_userkey,_pin);
		}];
	}
}

/*
+ (void)connectWithKey:(NSString *)userKey
                andPin:(NSString *)pin
          successBlock:(NetworkSuccessBlock)successBlock
          failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testConnectWithKeyAndPin {
	
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testConnectWithKeyAndPin"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *connectionWithKeySucceeded = [self expectationWithDescription:@"Connection with Userkey succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		_pin = [aSetOfParams objectForKey:@"pin"];
		_sendPin = [aSetOfParams objectForKey:@"sendPin"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_pin, @"No pin");
		[ConnectionServices sendPIN:_sendPin withUserKey:_userkey withToken:@"" successBlock:^(id context) {
			
			[ConnectionServices connectWithKey:_userkey andPin:_pin successBlock:^(id context) {
				
				XCTAssertNotNil(context, @"Connection with Userkey failure");
				
				[connectionWithKeySucceeded fulfill];
				
				[self resultSuccess];
				
			} failureBlock:^(Error *error) {
				[connectionWithKeySucceeded fulfill];
				
				[self resultFail];
			}];

		} failureBlock:^(Error *error) {
			[connectionWithKeySucceeded fulfill];
			
			[self resultFail];
		}];
		
				[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@ - pin : %@ ]",_userkey,_pin);
		}];
	}
}

/*
+ (void)disconnect:(NSString *)userkey
      successBlock:(NetworkSuccessBlock)successBlock
      failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testDisconnect {
	
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testSendPINWithUserkeyWithToken"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *sendPINSucceeded = [self expectationWithDescription:@"disconnect succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		
		[ConnectionServices disconnect:_userkey successBlock:^(id context) {
			
			XCTAssertNotNil(context, @"disconnect failure");
			
			[sendPINSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			[sendPINSucceeded fulfill];
			
			[self resultFail];
		}];
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@]",_userkey);
		}];
	}
}

/*
+ (void)retrieveAccount:(NSString *)userKey
           successBlock:(NetworkSuccessBlock)successBlock
           failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testRetrieveAccount {
    
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testRetrieveAccount"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *retrieveAccountSucceeded = [self expectationWithDescription:@"retrieve Account succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		
		[ConnectionServices retrieveAccount:_userkey successBlock:^(id context) {
			
			XCTAssertNotNil(context, @"retrieve Account failure");
			
			[retrieveAccountSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			[retrieveAccountSucceeded fulfill];
			
			[self resultFail];
		}];
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@]",_userkey);
		}];
	}
}

/*
+ (void)retrieveUserInfos:(NSString *)userKey
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testRetrieveUserInfos {
    
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testRetrieveUserInfos"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *RetrieveUserInfosSucceeded = [self expectationWithDescription:@"retrieve user infos succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		
		[ConnectionServices retrieveAccount:_userkey successBlock:^(id context) {
			
			XCTAssertNotNil(context, @"retrieve user infos failure");
			
			[RetrieveUserInfosSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			[RetrieveUserInfosSucceeded fulfill];
			
			[self resultFail];
		}];
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@]",_userkey);
		}];
	}
}

/*
+ (void)retrieveUserInfosLight:(NSString *)userKey
                  successBlock:(NetworkSuccessBlock)successBlock
                  failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testRetrieveUserInfosLight {
    
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testRetrieveUserInfosLight"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *RetrieveUserInfosLightSucceeded = [self expectationWithDescription:@"retrieve user infos light succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		
		[ConnectionServices retrieveAccount:_userkey successBlock:^(id context) {
			
			XCTAssertNotNil(context, @"retrieve user infos light failure");
			
			[RetrieveUserInfosLightSucceeded fulfill];
			
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			[RetrieveUserInfosLightSucceeded fulfill];
			
			[self resultFail];
		}];
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@]",_userkey);
		}];
	}
}

/*
+ (void)checkPIN:(NSString *)PIN
     withUserKey:(NSString *)userKey
    successBlock:(NetworkSuccessBlock)successBlock
    failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testCheckPINWithUserKey {
	
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testCheckPinWithUserkey"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");

	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *checkPINWithUserKeySucceeded = [self expectationWithDescription:@"check pin succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		_sendPin=[aSetOfParams objectForKey:@"sendPin"];
		_checkPin=[aSetOfParams objectForKey:@"checkPin"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_sendPin, @"No sendPin");
		XCTAssertNotNil(_checkPin, @"No checkpin");
		
		[ConnectionServices sendPIN:_sendPin withUserKey:_userkey withToken:@"" successBlock:^(id context) {
			
			[ConnectionServices checkPIN:_checkPin withUserKey:_userkey successBlock:^(id context) {
				
				XCTAssertNotNil(context, @"Check PIN failure");
				
				[self resultSuccess];
				[checkPINWithUserKeySucceeded fulfill];
				
			} failureBlock:^(Error *error) {
				[self resultFail];

				[checkPINWithUserKeySucceeded fulfill];
			}];
			
		} failureBlock:^(Error *error) {
			
			[self resultFail];

			[checkPINWithUserKeySucceeded fulfill];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@ - sendPin : %@ - checkPin : %@]",_userkey,_sendPin,_checkPin);
		}];
	}

}

/*
+ (void)changePIN:(NSString *)oldPIN
         toNewPIN:(NSString *)newPIN
      withUserKey:(NSString *)userKey
     successBlock:(NetworkSuccessBlock)successBlock
     failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testChangePINToNewPINWithUserkey {
    
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testChangePinToNewPinWithUserkey"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *changePINWithUserKeySucceeded = [self expectationWithDescription:@"change pin to new pin succeeded"];
		
		_userkey = [self getAppropriateUserkeyWithParameter:[aSetOfParams objectForKey:@"userkey"]];
		_oldPin=[aSetOfParams objectForKey:@"oldPin"];
		_neewPin=[aSetOfParams objectForKey:@"newPin"];
		
		XCTAssertNotNil(_userkey, @"No userkey");
		XCTAssertNotNil(_oldPin, @"No oldPin");
		XCTAssertNotNil(_neewPin, @"No newPin");
		
		[ConnectionServices sendPIN:_oldPin withUserKey:_userkey withToken:@"" successBlock:^(id context) {
			
			[ConnectionServices changePIN:_oldPin toNewPIN:_neewPin withUserKey:_userkey successBlock:^(id context) {
				
				XCTAssertNotNil(context, @"change pin to new pin failure");
				
				[self resultSuccess];
				[changePINWithUserKeySucceeded fulfill];
				
			} failureBlock:^(Error *error) {
				[self resultFail];
				[changePINWithUserKeySucceeded fulfill];
			}];
			
		} failureBlock:^(Error *error) {
			[self resultFail];
			[changePINWithUserKeySucceeded fulfill];
		}];
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [userkey : %@ - newPin : %@ - oldPin : %@]",_userkey,_neewPin,_oldPin);
		}];
	}
}

/*
+ (void)forgottenPassword:(NSString *)email
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock;
*/
- (void)testForgottenPassword {
    
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testForgottenPassword"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	int i = 0;
	for (NSDictionary *aSetOfParams in params) {
		
		NSLog(@"\n\n%d\n",i);
		i++;
		
		XCTestExpectation *forgottenPasswordSucceeded = [self expectationWithDescription:@"forgottenPassword succeeded"];
		
		_email = [aSetOfParams objectForKey:@"email"];
		
		XCTAssertNotNil(_email, @"No email");
		
		[ConnectionServices forgottenPassword:_email successBlock:^(id context) {
			
			XCTAssertNotNil(context, @"forgottenPassword failure");
			
			[forgottenPasswordSucceeded fulfill];
			[self resultSuccess];
			
		} failureBlock:^(Error *error) {
			[forgottenPasswordSucceeded fulfill];
			
			[self resultFail];
		}];
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [email : %@]",_email);
		}];
	}
}

#pragma mark - Cannot be tested

// Token is sent by email

/*
 + (void)secretQuestion:(NSString *)token
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock;
 
 + (void)confirmSecretAnswer:(NSString *)token
 secretAnswer:(NSString *)secretAnswer
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock;
 
 + (void)changePassword:(NSString *)password
 token:(NSString *)token
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock;
*/

// Uses the service : retrieveUserInfosLight

/*
 + (void)updateIfStillTrial;
*/

#pragma mark - MM

- (void)dealloc {
    [super dealloc];
    [_email release], _email = nil;
    [_password release], _password = nil;
    [_userkey release], _userkey = nil;
    [_pin release], _pin = nil;
    
    [_datasourceDict retain], _datasourceDict = nil;
}

@end

