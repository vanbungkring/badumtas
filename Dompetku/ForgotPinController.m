//
//  ForgotPinController.m
//  Dompetku
//
//  Created by iMac on 11/14/14.
//
//

#import "ForgotPinController.h"

@interface ForgotPinController ()
@property (strong, nonatomic) IBOutlet UILabel *lupaPinWording;

@end

@implementation ForgotPinController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    //show navigation bar
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"Lupa Pin", nil);
    _lupaPinWording.text = @"Silahkan Hubungi 111 dari nomor Matrix dan 100 dari nomor Mentari & IM3 untuk permintaan reset PIN, PIN baru akan dikirimkan melalui SMS setelah kami verifikasi";
    _lupaPinWording.numberOfLines = 0;
    [_lupaPinWording sizeToFit];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backgroundTap:(id)sender {
    [self.view endEditing:YES];
}
@end
