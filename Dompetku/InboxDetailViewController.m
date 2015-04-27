//
//  InboxDetailViewController.m
//  Dompetku
//
//  Created by Indosat on 1/21/15.
//
//

#import "InboxDetailViewController.h"
#import "Log.h"
@interface InboxDetailViewController ()
@property (strong, nonatomic) IBOutlet UILabel *refID;
@property (strong, nonatomic) IBOutlet UILabel *createdDate;
@property (strong, nonatomic) IBOutlet UILabel *actionName;
@property (strong, nonatomic) IBOutlet UILabel *merchantName;
@property (strong, nonatomic) IBOutlet UILabel *tujuan;
@property (strong, nonatomic) IBOutlet UILabel *jumlah;
@property (strong, nonatomic) IBOutlet UILabel *voucherID;
@property (strong, nonatomic) IBOutlet UILabel *labelData;
@property (strong, nonatomic) IBOutlet UILabel *labelMerchant;
@property (strong, nonatomic) IBOutlet UILabel *labelKe;
@property (strong, nonatomic) IBOutlet UILabel *labelJumlah;

@end

@implementation InboxDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Inbox Detail";
    _refID.text = _log.refId;
    _createdDate.text = [[NSString stringWithFormat:@"%@",_log.createdAt]stringByReplacingOccurrencesOfString:@"+0000" withString:@""];
    _actionName.text = _log.actionName;
    if([_log.actionName isEqualToString:@"Minta Token"]){
        _merchantName.text = @"";
        _labelMerchant.text = [NSString stringWithFormat:@"Token: "];
        _merchantName.text =[NSString stringWithFormat:@"%@ (berlaku s/d %@)",_log.token,_log.createdAt];
        CGRect frame = _merchantName.frame;
        frame.origin.x = _merchantName.frame.origin.x-25;
        frame.size.width =200;
        _merchantName.frame =frame;
        _merchantName.numberOfLines =0;
        [_merchantName sizeToFit];
        _labelKe.hidden = YES;
        _labelJumlah.hidden = YES;
        _tujuan.hidden = YES;
        _jumlah.hidden = YES;
        _labelData.hidden = YES;
        _voucherID.hidden = YES;
    }
    else{
        _merchantName.text =_log.merchant;
        _tujuan.text = _log.destination;
        _jumlah.text = _log.amount;
        if (![_log.voucherID isEqualToString:@""]) {
            
            CGRect labelJumlahFrame =_labelJumlah.frame;
            labelJumlahFrame.origin.y = labelJumlahFrame.origin.y-30;
            _labelJumlah.frame =labelJumlahFrame;
            
            
            CGRect labelJumlahAmount =_jumlah.frame;
            labelJumlahAmount.origin.y = labelJumlahAmount.origin.y-30;
            _jumlah.frame =labelJumlahAmount;
            
            CGRect labelVoucher =_labelData.frame;
            labelVoucher.origin.y = labelVoucher.origin.y-30;
            _labelData.frame =labelVoucher;
            
            CGRect labelVoucherContent =_voucherID.frame;
            labelVoucherContent.origin.y = labelVoucherContent.origin.y-30;
            _voucherID.frame =labelVoucherContent;
            
            _labelData.hidden = NO;
            _voucherID.hidden = NO;
            _labelKe.hidden = YES;
            _tujuan.hidden = YES;
            _voucherID.text = _log.voucherID;
            _voucherID.numberOfLines = 0;
            [_voucherID sizeToFit];
            
        }
        else{
            _labelData.hidden = YES;
            _voucherID.hidden = YES;
        }
        if([_log.actionName isEqualToString:@"Beli Donasi"]){
            _refID.text= _log.token;
            CGRect frame = _labelKe.frame;
            frame.size.width = 200;
            _labelKe.frame = frame;
            _labelJumlah.hidden = YES;
            _jumlah.hidden = YES;
            _labelKe.text = [NSString stringWithFormat:@"Jumlah: %@",_log.amount];
        }
    }
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
