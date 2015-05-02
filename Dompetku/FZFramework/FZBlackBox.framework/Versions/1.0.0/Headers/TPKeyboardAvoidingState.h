//
//  TPKeyboardAvoidingState.h
//  FZBlackBox
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

static const CGFloat kCalculatedContentPadding = 10;
static const CGFloat kMinimumScrollOffsetPadding = 20;

static const int kStateKey;

#define _UIKeyboardFrameEndUserInfoKey (&UIKeyboardFrameEndUserInfoKey != NULL ? UIKeyboardFrameEndUserInfoKey : @"UIKeyboardBoundsUserInfoKey")

@interface TPKeyboardAvoidingState : NSObject
@property (nonatomic, assign) UIEdgeInsets priorInset;
@property (nonatomic, assign) UIEdgeInsets priorScrollIndicatorInsets;
@property (nonatomic, assign) BOOL         keyboardVisible;
@property (nonatomic, assign) CGRect       keyboardRect;
@property (nonatomic, assign) CGSize       priorContentSize;
@end