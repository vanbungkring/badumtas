//
//  SDKFlashizFacade.h
//  FZSDK
//
//  Created by Matthieu Barile on 02/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FZBlackBox/FZFlashizFacade.h>
#import <FZBlackBox/FlashizFacadeDelegate.h>

@protocol SDKFlashizFacadeDelegate <NSObject>

@optional

/**
 Tells the delegate that the login process failed.
 
 @param invoiceId The invoice id used for the payment process.
 
 @discussion This message is sent when the user enters incorrect credentials or server error occurred.
 
 */

- (void)didFailLoginForInvoice:(NSString *)invoiceId;

/**
 Tells the delegate that the login process has been cancelled by the user.
 
 @param invoiceId The invoice id used for the payment process.
 
 @discussion This message is sent when the Login view or the pin view fails.
 
 */

- (void)didCancelLoginForInvoice:(NSString *)invoiceId;

/**
 Tells the delegate that the payment has been validated for the specified invoice Id.
 
 @param invoiceId The invoice id used for the validated payment.
 
 @discussion This message is sent when the user dismiss Login view or the pin view.
 */

- (void)paymentAcceptedForInvoice:(NSString *)invoiceId;

/**
 Tells the delegate that the payment has been cancelled for the specified invoice Id.
 
 @param invoiceId The invoice id used for the payment.
 
 @discussion This message is sent when the payment for the given invoice is accepted.
 */

- (void)paymentCanceledForInvoice:(NSString *)invoiceId;

/**
 Tells the delegate that the payment failed for the specified invoice Id.
 
 @param invoiceId The invoice id used for the payment.
 
 @discussion This message is sent when the payment for the given invoice is canceled by the user.
 */

- (void)paymentFailedForInvoice:(NSString *)invoiceId;

/**
 Tells the delegate that the QR Code is invalid.
 
 @param invoiceId The invoice id used for the payment.
 
 @discussion This message is sent when the scanned qrCode is invalid.
 */

- (void)qrCodeisInvalid;

@end

@interface SDKFlashizFacade : FZFlashizFacade

@property (assign, nonatomic) id<SDKFlashizFacadeDelegate> sdkDelegate;

- (id)initSDKWithDelegate:(id<SDKFlashizFacadeDelegate>)delegate configureUrlSchemesWihtCustomerHost:(NSString *)customerHost  andCustomerScheme:(NSString *)customerScheme;

@end
