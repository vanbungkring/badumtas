//
//  UserServices.m
//  iMobey
//
//  Created by Neopixl on 02/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "UserServices.h"
#import "FlashizUrlBuilder.h"

#import "User.h"

static NSString * const userGetInformationServiceDescription = @"user get informations";

static NSString * const userEditInformationServiceDescription = @"user edit informations";

@implementation UserServices

+ (void)userGetInformation:(NetworkSuccessBlock)successBlock
              failureBlock:(NetworkFailureBlock)failureBlock{
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder userGetInformation]];
  
    [FlashizServices executeRequest:request
                         forService:userGetInformationServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       User *user = [User userWithInformationDictionary:[context objectForKey:@"user"]];
                       successBlock(user);
                       
                   } failureBlock:failureBlock];
}


+ (void)userEditInformation:(User *)user userkey:(NSString *)userkey withSuccesBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"ddMMyyyy"];
    
    NSString *birthdayString = [formatter stringFromDate:user.birthday];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:user.lastName, @"lastName", user.firstName, @"firstName", user.sex, @"gender", birthdayString,@"birthDate",user.nationality, @"nationality", user.address1, @"address1", user.cityCode, @"zipcode", user.cityName, @"city", user.phoneNumber, @"phoneNumber", userkey,userKeyParameter, nil];
    
    
    [formatter release];
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder userEditInformationWithParameters:params]];
    
    [FlashizServices executeRequest:request
                         forService:userEditInformationServiceDescription
                   withSuccessBlock:^(id context) {
                       successBlock(user);
                       
                   } failureBlock:failureBlock];
    
    
}

@end
