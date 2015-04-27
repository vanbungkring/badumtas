//
//  ErrorTests.m
//  FZAPI
//
//  Created by Matthieu Barile on 22/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Domain
#import "Error.h"
#import "FlashizServices.h"

//Utils
#import <FZBlackBox/BundleHelper.h>
#import <FZBlackBox/FZTargetManager.h>

@interface ErrorTests : XCTestCase

@end

@implementation ErrorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [[FZTargetManager sharedInstance] loadUnitTesting];
    [[BundleHelper sharedInstance] setRootBundle:FZBundleAPI];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_REQUEST_CANCELED
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorCancelled {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorCancelled];
    
    XCTAssertEqual(requestErrorCode,FZ_REQUEST_CANCELED, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorCancelled"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_BAD_URL
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorBadURL {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorBadURL];
    
    XCTAssertEqual(requestErrorCode,FZ_BAD_URL, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorBadURL"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_TIMED_OUT
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorTimedOut {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorTimedOut];
    
    XCTAssertEqual(requestErrorCode,FZ_TIMED_OUT, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorTimedOut"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_HOST_NOT_FOUND
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorCannotFindHost {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorCannotFindHost];
    
    XCTAssertEqual(requestErrorCode,FZ_HOST_NOT_FOUND, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorCannotFindHost"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_CAN_NOT_CONNECT_TO_HOST
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorCannotConnectToHost {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorCannotConnectToHost];
    
    XCTAssertEqual(requestErrorCode,FZ_CAN_NOT_CONNECT_TO_HOST, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorCannotConnectToHost"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}


/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_CONNECTION_LOST
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorNetworkConnectionLost {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorNetworkConnectionLost];
    
    XCTAssertEqual(requestErrorCode,FZ_CONNECTION_LOST, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorNetworkConnectionLost"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_NO_INTERNET_CONNECTION
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorNotConnectedToInternet {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorNotConnectedToInternet];
    
    XCTAssertEqual(requestErrorCode,FZ_NO_INTERNET_CONNECTION, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorNotConnectedToInternet"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"You need an internet connection to use FLASHiZ. Please check your connection and try again."]);
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_AUTHENTICATION_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorUserCancelledAuthentication {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorUserCancelledAuthentication];
    
    XCTAssertEqual(requestErrorCode,FZ_AUTHENTICATION_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorUserCancelledAuthentication"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_AUTHENTICATION_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorUserAuthenticationRequired {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorUserAuthenticationRequired];
    
    XCTAssertEqual(requestErrorCode,FZ_AUTHENTICATION_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorUserAuthenticationRequired"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_SERVER_RESPONSE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorBadServerResponse {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorBadServerResponse];
    
    XCTAssertEqual(requestErrorCode,FZ_SERVER_RESPONSE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorBadServerResponse"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_SERVER_RESPONSE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorCannotDecodeRawData {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorCannotDecodeRawData];
    
    XCTAssertEqual(requestErrorCode,FZ_SERVER_RESPONSE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorCannotDecodeRawData"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_SERVER_RESPONSE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorCannotDecodeContentData {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorCannotDecodeContentData];
    
    XCTAssertEqual(requestErrorCode,FZ_SERVER_RESPONSE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorCannotDecodeContentData"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_SERVER_RESPONSE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorCannotParseResponse {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorCannotParseResponse];
    
    XCTAssertEqual(requestErrorCode,FZ_SERVER_RESPONSE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorCannotParseResponse"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_CERTIFICATE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorSecureConnectionFailed {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorSecureConnectionFailed];
    
    XCTAssertEqual(requestErrorCode,FZ_CERTIFICATE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorSecureConnectionFailed"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_CERTIFICATE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorServerCertificateHasBadDate {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorServerCertificateHasBadDate];
    
    XCTAssertEqual(requestErrorCode,FZ_CERTIFICATE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorServerCertificateHasBadDate"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_CERTIFICATE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorServerCertificateUntrusted {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorServerCertificateUntrusted];
    
    XCTAssertEqual(requestErrorCode,FZ_CERTIFICATE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorServerCertificateUntrusted"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_CERTIFICATE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorServerCertificateHasUnknownRoot {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorServerCertificateHasUnknownRoot];
    
    XCTAssertEqual(requestErrorCode,FZ_CERTIFICATE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorServerCertificateHasUnknownRoot"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_CERTIFICATE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorServerCertificateNotYetValid {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorServerCertificateNotYetValid];
    
    XCTAssertEqual(requestErrorCode,FZ_CERTIFICATE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorServerCertificateNotYetValid"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_CERTIFICATE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorClientCertificateRejected {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorClientCertificateRejected];
    
    XCTAssertEqual(requestErrorCode,FZ_CERTIFICATE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorClientCertificateRejected"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}


/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_CERTIFICATE_ISSUE
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorClientCertificateRequired {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorClientCertificateRequired];
    
    XCTAssertEqual(requestErrorCode,FZ_CERTIFICATE_ISSUE, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorClientCertificateRequired"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"The connection with FLASHiZ failed. Please try again."],@"Bad message");
}

/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_UNKNOWN_ERROR
 */
- (void)testErrorMessageWithErrorCodeNSURLErrorUnknown {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:NSURLErrorUnknown];
    
    XCTAssertEqual(requestErrorCode,FZ_UNKNOWN_ERROR, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeNSURLErrorUnknown"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"An error occured, please try again."],@"Bad message");
}


/*
 + (int)errorMessageWithErrorCode:(int)code
 // FZ_NO_LOCAL_ERROR
 */
- (void)testErrorMessageWithErrorCodeUnmanagedError {
    
    int requestErrorCode = [Error errorMessageWithErrorCode:-466544554];
    
    XCTAssertEqual(requestErrorCode,FZ_NO_LOCAL_ERROR, @"Bad Error code");
    
    Error *error = [FlashizServices retrieveErrorWith:-1 and:requestErrorCode forService:@"testErrorMessageWithErrorCodeUnmanagedError"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"An error occured, please try again."],@"Bad message");
}


/*
 +(Error*)retrieveErrorWith:(int)requestStatusCode and:(int)requestErrorCode forService:(NSString *)serviceDescription;
 // 404
 */
- (void)testErrorMessageWithError404 {
    
    Error *error = [FlashizServices retrieveErrorWith:404 and:-1 forService:@"testErrorMessageWithError404"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"An error occured, please try again."],@"Bad message");
}

/*
 +(Error*)retrieveErrorWith:(int)requestStatusCode and:(int)requestErrorCode forService:(NSString *)serviceDescription;
 // 404
 */
- (void)testErrorMessageWithError500 {
    
    Error *error = [FlashizServices retrieveErrorWith:500 and:-1 forService:@"testErrorMessageWithError500"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"An error occured, please try again."],@"Bad message");
}


/*
 +(Error*)retrieveErrorWith:(int)requestStatusCode and:(int)requestErrorCode forService:(NSString *)serviceDescription;
 // 232
 */
- (void)testErrorMessageWithErrorUnknowCode {
    
    Error *error = [FlashizServices retrieveErrorWith:232 and:-1 forService:@"testErrorMessageWithErrorUnknowCode"];
    
    NSString *localizedString = [NSString stringWithFormat:@"%@",[error localizedError]];
    
    XCTAssertTrue([localizedString isEqualToString:@"An error occured, please try again."],@"Bad message");
}

/*
 - (id)initWithRequest:(NSString *)url response:(NSString *)serverResponse timestamp:(NSDate *)timestamp messageCode:(NSString *)messageCode detail:(NSString *)detail code:(NSInteger)errorCode andRequestErrorCode:(NSInteger)errorRequest trial:(NSInteger)trialCount maxTrial:(NSInteger)maxTrialCount;
 */

- (void)testConstructorWithTrial{
    
    
}

/*
 - (id)initWithRequest:(NSString *)url response:(NSString *)serverResponse timestamp:(NSDate *)timestamp messageCode:(NSString *)messageCode detail:(NSString *)detail code:(NSInteger)errorCode andRequestErrorCode:(NSInteger)errorRequest;
 */
- (void)testConstructor{
    //
    NSString *requestDescription = @"http://flashiz.com";
    NSString *responseDescription = @"<body>Unit testing </body>";
    NSString *messageCode = @"Login page";
    NSString *messageCodeDetail = @"askPinCode";
    int codeValue = 0;
    int trialValue = -1;
    
    Error *error = [[Error alloc] initWithRequest:requestDescription
                                         response:responseDescription
                                        timestamp:[NSDate date]
                                      messageCode:messageCode
                                           detail:messageCodeDetail
                                             code:codeValue
                              andRequestErrorCode:codeValue
                                            trial:trialValue
                                         maxTrial:trialValue];
    
    XCTAssertEqual(requestDescription, [error request], @"!= request URL");
    XCTAssertEqual(responseDescription, [error response], @"!= response");
    XCTAssertEqual(codeValue, [error errorCode], @"!= errorCode");
    XCTAssertEqual(codeValue, [error errorRequest], @"!= errorRequest");
    XCTAssertEqual(trialValue, [error trial], @"!= trial");
    XCTAssertEqual(trialValue, [error maxTrial], @"!= maxTrial");
    
    [error release];
}

/*
 + (Error *)errorWithMessage:(NSString *)message code:(int)code andRequestCode:(int)rCode;
 */
- (void)testStaticConstructorWithCodeAndRequestCode{
    NSString *requestDescription = @"http://flashiz.com";
    NSString *responseDescription = @"<body>Unit testing </body>";
    NSString *messageCode = @"Login page";
    NSString *messageCodeDetail = @"askPinCode";
    int codeValue = 0;
    
    Error *error = [[Error alloc] initWithRequest:requestDescription
                                         response:responseDescription
                                        timestamp:[NSDate date]
                                      messageCode:messageCode
                                           detail:messageCodeDetail
                                             code:codeValue
                              andRequestErrorCode:codeValue];
    
    XCTAssertEqual(requestDescription, [error request], @"!= request URL");
    XCTAssertEqual(responseDescription, [error response], @"!= response");
    XCTAssertEqual(codeValue, [error errorCode], @"!= errorCode");
    XCTAssertEqual(codeValue, [error errorRequest], @"!= errorRequest");
    XCTAssertEqual(codeValue, [error trial], @"!= trial");
    XCTAssertEqual(codeValue, [error maxTrial], @"!= maxTrial");
    
    [error release];
}


@end
