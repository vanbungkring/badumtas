/*
 
 File: CoreTextArcView.m (iOS version)
 
 Abstract: Defines and implements the CoreTextArcView custom UIView subclass to
 draw text on a curve and illustrate best practices with CoreText.
 
 Based on CoreTextArcView provided by Apple for Mac OS X https://developer.apple.com/library/mac/#samplecode/CoreTextArcCocoa/Introduction/Intro.html
 
 Ported to iOS (& added color, arcsize features) August 2011 by Alec Vance, Juggleware LLC http://juggleware.com/
 
 */

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>


@interface CoreTextArcView : UIView {
@private
    UIFont *            _font;
    NSString *          _string;
    CGFloat             _radius;
    UIColor *           _color;
    CGFloat             _arcSize;
    CGFloat             _shiftH, _shiftV; // horiz & vertical shift
    
    struct {
        unsigned int    showsGlyphBounds:1;
        unsigned int    showsLineMetrics:1;
        unsigned int    dimsSubstitutedGlyphs:1;
        unsigned int    reserved:29;
    }                   _flags;
}

@property(retain, nonatomic) UIFont *font;
@property(retain, nonatomic) NSString *text;
@property(readonly, nonatomic) NSAttributedString *attributedString;
@property(assign, nonatomic) CGFloat radius;
@property(nonatomic) BOOL showsGlyphBounds;
@property(nonatomic) BOOL showsLineMetrics;
@property(nonatomic) BOOL dimsSubstitutedGlyphs;
@property(retain, nonatomic) UIColor *color;
@property(nonatomic) CGFloat arcSize;
@property(nonatomic) CGFloat shiftH, shiftV;

+ (void)forceLinkerLoad_;

@end