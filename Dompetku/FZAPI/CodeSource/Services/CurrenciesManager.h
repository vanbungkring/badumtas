//
//  CurrenciesManager.h
//  iMobey
//
//  Created by Matthieu Barile on 04/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrenciesManager : NSObject {
    
}

@property (nonatomic, retain) NSDictionary * iso_currency;
@property (nonatomic, retain) NSString * defaultCurrency;

+ (CurrenciesManager *)currentManager;
- (NSString *)formattedAmount:(NSString *) amount currency:(NSString *)currency;
- (NSString *)formattedAmountLight:(NSString *) amount currency:(NSString *)currency;
- (NSString *)formattedAmountWithNoCurrency:(NSString*) amount;
- (NSString *)formattedPercent:(NSString *)value;
- (NSString *)formattedPercentLight:(NSString *)value;
- (NSArray *)currencySymbols:(NSString *)currency;
- (NSString *)formattedAmountWithNoCurrency:(NSString*) amount butWithCurrency:(NSString *)currency;

@end
