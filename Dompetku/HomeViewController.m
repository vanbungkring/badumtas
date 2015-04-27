//
//  HomeViewController.m
//  Dompetku
//
//  Created by Indosat on 11/23/14.
//
//

#import "HomeViewController.h"
#import "TabbarViewController.h"
#import "NetraUserModel.h"
#import "NetraUserProfile.h"
#import "NetraUserInquiry.h"
#import "transactionMapping.h"
#import "homeViewTableViewCell.h"
#import <MBProgressHUD.h>
#import "fieldTransaction.h"
#import "transactionDetailAttribute.h"
#import "transactionMapping.h"
#import "ModelBayar.h"
#import "NetraDataManager.h"
#import "LoginController.h"
#import <AFNetworking.h>
#import "NetraApiManager.h"
#import "ModelBeli+Bayar.h"
#import "HistoryTransaksiTableViewController.h"
#import "PromoViewController.h"
#import <SWRevealViewController.h>
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SWRevealViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *basicScroll;
@property (strong, nonatomic) IBOutlet UILabel *nowTime;
@property (strong, nonatomic) IBOutlet UIView *fakeTabbar;
@property (strong, nonatomic) IBOutlet UILabel *userNama;
@property (strong, nonatomic) IBOutlet UILabel *userPhone;
@property (nonatomic,strong)TabbarViewController *tab;
@property (strong, nonatomic) IBOutlet UILabel *userBalance;
@property (strong, nonatomic) IBOutlet UITableView *trxHistory;
@property (strong, nonatomic) IBOutlet UIScrollView *promo;
@property (weak, nonatomic) IBOutlet UILabel *walletType;
@property (strong, nonatomic) NSMutableArray *promo_;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@end
int current_page;
@implementation HomeViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _basicScroll.delegate = self;
    _promo.delegate = self;
    _promo_ = [[NSMutableArray alloc]init];
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"dd/MM/YYYY HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    _nowTime.text= [NSString stringWithFormat:@"Per %@",dateString];
    
    self.revealViewController.panGestureRecognizer.enabled=YES;
    [_fakeTabbar setFrame:CGRectMake(0, self.view.frame.size.height-54, _fakeTabbar.frame.size.width, _fakeTabbar.frame.size.height)];
    _fakeTabbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"home-state"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar-logo"] forBarMetrics:UIBarMetricsDefault];
    
    
    
    netraUserModel *modelUser = [netraUserModel getUserProfile];
    
    if([modelUser.tripleDes isEqualToString:@""]){
        UIStoryboard *mainstoryboard = [UIStoryboard storyboardWithName:@"Login"bundle:nil];
        UIViewController *navLogin = [mainstoryboard instantiateViewControllerWithIdentifier:@"NavLogin"];
        [self.navigationController presentViewController:navLogin animated:YES completion:NULL];
    }
    else{
        [self reloadData];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    current_page=0;
    _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
    _pageControl.tag =10010;
    [_pageControl addTarget:self action:@selector(pageControlChanged:) forControlEvents:UIControlEventTouchUpInside];
    _pageControl.backgroundColor = [UIColor clearColor];
    
    _promo.backgroundColor = [UIColor whiteColor];
    
    _trxHistory.delegate = self;
    _trxHistory.dataSource = self;
    
    _promo.showsHorizontalScrollIndicator = false;
    _promo.showsVerticalScrollIndicator = false;
    
    for (int i=1; i<3; i++) {
        [[NetraCommonFunction sharedCommonFunction]giveBorderTo:[self.view viewWithTag:i]
                                                      withColor:GRAY_BORDER_COLOR
                                               withCornerRadius:5
                                                withBorderWidth:2];
    }
    [[NetraCommonFunction sharedCommonFunction]giveBorderTo:_promo
                                                  withColor:GRAY_BORDER_COLOR
                                           withCornerRadius:5
                                            withBorderWidth:0];
    [self setDefaultNavigationBar];
    ///fetch elasitas API
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTabel)
                                                 name:@"successFetch"
                                               object:nil];
    [self getPromo];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(renewBalance)
                                                 name:@"renewTheBalance"
                                               object:nil];
    
    
    
    self.revealViewController.delegate = self;
    //    netraUserModel *modelUser = [netraUserModel getUserProfile];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(useNotificationWithString)
     name:@"gotoHome"
     object:nil];
}
-(void)useNotificationWithString{
    NSLog(@"HOME-> GOTO HOME");
    [self dismissViewControllerAnimated:NO completion:nil];
    [[self presentingViewController] dismissViewControllerAnimated:NO completion:nil];
}
- (void)revealController:(SWRevealViewController *)revealController willMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}

- (void)revealController:(SWRevealViewController *)revealController didMoveToPosition:(FrontViewPosition)position
{
    if(position == FrontViewPositionLeft) {
        self.view.userInteractionEnabled = YES;
    } else {
        self.view.userInteractionEnabled = NO;
    }
}
-(void)reloadTabel{
    
    [_trxHistory reloadData];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}
-(void)getPromo{
    [[NetraApiManager sharedClient]GET:[NSString stringWithFormat:@"%@/list_promo/204a217e5873d4a00868f3224cebd607",elasitasApiUrl] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"response->%@",responseObject);
        for (id object in responseObject) {
            if(![_promo_ containsObject:object]){
                [_promo_ addObject:object];
            }
            [self drawPromo];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"error->%@",error);
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
    
}
-(void)drawPromo{
    [_pageControl setNumberOfPages:_promo_.count];
    [_pageControl setCurrentPage:0];
    for (int i=0; i<_promo_.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5+(i*_promo.frame.size.width), _promo.frame.size.height/3, _promo.frame.size.width-10, 40)];
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:11];
        label.textAlignment =NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.tag =i;
        label.text  =[[_promo_ objectAtIndex:i] objectForKey:@"promo_text"];
        label.numberOfLines = 2;
        [_promo addSubview:label];
        [label setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBrowser:)];
        [tapGestureRecognizer setNumberOfTapsRequired:1];
        [label addGestureRecognizer:tapGestureRecognizer];
        
    }
    //    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(onTimer)   userInfo:nil repeats:YES];
    _promo.contentSize = CGSizeMake(_promo.frame.size.width *_promo_.count, _promo.frame.size.height);
    
}
-(void)openBrowser:(id)sender{
    
//    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
//    NSURL *url = [NSURL URLWithString:[[_promo_ objectAtIndex:[tapRecognizer.view tag]] objectForKey:@"promo_url"]];
//    if (![[UIApplication sharedApplication] openURL:url]) {
//        NSLog(@"%@%@",@"Failed to open url:",[url description]);
//    }
    
    PromoViewController *p = [[PromoViewController alloc]init];
    UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    p.urlPass =[[_promo_ objectAtIndex:[tapRecognizer.view tag]] objectForKey:@"promo_url"];
    [self.navigationController pushViewController:p animated:YES];
    
}
- (IBAction)reload:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self reloadData];
    
}

-(void) onTimer {
    // NSLog(@"content offset %f",scrollVw.contentOffset.y);
    if (_promo.contentOffset.x<_promo.contentSize.width*_promo_.count) {
        //scroll to desire position
        _promo.contentOffset = CGPointMake(0, _promo.contentOffset.x+100);
    }
    
    
}

-(void)renewBalance{
    netraUserModel *modelUser = [netraUserModel getUserProfile];
    NetraUserInquiry *modelUserInquiry = [NetraUserInquiry getUserInquiry];
    _userNama.text = modelUserInquiry.name;
    _walletType.text =[[NetraDataManager sharedDataManager]walletType];
    _userBalance.text = [NSString stringWithFormat:@"Rp. %@",[[NetraCommonFunction sharedCommonFunction]formatToRupiah:[NSNumber numberWithInteger:[modelUserInquiry.balance   integerValue]]]];
    _userPhone.text = modelUser.userNumber;
    [self.view setNeedsDisplay];
}
-(void)reloadData{
    [NetraUserProfile getUserInquiry];
    netraUserModel *modelUser = [netraUserModel getUserProfile];
    NetraUserInquiry *modelUserInquiry = [NetraUserInquiry getUserInquiry];
    _userNama.text = modelUserInquiry.name;
    _walletType.text =[[NetraDataManager sharedDataManager]walletType];
    _userBalance.text = [NSString stringWithFormat:@"Rp. %@",[[NetraCommonFunction sharedCommonFunction]formatToRupiah:[NSNumber numberWithInteger:[modelUserInquiry.balance   integerValue]]]];
    _userPhone.text = modelUser.userNumber;
    [self.view setNeedsDisplay];
    [self getPromo];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [transactionMapping sharedDataManager].historyTransaction.count;
    if ([transactionMapping sharedDataManager].historyTransaction.count<3) {
        return [transactionMapping sharedDataManager].historyTransaction.count;
    }
    else{
        return 3;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    homeViewTableViewCell *cell = [_trxHistory dequeueReusableCellWithIdentifier:@"Cell"];
    cell.userProfile = [[transactionMapping sharedDataManager].historyTransaction objectAtIndex:indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    // Dispose of any resources that can be recreated.
}
- (IBAction)beli:(id)sender {
    _tab= [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarViewController"];
    _tab.state = @"0";
    [self.navigationController presentViewController:_tab animated:YES completion:^{
        
    }];
}
- (IBAction)bayar:(id)sender {
    _tab= [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarViewController"];
    _tab.state = @"2";
    [self.navigationController presentViewController:_tab animated:YES completion:^{
        
    }];
}
- (IBAction)mintaToken:(id)sender {
    _tab= [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarViewController"];
    _tab.state = @"3";
    [self.navigationController presentViewController:_tab animated:YES completion:^{
        
    }];
}
- (IBAction)transfer:(id)sender {
    _tab= [self.storyboard instantiateViewControllerWithIdentifier:@"TabbarViewController"];
    _tab.state = @"4";
    [self.navigationController presentViewController:_tab animated:YES completion:^{
        
    }];
}
- (IBAction)moreHistroy:(id)sender {
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"HistoryTransaksi" bundle:nil];
    HistoryTransaksiTableViewController *purchaseContr = (HistoryTransaksiTableViewController *)[s instantiateViewControllerWithIdentifier:@"HistoryTransaksiTableViewController"];
    purchaseContr.isMore = 1;
    [self.navigationController pushViewController:purchaseContr animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pageControl setNumberOfPages:_promo_.count];
    CGFloat pageWidth = _promo.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = _promo.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    current_page=page;
    [_pageControl setCurrentPage:page]; // you need to have a **iVar** with getter for pageControl

}
- (void)pageControlChanged:(id)sender
{
    UIPageControl *pageControl = sender;
    CGFloat pageWidth = _promo.frame.size.width;
    CGPoint scrollTo = CGPointMake(pageWidth * pageControl.currentPage, 0);
    [_promo setContentOffset:scrollTo animated:YES];
}
- (IBAction)next:(id)sender {
    CGFloat pageWidth = _promo.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = _promo.contentOffset.x / pageWidth;
    NSInteger page = lround(fractionalPage);
    if(current_page<_promo_.count-1){
        current_page=current_page+1;
    }
     NSLog(@"promo count->%d",_promo_.count);
    NSLog(@"current page->%d",current_page);
    CGPoint scrollTo = CGPointMake(pageWidth * current_page-1, 0);
    [_promo setContentOffset:scrollTo animated:YES];
}
- (IBAction)prev:(id)sender {
    CGFloat pageWidth = _promo.frame.size.width; // you need to have a **iVar** with getter for scrollView
    float fractionalPage = _promo.contentOffset.x / pageWidth;
    if(current_page>0){
        current_page=current_page-1;
    }
    NSLog(@"current page->%d",current_page);
    CGPoint scrollTo = CGPointMake(pageWidth * current_page-1, 0);
    [_promo setContentOffset:scrollTo animated:YES];
    

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
