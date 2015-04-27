//
//  Error.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "Error.h"

#import <objc/message.h>

#import "FZFilesEnum.h"

@implementation Error

- (id)initWithRequest:(NSString *)url response:(NSString *)serverResponse timestamp:(NSDate *)timestamp messageCode:(NSString *)messageCode detail:(NSString *)detail code:(NSInteger)errorCode andRequestErrorCode:(NSInteger)errorRequest{
    
    static int id_generator = 0;
    
    self = [super init];
    if(self){
        
        [self setID:id_generator++];
        [self setRequest : url ];
        [self setResponse : serverResponse];
        [self setTimestamp : timestamp ];
        [self setDetail : detail ];
        [self setMessageCode : messageCode ];
        [self setErrorCode:errorCode];
        [self setErrorRequest:errorRequest];
    }
    
    return self;
}

- (id)initWithRequest:(NSString *)url response:(NSString *)serverResponse timestamp:(NSDate *)timestamp messageCode:(NSString *)messageCode detail:(NSString *)detail code:(NSInteger)errorCode andRequestErrorCode:(NSInteger)errorRequest trial:(NSInteger)trialCount maxTrial:(NSInteger)maxTrialCount {
    
    static int id_generator = 0;
    
    self = [super init];
    if(self){
        
        [self setID:id_generator++];
        [self setRequest : url ];
        [self setResponse : serverResponse];
        [self setTimestamp : timestamp];
        [self setDetail : detail];
        [self setMessageCode : messageCode];
        [self setErrorCode:errorCode];
        [self setErrorRequest:errorRequest];
        
        if(trialCount && maxTrialCount) {
            [self setTrial:trialCount];
            [self setMaxTrial:maxTrialCount];
        } else {
            [self setTrial:-1];
            [self setMaxTrial:-1];
        }
    }
    
    return self;
}

- (NSString *)description{
    
    return [_messageCode stringByAppendingFormat:@" - #%d - %@ - %ld", self.ID, self.detail,(long)_errorCode];
}

-(NSString*)localizedError
{
    Class cls = NSClassFromString(@"LocalizationHelper");
    SEL selector = NSSelectorFromString(@"reflectErrorForKey:withComment:inDefaultBundle:");
    
    id (*response)(id, SEL, id, id, id) = (id (*)(id, SEL, id, id, id)) objc_msgSend;
    
    return response(cls, selector,[NSString stringWithFormat:@"%ld",(long)_errorCode],@"Error",@"FZBundleAPI");
    
    //return objc_msgSend(cls, selector,[NSString stringWithFormat:@"%ld",(long)_errorCode],@"Error",@"FZBundleAPI");
}

+ (int)errorMessageWithErrorCode:(int)code
{
    
    switch (code) {
            
        case NSURLErrorCancelled : return FZ_REQUEST_CANCELED; break;
        case NSURLErrorBadURL : return FZ_BAD_URL; break;
        case NSURLErrorTimedOut: return FZ_TIMED_OUT; break;
        case NSURLErrorCannotFindHost : return FZ_HOST_NOT_FOUND; break;
        case NSURLErrorCannotConnectToHost : return FZ_CAN_NOT_CONNECT_TO_HOST; break;
            
        case NSURLErrorNetworkConnectionLost : return FZ_CONNECTION_LOST; break;
        case NSURLErrorNotConnectedToInternet : return FZ_NO_INTERNET_CONNECTION; break;
            
        case NSURLErrorUserCancelledAuthentication :
        case NSURLErrorUserAuthenticationRequired : return FZ_AUTHENTICATION_ISSUE; break;
            
        case NSURLErrorBadServerResponse :
        case NSURLErrorCannotDecodeRawData :
        case NSURLErrorCannotDecodeContentData :
        case NSURLErrorCannotParseResponse : return FZ_SERVER_RESPONSE_ISSUE; break;
            
        case NSURLErrorSecureConnectionFailed :
        case NSURLErrorServerCertificateHasBadDate :
        case NSURLErrorServerCertificateUntrusted :
        case NSURLErrorServerCertificateHasUnknownRoot :
        case NSURLErrorServerCertificateNotYetValid :
        case NSURLErrorClientCertificateRejected :
        case NSURLErrorClientCertificateRequired : return FZ_CERTIFICATE_ISSUE; break;
        case NSURLErrorUnknown : return FZ_UNKNOWN_ERROR; break;
            
        default : return FZ_NO_LOCAL_ERROR; break;
    }
}

+ (Error *)errorWithMessage:(NSString *)message code:(int)code andRequestCode:(int)rCode
{
    Error *error = [[[Error alloc] init] autorelease];
    [error setDetail:message];
    [error setErrorCode:code];
    [error setErrorRequest:rCode];
    
    return error;
}

@end
