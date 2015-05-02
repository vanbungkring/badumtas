//
//  ActionSuccessfullDelegate.h
//  FZPayment
//
//  Created by julian Clémot on 05/05/2014.
//  Copyright (c) 2014 FLASHiZ All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActionSuccessfullDelegate <NSObject>

@required
- (void)didValidate:(id)controller;

@optional
- (void)didGoToMap:(id)controller;


@end
