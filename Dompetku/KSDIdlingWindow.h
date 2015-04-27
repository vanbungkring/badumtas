//
//  KSDIdlingWindow.h
//  Dompetku
//
//  Created by Arie Prasetyo on 3/4/15.
//
//

#import <UIKit/UIKit.h>

extern NSString * const KSDIdlingWindowIdleNotification;
extern NSString * const KSDIdlingWindowActiveNotification;

@interface KSDIdlingWindow : UIWindow {
    NSTimer *idleTimer;
    NSTimeInterval idleTimeInterval;
}

@property (assign) NSTimeInterval idleTimeInterval;

@property (nonatomic, retain) NSTimer *idleTimer;

@end