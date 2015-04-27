//
//  IndonesianInvoiceStatus.m
//  FZAPI
//
//  Created by OlivierDemolliens on 6/19/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import "IndonesianInvoiceStatus.h"

#import "IndonesianInvoiceStatus.h"
#import "Error.h"

@implementation IndonesianInvoiceStatus

+ (void)indonesianInvoiceStatusWithDictionary:(NSDictionary *)indonesianInvoiceStatus successBlock:(ParseSuccessBlock)success failureBlock:(ParseFailureBlock)failure {
    
    
    //create the array of which keys we need to have to create the account object
    NSArray *keysArray = [NSArray arrayWithObjects:@"status", @"invoiceId", nil];
    
    //define a missing keys array to know which one was missing if its the case
    NSMutableArray *keysMatchingArray = [NSMutableArray arrayWithObjects:@"status", @"invoiceId", nil];
    
    IndonesianInvoiceStatus *indonesianInvoiceStatusObject = [[[IndonesianInvoiceStatus alloc] init] autorelease];
    
    [indonesianInvoiceStatusObject fillWithMatchingKeys:keysMatchingArray
                                                   keys:keysArray
                                               fromJSON:[indonesianInvoiceStatus objectForKey:@"content"] successBlock:^{
                                                   success(indonesianInvoiceStatusObject);
                                               } failureBlock:^(Error *error) {
                                                   failure(error);
                                               }];
}

- (void)dealloc
{
    [super dealloc];
}

@end