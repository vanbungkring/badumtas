//
//  KSDIdlingWindow.m
//  Dompetku
//
//  Created by Arie Prasetyo on 3/4/15.
//
//

#import "KSDIdlingWindow.h"

NSString * const KSDIdlingWindowIdleNotification   = @"KSDIdlingWindowIdleNotification";
NSString * const KSDIdlingWindowActiveNotification = @"KSDIdlingWindowActiveNotification";

@interface KSDIdlingWindow (PrivateMethods)
- (void)windowIdleNotification;
- (void)windowActiveNotification;


@end


@implementation KSDIdlingWindow
@synthesize idleTimer, idleTimeInterval;

- (id) initWithFrame:(CGRect)frame {
    NSLog(@"data");
    self = [super initWithFrame:frame];
    if (self) {
        self.idleTimeInterval = 1;
    }
    return self;
}
#pragma mark activity timer

- (void)sendEvent:(UIEvent *)event {
    NSLog(@"event");
    [super sendEvent:event];
    self.idleTimeInterval=1;
    NSSet *allTouches = [event allTouches];
    if ([allTouches count] > 0) {
        
        // To reduce timer resets only reset the timer on a Began or Ended touch.
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        if (phase == UITouchPhaseBegan || phase == UITouchPhaseEnded) {
            if (!idleTimer) {
                [self windowActiveNotification];
            } else {
                [idleTimer invalidate];
            }
            
            if (idleTimeInterval != 0) {
                self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:idleTimeInterval
                                                                  target:self
                                                                selector:@selector(windowIdleNotification)
                                                                userInfo:nil repeats:NO];
            }
        }
    }
    else{
        if (idleTimeInterval != 0) {
            self.idleTimer = [NSTimer scheduledTimerWithTimeInterval:idleTimeInterval
                                                              target:self
                                                            selector:@selector(windowIdleNotification)
                                                            userInfo:nil repeats:NO];
        }
    }
}


- (void)windowIdleNotification {
    NSLog(@"time habis");
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc postNotificationName:KSDIdlingWindowIdleNotification
                       object:self
                     userInfo:nil];
    self.idleTimer = nil;
}

- (void)windowActiveNotification {
    NSLog(@"windowActiveNotification");
    NSNotificationCenter *dnc = [NSNotificationCenter defaultCenter];
    [dnc postNotificationName:KSDIdlingWindowActiveNotification
                       object:self
                     userInfo:nil];
}

- (void)dealloc {
    if (self.idleTimer) {
        [self.idleTimer invalidate];
        self.idleTimer = nil;
    }
}


@end