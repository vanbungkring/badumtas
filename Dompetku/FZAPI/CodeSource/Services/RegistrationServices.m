//
//  RegistrationServices.m
//  iMobey
//
//  Created by Neopixl on 29/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "RegistrationServices.h"
#import "FlashizUrlBuilder.h"

#import "Country.h"
#import "User.h"

static NSString * const secretQuestionsServiceDescription = @"secret questions";
static NSString * const countriesServiceDescription = @"countries";
//static NSString * const captchaServiceDescription = @"captcha";
static NSString * const captchaSubmitServiceDescription = @"captcha submit";

static NSString * const userTrialServiceDescription = @"user trial";

@implementation RegistrationServices


+ (void)secretQuestionsWithSuccessBlock:(NetworkSuccessBlock)successBlock
                              failureBlock:(NetworkFailureBlock)failureBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSLocale preferredLanguages] objectAtIndex:0] forKey:@"lang"];
    
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder registrationListsWithParameters:params]];
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:secretQuestionsServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       NSMutableArray *secretQuestionsList = [NSMutableArray arrayWithArray:(NSArray *)[context objectForKey:@"secretQuestions"]];
                       
                       successBlock(secretQuestionsList);
                       
                   } failureBlock:failureBlock];



}

+ (void)countriesWithLang:(NSString *)lang andSuccessBlock:(NetworkSuccessBlock)successBlock
                              failureBlock:(NetworkFailureBlock)failureBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:lang forKey:@"lang"];
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder countriesWithParameters:params]];
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:countriesServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       // TODO : not the good place to parse the object
                       NSMutableArray *countriesList = [[NSMutableArray alloc] init];
                       
                       NSArray *countriesListTemp = [context objectForKey:@"countryDtoList"];
                       
                       for(NSDictionary *countryDict in countriesListTemp){
                           //Country *country = [Country countryWithDictionary:countryDict error:error];
                           [Country countryWithDictionary:countryDict successBlock:^(id object) {
                               [countriesList addObject:(Country *)object];
                           } failureBlock:^(Error *error) {
                               //do not add malformerd country
                           }];
                       }
                       
                       successBlock(countriesList);
                       
                       [countriesList release];
                       
                   } failureBlock:failureBlock];
}

+ (void)captchaSubmitWithCaptcha:(NSString *)captcha
                    successBlock:(NetworkSuccessBlock)successBlock
                    failureBlock:(NetworkFailureBlock)failureBlock{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:captcha forKey:@"captchaResponse"];
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder captchaSubmitWithParameters:params]];
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:captchaSubmitServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       successBlock(context);
                       
                   } failureBlock:failureBlock];
}


+ (void)createUserTrialWith:(User *)user
            forBrandPartner:(NSString *)brandPartner
               successBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:user.country forKey:@"country"];
    [params setObject:user.email forKey:@"mail"];
    [params setObject:user.password forKey:@"password"];
    [params setObject:user.secretQuestion forKey:@"secretQuestion"];
    [params setObject:user.secretAnswer forKey:@"secretAnswer"];
    //[params setObject:user.captcha forKey:@"captchaResponse"];
    [params setObject:brandPartner forKey:@"brandPartner"];
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder userTrial:params]];
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:userTrialServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       successBlock(context);
                       
                   } failureBlock:failureBlock];

}


@end
