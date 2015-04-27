//
//  PromoViewController.h
//  Dompetku
//
//  Created by Arie Prasetyo on 2/16/15.
//
//

#import <UIKit/UIKit.h>

@interface PromoViewController : UIViewController<UIWebViewDelegate>
@property (nonatomic,strong)UIWebView  *web;
@property (nonatomic,strong)NSString *urlPass;
@end
