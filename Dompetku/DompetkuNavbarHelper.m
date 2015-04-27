//
//  DompetkuNavbarHelper.m
//  Dompetku
//
//  Created by Indosat on 12/18/14.
//
//

#import "DompetkuNavbarHelper.h"
#import <SWRevealViewController.h>
@implementation UIViewController (DompetkuNavbarHelper)

- (void)sidebarButtonTouched {
    [self.revealViewController revealToggle:nil];
    self.revealViewController.frontViewShadowOffset = CGSizeMake(0, 0);
    self.revealViewController.frontViewShadowOpacity = 0.0f;
    self.revealViewController.frontViewShadowRadius = 0.0f;
    
}
- (void)setDefaultNavigationBar {
    [self setLeftAbraNavigationBar];
}
- (void)setLeftAbraNavigationBar {
    NSLog(@"data");
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                   target:nil
                                                                                   action:nil];
    negativeSpacer.width = -10;
    
    UIButton *sidebarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGRect sidebarButtonFrame = sidebarButton.frame;
    sidebarButtonFrame.size.width = 32;
    sidebarButtonFrame.size.height = 32;
    
    sidebarButton.frame = sidebarButtonFrame;
    
    [sidebarButton setImage:[UIImage imageNamed:@"left-menu"]
                   forState:UIControlStateNormal];
    
    [sidebarButton addTarget:self
                      action:@selector(sidebarButtonTouched)
            forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *sidebarBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sidebarButton];
    
    self.navigationItem.leftBarButtonItems = @[negativeSpacer, sidebarBarButtonItem];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
