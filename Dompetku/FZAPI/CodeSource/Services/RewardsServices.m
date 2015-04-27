//
//  FidelitizServices.m
//  iMobey
//
//  Created by Yvan Moté on 12/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "RewardsServices.h"
#import "FlashizUrlBuilder.h"

//Model
#import "LoyaltyProgram.h"
#import "LoyaltyAffiliateProgram.h"
#import "LoyaltyCard.h"


static NSString * const createFidelitizAccountServiceDescription = @"create fidelitiz account";
static NSString * const createFidelitizCardServiceDescription = @"create fidelitiz card";
static NSString * const deleteFidelitirCardServiceDescription = @"delete fidelitiz card";
static NSString * const fidelitizCardsServiceDescription = @"fidelitiz cards";
static NSString * const fidelitizCardServiceDescription = @"fidelitiz card";
static NSString * const programDetailsServiceDescription = @"program details";
static NSString * const programsListServiceDescription = @"programs list";
static NSString * const affiliatesListServiceDescription = @"affiliates list";


@implementation RewardsServices

+ (void)createFidelitizAccountWithSuccessBlock:(NetworkSuccessBlock)successBlock
                                  failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSURLRequest *request = [FlashizServices requestGetForUrl:[FlashizUrlBuilder createRewardsAccountUrl]];
    
    [FlashizServices executeRequest:request
                         forService:createFidelitizAccountServiceDescription
                   withSuccessBlock:^(id context) {
                       successBlock(context);
                   } failureBlock:failureBlock];
}

+ (void)createFidelitizCard:(NSString*)fidelitizId AffiliatedToTheProgramId:(NSString*)loyaltyProgramId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:fidelitizId forKey:@"fidelitizId"];
    [params setObject:loyaltyProgramId forKey:@"loyaltyProgramId"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder createRewardsCardUrl]
                                                withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:createFidelitizCardServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       // TODO: and if the key doesn't exist????? 🙈
                       NSString *loyaltyCardId = [context objectForKey:@"loyaltyCardId"];
                       
                       successBlock(loyaltyCardId);
                       
                   } failureBlock:failureBlock];
    
}

+ (void)createFidelitizCard:(NSString*)fidelitizId AffiliatedToTheProgramId:(NSString*)loyaltyProgramId PrivateReference:(NSString*)reference withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:fidelitizId forKey:@"fidelitizId"];
    [params setObject:loyaltyProgramId forKey:@"loyaltyProgramId"];
    [params setObject:reference forKey:@"reference"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder createRewardsCardPrivateUrl]
                                                withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:createFidelitizCardServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       FZAPILog(@"result : %@",context);
                       
                       // TODO: and if the key doesn't exist????? 🙈
                       NSString *loyaltyCardId = [context objectForKey:@"loyaltyCardId"];
                       
                       successBlock(loyaltyCardId);
                       
                   } failureBlock:failureBlock];
}


+ (void)deleteFidelitizCard:(NSString*)fidelitizId CardId:(NSString*)loyaltyCardId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:fidelitizId forKey:@"fidelitizId"];
    [params setObject:loyaltyCardId forKey:@"loyaltyCardId"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder deleteRewardsCardUrl]
                                                withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:deleteFidelitirCardServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       NSString *result = [context objectForKey:@"result"];
                       
                       successBlock([NSNumber numberWithBool:[result isEqualToString:@"success"]?YES:NO]);
                       
                   } failureBlock:failureBlock];
}

+ (void)fidelitizCards:(NSString*)fidelitizId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    
    if([fidelitizId length]==0) {
        Error *error = [FlashizServices errorWithMessage:@"fidelitiz id is empty" code:FZ_INVALID_SERVICE_OR_PARAMETERS_ERROR_CODE andRequestCode:-1];
        
        failureBlock(error);
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:fidelitizId forKey:@"fidelitizId"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder rewardsCardsListUrl]
                                                withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:fidelitizCardsServiceDescription
                   withSuccessBlock:^(id context) {
                       // TODO: and if the key doesn't exist????? 🙈
                       // TODO : not the good place to parse
                       NSArray *loyaltyCards = [context objectForKey:@"loyaltyCards"];
                       
                       NSMutableArray *cards = [[NSMutableArray alloc] init];
                       
                       for(NSDictionary *dictionaryLoyaltyCard in loyaltyCards) {
                           
                           //LoyaltyCard *card = [LoyaltyCard loyaltyProgramWithDictionary:dictionaryLoyaltyCard error:error];
                           [LoyaltyCard loyaltyProgramWithDictionary:dictionaryLoyaltyCard successBlock:^(id object) {
                               [cards addObject:(LoyaltyCard *)object];
                           } failureBlock:^(Error *error) {
                               NSLog(@"do not add malformed LoyaltyCard");
                               //do not add malformed LoyaltyCard
                           }];
                       }
                       
                       successBlock(cards);
                       
                       [cards release];
                       
                   } failureBlock:failureBlock];
}

/* New */
+ (void)fidelitizCardsWithUserkey:(NSString*)userkey withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    
    if([userkey length]==0) {
        Error *error = [FlashizServices errorWithMessage:@"userkey is empty" code:FZ_INVALID_SERVICE_OR_PARAMETERS_ERROR_CODE andRequestCode:-1];
        
        failureBlock(error);
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:@"userkey"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder rewardsCardsListUrl]
                                                withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:fidelitizCardsServiceDescription
                   withSuccessBlock:^(id context) {
                       // TODO: and if the key doesn't exist?????
                       NSArray *loyaltyCards = [context objectForKey:@"loyaltyCards"];
                       
                       NSMutableArray *cards = [[NSMutableArray alloc] init];
                       
                       for(NSDictionary *dictionaryLoyaltyCard in loyaltyCards) {
                           
                           //LoyaltyCard *card = [LoyaltyCard loyaltyProgramWithDictionary:dictionaryLoyaltyCard error:error];
                           [LoyaltyCard loyaltyProgramWithDictionary:dictionaryLoyaltyCard successBlock:^(id object) {
                               [cards addObject:(LoyaltyCard *)object];
                           } failureBlock:^(Error *error) {
                               NSLog(@"do not add malformed LoyaltyCard");
                               //do not all malformed LoyaltyCard
                           }];
                       }
                       
                       successBlock(cards);
                       
                       [cards release];
                       
                   } failureBlock:failureBlock];
}

+ (void)fidelitizCard:(NSString*)loyaltyCardId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:loyaltyCardId forKey:@"loyaltyCardId"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder rewardsCardUrl]
                                                withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:fidelitizCardServiceDescription
                   withSuccessBlock:^(id context) {
                       NSDictionary *loyaltyCardDictionary = [context objectForKey:@"loyaltyCard"];
                       
                       //LoyaltyCard *card = [LoyaltyCard loyaltyProgramWithDictionary:loyaltyCardDictionary error:error];
                       [LoyaltyCard loyaltyProgramWithDictionary:loyaltyCardDictionary successBlock:^(id object) {
                           successBlock((LoyaltyCard *)object);
                       } failureBlock:^(Error *error) {
                           failureBlock(error);
                       }];
                   } failureBlock:failureBlock];
}

+ (void)programDetails:(NSString*)loyaltyProgramId withLogo:(BOOL)withLogo withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:loyaltyProgramId forKey:@"loyaltyProgramId"];
    [params setObject:withLogo?@"TRUE":@"FALSE" forKey:@"withLogo"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder programDetailsUrl]
                                                withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:programDetailsServiceDescription
                   withSuccessBlock:^(id context) {
                       //LoyaltyProgram *loyaltyProgram = [LoyaltyProgram loyaltyProgramWithDictionary:[context objectForKey:@"loyaltyProgram"] error:error];
                       [LoyaltyProgram loyaltyProgramWithDictionary:[context objectForKey:@"loyaltyProgram"] successBlock:^(id object) {
                           successBlock((LoyaltyProgram *)object);
                       } failureBlock:^(Error *error) {
                           failureBlock(error);
                       }];
                   } failureBlock:failureBlock];
}

+ (void)programsListNotAlreadySuscribe:(NSString*)fidelitizId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:fidelitizId forKey:@"fidelitizId"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder programsListNotAlreadyUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:programsListServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       NSArray *programs = [context objectForKey:@"loyaltyPrograms"];
                       
                       NSMutableArray *programsList = [[NSMutableArray alloc] init];
                       
                       for(NSDictionary *program in programs) {
                           //LoyaltyProgram *loyaltyProgram = [LoyaltyProgram loyaltyProgramWithDictionary:program error:error];
                           [LoyaltyProgram loyaltyProgramWithDictionary:program successBlock:^(id object) {
                               [programsList addObject:(LoyaltyProgram *)object];
                           } failureBlock:^(Error *error) {
                               NSLog(@"do not add malformed LoyaltyProgram");
                               //do not add malformed LoyaltyProgram
                           }];
                       }
                       
                       successBlock(programsList);
                       
                       [programsList release];
                       
                   } failureBlock:failureBlock];
}

/* New */
+ (void)programsListNotAlreadySuscribeWithUserkey:(NSString*)userkey withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userkey forKey:@"userkey"];
    [params setObject:@"0" forKey:@"fidelitizId"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder programsListNotAlreadyUrl] withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:programsListServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       NSArray *programs = [context objectForKey:@"loyaltyPrograms"];
                       
                       NSMutableArray *programsList = [[NSMutableArray alloc] init];
                       
                       for(NSDictionary *program in programs) {
                           //LoyaltyProgram *loyaltyProgram = [LoyaltyProgram loyaltyProgramWithDictionary:program error:error];
                           [LoyaltyProgram loyaltyProgramWithDictionary:program successBlock:^(id object) {
                               [programsList addObject:(LoyaltyProgram *)object];
                           } failureBlock:^(Error *error) {
                               NSLog(@"do not add malformed LoyaltyProgram");
                               //do not add malformed LoyaltyProgram
                           }];
                       }
                       
                       successBlock(programsList);
                       
                       [programsList release];
                       
                   } failureBlock:failureBlock];
}

+ (void)affiliatesList:(NSString*)proId withSuccessBlock:(NetworkSuccessBlock)successBlock failureBlock:(NetworkFailureBlock)failureBlock {
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:proId forKey:@"loyaltyProgramId"];
    
    NSURLRequest *request = [FlashizServices requestPostForUrl:[FlashizUrlBuilder affiliatesListUrl]
                                                withParameters:params];
    
    [params release];
    
    [FlashizServices executeRequest:request
                         forService:affiliatesListServiceDescription
                   withSuccessBlock:^(id context) {
                       
                       // TODO: and if the key doesn't exist????? 🙈
                       
                       NSArray *affiliationsList = [context objectForKey:@"affiliationsList"];
                       
                       NSMutableArray *listAffiliateProgram = [NSMutableArray array];
                       
                       for(NSDictionary *dictionaryAffiliation in affiliationsList) {
                           //LoyaltyAffiliateProgram *affiliateProgram = [LoyaltyAffiliateProgram loyaltyAffiliateProgramvWithDictionary:dictionaryAffiliation error:error];
                           [LoyaltyAffiliateProgram loyaltyAffiliateProgramvWithDictionary:dictionaryAffiliation successBlock:^(id object) {
                              [listAffiliateProgram addObject:(LoyaltyAffiliateProgram *)object];
                           } failureBlock:^(Error *error) {
                               NSLog(@"do not add malformed LoyaltyAffiliateProgram");
                               //do not add malformed LoyaltyAffiliateProgram
                           }];
                       }
                       successBlock(listAffiliateProgram);
                       
                   } failureBlock:failureBlock];
}

@end
