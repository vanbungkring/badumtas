//
//  ODCustomAlertView.m
//  OsTaLgO
//
//  Created by Olivier Demolliens on 23/09/11.
//  Copyright 2011 OsTaLgO. All rights reserved.
//

#import "ODCustomAlertView.h"

@interface ODCustomAlertView (Private)

- (void) drawRoundedRect:(CGRect) rect inContext:(CGContextRef)
context withRadius:(CGFloat) radius;

@end

static UIColor *fillColor = nil;
static UIColor *borderColor = nil;

@implementation ODCustomAlertView

- (void) setBackgroundColor:(UIColor *) background
            withStrokeColor:(UIColor *) stroke
{
    if(fillColor != nil)
    {
        [fillColor release];
        [borderColor release];
    }
    
    fillColor = [background retain];
    borderColor = [stroke retain];
}

- (id)initWithFrame:(CGRect)frame
{
    if((self = [super initWithFrame:frame]))
    {
        if(fillColor == nil)
        {
            fillColor = [[UIColor blackColor] retain];
            borderColor = [[UIColor colorWithHue:0.625
                                      saturation:0.0 brightness:0.8 alpha:0.8]
                           retain];
        }
    }
    
    return self;
}

- (void)layoutSubviews
{
    for (UIView *sub in [self subviews])
    {
        if([sub class] == [UIImageView class] && sub.tag == 0)
        {
            // The alert background UIImageView tag is 0,
            // if you are adding your own UIImageView's
            // make sure your tags != 0 or this fix
            // will remove your UIImageView's as well!
            [sub removeFromSuperview];
            break;
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextClearRect(context, rect);
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetLineWidth(context, 0.0);
    CGContextSetAlpha(context, 0.8);
    CGContextSetLineWidth(context, 2.0);
    CGContextSetStrokeColorWithColor(context, [borderColor CGColor]);
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    
    // Draw background
    CGFloat backOffset = 2;
    CGRect backRect = CGRectMake(rect.origin.x + backOffset,
                                 rect.origin.y + backOffset,
                                 rect.size.width - backOffset*2,
                                 rect.size.height - backOffset*2);
    
    [self drawRoundedRect:backRect inContext:context withRadius:8];
    CGContextDrawPath(context, kCGPathFillStroke);
    
    // Clip Context
    CGRect clipRect = CGRectMake(backRect.origin.x + backOffset-1,
                                 backRect.origin.y + backOffset-1,
                                 backRect.size.width - (backOffset-1)*2,
                                 backRect.size.height - (backOffset-1)*2);
    
    [self drawRoundedRect:clipRect inContext:context withRadius:8];
    CGContextClip (context);
    
    //Draw highlight
    CGGradientRef glossGradient;
    CGColorSpaceRef rgbColorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 1.0, 1.0, 0.35, 1.0, 1.0, 1.0, 0.06 };
    rgbColorspace = CGColorSpaceCreateDeviceRGB();
    glossGradient = CGGradientCreateWithColorComponents(rgbColorspace,
                                                        components, locations, num_locations);
    
    CGRect ovalRect = CGRectMake(-130, -115, (rect.size.width*2),
                                 rect.size.width/2);
    
    CGPoint start = CGPointMake(rect.origin.x, rect.origin.y);
    CGPoint end = CGPointMake(rect.origin.x, rect.size.height/5);
    
    CGContextSetAlpha(context, 1.0);
    CGContextAddEllipseInRect(context, ovalRect);
    CGContextClip (context);
    
    CGContextDrawLinearGradient(context, glossGradient, start, end, 0);
    
    CGGradientRelease(glossGradient);
    CGColorSpaceRelease(rgbColorspace);
}

- (void) drawRoundedRect:(CGRect) rrect inContext:(CGContextRef) context
              withRadius:(CGFloat) radius
{
    CGContextBeginPath (context);
    
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    
    CGFloat miny = CGRectGetMinY(rrect), midy = CGRectGetMidY(rrect),
    maxy = CGRectGetMaxY(rrect);
    
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
}

- (void)show {
    //When the application goes in background the alert view will be automatically dismissed
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    [super show];
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    
    [super dismissWithClickedButtonIndex:[self cancelButtonIndex] animated:NO];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [super dealloc];
}

@end