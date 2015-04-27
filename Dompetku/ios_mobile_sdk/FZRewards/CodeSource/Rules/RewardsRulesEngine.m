//
//  FidelitizRulesEngine.m
//  iMobey
//
//  Created by Matthieu Barile on 19/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "RewardsRulesEngine.h"


//Domain
#import <FZAPI/User.h>
#import <FZAPI/UserSession.h>

//Currency
#import <FZAPI/CurrenciesManager.h>

//Language
#import <FZBlackBox/LocalizationHelper.h>

@implementation RewardsRulesEngine

+(NSArray*)rulesEngine:(LoyaltyProgram *)program Currency:(NSString*)currency{//TODO test currency
	
	//create phrases according to the rule
	NSString * rule1;
	NSString * rule2;
	
	
	
	if ([[program loyaltyProgramType] isEqualToString:@"POINTS"]){// points rule
		if([[program expenseType] isEqualToString:@"MONEY"]){//points by money spent
			if([[program rewardType] isEqualToString:@"CASH"]){ //earn cash
				//NSLog(@"Obtenez X points pour X€ d’achat.");
				//[NSString stringWithFormat:@"%d",[program pointPerExpense]]
				[[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[program pointPerExpense]] butWithCurrency:[[[[UserSession currentSession] user] account]currency]];
				
				rule1 = [NSString stringWithFormat:@"%@ %@ %@ %@ %@%@",
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.A" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],//Obtenez
						 [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[program pointPerExpense]] butWithCurrency:currency],//X
						 [program pointPerExpense]>1?[LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.B2" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]:[LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.B1" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],//point(s)
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.C" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],//pour
						 [[CurrenciesManager currentManager] formattedAmountLight:@"1" currency:currency],//X
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.D" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]];//€ d'achat
				
				//NSLog(@"Cumulez X points pour obtenir un bon d’achat de X€.");
				rule2 = [NSString stringWithFormat:@"%@ %@ %@ %@ %@%@",
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.A" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[program pointAmountForCoupon]] butWithCurrency:currency],
						 [program pointAmountForCoupon]>1?[LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.B2" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]:[LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.B1" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.C" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.f",[program discountAmount]] currency:currency],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.D" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]];
				
			} else { //earn percent
				//NSLog(@"Obtenez X points pour X€ d’achat.");
				rule1 = [NSString stringWithFormat:@"%@ %@ %@ %@ %@%@",
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.A" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],//Obtenez
						 [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[program pointPerExpense]] butWithCurrency:currency],//X
						 [program pointPerExpense]>1?[LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.B2" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]:[LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.B1" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],//point(s)
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.C" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],//pour
						 [[CurrenciesManager currentManager] formattedAmountLight:@"1" currency:currency],//X
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.D" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]];//€ d'achat
				
				//NSLog(@"Cumulez X points pour obtenir X%% de réduction");
				rule2 = [NSString stringWithFormat:@"%@ %@ %@ %@ %.0f%@",
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.A" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[program pointAmountForCoupon]] butWithCurrency:currency],
						 [program pointAmountForCoupon]>1?[LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.B2" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]:[LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.B1" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.C" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [program discountAmount],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.D" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]];
			}
		} else {//points by visit
			if([[program rewardType] isEqualToString:@"CASH"]){ //earn cash
				//NSLog(@"Obtenez X points à chaque paiement.");
				rule1 = [NSString stringWithFormat:@"%@ %@ %@ %@",
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PAIEMENT.A" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[program pointPerExpense]] butWithCurrency:currency],
						 [program pointPerExpense]>1?[LocalizationHelper stringForKey:@"DISCOUNT.POINT.PAIEMENT.B2" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]:[LocalizationHelper stringForKey:@"DISCOUNT.POINT.PAIEMENT.B1" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PAIEMENT.C" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]];
				
				//NSLog(@"Cumulez X points pour obtenir un bon d’achat de X€.");
				rule2 = [NSString stringWithFormat:@"%@ %@ %@ %@ %@%@",
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.A" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[program pointAmountForCoupon]] butWithCurrency:currency],
						 [program pointAmountForCoupon]>1?[LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.B2" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]:[LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.B1" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.C" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [[CurrenciesManager currentManager] formattedAmountLight:[NSString stringWithFormat:@"%.f",[program discountAmount]] currency:currency],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.CASH.GET.D" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]];
			} else { //earn percent
				//NSLog(@"Obtenez X points à chaque paiement.");
				rule1 = [NSString stringWithFormat:@"%@ %@ %@ %@",
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PAIEMENT.A" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[program pointPerExpense]] butWithCurrency:currency],
						 [program pointPerExpense]>1?[LocalizationHelper stringForKey:@"DISCOUNT.POINT.PAIEMENT.B2" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]:[LocalizationHelper stringForKey:@"DISCOUNT.POINT.PAIEMENT.B1" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PAIEMENT.C" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]];
				
				//NSLog(@"Cumulez X points pour obtenir X%% de réduction");
				rule2 = [NSString stringWithFormat:@"%@ %@ %@ %@ %.f%@",
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.A" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [[CurrenciesManager currentManager] formattedAmountWithNoCurrency:[NSString stringWithFormat:@"%d",[program pointAmountForCoupon]] butWithCurrency:currency],
						 [program pointAmountForCoupon]>1?[LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.B2" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]:[LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.B1" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.C" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
						 [program discountAmount],
						 [LocalizationHelper stringForKey:@"DISCOUNT.POINT.PERCENT.D" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]];
			}
		}
	} else { //fixe percent by visit
		//NSLog(@"Obtenez X%% de réduction à chaque paiement.");
		rule1 = [NSString stringWithFormat:@"%@ %.f%@",
				 [LocalizationHelper stringForKey:@"DISCOUNT.PERCENT.PAIEMENT.A" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards],
				 [program permanentPercentageDiscount],
				 [LocalizationHelper stringForKey:@"DISCOUNT.PERCENT.PAIEMENT.B" withComment:@"RewardsRulesEngine" inDefaultBundle:FZBundleRewards]];
		rule2 = @"";
	}
	
	return [[[NSArray alloc] initWithObjects:rule1,rule2,nil] autorelease];
}


@end