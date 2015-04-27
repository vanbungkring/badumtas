//
//  InvoiceFactory.h
//  iMobey
//
//  Created by Yvan Moté on 16/10/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kFlashizInvoiceUrlBase;
extern NSString * const kFlashizInvoiceUrlInfo;

@interface InvoiceHelper : NSObject

+ (BOOL)isInvoiceUrlValid:(NSString *)invoiceUrl validUrls:(NSArray *)validUrls;

@end
