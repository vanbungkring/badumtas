//
//  BeliViewController.m
//  Dompetku
//
//  Created by Indosat on 11/23/14.
//
//

#import "BeliViewController.h"
#import "BeliTableViewCell.h"
#import "ModelBeli+Bayar.h"
#import "ModelBeli+BayarManager.h"
#import "BeliDetailTableViewController.h"
#import "NetraDataManager.h"
#import "detaiSharedViewController.h"
#import <MBProgressHUD.h>
@interface BeliViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIView *fakeTabbar;
@property (nonatomic,strong)NSMutableArray *array;
@property (nonatomic,strong)NSArray *tempData;
@end

@implementation BeliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Beli";
    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
    self.beliTableView.delegate = self;
    self.beliTableView.dataSource = self;
    self.beliTableView.tableFooterView = [[UIView alloc]init];
    _array = [NSMutableArray arrayWithArray:[ModelBeli_Bayar isBeliStatus:1]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.beliTableView reloadData];
    _fakeTabbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"beli-state"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    self.beliTableView.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadTable)
     name:@"errorFetch"
     object:nil];
    
    [self.navigationController.tabBarItem setSelectedImage:[[UIImage imageNamed:@"buttonmenubayar@2x.png"]
                                                            imageWithRenderingMode: UIImageRenderingModeAlwaysOriginal]];
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;// it was -6 in iOS 6
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, _backButton, nil] animated:NO];
    
    
}
-(void)load{
    [ModelBeli_Bayar getDataFromModelBeli:^(NSArray *beli, NSArray *bayar, NSError *error) {
        if (!error) {
            NSLog(@"beli-->%@",beli);
            _tempData = beli;
            [self.beliTableView reloadData];
            [self reloadTable];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
        }
        else{
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Terjadi kesalahan pada server, Silahkan coba beberapa saat lagi"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
            ///[[NRealmSingleton sharedMORealmSingleton]deleteRealm];
        }
        
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    UIImage *tabBackground = [UIImage imageNamed:@"beli-state"];
    [[UITabBar appearance] setBackgroundImage:tabBackground];
    // not supported on iOS4
    UITabBar *tabBar = [self.tabBarController tabBar];
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        NSLog(@"keen update");
        [self load];
        // set it just for this instance
        [tabBar setBackgroundImage:[UIImage imageNamed:@"beli-state"]];
        
        // set for all
        // [[UITabBar appearance] setBackgroundImage: ...
    }
    else
    {
        // ios 4 code here
    }
    
    
}
-(void)reloadTable{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.beliTableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tempData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BeliTableViewCell *cell = [self.beliTableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.manager = [_tempData objectAtIndex:(NSUInteger)indexPath.row];
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    }
    else{
        
        cell.contentView.backgroundColor  =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ModelBeli_BayarManager *m = [_tempData objectAtIndex:indexPath.row];
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Beli" bundle:nil];
    BeliDetailTableViewController *newView = [s instantiateViewControllerWithIdentifier:@"BeliDetailTableViewController"];
    newView.title = m.jsonMnama;
    newView.merchantId =[m.jsonMid integerValue];
    newView.merchantState = m.jsonMnama;
    newView.merchantSub =[_tempData objectAtIndex:(NSUInteger)indexPath.row];
    [self.navigationController pushViewController:newView animated:YES];
    
    /*
     ModelBeli_BayarManager *m = [_tempData objectAtIndex:indexPath.row];
     UIStoryboard *s = [UIStoryboard storyboardWithName:@"Bayar" bundle:nil];
     BayarDetailTableViewController *newView = [s instantiateViewControllerWithIdentifier:@"BayarDetailTableViewController"];
     newView.title = m.jsonMnama;
     newView.merchantId =[m.jsonMid integerValue];
     newView.merchantState = m.jsonMnama;
     newView.merchantSub =[_tempData objectAtIndex:(NSUInteger)indexPath.row];
     [self.navigationController pushViewController:newView animated:YES];
     */
    
}

- (IBAction)backButton:(id)sender {
    NSLog(@"123");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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
