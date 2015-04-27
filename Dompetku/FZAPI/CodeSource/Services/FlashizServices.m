//
//  FlashizServices.m
//  iMobey
//
//  Created by Yvan Moté on 08/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizServices.h"

//Library
#import "FZAFNetworking.h"

//Domain
#import "Error.h"

NSString * const userKeyParameter = @"userkey";

@implementation FlashizServices

+ (NSURLRequest *)requestPostForUrl:(NSURL *)url
                     withParameters:(NSDictionary *)parameters {
    //generating post request body by including parameters
    
    NSString *post = @"";
    
    if(parameters != nil && [parameters count] > 0){
        
        for(NSString *key in parameters){
            
            NSString *value = [parameters objectForKey:key];
            
            post = [post stringByAppendingFormat:@"%@=%@&", key, value];
        }
        
        post = [post substringToIndex:(post.length-1)];
    }
    
    //FZAPILog(@"REQUEST : %@ PARAMS : %@", [url absoluteString], post);
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding] ; //encode post body into NSData using UTF-8 encoding
    
    
    NSMutableURLRequest * mutableRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:45]; //create the real request
    
    //setting the request body with parameters we encoded previously
    
    NSString *postLength = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:postData];
    
    [postLength release];
    
    NSURLRequest *urlRequest = [mutableRequest copy];
    
    [mutableRequest release];
    
    return [urlRequest autorelease];
}

+ (NSURLRequest *)requestPostForUrl:(NSURL *)url
                       withJsonData:(NSString *)data {
    //generating post request body by including parameters
    
    FZAPILog(@"REQUEST : %@ PARAMS : %@", [url absoluteString], data);
    
    NSData *postData = [data dataUsingEncoding:NSUTF8StringEncoding] ; //encode post body into NSData using UTF-8 encoding
    
    
    NSMutableURLRequest * mutableRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:45]; //create the real request
    
    /*
     if(self.ignoreSecurityCertificates){
     [NSURLRequest setAllowsAnyHTTPSCertificate:YES forHost:[nsurl host]];
     DDLogWarn(@"IGNORING CERTIFICATES");
     }
     */
    
    //setting the request body with parameters we encoded previously
    
    NSString *postLength = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [mutableRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:postData];
    
    
    [postLength release];
    
    NSURLRequest *urlRequest = [mutableRequest copy];
    
    [mutableRequest release];
    
    return [urlRequest autorelease];
}

+ (NSURLRequest *)requestPostCustomForUrl:(NSURL *)url
                           withParameters:(NSDictionary *)parameters {
    //generating post request body by including parameters
    //FZAPILog(@"REQUEST : %@", [url absoluteString]);
    
    //Custom URL encoded POST data
    NSData *postData = [self postDataFromDictionary:parameters];
    
    NSMutableURLRequest * mutableRequest = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:45]; //create the real request
    
    //setting the request body with parameters we encoded previously
    
    NSString *postLength = [[NSString alloc] initWithFormat:@"%lu",(unsigned long)[postData length]];
    
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [mutableRequest setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [mutableRequest setHTTPBody:postData];
    
    [postLength release];
    
    NSURLRequest *urlRequest = [mutableRequest copy];
    
    [mutableRequest release];
    
    return [urlRequest autorelease];
}

// Construct URL encoded POST data from a dictionary
+ (NSData *)postDataFromDictionary:(NSDictionary *)params {
    NSMutableString *data = [NSMutableString string];
    
    for (NSString *key in params) {
        NSString *value = [params objectForKey:key];
        if (value == nil) {
            continue;
        }
        if ([value isKindOfClass:[NSString class]]) {
            value = [self URLEncodedStringFromString:value];
        }
        
        [data appendFormat:@"%@=%@&", [self URLEncodedStringFromString:key], value];
    }
    
    data = [NSMutableString stringWithString:[data substringToIndex:(data.length-1)]];
    
    //FZAPILog(@"PARAMS : %@", data);
    
    return [data dataUsingEncoding:NSUTF8StringEncoding];
}

// This method is adapted from from Dave DeLong's example at
// http://stackoverflow.com/questions/3423545/objective-c-iphone-percent-encode-a-string ,
// and protected by http://creativecommons.org/licenses/by-sa/3.0/
+ (NSString *) URLEncodedStringFromString: (NSString *)string {
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[string UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+ (NSURLRequest *)requestGetForUrl:(NSURL *)url {
    
    //FZAPILog(@"REQUEST : %@", url);
    
    //create the NSURLRequest corresponding and return it
    return [NSURLRequest requestWithURL:url
                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                        timeoutInterval:45];
}

+ (void)executeRequest:(NSURLRequest *)urlrequest
            forService:(NSString *)serviceDescription
      withSuccessBlock:(NetworkSuccessBlock)successBlock
          failureBlock:(NetworkFailureBlock)failureBlock {
    
    //Crashlytics
    NSString *url = [[urlrequest URL] description];
    
    NSArray *arrayUrl = [[[urlrequest URL] description] componentsSeparatedByString:@"?"];
    if([arrayUrl count] > 0) {//hide get parameters
        url = [arrayUrl objectAtIndex:0];
    }
    
    
    NSString *query = [[urlrequest URL] query];
    NSArray *params = [query componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *allParams = [[NSMutableDictionary alloc] init];
    
    for(NSString *param in params) {
        NSArray *paramWithValue = [param componentsSeparatedByString:@"="];
        
        if([paramWithValue count]>1) {
            [allParams addEntriesFromDictionary:[NSDictionary dictionaryWithObject:[paramWithValue objectAtIndex:1] forKey:[paramWithValue objectAtIndex:0]]];
        }
    }
    
    if([[allParams allKeys] containsObject:userKeyParameter]) {
        NSString *userKeyValue = [allParams objectForKey:userKeyParameter];
        
        if([userKeyValue length]==0) {
            FZAPILog(@"request execution aborted (userkey empty).");
            [allParams release];
            return;
        }
    }
    
    [allParams release];
    
    
    FZAFJSONRequestOperation *jsonRequestOperation =
    [FZAFJSONRequestOperation
     JSONRequestOperationWithRequest:urlrequest
     
     success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
         
         BOOL isResultValid = [FlashizServices isResultValidForContextDictionary:JSON];
         if(isResultValid) {
             successBlock(JSON);
         } else {
             
             NSString *errorDetailFromServer = [JSON objectForKey:@"errorDetail"];
             NSString *errorMessageFromServer = [JSON objectForKey:@"errorMessage"];
             NSInteger trial = [[JSON objectForKey:@"trial"] integerValue];
             NSInteger maxTrial = [[JSON objectForKey:@"maxTrial"] integerValue];
             
             Error *error = [[Error alloc] initWithRequest:[request description]
                                                  response:[response description]
                                                 timestamp:[NSDate date]
                                               messageCode:errorMessageFromServer
                                                    detail:errorDetailFromServer
                                                      code:[[JSON objectForKey:@"errorCode"] integerValue]
                                       andRequestErrorCode:-1
                                                     trial:trial
                                                  maxTrial:maxTrial];
             
             failureBlock(error);
         }
         
     } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *anError, id JSON) {
         
         int requestErrorCode = [Error errorMessageWithErrorCode:(int)[anError code]];
         int requestStatusCode = (int)[response statusCode];
         
         failureBlock([FlashizServices retrieveErrorWith:requestStatusCode and:requestErrorCode forService:serviceDescription]);
         
     }];
    [jsonRequestOperation start];
}


+(Error*)retrieveErrorWith:(int)requestStatusCode and:(int)requestErrorCode forService:(NSString *)serviceDescription
{
    Error *error = nil;
    NSString *errorMessage = @"";
    
    int errorCode = requestErrorCode;
    
    //Handle system request error
    if(errorCode == FZ_UNKNOWN_ERROR || errorCode == FZ_NO_LOCAL_ERROR){
        
        errorMessage = @"A problem occured while connecting to the server.";
        
        error = [FlashizServices errorWithMessage:errorMessage code:FZ_UNKNOWN_ERROR andRequestCode:requestErrorCode];
        
    } else if(errorCode == FZ_SERVER_ISSUE || errorCode == FZ_REQUEST_CANCELED || errorCode == FZ_BAD_URL){
        
        errorMessage = @"A problem occured while connecting to the server.";
        
        error = [FlashizServices errorWithMessage:errorMessage code:FZ_CONNECTION_ISSUE andRequestCode:requestErrorCode];
        
    } else if(errorCode == FZ_CONNECTION_LOST || errorCode == FZ_TIMED_OUT){
        
        errorMessage = @"The connection with FLASHiZ failed. Please try again.";
        
        error = [FlashizServices errorWithMessage:errorMessage code:FZ_CONNECTION_LOST andRequestCode:requestErrorCode];
        
    } else if(errorCode == FZ_NO_INTERNET_CONNECTION){
        
        errorMessage = @"A problem occured while connecting to the server. Please check your connection or try later.";
        
        error = [FlashizServices errorWithMessage:errorMessage code:FZ_NO_INTERNET_CONNECTION andRequestCode:requestErrorCode];
        
    } else {
        
        //Handle http request error
        if(requestStatusCode==404) {
            errorMessage = [NSString stringWithFormat:@"service unavailable: %@",serviceDescription];
            
            error = [FlashizServices errorWithMessage:errorMessage code:FlashizErrorUnavailableService andRequestCode:requestStatusCode];
            
        } else if(requestStatusCode>=500) {
            errorMessage = [NSString stringWithFormat:@"service %@ failed",serviceDescription];
            
            error = [FlashizServices errorWithMessage:errorMessage code:FlashizErrorServer andRequestCode:requestStatusCode];
            
        } else {
            //Defaut error
            NSLog(@"Throw unknow error:%i   - %@",requestErrorCode,serviceDescription);
            
            errorMessage = @"A problem occured while connecting to the server.";
            error = [FlashizServices errorWithMessage:errorMessage code:FlashizErrorUnavailableService andRequestCode:requestStatusCode];
        }
    }
    
    return error;
}

+ (BOOL)isResultValidForContextDictionary:(NSDictionary *)context {
    NSString *result = [context objectForKey:@"result"];
    
    return ![result isEqualToString:@"NOK"];
}

+ (Error *)errorWithMessage:(NSString *)message code:(FlashizError)code andRequestCode:(int)rCode {
    return [Error errorWithMessage:message code:code andRequestCode:rCode];
}

@end
