//
//  RewardsEngine.m
//  iMobey
//
//  Created by Matthieu Barile on 21/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "RewardsEngine.h"
#import <FZAPI/LoyaltyCoupon.h>
#import <FZAPI/LoyaltyProgram.h>

static inline long NSIntToLong(NSInteger i) {return (long)i;}

@implementation RewardsEngine

+(InvoiceCorrectedParameters *) computeDiscountForInvoice:(Invoice *)invoice AndNbOfUsedCoupons:(NSInteger)nbOfUsedCoupons LivePPD:(double)livePermanentPercentageDiscount{
    
    InvoiceCorrectedParameters * invoiceCorrectedParameters = [InvoiceCorrectedParameters initWithInvoice:invoice];
    
    //test if the user just get a loyalty card with a permanent percentage discount (get a card in the payment process)
    if(livePermanentPercentageDiscount != 0){
        if (![[invoice currentLoyaltyProgram] isPrivate]) {
            invoice.hasLoyaltyCard = YES;
            invoice.permanentPercentageDiscount = livePermanentPercentageDiscount;
           /* invoice.correctedInvoiceAmountWithPercentage = [invoice amount]*(1-[invoice permanentPercentageDiscount]/100);*/
        } else {
            //if the program is private, the user has to join the program by a private code and the "hasLoyaltyCard" will come from the server
            return invoiceCorrectedParameters;
        }
    }
        
    //NSInteger errorCode = 0;
    
    //calcul préliminaire
    double diff = [invoice balance] - [invoice amount];
    
    /*A*/
    if(diff>=0){//pas de rechargement necessaire
        //FZBlackBoxLog(@"A");
        /*A1*/ //si c'est un programme avec un % permanent
        if([invoice permanentPercentageDiscount]>0){
            //FZBlackBoxLog(@"A1");
            
            //set params
            invoiceCorrectedParameters.newWithRefill = NO;
            invoiceCorrectedParameters.correctedInvoiceAmount = [invoice correctedInvoiceAmountWithPercentage];
            invoiceCorrectedParameters.newBalanceWithRefill = 0;
            invoiceCorrectedParameters.nbOfRefill = 0;
            invoiceCorrectedParameters.amountOfRefill = 0;
            invoiceCorrectedParameters.discount = [invoice amount]*[invoice permanentPercentageDiscount]/100;
            invoiceCorrectedParameters.hasLoyaltyCard = [invoice hasLoyaltyCard];
        }
        else
        /*A2*/ //si on a des coupons disponibles
            if(([[invoice couponList] count]>0) && (nbOfUsedCoupons>0)){
                //get coupons list
                //FZBlackBoxLog(@"A2 - used %ld coupons",NSIntToLong(nbOfUsedCoupons));
                
                double reduc = [self computeDiscountBasedOnInvoice:invoice AndNbOfUsedCoupons:nbOfUsedCoupons];
                
                //set params
                invoiceCorrectedParameters.newWithRefill = NO;
                invoiceCorrectedParameters.correctedInvoiceAmount = [invoice amount] - reduc;
                invoiceCorrectedParameters.newBalanceWithRefill = 0;
                invoiceCorrectedParameters.nbOfRefill = 0;
                invoiceCorrectedParameters.amountOfRefill = 0;
                invoiceCorrectedParameters.discount = reduc;
                invoiceCorrectedParameters.hasLoyaltyCard = [invoice hasLoyaltyCard];
            }
            else
            /*A3*/ //rien
            {
                //FZBlackBoxLog(@"A3");
                //set params
                invoiceCorrectedParameters.newWithRefill = NO;
                invoiceCorrectedParameters.correctedInvoiceAmount = [invoice amount];
                invoiceCorrectedParameters.newBalanceWithRefill = 0;
                invoiceCorrectedParameters.nbOfRefill = 0;
                invoiceCorrectedParameters.amountOfRefill = 0;
                invoiceCorrectedParameters.discount = 0;
                invoiceCorrectedParameters.hasLoyaltyCard = [invoice hasLoyaltyCard];
            }
    }
    
    /*B*/
    if(diff<0){//rechargement necessaire
        //FZBlackBoxLog(@"B");
        /*B1*/ //si c'est un programme avec un % permanent
        if([invoice permanentPercentageDiscount]>0){
            //FZBlackBoxLog(@"B1");
            diff = [invoice balance] - [invoice correctedInvoiceAmountWithPercentage];
            
            if(diff>0){//plus de rechargement necessaire
                //FZBlackBoxLog(@"B1.1");
                //set params
                invoiceCorrectedParameters.newWithRefill = NO;
                invoiceCorrectedParameters.correctedInvoiceAmount = [invoice correctedInvoiceAmountWithPercentage];
                invoiceCorrectedParameters.newBalanceWithRefill = 0;
                invoiceCorrectedParameters.nbOfRefill = 0;
                invoiceCorrectedParameters.amountOfRefill = 0;
                invoiceCorrectedParameters.discount = [invoice amount]*[invoice permanentPercentageDiscount]/100;
                invoiceCorrectedParameters.hasLoyaltyCard = [invoice hasLoyaltyCard];
            } else {//rechargement toujours necessaire
                //FZBlackBoxLog(@"B1.2");
                //set params
                invoiceCorrectedParameters.newWithRefill = YES;
                invoiceCorrectedParameters.correctedInvoiceAmount = [invoice correctedInvoiceAmountWithPercentage];
                invoiceCorrectedParameters.nbOfRefill = [self optimalNbOfRefill:diff takenAmount:[invoice takenAmount]];
                invoiceCorrectedParameters.amountOfRefill = invoiceCorrectedParameters.nbOfRefill*[invoice takenAmount];
                invoiceCorrectedParameters.newBalanceWithRefill = diff+invoiceCorrectedParameters.amountOfRefill;
                invoiceCorrectedParameters.discount = [invoice amount]*[invoice permanentPercentageDiscount]/100;
                invoiceCorrectedParameters.hasLoyaltyCard = [invoice hasLoyaltyCard];
            }
        }
        else
        /*B2*/ //si on a des coupons disponibles
            if([[invoice couponList] count]>0 && (nbOfUsedCoupons>0)){
                //get coupons list
                //FZBlackBoxLog(@"B2 - used %ld coupons",NSIntToLong(nbOfUsedCoupons));
                
                double reduc = [self computeDiscountBasedOnInvoice:invoice AndNbOfUsedCoupons:nbOfUsedCoupons];
                
                diff = [invoice balance] - ([invoice amount] - reduc);
                
                if(diff>0){//plus de rechargement necessaire
                    //FZBlackBoxLog(@"B2.1");
                    //set params
                    invoiceCorrectedParameters.newWithRefill = NO;
                    invoiceCorrectedParameters.correctedInvoiceAmount = [invoice amount] - reduc;
                    invoiceCorrectedParameters.newBalanceWithRefill = 0;
                    invoiceCorrectedParameters.nbOfRefill = 0;
                    invoiceCorrectedParameters.amountOfRefill = 0;
                    invoiceCorrectedParameters.discount = reduc;
                    invoiceCorrectedParameters.hasLoyaltyCard = [invoice hasLoyaltyCard];
                } else {//rechargement toujours necessaire
                    //FZBlackBoxLog(@"B2.2");
                    //set params
                    invoiceCorrectedParameters.newWithRefill = YES;
                    invoiceCorrectedParameters.correctedInvoiceAmount = [invoice amount] - reduc;
                    invoiceCorrectedParameters.nbOfRefill = [self optimalNbOfRefill:diff takenAmount:[invoice takenAmount]];
                    invoiceCorrectedParameters.amountOfRefill = invoiceCorrectedParameters.nbOfRefill*[invoice takenAmount];
                    invoiceCorrectedParameters.newBalanceWithRefill = diff+invoiceCorrectedParameters.amountOfRefill;
                    invoiceCorrectedParameters.discount = reduc;
                    invoiceCorrectedParameters.hasLoyaltyCard = [invoice hasLoyaltyCard];
                }
            }
            else
            /*B3*/ //rien
            {
                //FZBlackBoxLog(@"B3");
                diff = [invoice balance] - [invoice amount];
                
                //set params
                invoiceCorrectedParameters.newWithRefill = YES;
                invoiceCorrectedParameters.correctedInvoiceAmount = [invoice amount];
                invoiceCorrectedParameters.nbOfRefill =  [invoice numberOfRefill];
                invoiceCorrectedParameters.amountOfRefill = invoiceCorrectedParameters.nbOfRefill*[invoice takenAmount];
                invoiceCorrectedParameters.newBalanceWithRefill = diff+invoiceCorrectedParameters.amountOfRefill;
                invoiceCorrectedParameters.discount = 0;
                invoiceCorrectedParameters.hasLoyaltyCard = [invoice hasLoyaltyCard];
            }
    }
    
    //check if the invoice amount is > 0
    if(invoiceCorrectedParameters.correctedInvoiceAmount<0){
        invoiceCorrectedParameters.correctedInvoiceAmount = 0;
    }
    
    return invoiceCorrectedParameters;
}

+ (NSInteger)optimalNbOfCoupons:(Invoice*)invoice{
    //FZBlackBoxLog(@"**** FIDELITiZ ENGINE OPTIMAL NB OF COUPONS ****");
        
    if([invoice couponList].count>0){
        if([[[invoice couponList] objectAtIndex:0] couponType] == COUPON_TYPE_PERCENT) {
            //si les coupons sont de type %, on a le droit d'en utiliser qu'un seul
            return 1;
        } else {
            //valeur d'un coupon
            double val = [[[invoice couponList] objectAtIndex:0] amount];
            
            NSInteger nbMaxOfCoupons = [invoice amount]/val;
            //FZBlackBoxLog(@"nbMaxOfCoupons : %ld",NSIntToLong(nbMaxOfCoupons));
            
            if([invoice couponList].count>nbMaxOfCoupons){//si on a plus de coupons que le nombre optimal
                return nbMaxOfCoupons;
            } else {//si on a moins de coupons que le nombre optimal
                return [invoice couponList].count;
            }
        }
    } else {//pas de coupons
        return 0;
    }
}

+ (NSInteger)optimalNbOfRefill:(double)diff takenAmount:(int)_takenAmount{
    //FZBlackBoxLog(@"**** FIDELITiZ ENGINE OPTIMAL NB OF REFILLS ****");
    
    if(_takenAmount == 0) {
        return 0;
    } else {
        double nbOfRefillDouble = (double)(-diff/_takenAmount);//nb of refill as float
        NSInteger nbOfRefillInt = (NSInteger)(-diff/_takenAmount);//nb of refill cast in int
        
        //FZBlackBoxLog(@"nbOfRefillDouble %f, nbOfRefillInt %ld", nbOfRefillDouble, NSIntToLong(nbOfRefillInt));
        
        if([[NSString stringWithFormat:@"%.4f",nbOfRefillDouble] isEqualToString:[NSString stringWithFormat:@"%.4f",(double)nbOfRefillInt]]){//if the float is the same as the int return the value
            return (NSInteger)-diff/_takenAmount;
        } else {//else return the value+1
            return ((NSInteger)-diff/_takenAmount)+1;
        }
    }
}

+(double)computeDiscountBasedOnInvoice:(Invoice *)invoice AndNbOfUsedCoupons:(NSInteger)nbOfUsedCoupons{
    //find what type of coupon is used referring to the first coupon of the list
    CouponType type = [[[invoice couponList] objectAtIndex:0] couponType];
    
    
    double reduc = 0.0;
    
    for (NSInteger i = 0; i<nbOfUsedCoupons;i++){
        
        LoyaltyCoupon *coupon = [[invoice couponList] objectAtIndex:i];
        //FZBlackBoxLog(@"coupon value = %f",[coupon amount]);
        
        if(([coupon couponType] == COUPON_TYPE_CASH) && ([coupon couponType] == type)){//if CASH
            reduc = reduc + [coupon amount];
        } else if (([coupon couponType] == COUPON_TYPE_PERCENT) && ([coupon couponType] == type)){//if PERCENT
            reduc = [invoice amount]*([coupon amount]/100);
        } else {//utilisation de coupons de types différents
            //errorCode = 1;
        }
        
        //FZBlackBoxLog(@"reduc %f",reduc);
    }
    
    return reduc;
}

+ (NSInteger)computeNbOfPointsEarnWithCorrectedInvoiceAmount:(double) amount andProgram:(LoyaltyProgram *) loyaltyProgram {
    
    //FZBlackBoxLog(@"amount %f",amount);
    
    if([loyaltyProgram permanentPercentageDiscount]>0){
        return 0;
    } else {
        //FZBlackBoxLog(@"%@",[loyaltyProgram rewardType]);
        //FZBlackBoxLog(@"%@",[loyaltyProgram expenseType]);
        //FZBlackBoxLog(@"%d",[loyaltyProgram pointPerExpense]);
        //FZBlackBoxLog(@"%f",[loyaltyProgram discountAmount]);
        return 0;
    }
}

@end
