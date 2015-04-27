//
//  Error.h
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "FlashizObject.h"


// TODO : too much error case
#define FZ_INVALID_JSON 10030
#define FZ_INVALID_JSON_ERROR_CODE 10030
#define FZ_INVALID_JSON_MISSING_KEYS 10030

#define FZ_JSON_MISSING_KEYS_ERROR_CODE 10030

#define FZ_INVALID_SERVICE_OR_PARAMETERS 10030
#define FZ_INVALID_SERVICE_OR_PARAMETERS_ERROR_CODE 10030

//Local error case
#define FZ_SERVER_ISSUE 500 //Global value to catch
#define FZ_AUTHENTICATION_ISSUE 500
#define FZ_SERVER_RESPONSE_ISSUE 500
#define FZ_CERTIFICATE_ISSUE 500
#define FZ_HOST_NOT_FOUND 500
#define FZ_CAN_NOT_CONNECT_TO_HOST 500


#define FZ_CONNECTION_ISSUE 10020 //Global value to catch
#define FZ_CONNECTION_LOST 10020
#define FZ_TIMED_OUT 10020

#define FZ_REQUEST_CANCELED 10040
#define FZ_BAD_URL 10050

#define FZ_NO_INTERNET_CONNECTION 10010

#define FZ_UNKNOWN_ERROR 10000
#define FZ_NO_LOCAL_ERROR -10000


// Local dev. message
#define FZ_JSON_MISSING_KEYS_ERROR_MESSAGE @"The following keys are missing to create the object"
#define FZ_JSON_MISSING_KEYS_ERROR_MESSAGE @"The following keys are missing to create the object"
#define FZ_INVALID_JSON_ERROR_MESSAGE @"Unable to decode the JSON encoded server response. Are you correctly connected to your FLASHiZ account ?"
#define FZ_JSON_NUMBER_OF_KEYS_BETWEEN_SERVER_AND_OBJECT @"Count of matching keys (%ld) differs from count of keys (%ld)'"


@interface Error : FlashizObject

@property (nonatomic) int ID; //should never be set manually
@property (copy, nonatomic) NSString *request; //if the error is related to a particular server request
@property (copy, nonatomic) NSString *response; //the server response to the request sent (if previous request properties is filled)
@property (copy, nonatomic) NSDate *timestamp; //the date at which error happened
@property (copy, nonatomic) NSString *detail; //the detail of the error if there is one
@property (copy, nonatomic) NSString *messageCode;//the string error code
@property (nonatomic) NSInteger errorCode;//the error code
@property (nonatomic) NSInteger errorRequest;//the Request error code

//TODO : in error object ? WTF 🙈 -> need a modification on the server
//Forgotten password parameters
@property (assign, nonatomic) NSInteger trial __attribute__((deprecated));//the number of try to find the secret answer to the secure question
@property (assign, nonatomic) NSInteger maxTrial __attribute__((deprecated));//the number max of try to find the secret answer to the secure questionbrand

/*
 Used only on the pin code case
 */
- (id)initWithRequest:(NSString *)url response:(NSString *)serverResponse timestamp:(NSDate *)timestamp messageCode:(NSString *)messageCode detail:(NSString *)detail code:(NSInteger)errorCode andRequestErrorCode:(NSInteger)errorRequest trial:(NSInteger)trialCount maxTrial:(NSInteger)maxTrialCount __attribute__((deprecated));

- (id)initWithRequest:(NSString *)url response:(NSString *)serverResponse timestamp:(NSDate *)timestamp messageCode:(NSString *)messageCode detail:(NSString *)detail code:(NSInteger)errorCode andRequestErrorCode:(NSInteger)errorRequest;

/**
 Return localized error from FZBundleAPI or from root bundle
 **/
- (NSString*)localizedError;

//Util

+ (int)errorMessageWithErrorCode:(int)code;

+ (Error *)errorWithMessage:(NSString *)message code:(int)code andRequestCode:(int)rCode;

@end
