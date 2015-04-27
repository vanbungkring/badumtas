//
//  FZButton.m
//  flashiz_ios_core_ui
//
//  Created by Matthieu Barile on 13/02/2014.
//  Copyright (c) 2014 Flashiz. All rights reserved.
//

#import "FZButton.h"

@interface FZButton ()

@property (retain, nonatomic) UIColor *backgroundColorForStateHighlighted;
@property (retain, nonatomic) UIColor *backgroundColorForStateNormal;

@property (retain, nonatomic) UIColor *borderColorForStateHighlighted;
@property (retain, nonatomic) UIColor *borderColorForStateNormal;

@end

@implementation FZButton

+ (void)forceLinkerLoad_ {
    
}

#pragma mark Settings

- (void)setBackgroundNormalColor:(UIColor *)backgroundColor {
    [self setBackgroundColor:backgroundColor];
    [self setBackgroundColorForStateNormal:backgroundColor];
}

- (void)setBackgroundHighlightedColor:(UIColor *)highlightedColor {
    [self setBackgroundColorForStateHighlighted:highlightedColor];
}

- (void)setBorderNormalColor:(UIColor *)borderColor{
    [[self layer] setBorderColor:borderColor.CGColor];
    [self setBorderColorForStateNormal:borderColor];
}

- (void)setBorderHighlightedColor:(UIColor *)borderHighlightedColor {
    [self setBorderColorForStateHighlighted:borderHighlightedColor];
}

#pragma mark Actions

- (void)didTapButtonForHighlight:(UIButton *)sender {
    [self setBackgroundColor:[self backgroundColorForStateHighlighted]];
    if(_borderColorForStateHighlighted) {
        [[self layer] setBorderColor:[self borderColorForStateHighlighted].CGColor];
    }
}

- (void)didUnTapButtonForHighlight:(UIButton *)sender {
    [self setBackgroundColor:[self backgroundColorForStateNormal]];
    if(_borderColorForStateNormal) {
        [[self layer] setBorderColor:[self borderColorForStateNormal].CGColor];
    }
}

#pragma mark Initialization

- (void)setupButton {
    [self addTarget:self action:@selector(didTapButtonForHighlight:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(didUnTapButtonForHighlight:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(didUnTapButtonForHighlight:) forControlEvents:UIControlEventTouchUpOutside];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupButton];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)dealloc {
    [_backgroundColorForStateNormal release]; _backgroundColorForStateNormal = nil;
    [_backgroundColorForStateHighlighted release]; _backgroundColorForStateHighlighted = nil;
    [_borderColorForStateNormal release]; _borderColorForStateNormal = nil;
    [_borderColorForStateHighlighted release]; _borderColorForStateHighlighted = nil;
    [super dealloc];
}

@end
