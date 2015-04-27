//
//  QRViewController.h
//  Dompetku
//
//  Created by Arie Prasetyo on 4/14/15.
//
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
@interface QRViewController : UIViewController<ZBarReaderDelegate>
{
    ZBarReaderViewController *reader;
}

@end
