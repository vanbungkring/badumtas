//
//  TOCViewController.m
//  Dompetku
//
//  Created by Indosat on 12/3/14.
//
//

#import "InformasiDetail.h"
#import <FZBlackBox/SWRevealViewController.h>
@interface infomasiDetail ()<UIWebViewDelegate>
@property (strong, nonatomic)  UIWebView *webviw;

@end

@implementation infomasiDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _webviw = [[UIWebView alloc]initWithFrame:self.view.bounds];
    _webviw.delegate=self;
    NSString *htmlFile;
    if([self.title isEqualToString:@"Beli/Bayar"]){
     htmlFile = [[NSBundle mainBundle] pathForResource:@"Bayar-Beli" ofType:@"html"];
    }
    else{
     htmlFile = [[NSBundle mainBundle] pathForResource:self.title ofType:@"html"];
    }
    SWRevealViewController *reveal = self.revealViewController;
    reveal.panGestureRecognizer.enabled = NO;
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    [_webviw loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:_webviw];
    // Do any additional setup after loading the view.
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
