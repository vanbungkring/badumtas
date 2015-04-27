//
//  SDKFlashizFacade.m
//  FZSDK
//
//  Created by Matthieu Barile on 02/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import "SDKFlashizFacade.h"

#import "SDKMultiTargetManager.h"

@interface SDKFlashizFacade () <FlashizFacadeDelegate>

@property (nonatomic, retain) NSString* userKey;

@end

@implementation SDKFlashizFacade
@synthesize sdkDelegate;

- (id)initSDKWithDelegate:(id<SDKFlashizFacadeDelegate>)delegate configureUrlSchemesWihtCustomerHost:(NSString *)customerHost andCustomerScheme:(NSString *)customerScheme {
    
    self = [super init];
    if (self) {
        
        NSAssert([customerHost length] > 0 && [customerScheme length] > 0, @"The customer host and/or the customer scheme have to be specified (CustomerSheme://CustomerHost)");
        
        SDKMultiTargetManager *target = [[SDKMultiTargetManager alloc] init];
        
        [self setSdkDelegate:delegate];
        
        self = [self initSDKWith:target withDelegate:self configureUrlSchemesWihtCustomerHost:customerHost andCustomerScheme:customerScheme];
        
        [target release];
    }
    return self;
}

#pragma mark - @protocol FlashizFacadeDelegate -

- (void)didFailLoginForInvoice:(NSString *)invoiceId {
    if([sdkDelegate respondsToSelector:@selector(didFailLoginForInvoice:)]) {
        [sdkDelegate didFailLoginForInvoice:invoiceId];
    }
}

- (void)didCancelLoginForInvoice:(NSString *)invoiceId {
    if([sdkDelegate respondsToSelector:@selector(didCancelLoginForInvoice:)]) {
        [sdkDelegate didCancelLoginForInvoice:invoiceId];
    }
}

- (void)paymentAcceptedForInvoice:(NSString *)invoiceId {
    
    //Call the FZFlashizFacade to close the scanner (PaymentViewController)
    //[super paymentAcceptedForInvoice:invoiceId];
    
    if([sdkDelegate respondsToSelector:@selector(paymentAcceptedForInvoice:)]) {
        [sdkDelegate paymentAcceptedForInvoice:invoiceId];
    }
}

- (void)paymentCanceledForInvoice:(NSString *)invoiceId {
    if([sdkDelegate respondsToSelector:@selector(paymentCanceledForInvoice:)]) {
        [sdkDelegate paymentCanceledForInvoice:invoiceId];
    }
}

- (void)paymentFailedForInvoice:(NSString *)invoiceId {
    if([sdkDelegate respondsToSelector:@selector(paymentFailedForInvoice:)]) {
        [sdkDelegate paymentFailedForInvoice:invoiceId];
    }
}

- (void)qrCodeisInvalid {
    if([sdkDelegate respondsToSelector:@selector(qrCodeisInvalid)]) {
        [sdkDelegate qrCodeisInvalid];
    }
}

- (BOOL)isClosingSdkAfterPaymentFailedOrSucceeded
{
    //not used
    return NO;
}

- (BOOL)isClosingSdkAfterUserCancelTransaction
{
    //not used
    return NO;
}

- (BOOL)isClosingSdkAfterInvalidQrCode
{
    //not used
    return NO;
}

- (BOOL)isDebugMode
{
    //not used
    return NO;
}

- (BOOL)isClosingSdkAfterUnknownError
{
    //not used
    return NO;
}

- (BOOL)isForcingCancelTransaction
{
    //not used
    return NO;
}

- (double)timeBeforeStartingPoll
{
    //not used
    return 0;
}

- (double)timeBetweenEachPollCall
{
    //not used
    return 0;
}

- (void)didAcceptEula {
    //not used
}

- (void)didRefuseEula {
    //not used
}

- (void)didCloseSdk {
    //not used
}

-(void)dealloc {
    if(_userKey!=nil){
        [_userKey release],_userKey = nil;
    }
    
    [super dealloc];
}

@end
