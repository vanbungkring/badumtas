//
//  FlashizFacadeDelegate.h
//  FZBlackBox
//
//  Created by OlivierDemolliens on 6/4/14.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FlashizFacadeDelegate <NSObject>

@required

/**
 * Reject/Accept transaction
 * @return true if close SDK or not
 */
- (BOOL)isClosingSdkAfterPaymentFailedOrSucceeded;
- (BOOL)isClosingSdkAfterUserCancelTransaction;
- (BOOL)isClosingSdkAfterInvalidQrCode;

/**
 * Debug mode (LogCat)
 *
 * @return true if you want display in console some debugs information from the SDK
 */
- (BOOL)isDebugMode;

/**
 * Unknown error: for all errors not covered above
 * @return true if you want close the SDK
 */
- (BOOL)isClosingSdkAfterUnknownError;

/**
 * User has canceled the transaction
 * @return true if you want close the SDK
 */
- (BOOL)isForcingCancelTransaction;

/**
 * Waiting time before first call in milliseconds - minimun time 1s
 */
- (double)timeBeforeStartingPoll;

/**
 * Waiting time between call in milliseconds - minimun time 1s
 */
- (double)timeBetweenEachPollCall;

/**
 * User has confirmed Eula
 */
- (void)didAcceptEula;

/**
 * User has cancelled Eula
 */
- (void)didRefuseEula;

/**
 * User has closed SDK (origin: SDK)
 */
- (void)didCloseSdk;

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
 
 @discussion This message is sent when the scanned qrCode is invalid.
 */

- (void)qrCodeisInvalid;

/**
 Delegate used to pay an invoice
 
 @param invoiceId The invoice id used for the payment.
 
 @param amount The amount of the invoice.
 
 @param discountedAmount The amount of the invoice with applied discount
 
 @param nbOfCoupons Number of Coupons
 
 @param andMerchantName Type of Discount
 
 @param merchantName The name of the merchant who receives the payment
 
 @discussion This function is called when you want to pay an invoice.
 */

- (void)payInvoice:(NSString *)invoiceId withOriginalAmount:(double)amount andDiscountedAmount:(double) discountedAmount andMerchantName:(NSString *)merchantName andNbOfCoupons:(int)nbOfCoupons andTypeOfDiscount:(NSString *)discountType andLoyaltyProgramName:(NSString *)loyaltyProgramName andDiscountAmount:(double)amountOfDiscount;

/**
 Delegate used to generate an userkey
 
 When you retrive the user api key, inform SDK with [myFlashizFacadeObject registerUserApiKey:@"userKey"];
 
 @discussion This function is called when you want to pay an invoice.
 */

- (void)generateUserkey;

/**
 Delegate used to get the controller Of Eula
 @discussion This function is called when you want to retrieve the controller of eula.
 */

- (UIViewController *)controllerEULA;

@end
