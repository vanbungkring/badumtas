//
//  InvoiceFactory.m
//  iMobey
//
//  Created by Yvan Moté on 16/10/13.
//  Copyright (c) 2013 Neopixl. All rights reserved.
//

#import "InvoiceHelper.h"

#import <FZAPI/InvoiceServices.h>

NSString * const kFlashizInvoiceUrlBase = @"http://www.flashiz.com/";
NSString * const kFlashizInvoiceUrlInfo = @"/infos/";

NSString * const kLeclercInvoiceUrlBase = @"http://www.paiementflashleclerc.com/";
NSString * const kLeclercInvoiceUrlInfo = @"/infos/";

@implementation InvoiceHelper

+ (BOOL)isInvoiceUrlValid:(NSString *)invoiceUrl validUrls:(NSArray *)validUrls{
    
    for (NSInteger i = 0; i < [validUrls count]; i++) {
        if([invoiceUrl rangeOfString:[validUrls objectAtIndex:i]].location != NSNotFound) {
            return YES;
        }
    }
    
    return NO;
}

@end