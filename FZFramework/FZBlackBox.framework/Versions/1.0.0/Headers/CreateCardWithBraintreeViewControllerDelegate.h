//
//  CreateCardWithBraintreeViewControllerDelegate.h
//  FZBlackBox
//
//  Created by Olivier Demolliens on 4/22/14.
//  Copyright (c) 2014 FLASHiZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CreditCard;

@protocol CreateCardWithBraintreeViewControllerDelegate <NSObject>

- (void)refresh;

@end
