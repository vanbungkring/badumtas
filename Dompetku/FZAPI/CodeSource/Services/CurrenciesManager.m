//
//  CurrenciesManager.m
//  iMobey
//
//  Created by Matthieu Barile on 04/09/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "CurrenciesManager.h"

static CurrenciesManager *cm = nil;

@implementation CurrenciesManager

#pragma mark - Init

+ (CurrenciesManager *)currentManager {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		FZAPILog(@"init");
		cm = [[CurrenciesManager alloc] init];
	});
	return cm;
}

- (id)init {
	self = [super init];
	if (self) {
		//init default values available in the currencies manager
		NSArray *eur = [[NSArray alloc] initWithObjects:@"",@"€",nil];
		NSArray *usd = [[NSArray alloc] initWithObjects:@"$",@"",nil];
		NSArray *aud = [[NSArray alloc] initWithObjects:@"$",@"AUD",nil];
		NSArray *idr = [[NSArray alloc] initWithObjects:@"IDR",@"",nil];
		NSArray *currencies = [[NSArray alloc] initWithObjects:
							   eur,
							   usd,
							   aud,
							   idr,nil];
		NSArray *isoCurrencies = [[NSArray alloc] initWithObjects:
								  @"EUR",
								  @"USD",
								  @"AUD",
								  @"IDR",nil];
		
		[self setIso_currency:[[[NSDictionary alloc] initWithObjects:currencies
															 forKeys:isoCurrencies] autorelease]];
		[eur release];
		[usd release];
		[aud release];
		[idr release];
		[currencies release];
		[isoCurrencies release];
		
		[self setManualDefaultCurrency:@"EUR"]; //the default currency is EUR
		
		FZAPILog(@"CurrenciesManager init done");
	}
	
	return self;
}

#pragma mark - Methods

- (NSString *)getDefaultCurrency{
	
	if([_defaultCurrency length]>0) {
		return [self defaultCurrency];
	} else {
		return @"EUR"; //the default currency is EUR
	}
}

- (void)setManualDefaultCurrency:(NSString *)newDefaultCurrency{
	if([newDefaultCurrency length]==0){
		//FZAPILog(@"**** WARNING NO CURRENCY DETECTED, EUR IS NOW USED AS DEFAULT ****");
		[self setDefaultCurrency:@"EUR"];//the default currency is EUR
	} else {
		[self setDefaultCurrency:[newDefaultCurrency uppercaseString]];
	}
}

//Get formatted amount
- (NSString *)formattedAmount:(NSString*) amount currency:(NSString *) currency{
	return [self formattedAmount:amount currency:currency percent:false];
}

- (NSString *)formattedAmountLight:(NSString*) amount currency:(NSString *) currency{
	return [self formattedAmountLight:amount currency:currency percent:false];
}

- (NSString *)formattedAmount:(NSString*) amount currency:(NSString *) currency percent:(BOOL)isPercent{
	
	NSString *tempCurrency = [currency uppercaseString]; //prevent currency lowercase
	
	if(tempCurrency.length == 0 || tempCurrency.length > 3){
		tempCurrency = [self getDefaultCurrency];
	}
	
	//TODO : NSNumberFormatter is very powerful, we should use it to format perfectly the amount by using its properties and method so that the amount formatting be very quick and efficient
	
	NSNumberFormatter *amountFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    
    if([currency isEqualToString:@"IDR"]){
        if(isPercent){
            [amountFormatter setNumberStyle:NSNumberFormatterPercentStyle];
            NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]/100];
            return [amountFormatter stringFromNumber:formattedAmount];
        } else{
            [amountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            [amountFormatter setMaximumFractionDigits:2];
            [amountFormatter setAlwaysShowsDecimalSeparator:NO];
            [amountFormatter setGroupingSeparator:@","];
            if([amount doubleValue]<0){
                double amountDouble =[amount doubleValue] * -1;
                NSNumber *formattedAmount = [NSNumber numberWithDouble:amountDouble];
                return [NSString stringWithFormat:@"%@%@ %@",@"- ",[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0],[amountFormatter stringFromNumber:formattedAmount]];
            } else{
                NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]];
                return [NSString stringWithFormat:@"%@ %@",[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0],[amountFormatter stringFromNumber:formattedAmount]];
            }
        }
    }
    
     NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]];
    
    if(isPercent){
        return [NSString stringWithFormat:@"%.2f %@",[formattedAmount doubleValue],@"%"];
    } else {
        if(![self checkCurrency:tempCurrency]){
            [self currencyError];
            return NULL;//currency error
        } else {
            NSString* sign = @"";
            if([formattedAmount doubleValue] < 0){
                sign = @"- "; //don't forget the white space
                formattedAmount = [NSNumber numberWithDouble:(-1)*[amount doubleValue]];
            } else {
                sign = @"";
            }
            
            if([self revertSymbols]) {
                return [NSString stringWithFormat:@"%@%@ %.2f %@",sign,[[_iso_currency objectForKey: tempCurrency] objectAtIndex:1],[formattedAmount doubleValue],[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0]];
            } else {
                return [NSString stringWithFormat:@"%@%@ %.2f %@",sign,[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0],[formattedAmount doubleValue],[[_iso_currency objectForKey: tempCurrency] objectAtIndex:1]];
            }
        }
    }
}

- (NSString *)formattedAmountLight:(NSString*) amount currency:(NSString *) currency percent:(BOOL)isPercent{
	
	NSString *tempCurrency = [currency uppercaseString]; //prevent currency lowercase
	
	if(tempCurrency.length == 0 || tempCurrency.length > 3){
		tempCurrency = [self getDefaultCurrency];
	}
	
	NSNumberFormatter *amountFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[amountFormatter setGroupingSeparator:@","];
	
	if([currency isEqualToString:@"IDR"]){
		if(isPercent){
			[amountFormatter setNumberStyle:NSNumberFormatterPercentStyle];
			NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]/100];
			return [amountFormatter stringFromNumber:formattedAmount];
		}
		else{
			[amountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
			[amountFormatter setAlwaysShowsDecimalSeparator:NO];
			if([amount doubleValue]<0){
				double amountDouble =[amount doubleValue] * -1;
				NSNumber *formattedAmount = [NSNumber numberWithDouble:amountDouble];
				return [NSString stringWithFormat:@"%@%@ %@",@"- ",[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0],[amountFormatter stringFromNumber:formattedAmount]];
			} else{
				NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]];
				return [NSString stringWithFormat:@"%@ %@",[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0],[amountFormatter stringFromNumber:formattedAmount]];
			}
		}
	}
    
	/*if(isPercent){
     [amountFormatter setNumberStyle:NSNumberFormatterPercentStyle];
     NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]/100];
     return [amountFormatter stringFromNumber:formattedAmount];
     }
     else{
     [amountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
     [amountFormatter setAlwaysShowsDecimalSeparator:NO];
     if([amount doubleValue]<0){
     double amountDouble =[amount doubleValue] * -1;
     NSNumber *formattedAmount = [NSNumber numberWithDouble:amountDouble];
     return [NSString stringWithFormat:@"%@%@ %@",@"- ",[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0],[amountFormatter stringFromNumber:formattedAmount]];
     } else{
     NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]];
     return [NSString stringWithFormat:@"%@ %@",[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0],[amountFormatter stringFromNumber:formattedAmount]];
     }
     }*/
	if([[amount componentsSeparatedByString:@","] count] > 1){
        if([NSNumber numberWithDouble:[[NSString stringWithFormat:@"%.2f",[[[amount componentsSeparatedByString:@","] objectAtIndex:1] doubleValue]]  doubleValue]] > 0) {
            FZAPILog(@"There are decimal >> redirect to non light formatter");
            return [self formattedAmount:amount currency:currency percent:isPercent];
        }
    }
    
    
    [amountFormatter setMaximumFractionDigits:0];
    [amountFormatter setMinimumFractionDigits:0];
    [amountFormatter setGroupingSeparator:[[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator]];
    [amountFormatter setGroupingSize:3];
    [amountFormatter setAlwaysShowsDecimalSeparator:YES];
    [amountFormatter setUsesGroupingSeparator:YES];
    
    NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]];
    
    if(isPercent){
        if([amount doubleValue]<0){
            return [NSString stringWithFormat:@"- %.0f %@",[formattedAmount doubleValue]*(-1),@"%"];
        } else {
            return [NSString stringWithFormat:@"%.0f %@",[formattedAmount doubleValue],@"%"];
        }
    } else {
        if(![self checkCurrency:tempCurrency]){
            [self currencyError];
            return NULL;//currency error
        } else {
            NSString* sign = @"";
            if([formattedAmount doubleValue] < 0){
                sign = @"- "; //don't forget the white space
                formattedAmount = [NSNumber numberWithDouble:(-1)*[amount doubleValue]];
            } else {
                sign = @"";
            }
            if([[self defaultCurrency] isEqualToString:@"AUD"]){
                return [NSString stringWithFormat:@"%@%@ %.0f",sign,[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0],[formattedAmount doubleValue]];
            } else {
                if([self revertSymbols]) {
                    return [NSString stringWithFormat:@"%@%@ %.0f %@",sign,[[_iso_currency objectForKey: tempCurrency] objectAtIndex:1],[formattedAmount doubleValue],[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0]];
                } else {
                    return [NSString stringWithFormat:@"%@%@ %.0f %@",sign,[[_iso_currency objectForKey: tempCurrency] objectAtIndex:0],[formattedAmount doubleValue],[[_iso_currency objectForKey: tempCurrency] objectAtIndex:1]];
                }
            }
        }
    }
}

- (NSString *)formattedAmountWithNoCurrency:(NSString*) amount {
	
	NSNumberFormatter *amountFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[amountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[amountFormatter setAlwaysShowsDecimalSeparator:NO];
	NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]];
    
    if ([[self getDefaultCurrency] length] > 0 && ![[self getDefaultCurrency] isEqualToString:@"IDR"]) {
        [amountFormatter setGroupingSeparator:@""];
    } else {
        [amountFormatter setGroupingSeparator:@","];
    }
	
	return [amountFormatter stringFromNumber:formattedAmount];
}

- (NSString *)formattedAmountWithNoCurrency:(NSString*) amount butWithCurrency:(NSString *)currency {
	
	NSNumberFormatter *amountFormatter = [[[NSNumberFormatter alloc] init] autorelease];
	[amountFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[amountFormatter setAlwaysShowsDecimalSeparator:NO];
	NSNumber *formattedAmount = [NSNumber numberWithDouble:[amount doubleValue]];
	if([currency isEqualToString:@"IDR"]){
		[amountFormatter setGroupingSeparator:@","];
	}else{
		[amountFormatter setGroupingSeparator:@" "];
	}
	
	return [amountFormatter stringFromNumber:formattedAmount];
}

- (NSString *)formattedPercent:(NSString*) value{
	return [self formattedAmount:value currency:@"" percent:YES];
}

- (NSString *)formattedPercentLight:(NSString*) value{
	return [self formattedAmountLight:value currency:@"" percent:YES];
}

//Get associated symbols
- (NSArray *)currencySymbols:(NSString *) currency{
	
	NSString *tempCurrency = [currency uppercaseString]; //prevent currency lowercase
	
	if([self checkCurrency:tempCurrency]){
		return [_iso_currency objectForKey:tempCurrency];
	} else {
		[self currencyError];
		return nil;
	}
}

//Check currency consistence
- (BOOL)checkCurrency:(NSString*) newCurrency{
	
#warning TEMP: bypass for indonesia, wainting for a webservice to retrieve the default currency
	if([newCurrency isEqualToString:@"IDR"]) {
		return YES;
	} else {
		//FZAPILog(@"Default currency : %@ | Tested currency : %@",_defaultCurrency,newCurrency);
		return [newCurrency isEqualToString:[self getDefaultCurrency]];
	}
}

#pragma mark - Rules

- (BOOL)revertSymbols {
	if([[[NSLocale preferredLanguages] objectAtIndex:0] isEqualToString:@"nl"] && [[self defaultCurrency] isEqualToString:@"EUR"]){
		return YES;
	} else {
		return NO;
	}
}

#pragma mark - Errors

- (void)currencyError{
	FZAPILog(@"Currency error !");
	
#warning Disabled UIAlertView
	/*
	 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
	 message:[LocalizationHelper stringForKey:@"currencyManager_error" withComment:@"CurrencyManager"]
	 delegate:self
	 cancelButtonTitle:[LocalizationHelper stringForKey:@"app_back" withComment:@"CurrencyManager"]
	 otherButtonTitles:nil];
	 [alert show];
	 [alert release];
	 */
}

#pragma mark - MM

- (void)dealloc {
	[_iso_currency release];
	[_defaultCurrency release];
	[super dealloc];
}

@end
