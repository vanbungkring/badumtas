//
//  InvoiceServices.h
//  iMobey
//
//  Created by Yvan Moté on 09/08/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "FlashizServices.h"

@interface InvoiceServices : FlashizServices

/**
 @brief Retrieve the user 50 last transactions //TODO check debitor/creditor
 @param userKey the user userkey
 @return An array containing transactions (Transaction objects) of the user
 @see Transaction
 */
+ (void)getTransactionsHistory:(NSString *)userKey
                  successBlock:(NetworkSuccessBlock)successBlock
                  failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve the user 50 last transactions between the two given dates
 @param userKey the userKey
 @param from begining date
 @param to ending date
 @return An array containing transactions (Transaction objects) of the user between the two given dates
 @see Transaction
 */
+ (void)getTransactionsHistory:(NSString *)userKey
                          from:(NSString *)from
                            to:(NSString *)to
                  successBlock:(NetworkSuccessBlock)successBlock
                  failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Retrieve the information relative to the given invoice
 @param invoiceId the ID of the invoice to get information from
 @param userKey userkey
 @return An Invoice object containing the invoice related information
 @see Invoice
 */
+ (void)readInvoice:(NSString *)invoiceId
            userKey:(NSString *)userKey
       successBlock:(NetworkSuccessBlock)successBlock
       failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Pay the given invoice
 @param invoiceId ID of the invoice to pay
 @param userKey the userKey of the user that pay the invoice
 @return A PaymentSummary object which contain some information related to the payment did for the given invoice
 @see PaymentSummary
 */
+ (void)payInvoice:(NSString *)invoiceId
           userKey:(NSString *)userKey
    hasLoyaltyCard:(BOOL)hasLoyaltyCard
correctedInvoiceAmount:(double)correctedInvoiceAmount
         nbCoupons:(NSInteger)nbCoupons
      successBlock:(NetworkSuccessBlock)successBlock
      failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Create an invoice with the given amount
 @param userKey userkey of the user which create the invoice
 @param amount the amount of the invoice
 @return The unique ID of the created invoice
 */
+ (void)createInvoice:(NSString *)userKey
               amount:(NSString *)amount
         successBlock:(NetworkSuccessBlock)successBlock
         failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Cancel the given invoice
 @param invoiceId Id of the invoice to cancel
 @param UserKey userkey of the user that own and cancel the invoice
 @return YES if the invoice was correctly canceled
 */
+ (void)cancelInvoice:(NSString *)invoiceId
              userKey:(NSString *)userKey
         successBlock:(NetworkSuccessBlock)successBlock
         failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Create a cash credit with the given amount
 @param userKey userkey of the user that creates the cash credit
 @param amount the amount of the cash credit to create
 @return The unique ID of the created cash credit (credit works in the same way as invoice)
 */
+ (void)createCredit:(NSString *)userKey
              amount:(NSString *)amount
        successBlock:(NetworkSuccessBlock)successBlock
        failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Check if the given invoice has been paid or not
 @param invoiceId the ID of the invoice we want to check
 @param userKey userKey of the user that want to check the invoice
 @return A CheckPaymentResult object which indicate the status of an invoice (paid or still not). If the invoice is paid the returned object will contain further information
 @see CheckPaymentResult
 */
+ (void)checkPayment:(NSString *)invoiceId
          forUserKey:(NSString *)userKey
        successBlock:(NetworkSuccessBlock)successBlock
        failureBlock:(NetworkFailureBlock)failureBlock;

/**
 @brief Get the valid url to read and generate QR code
 @return A list of valid url
 @see urlListResult
 */
+ (void)urlListSuccessBlock:(NetworkSuccessBlock)successBlock
               failureBlock:(NetworkFailureBlock)failureBlock;

@end
