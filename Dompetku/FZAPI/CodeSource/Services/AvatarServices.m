//
//  AvatarServices.m
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "AvatarServices.h"

#import <UIKit/UIKit.h>

#import "FlashizUrlBuilder.h"

static NSString * const avatarServiceDescription = @"avatar";
static NSString * const changeAvatarServiceDescription = @"change avatar";

@implementation AvatarServices

+ (void)avatarWithMail:(NSString *)userMail
             successBlock:(NetworkSuccessBlock)successBlock
             failureBlock:(NetworkFailureBlock)failureBlock {
   
   NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
   [params setObject:userMail forKey:@"mail"];
   
   NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder avatarUrlFromMailWithParameters:params]];
   [params release];
   
   [FlashizServices executeRequest:request
                        forService:avatarServiceDescription
                  withSuccessBlock:^(id context) {
                     
                     id byteArray = [context objectForKey:@"avatar"];
                     
                     if(byteArray != nil && [byteArray isKindOfClass:[NSArray class]]){
                         
                        NSArray *array = [[[NSArray alloc] initWithArray:byteArray] autorelease];
                        
                        successBlock(array);
                        
                     } else {
                         
                         //we don't block the user in the app only because of avatar's problem
                         //so just return nil
                        
                         successBlock(nil);
                     }
                  } failureBlock:failureBlock];
}

+ (void)avatarWithUserName:(NSString *)userName
                 successBlock:(NetworkSuccessBlock)successBlock
                 failureBlock:(NetworkFailureBlock)failureBlock {
   
   NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
   [params setObject:userName forKey:@"username"];
   
   NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder avatarUrlWithParameters:params]];
   [params release];
   
    [FlashizServices executeRequest:request
                         forService:avatarServiceDescription
                   withSuccessBlock:^(id context) {
                       id byteArray = [context objectForKey:@"avatar"];
                       
                       if(byteArray != nil && [byteArray isKindOfClass:[NSArray class]]){
                           
                           NSArray *array = [[[NSArray alloc] initWithArray:byteArray] autorelease];
                           
                           successBlock(array);
                       } else {
                           
                           //we don't block the user in the app only because of avatar's problem
                           //so just return nil
                           
                           successBlock(nil);
                       }
                   } failureBlock:failureBlock];
}

+ (void)avatarTimestampWithMail:(NSString *)mail
                      successBlock:(NetworkSuccessBlock)successBlock
                      failureBlock:(NetworkFailureBlock)failureBlock {
   
   NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
   [params setObject:mail forKey:@"mail"];
   
   NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder avatarTimestampFromMailWithParameters:params]];
   [params release];
   
   
   [FlashizServices executeRequest:request
                        forService:avatarServiceDescription
                  withSuccessBlock:^(id context) {
                     id timestamp = [context objectForKey:@"timestamp"];
                     
                      
                      //TODO : improve this...
                     if(timestamp != nil){
                         //return (NSNumber *)timestamp;
                     } else {
                         
                         #warning undefined read error ?!!!!
                        
                        /*
                        Error *error = [[Error alloc] initWithRequest:nil response:response.description timestamp:[NSDate date] message:INVALID_JSON_MISSING_KEYS detail:[NSString stringWithFormat:@"%@ : timestamp",JSON_MISSING_KEYS_ERROR_MESSAGE]];
                        [ErrorManager addError:error];
                        */
                        
                        //return nil;
                        
                     }
                     
                     successBlock(timestamp);

                  } failureBlock:failureBlock];
}

+ (void)setAvatarWithUserKey:(NSString *)userKey
                      avatar:(UIImage *)avatarFile
                       token:(NSString *)token
                successBlock:(NetworkSuccessBlock)successBlock
                failureBlock:(NetworkFailureBlock)failureBlock {
   
   NSURL* requestURL = [FlashizUrlBuilder avatarUploadUrl];
   
   // create request
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:requestURL];
   [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
   //[request setHTTPShouldHandleCookies:NO]; we comment this line because it disable cookies. However we need to be connected to access uploadavatar service (so we need cookies, because everyone love cookies)
   [request setTimeoutInterval:30];
   [request setHTTPMethod:@"POST"];
   
   // Dictionary that holds post parameters. You can set your post parameters that your server accepts or programmed to accept.
   NSMutableDictionary* _params = [[NSMutableDictionary alloc] init];
   [_params setObject:[NSString stringWithString:(userKey != nil ? userKey : @"")] forKey:userKeyParameter];
   [_params setObject:@"" forKey:@"token"];
   
   // the boundary string : a random string, that will not repeat in post data, to separate post data fields.
   NSString *BoundaryConstant = @"----------V2ymHFg03ehbqgZCaKO6jy";
   
   // string constant for the post parameter 'file'. My server uses this name: `file`. Your's may differ
   NSString* FileParamConstant = @"avatar";
   
   // set Content-Type in HTTP header
   NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", BoundaryConstant];
   [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
   
   // post body
   NSMutableData *body = [NSMutableData data];
   
   // add params (all params are strings)
   for (NSString *param in _params) {
      [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", param] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"%@\r\n", [_params objectForKey:param]] dataUsingEncoding:NSUTF8StringEncoding]];
   }
   
   [_params release];
   
   // add image data
   NSData *imageData = UIImageJPEGRepresentation(avatarFile, 0.8);
   if (imageData) {
      [body appendData:[[NSString stringWithFormat:@"--%@\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"avatar.jpg\"\r\n", FileParamConstant] dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
      [body appendData:imageData];
      [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
   }
   
   [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", BoundaryConstant] dataUsingEncoding:NSUTF8StringEncoding]];
   
   // setting the body of the post to the reqeust
   [request setHTTPBody:body];
   
   // set the content-length
   NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
   [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
   
   [FlashizServices executeRequest:request
                        forService:changeAvatarServiceDescription
                  withSuccessBlock:^(id context) {
                     BOOL isSuccessful = (nil!=context);
                     
                     successBlock([NSNumber numberWithBool:isSuccessful]);
                     
                  } failureBlock:failureBlock];
}

@end
