//
//  SDKMultiTargetManager.h
//  FZApp
//
//  Created by Olivier Demolliens on 4/22/14.
//  Copyright (c) 2014 flashiz. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <FZBlackBox/FZDefaultMultiTargetManager.h>
#import <FZBlackBox/CoreMultiTargetManager.h>

@interface SDKMultiTargetManager : FZDefaultMultiTargetManager <CoreMultiTargetManager>

@end
