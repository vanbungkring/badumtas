//
//  AvatarServicesTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 29/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConfigForTests.h"
#import "ConnectionServices.h"

//Tested
#import "AvatarServices.h"

@interface AvatarServicesTests : XCTestCase

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userkey;
@property (nonatomic, retain) NSString *username;

@property (nonatomic, assign) int result;

@end

@implementation AvatarServicesTests

#pragma mark - Init & Ending

- (void)setUp {
	[super setUp];
	// Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
	// Put teardown code here. This method is called after the invocation of each test method in the class.
	[super tearDown];
}

#pragma mark - Util

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
 + (void)avatarWithMail:(NSString *)userMail
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testAvatarWithMail {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testAvatarWithMail"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *avatarWithMailSucceeded = [self expectationWithDescription:@"AvatarWithMail succeeded"];
		
		NSString *email = [aSetOfParams objectForKey:@"email"];
		
		BOOL connected = [[aSetOfParams objectForKey:@"connected"] boolValue];
		if(!connected) {
			
			if([_userkey length] > 0) {
				
				[ConnectionServices disconnect:_userkey successBlock:^(id context) {
					
					if([email isEqualToString:@"unValidEmail"]) {
						[self setEmail:@"unvalid@unvalid.com"];
					}
					
					[self doTestAvatarWithMail:_email expectation:avatarWithMailSucceeded];
					
					[self setUserkey:nil];
					
				} failureBlock:^(Error *error) {
					XCTFail(@"ConnectionServices disconnection has failed");
					
				}];
			} else {
				
				if([email isEqualToString:@"unValidEmail"]) {
					[self setEmail:@"unvalid@unvalid.com"];
				}
				
				[self doTestAvatarWithMail:email expectation:avatarWithMailSucceeded];
			}
			
		} else {
			
			_email = [[ConfigForTests sharedInstance] emailClientUsed];
			_password = [[ConfigForTests sharedInstance] passwordClientUsed];
			
			XCTAssertNotNil(_email, @"No email");
			XCTAssertNotNil(_password, @"No password");
			
			[ConnectionServices connect:_email password:_password firstTime:YES withDevice:@"XCodeUnitTests" withDeviceName:@"XCodeUnitTests" successBlock:^(id context) {
				
				XCTAssertNotNil(context, @"No userkey");
				
				[self setUserkey:context];
				
				if([email isEqualToString:@"unValidEmail"]) {
					[self setEmail:@"unvalid@unvalid.com"];
				}
				
				[self doTestAvatarWithMail:_email expectation:avatarWithMailSucceeded];
				
			} failureBlock:^(Error *error) {
				XCTFail(@"ConnectionServices connection has failed");
			}];
		}
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [connected : %@ - email : %@ ]",connected?@"YES":@"NO",email);
		}];
	}
}

- (void)doTestAvatarWithMail:(NSString *)email expectation:(XCTestExpectation *)avatarWithMailSucceeded{
	
	[AvatarServices avatarWithMail:email successBlock:^(id context) {
		
		XCTAssertNotNil(context, @"No avatar");
		
		[avatarWithMailSucceeded fulfill];
		
		[self resultSuccess];
		
	} failureBlock:^(Error *error) {
		
		[avatarWithMailSucceeded fulfill];
		
		[self resultFail];
	}];
}

/*
 + (void)avatarWithUserName:(NSString *)userName
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testAvatarWithUserName {
	
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testAvatarWithUserName"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *avatarWithUserNameSucceeded = [self expectationWithDescription:@"AvatarWithUserName succeeded"];
		
		[self setUsername: [aSetOfParams objectForKey:@"username"]];
		
		BOOL connected = [[aSetOfParams objectForKey:@"connected"] boolValue];
		if(!connected) {
			
			if([_userkey length] > 0) {
				
				[ConnectionServices disconnect:_userkey successBlock:^(id context) {
					
					//NSLog(@"Disconnected");
					
					//NSLog(@"username : %@",_username);
					
					[self doTestAvatarWithUserName:_username expectation:avatarWithUserNameSucceeded];
					
					[self setUserkey:nil];
					
				} failureBlock:^(Error *error) {
					XCTFail(@"ConnectionServices disconnection has failed");
					
				}];
			} else {
				[self doTestAvatarWithUserName:_username expectation:avatarWithUserNameSucceeded];
			}
			
		} else {
			
			[self setEmail:[[ConfigForTests sharedInstance] emailClientUsed]];
			[self setPassword:[[ConfigForTests sharedInstance] passwordClientUsed]];
			
			XCTAssertNotNil(_email, @"No email");
			XCTAssertNotNil(_password, @"No password");
			
			[ConnectionServices connect:_email password:_password firstTime:YES withDevice:@"XCodeUnitTests" withDeviceName:@"XCodeUnitTests" successBlock:^(id context) {
				
				XCTAssertNotNil(context, @"No userkey");
				
				//NSLog(@"Connected");
				
				[self setUserkey:context];
				
				[ConnectionServices retrieveUserInfos:_userkey successBlock:^(id context) {
					
					if([_username isEqualToString:@"validUsername"]) {
						[self setUsername:[context username]];
					}
					
					[self doTestAvatarWithUserName:_username expectation:avatarWithUserNameSucceeded];
					
				} failureBlock:^(Error *error) {
					XCTFail(@"ConnectionServices retrieveUserInfos has failed");
					
				}];
				
			} failureBlock:^(Error *error) {
				XCTFail(@"ConnectionServices connection has failed");
			}];
		}
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [connected : %@ - username : %@ ]",connected?@"YES":@"NO",_username);
		}];
	}
}

- (void)doTestAvatarWithUserName:(NSString *)userName expectation:(XCTestExpectation *)avatarWithUserNameSucceeded{
	
	
	//NSLog(@"%@ %@",userName,avatarWithUserNameSucceeded);
	
	
	[AvatarServices avatarWithUserName:userName successBlock:^(id context) {
		
		XCTAssertNotNil(context, @"No avatar");
		
		//NSLog(@"%@",context);
		
		[avatarWithUserNameSucceeded fulfill];
		
		[self resultSuccess];
		
	} failureBlock:^(Error *error) {
		
		[avatarWithUserNameSucceeded fulfill];
		
		[self resultFail];
	}];
}

/*
 + (void)avatarTimestampWithMail:(NSString *)mail
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testAvatarTimestampWithMail {
	
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testAvatarTimestampWithMail"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *avatarTimestampWithMailSucceeded = [self expectationWithDescription:@"AvatarTimestampWithMail succeeded"];
		
		NSString *email = [aSetOfParams objectForKey:@"email"];
		
		BOOL connected = [[aSetOfParams objectForKey:@"connected"] boolValue];
		if(!connected) {
			
			if([_userkey length] > 0) {
				
				[ConnectionServices disconnect:_userkey successBlock:^(id context) {
					
					if([email isEqualToString:@"unValidEmail"]) {
						[self setEmail:@"unvalid@unvalid.com"];
					}
					
					[self doTestAvatarTimestampWithMail:_email expectation:avatarTimestampWithMailSucceeded];
					
					[self setUserkey:nil];
					
				} failureBlock:^(Error *error) {
					XCTFail(@"ConnectionServices disconnection has failed");
					
				}];
			} else {
				
				if([email isEqualToString:@"unValidEmail"]) {
					[self setEmail:@"unvalid@unvalid.com"];
				}
				
				[self doTestAvatarTimestampWithMail:_email expectation:avatarTimestampWithMailSucceeded];
			}
			
		} else {
			
			_email = [[ConfigForTests sharedInstance] emailClientUsed];
			_password = [[ConfigForTests sharedInstance] passwordClientUsed];
			
			XCTAssertNotNil(_email, @"No email");
			XCTAssertNotNil(_password, @"No password");
			
			[ConnectionServices connect:_email password:_password firstTime:YES withDevice:@"XCodeUnitTests" withDeviceName:@"XCodeUnitTests" successBlock:^(id context) {
				
				XCTAssertNotNil(context, @"No userkey");
				
				[self setUserkey:context];
				
				if([email isEqualToString:@"unValidEmail"]) {
					[self setEmail:@"unvalid@unvalid.com"];
				}
				
				[self doTestAvatarTimestampWithMail:_email expectation:avatarTimestampWithMailSucceeded];
				
			} failureBlock:^(Error *error) {
				XCTFail(@"ConnectionServices connection has failed");
			}];
		}
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [connected : %@ - email : %@ ]",connected?@"YES":@"NO",email);
		}];
	}
}

- (void)doTestAvatarTimestampWithMail:(NSString *)email expectation:(XCTestExpectation *)avatarTimestampWithMailSucceeded{
	
	[AvatarServices avatarTimestampWithMail:email successBlock:^(id context) {
		
		XCTAssertNotNil(context, @"No timestamp");
		
		[avatarTimestampWithMailSucceeded fulfill];
		
		[self resultSuccess];
		
	} failureBlock:^(Error *error) {
		
		[avatarTimestampWithMailSucceeded fulfill];
		
		[self resultFail];
	}];
}

/*
 + (void)setAvatarWithUserKey:(NSString *)userKey avatar:(UIImage *)avatarFile token:(NSString *)token
 successBlock:(NetworkSuccessBlock)successBlock
 failureBlock:(NetworkFailureBlock)failureBlock;
 */
- (void)testSetAvatarWithUserKey {
	NSArray *params = [FZResponseLoader readCVSFromFile:@"testSetAvatarWithUserKey"];
	
	XCTAssertNotNil(params, @"No params");
	XCTAssertTrue([params count] > 0, @"No params");
	
	for (NSDictionary *aSetOfParams in params) {
		
		XCTestExpectation *setAvatarWithUserKeySucceeded = [self expectationWithDescription:@"SetAvatarWithUserKeySucceeded succeeded"];
		
		//params
		[self setUserkey:[aSetOfParams objectForKey:@"userkey"]];
		
		NSString *aToken = [aSetOfParams objectForKey:@"token"];
		
		//load the image
		NSArray *binaryArray = [[aSetOfParams objectForKey:@"avatar"]componentsSeparatedByString:@","];
		
		unsigned char *buffer = (unsigned char*)malloc([binaryArray count]);
		int j=0;
		for (NSDecimalNumber *num in binaryArray) {
			buffer[j++] = [num intValue];
		}
		NSData *data = [NSData dataWithBytes:buffer length:[binaryArray count]];
		free(buffer);
		
		NSData* dataImage = UIImagePNGRepresentation([UIImage imageWithData:data]);
		UIImage *anAvatar = [UIImage imageWithData:dataImage];
		
		//connected or not
		BOOL connected = [[aSetOfParams objectForKey:@"connected"] boolValue];
		if(!connected) {
			
			//NSLog(@"Disconnected");
			//NSLog(@"anAvatar : %@",anAvatar);
			
			//NSLog(@"_userkey : %@",_userkey);
			
			[self setUserkey:nil];
			
			[self doSetAvatarWithUserKey:_userkey avatar:anAvatar token:aToken expectation:setAvatarWithUserKeySucceeded];
			
		} else {
			
			//NSLog(@"Connected");
			//NSLog(@"anAvatar : %@",anAvatar);
			
			_email = [[ConfigForTests sharedInstance] emailClientUsed];
			_password = [[ConfigForTests sharedInstance] passwordClientUsed];
			
			XCTAssertNotNil(_email, @"No email");
			XCTAssertNotNil(_password, @"No password");
			
			[ConnectionServices connect:_email password:_password firstTime:YES withDevice:@"XCodeUnitTests" withDeviceName:@"XCodeUnitTests" successBlock:^(id context) {
				
				XCTAssertNotNil(context, @"No userkey");
				
				NSString *userkeyTemp = [aSetOfParams objectForKey:@"userkey"];
				
				if(![userkeyTemp isEqualToString:@"validUserkey"]) {
					[self setUserkey:userkeyTemp];
					//NSLog(@"Unvalid userkey");
				} else {
					[self setUserkey:context];
					//NSLog(@"Valid userkey");
				}
				
				[self doSetAvatarWithUserKey:_userkey avatar:anAvatar token:aToken expectation:setAvatarWithUserKeySucceeded];
				
			} failureBlock:^(Error *error) {
				XCTFail(@"ConnectionServices connection has failed");
			}];
		}
		
		[self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
			XCTAssertNil(error);
			
			if(connected){
				[ConnectionServices disconnect:_userkey successBlock:^(id context) {
					
				} failureBlock:^(Error *error) {
					
				}];
			}
			
			//NSLog(@"----> %@",_result == [[aSetOfParams objectForKey:@"expectedResult"] intValue]?@"Success":@"Fail");
			
			XCTAssertEqual(_result, [[aSetOfParams objectForKey:@"expectedResult"] intValue], @"Fail for params' set [connected : %@ - userkey : %@ - with an avatar : %@]",connected?@"YES":@"NO",_userkey,anAvatar?@"YES":@"NO");
		}];
	}
}

- (void)doSetAvatarWithUserKey:(NSString *)userkey avatar:(UIImage *)avatarFile token:(NSString *)aToken expectation:(XCTestExpectation *)setAvatarWithUserKeySucceeded{
	
	[AvatarServices setAvatarWithUserKey:userkey avatar:avatarFile token:aToken successBlock:^(id context) {
		
		XCTAssertNotNil(context, @"Set avatar with userkey failure");
		
		[setAvatarWithUserKeySucceeded fulfill];
		
		[self resultSuccess];
		
	} failureBlock:^(Error *error) {
		
		[setAvatarWithUserKeySucceeded fulfill];
		
		[self resultFail];
	}];
}

#pragma mark - MM

-(void)dealloc {
	[super dealloc];
	[_email release], _email = nil;
	[_password release], _password = nil;
	[_userkey release], _userkey = nil;
	[_username release], _username = nil;
}

@end
