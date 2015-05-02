////
////  QRViewController.h
////  Dompetku
////
////  Created by Arie Prasetyo on 4/14/15.
////
////
//
#import <UIKit/UIKit.h>
#import <FZBlackBox/FlashizFacade.h>


@interface QRViewController : UIViewController<FlashizFacadeDelegate>
{
    
}
@property (retain, nonatomic) FlashizFacade *sdkFlashizFacade;
@end
