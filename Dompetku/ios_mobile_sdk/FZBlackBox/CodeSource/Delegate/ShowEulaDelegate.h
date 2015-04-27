//
//  ShowEulaDelegate.h
//  FZBlackBox
//
//  Created by julian Clémot on 06/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ShowEulaDelegate <NSObject>

@optional
- (void) didRefuseEula;

@optional
- (void) didAcceptEula;

@end
