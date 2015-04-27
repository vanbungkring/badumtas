//
//  UserSessionTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "UserSession.h"

//Enum
#import "FZFilesEnum.h"

@interface UserSessionTests : XCTestCase

@end

@implementation UserSessionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/*
 - (id)init
 */
- (void)testUserSessionInit {
    UserSession *session = [UserSession currentSession];
    
    XCTAssertNotNil(session, @"UserSession : can't instantiate current session");
    
    // TODO : bad side effect with the others test
    //XCTAssertNil([session userKey],@"UserSession : userKey");//USER_KEY
    
    // TODO : bad side effect with the others test
    //XCTAssertEqual([session timeout], 2, @"UserSession : no default timeout");//TIMEOUT
    
    XCTAssertNil([session validUrls], @"UserSession : valid urls");
}

/*
 - (void)storeUserKey:(NSString *)userKey;
 */
- (void)testUserStoreUserKey {
    
    NSString *testKey = @"QXCDFGfgsdgdfg54dfg8d4fg86ds";
    
    UserSession *session = [UserSession currentSession];
    
    [session storeUserKey:testKey];
    
    XCTAssertTrue([[session userKey]isEqualToString:testKey], @"UserSession : not user key expected");
    
    [session storeUserKey:nil];
    
    XCTAssertNil([session userKey], @"UserSession : not user key expected");
}


/*
 - (void)storeAcceptedEula:(BOOL)storeEula;
 */
- (void)testUserStoreAcceptedEula {
    UserSession *session = [UserSession currentSession];
    
    [session storeAcceptedEula:YES];
    
    XCTAssertTrue([session isAcceptedEula], @"UserSession : not Accepted Eula as xpected");
    
    [session storeAcceptedEula:NO];
    
    XCTAssertFalse([session isAcceptedEula], @"UserSession : not Accepted Eula as xpected");
}


/*
 - (void)storeTimeout:(int)timeout;
 */
- (void)testUserStoreTimeout {
    UserSession *session = [UserSession currentSession];
    
    [session storeTimeout:0];
    
    XCTAssertEqual([session timeout], 0, @"UserSession : no timeout as expected");
    
    [session storeTimeout:5];
    
    XCTAssertEqual([session timeout], 5, @"UserSession : no timeout as expected");
}


/*
 - (void)storeEnvironment:(NSString *)environment;
 */
- (void)testUserStoreEnvironment {
    
    NSString *env = @"http://google.com";
    
    UserSession *session = [UserSession currentSession];
    
    [session storeEnvironment:env];
    
    XCTAssertTrue([[session environment]isEqualToString:env], @"UserSession : not store env. expected");
    
    [session storeEnvironment:@""];
    
    XCTAssertTrue([[session environment]isEqualToString:@""], @"UserSession : not store env. expected");
}

/*
 - (NSString *)emailAfterStoredEnvironmentWithTypedEmail:(NSString *)email;
 */
- (void)testUserEmailAfterStoredEnvironmentWithTypedEmail {
    
    NSString *emailTest = @"unittesting@yopmail.com";
    NSString *completionEmailTest = @"";
    NSString *result = @"";
    
    UserSession *session = [UserSession currentSession];
    
    completionEmailTest = [NSString stringWithFormat:@"%@%@",kITEnvironmentKey,emailTest];
    
    result = [session emailAfterStoredEnvironmentWithTypedEmail:completionEmailTest];
    
    XCTAssertTrue([result isEqualToString:emailTest], @"UserSession : not store env. expected");
    XCTAssertTrue([[session environment] isEqualToString:kITEnvironmentKey], @"UserSession : not store env. expected");
    
    completionEmailTest = [NSString stringWithFormat:@"%@%@",kTestEnvironmentKey,emailTest];
    
    result = [session emailAfterStoredEnvironmentWithTypedEmail:completionEmailTest];
    
    XCTAssertTrue([result isEqualToString:emailTest], @"UserSession : not store env. expected");
    XCTAssertTrue([[session environment] isEqualToString:kTestEnvironmentKey], @"UserSession : not store env. expected");
    
    completionEmailTest = [NSString stringWithFormat:@"%@%@",kQatEnvironmentKey,emailTest];
    
    result = [session emailAfterStoredEnvironmentWithTypedEmail:completionEmailTest];
    
    XCTAssertTrue([result isEqualToString:emailTest], @"UserSession : not store env. expected");
    XCTAssertTrue([[session environment] isEqualToString:kQatEnvironmentKey], @"UserSession : not store env. expected");
    
    completionEmailTest = [NSString stringWithFormat:@"%@%@",kIntegrationEnvironmentKey,emailTest];
    
    result = [session emailAfterStoredEnvironmentWithTypedEmail:completionEmailTest];
    
    XCTAssertTrue([result isEqualToString:emailTest], @"UserSession : not store env. expected");
    XCTAssertTrue([[session environment] isEqualToString:kIntegrationEnvironmentKey], @"UserSession : not store env. expected");
    
    completionEmailTest = [NSString stringWithFormat:@"%@%@",kSandboxEnvironmentKey,emailTest];
    
    result = [session emailAfterStoredEnvironmentWithTypedEmail:completionEmailTest];
    
    XCTAssertTrue([result isEqualToString:emailTest], @"UserSession : not store env. expected");
    XCTAssertTrue([[session environment] isEqualToString:kSandboxEnvironmentKey], @"UserSession : not store env. expected");
    
    completionEmailTest = [NSString stringWithFormat:@"%@%@",kUatEnvironmentKey,emailTest];
    
    result = [session emailAfterStoredEnvironmentWithTypedEmail:completionEmailTest];
    
    XCTAssertTrue([result isEqualToString:emailTest], @"UserSession : not store env. expected");
    XCTAssertTrue([[session environment] isEqualToString:kUatEnvironmentKey], @"UserSession : not store env. expected");
    
    completionEmailTest = [NSString stringWithFormat:@"%@%@",kProdEnvironmentKey,emailTest];
    
    result = [session emailAfterStoredEnvironmentWithTypedEmail:completionEmailTest];
    
    XCTAssertTrue([result isEqualToString:emailTest], @"UserSession : not store env. expected");
    XCTAssertTrue([[session environment] isEqualToString:kProdEnvironmentKey], @"UserSession : not store env. expected");
    
    completionEmailTest = [NSString stringWithFormat:@"%@%@",@"xxx.",emailTest];
    
    result = [session emailAfterStoredEnvironmentWithTypedEmail:completionEmailTest];
    
    XCTAssertTrue([result isEqualToString:completionEmailTest], @"UserSession : not store env. expected");
    
    XCTAssertTrue([[session environment] isEqualToString:kProdEnvironmentKey], @"UserSession : not store env. expected");
}

/*
 - (void)storeEnvironmentWithEnvironment:(NSString *)environment;
 */
- (void)testUserStoreEnvironmentWithEnvironment {
    UserSession *session = [UserSession currentSession];
    
    [session storeEnvironmentWithEnvironment:kITEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kITEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kTestEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kTestEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kQatEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kQatEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kIntegrationEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kIntegrationEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kSandboxEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kSandboxEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kUatEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kUatEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kProdEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kProdEnvironmentKey], @"UserSession : not store env. expected");
}


/*
 - (void)addProgramIdToFidelitizBlackList:(NSString *)programId;
 */
- (void)testUserAddProgramIdToFidelitizBlackList {
    NSString *fidelitizID = @"262";
    UserSession *session = [UserSession currentSession];
    
    //Clean content
    [session clearFidelitizBlackList];
    
    [session addProgramIdToFidelitizBlackList:fidelitizID];
    
    XCTAssertEqual([[session fidelitizBlackList]count], 1, @"UserSession : addProgramIdToFidelitizBlackList doesn't work as expected");
    
    XCTAssertTrue([[[session fidelitizBlackList]objectAtIndex:0] isEqualToString:fidelitizID], @"UserSession : not store env. expected");
    
    fidelitizID = @"364";
    
    [session addProgramIdToFidelitizBlackList:fidelitizID];
    
    XCTAssertEqual([[session fidelitizBlackList]count], 2, @"UserSession : addProgramIdToFidelitizBlackList doesn't work as expected");
    
    XCTAssertTrue([[[session fidelitizBlackList]objectAtIndex:1] isEqualToString:fidelitizID], @"UserSession : not store env. expected");
}


/*
 - (void)clearFidelitizBlackList;
 */
- (void)testUserClearFidelitizBlackList {
    NSString *fidelitizID = @"262";
    UserSession *session = [UserSession currentSession];
    
    //Clean content
    [session clearFidelitizBlackList];
    
    [session addProgramIdToFidelitizBlackList:fidelitizID];
    
    XCTAssertEqual([[session fidelitizBlackList]count], 1, @"UserSession : addProgramIdToFidelitizBlackList doesn't work as expected");
    
    XCTAssertTrue([[[session fidelitizBlackList]objectAtIndex:0] isEqualToString:fidelitizID], @"UserSession : not store env. expected");
    
    fidelitizID = @"364";
    
    [session addProgramIdToFidelitizBlackList:fidelitizID];
    
    XCTAssertEqual([[session fidelitizBlackList]count], 2, @"UserSession : addProgramIdToFidelitizBlackList doesn't work as expected");
    
    XCTAssertTrue([[[session fidelitizBlackList]objectAtIndex:1] isEqualToString:fidelitizID], @"UserSession : not store env. expected");
    
    [session clearFidelitizBlackList];
    
     XCTAssertEqual([[session fidelitizBlackList]count], 0, @"UserSession : addProgramIdToFidelitizBlackList doesn't work as expected");
    
}


/*
 - (NSString *)shortEnvironmentValue;
 */
- (void)testUserShortEnvironmentValue {
    UserSession *session = [UserSession currentSession];
    
    [session storeEnvironmentWithEnvironment:kITEnvironmentKey];
    
    XCTAssertTrue([[session shortEnvironmentValue] isEqualToString:kITKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kTestEnvironmentKey];
    
    XCTAssertTrue([[session shortEnvironmentValue] isEqualToString:kTestKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kQatEnvironmentKey];
    
    XCTAssertTrue([[session shortEnvironmentValue] isEqualToString:kQatKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kIntegrationEnvironmentKey];
    
    XCTAssertTrue([[session shortEnvironmentValue] isEqualToString:kIntKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kSandboxEnvironmentKey];
    
    XCTAssertTrue([[session shortEnvironmentValue] isEqualToString:kSandboxKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kUatEnvironmentKey];
    
    XCTAssertTrue([[session shortEnvironmentValue] isEqualToString:kUatKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kProdEnvironmentKey];
    
    XCTAssertTrue([[session shortEnvironmentValue] isEqualToString:kProdKey], @"UserSession : not store env. expected");
}


/*
 - (NSString*)environment;
 */
- (void)testUserEnvironment {
    UserSession *session = [UserSession currentSession];
    
    [session storeEnvironmentWithEnvironment:kITEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kITEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kTestEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kTestEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kQatEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kQatEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kIntegrationEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kIntegrationEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kSandboxEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kSandboxEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kUatEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kUatEnvironmentKey], @"UserSession : not store env. expected");
    
    [session storeEnvironmentWithEnvironment:kProdEnvironmentKey];
    
    XCTAssertTrue([[session environment] isEqualToString:kProdEnvironmentKey], @"UserSession : not store env. expected");
}


/*
 - (UIImage *)avatarWithDefaultImage:(UIImage *)defaultImage;
 */
/* TODO : move #import "UIImage+FZImage.h" in FZAPI
- (void)testUserAvatarWithDefaultImage {
    UserSession *session = [UserSession currentSession];
    
    UIImage *avatarImage = [[UserSession currentSession] avatarWithDefaultImage:[UIImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]];
    
    XCTAssertNil(avatarImage, @"UserSession : not valid avatar");
    
}*/


/*
 - (void) reloadAvatarWithDefaultImage:(UIImage *)defaultImage;
 */
/* TODO : move #import "UIImage+FZImage.h" in FZAPI
- (void)testUserReloadAvatarWithDefaultImage {
    UserSession *session = [UserSession currentSession];
    UserSession *session = [UserSession currentSession];
    
    UIImage *avatarImage = [[UserSession currentSession] avatarWithDefaultImage:[UIImage imageNamed:@"logo_default.png" inBundle:FZBundleAPI]];
    
    XCTAssertNil(avatarImage, @"UserSession : not valid avatar");
    
}*/

@end
