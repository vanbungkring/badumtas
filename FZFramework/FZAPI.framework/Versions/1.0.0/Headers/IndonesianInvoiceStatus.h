//
//  IndonesianInvoiceStatus.h
//  FZAPI
//
//  Created by OlivierDemolliens on 6/19/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FlashizObject.h"

@class Error;

//Must be refactor
__attribute__((deprecated))
@interface IndonesianInvoiceStatus : FlashizObject

@property (copy, nonatomic) NSString *status;
@property (copy, nonatomic) NSString *invoiceId;

+ (void)indonesianInvoiceStatusWithDictionary:(NSDictionary *)indonesianInvoiceStatus successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure;

@end