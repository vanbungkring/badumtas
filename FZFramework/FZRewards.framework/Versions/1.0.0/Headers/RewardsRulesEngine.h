//
//  FidelitizRulesEngine.h
//  iMobey
//
//  Created by Matthieu Barile on 19/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

//Domain
#import <FZAPI/LoyaltyProgram.h>

@interface RewardsRulesEngine : NSObject

+ (NSArray*)rulesEngine:(LoyaltyProgram *)program Currency:(NSString*)currency;

@end
