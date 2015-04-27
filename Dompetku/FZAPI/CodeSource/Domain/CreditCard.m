//
//  CreditCard.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 05/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "CreditCard.h"
#import "Error.h"
#import "ODDateUtil.h"

@implementation CreditCard

+ (void)creditCardWithDictionary:(NSDictionary *)card successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"id", @"owner", @"automaticRefill", @"comment", @"PAN", nil];
    
    NSArray *keysMatching = [NSArray arrayWithObjects:@"creditCardId", @"", @"", @"",@"pan", nil];
    
    //create and return the account object if it is the case
    CreditCard *cardObject = [[CreditCard alloc] init];
    
    /*
    [cardObject fillWithMatchingKeys:keysMatching
                                keys:keysArray
                            fromJSON:card];
     */
    
    [cardObject fillWithMatchingKeys:keysMatching
                                keys:keysArray
                            fromJSON:card
                        successBlock:^{
                            NSString *expirationDateKey = @"expirationDate";
                            
                            //expirationDate
                            if([card objectForKey:expirationDateKey] != (id)[NSNull null]){
                                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                                [dateFormatter setDateFormat:@"MMyy"];
                                cardObject.expirationDate = [dateFormatter dateFromString:[card objectForKey:expirationDateKey]];
                                
                                [dateFormatter release];
                            }
                            
                            success([cardObject autorelease]);
                        } failureBlock:^(Error *error) {
                            failure(error);
                        }];    
}

- (BOOL)isExpired
{   
    if (![self expirationDate] || [[NSDate date]timeIntervalSinceNow]>[[ODDateUtil addAtThisDate:[self expirationDate] day:[self getTheNumberOfDayInTheMonthOfTheDate:[self expirationDate]]]timeIntervalSinceNow]) {
        return YES;
    }
    else{
        return NO;
    }
}

- (NSString *)month {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dateComponents = [gregorian components:NSMonthCalendarUnit fromDate:_expirationDate];
    
    NSInteger monthValue = [dateComponents month];
    
    NSString *month = nil;
    
    if(monthValue<10) {
        month = [NSString stringWithFormat:@"0%ld",[dateComponents month]];
    }
    else {
        month = [NSString stringWithFormat:@"%ld",[dateComponents month]];
    }
    
    [gregorian release];

    return month;
}

- (NSString *)year {
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *dateComponents = [gregorian components:NSYearCalendarUnit fromDate:_expirationDate];
    NSString *year = [NSString stringWithFormat:@"%ld",[dateComponents year]];
    
    [gregorian release];
    
    return year;
}

- (NSInteger)getTheNumberOfDayInTheMonthOfTheDate:(NSDate*)date {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSRange days = [calendar rangeOfUnit:NSDayCalendarUnit
                                  inUnit:NSMonthCalendarUnit
                                 forDate:date];
    return days.length;
}


#pragma mark - MM

- (void)dealloc
{
    [self setPan:nil];
    [self setCreditCardId:nil];
    [self setOwner:nil];
    [self setExpirationDate:nil];
    [self setComment:nil];

    [super dealloc];
}

@end
