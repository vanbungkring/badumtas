//
//  Invoice.m
//  FLASHiZ-ios-api
//
//  Created by Jenkins on 07/08/13.
//  Copyright (c) 2013 net. All rights reserved.
//

#import "Invoice.h"
#import "Error.h"
#import "LoyaltyProgram.h"
#import "LoyaltyCoupon.h"

#import "FlashizDictionary.h"

@implementation Invoice

+ (void)invoiceWithDictionary:(NSDictionary *)invoice successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    NSArray *keysArray;
    NSArray *keysMatching;
    NSMutableArray *missingKeysArray = nil;
    
    // TODO : must be fixed a day (fix fillWithMatchingKeys method)
    if([invoice valueForKey:@"hasLoyaltyCard"]!=nil || [[invoice objectForKey:@"content"] objectForKey:@"hasLoyaltyCard"]!=nil){
        
        //create the array of which keys we need to have to create the invoice object
        if([invoice objectForKey:@"content"] && [[invoice objectForKey:@"content"] count] > 0){//Indonesia
            
            invoice = [NSDictionary dictionaryWithDictionary:[invoice objectForKey:@"content"]];
            keysArray = [NSArray arrayWithObjects:@"amount", @"receiver", @"comment", @"currency", @"invoiceId", @"status", @"correctedInvoiceAmountWithPercentage", @"couponList", @"currentLoyaltyProgram", @"fidelitizId", @"hasLoyaltyCard", @"permanentPercentageDiscount", nil];
            keysMatching = [NSArray arrayWithObjects:@"",@"otherName",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",nil];
            
        } else {//Europe
            
            keysArray = [NSArray arrayWithObjects:@"amount", @"receiver", @"mail", @"isCredit", @"withRefill", @"newBalanceWithRefill", @"newBalanceWithoutRefill", @"numberOfRefill", @"takenAmount", @"invoiceId", @"comment",@"balance", @"hasLoyaltyCard", @"permanentPercentageDiscount", @"correctedInvoiceAmountWithPercentage", nil];
            
            keysMatching = [NSArray arrayWithObjects:@"", @"otherName", @"otherMail", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", @"", nil];
        }
    }else{
        //create the array of which keys we need to have to create the invoice object
        keysArray = [NSArray arrayWithObjects:@"amount", @"comment", @"currency", @"invoiceId", @"receiver", @"status", nil];
        
        keysMatching = [NSArray arrayWithObjects:@"",@"",@"",@"",@"otherName",@"",nil];
        
        invoice = [NSDictionary dictionaryWithDictionary:[invoice objectForKey:@"content"]];
    }
    
    //Create the object dictionnary from the JSON object return by the server
    FlashizDictionary *invoiceDictionary = [FlashizDictionary dictionaryWithDictionary:invoice];
    
    //test if dictionary contains all our needed keys
    if([invoiceDictionary containsKeys:keysArray missingKeys:missingKeysArray]){
        //create and return the invoice object if it is the case
        Invoice *invoiceObject = [[Invoice alloc] init];
        
        [invoiceObject fillWithMatchingKeys:keysMatching keys:keysArray fromJSON:invoice successBlock:^{
            // We don't know what is type here
            // invoiceObject.type = [invoice objectForKey:[keysArray objectAtIndex:11]];
            
            NSString *cur = [invoice objectForKey:@"currency"];
            if (cur != nil){
                invoiceObject.currency = cur;
            }
            
            //Tip
            BOOL tipEnabled = [[invoice objectForKey:@"tipEnabled"] boolValue];
            
            [invoiceObject setTipEnabled: tipEnabled];
            
            if (tipEnabled) {
                NSDictionary *tip = [invoice objectForKey:@"tip"];
                
                [Tip tipWithDictionary:tip successBlock:^(id object) {
                    
                    [invoiceObject setTip:[[Tip alloc] init]];
                    
                    double tipsInitialValue = [[tip objectForKey:@"suggestedAmount"]doubleValue];
                    
                    if (tipsInitialValue != 0){
                        [[invoiceObject tip] setSuggestedAmount:tipsInitialValue];
                    } else {
                        [[invoiceObject tip] setSuggestedAmount:0.0];//default value
                    }
                    
                    double tipsLowValue = [[tip objectForKey:@"firstProposition"]doubleValue];
                    
                    if (tipsLowValue != 0){
                        [[invoiceObject tip] setFirstProposition:tipsLowValue];
                    } else {
                        [[invoiceObject tip] setFirstProposition:5000.0];//default value
                    }
                    
                    double tipsHighValue = [[tip objectForKey:@"secondProposition"]doubleValue];
                    
                    if (tipsHighValue != 0){
                        [[invoiceObject tip] setSecondProposition:tipsHighValue];
                    } else {
                        [[invoiceObject tip] setSecondProposition:10000.0];//default value
                    }
                } failureBlock:^(Error *error) {
                    failure(error);
                }];
            }
            
            // fill additional details
            
            id object = [invoice objectForKey:@"couponList"];
            if ([object isKindOfClass:[NSNull class]]) {
                [self fillInvoiceObject:invoiceObject withLoyaltyCouponList:nil];
            } else {
                [self fillInvoiceObject:invoiceObject withLoyaltyCouponList:object];
            }
            
            if ([invoice objectForKey:@"currentLoyaltyProgram"] && [[invoice objectForKey:@"currentLoyaltyProgram"] count] == 0) {
                [invoiceObject setCurrentLoyaltyProgram:nil];
            } else {
                [self fillInvoiceObject:invoiceObject withLoyaltyProgram:[invoice objectForKey:@"currentLoyaltyProgram"]];
            }
            
            success([invoiceObject autorelease]);
        } failureBlock:^(Error *error) {
            failure(error);
        }];
    } else {
        Error *error = [[[Error alloc] initWithRequest:nil response:invoice.description timestamp:[NSDate date] messageCode:FZ_INVALID_JSON_ERROR_MESSAGE detail:[NSString stringWithFormat:@"%@ : %@", FZ_JSON_MISSING_KEYS_ERROR_MESSAGE, missingKeysArray.description] code:-1 andRequestErrorCode:-1] autorelease];
        
        failure(error);
    }
}

+ (void)fillInvoiceObject:(Invoice *)invoiceObject withLoyaltyCouponList:(NSArray *)loyaltyCouponList{
    
    NSMutableArray *coupons = [NSMutableArray arrayWithCapacity:[loyaltyCouponList count]];
    for (NSDictionary *couponDictionary in loyaltyCouponList) {
        //LoyaltyCoupon *couponObject = [LoyaltyCoupon loyaltyCouponWithDictionary:couponDictionary error:nil];
        [LoyaltyCoupon loyaltyCouponWithDictionary:couponDictionary successBlock:^(id object) {
            LoyaltyCoupon *loyaltyCoupon = (LoyaltyCoupon *)object;
            if (loyaltyCoupon != nil) {
                [coupons addObject:loyaltyCoupon];
            }
        } failureBlock:^(Error *error) {
            NSLog(@"do not add in the array the malformed LoyaltyCoupon");
            //do not add in the array the malformed LoyaltyCoupon
        }];
    }
    [invoiceObject setCouponList:[NSArray arrayWithArray:coupons]];
}

+ (void)fillInvoiceObject:(Invoice *)invoiceObject withLoyaltyProgram:(NSDictionary *)loyaltyProgram{
    NSDictionary *lpDictionary = [loyaltyProgram objectForKey:@"loyaltyProgram"];
    if (lpDictionary == nil){
        return;
    }
    
    //invoiceObject.currentLoyaltyProgram=[LoyaltyProgram loyaltyProgramWithDictionary:lpDictionary error:nil];
    [LoyaltyProgram loyaltyProgramWithDictionary:lpDictionary successBlock:^(id object) {
        invoiceObject.currentLoyaltyProgram = (LoyaltyProgram *)object;
    } failureBlock:^(Error *error) {
        invoiceObject.currentLoyaltyProgram = nil;
    }];
}

-(id)mutableCopyWithZone:(NSZone *)zone{
    Invoice *copy = [[[self class] allocWithZone:zone] init];
    [copy setInvoiceId:[self invoiceId]];
    [copy setAmount:[self amount]];
    [copy setCurrency:[self currency]];
    [copy setOtherName:[self otherName]];
    [copy setOtherMail:[self otherMail]];
    [copy setIsCredit:[self isCredit]];
    [copy setWithRefill:[self withRefill]];
    [copy setNewBalanceWithoutRefill:[self newBalanceWithoutRefill]];
    [copy setNewBalanceWithRefill:[self newBalanceWithRefill]];
    [copy setNumberOfRefill:[self numberOfRefill]];
    [copy setTakenAmount:[self takenAmount]];
    [copy setComment:[self comment]];
    [copy setType:[self type]];
    
    // Fidelitiz
    [copy setBalance:[self balance]];
    [copy setHasLoyaltyCard:[self hasLoyaltyCard]];
    [copy setPermanentPercentageDiscount:[self permanentPercentageDiscount]];
    [copy setCorrectedInvoiceAmountWithPercentage:[self correctedInvoiceAmountWithPercentage]];
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithArray:[self couponList] copyItems:YES];
    [copy setCouponList:newArray];
    [newArray release];
    [copy setCurrentLoyaltyProgram:[[[self currentLoyaltyProgram] mutableCopy] autorelease]];
    return copy;
}

- (void)dealloc
{
    [self setInvoiceId:nil];
    [self setCurrency:nil];
    [self setOtherName:nil];
    [self setOtherMail:nil];
    [self setComment:nil];
    [self setType:nil];
    
    [self setCouponList:nil];
    [self setCurrentLoyaltyProgram:nil];
    
    [super dealloc];
}

/*
 
 SERVER BUG RESPONSE
 
 {
 content =     {
 amount = 600;
 comment = "No comment";
 correctedInvoiceAmountWithPercentage = 480;
 couponList = "<null>"; <--- bug here
 currency = IDR;
 currentLoyaltyProgram =         {
 };
 fidelitizId = 1259;
 hasLoyaltyCard = 1;
 invoiceId = 0KGCIJ2iaSFr;
 permanentPercentageDiscount = 20;
 receiver = "Brand Discount";
 status = "AVAILABLE_FOR_PAYMENT";
 };
 result = success;
 }
 
 */

@end