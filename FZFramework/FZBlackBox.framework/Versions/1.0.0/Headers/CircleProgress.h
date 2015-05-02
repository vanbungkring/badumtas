//
//  CircleProgress.h
//  FLASHiZ
//
//  Created by Matthieu Barile on 18/06/13.
//  Copyright (c) 2013 Mobey S.A. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@protocol CircleProgressDelegate <NSObject>

- (void)progressBarDidLoad;

@end

@interface CircleProgress : CAShapeLayer

@property (nonatomic, retain) id<CircleProgressDelegate> delegate;

- (id)initWithFillColor:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth;

- (void)drawCircleFromAngle:(int)degreStart toAngle:(int)degreEnd withDuration:(CFTimeInterval)animationDuration inLayer:(CALayer*)layer;

- (void)revertDirection:(BOOL)revert;

@end
