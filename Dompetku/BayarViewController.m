//
//  BayarViewController.m
//  Dompetku
//
//  Created by Indosat on 11/24/14.
//
//

#import "BayarViewController.h"
#import "ModelBeli+Bayar.h"
#import "bayarTableViewCell.h"
#import "NetraDataManager.h"
#import <MBProgressHUD.h>
#import "ModelBeli+BayarManager.h"
#import "BayarDetailTableViewController.h"
@interface BayarViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSArray *tempData;
@end

@implementation BayarViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Bayar";
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;// it was -6 in iOS 6
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, _backButton, nil] animated:NO];
    self.bayarTable.delegate = self;
    self.bayarTable.dataSource = self;
    self.view.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    self.bayarTable.tableFooterView = [[UIView alloc]init];
    [self.bayarTable reloadData];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    _array = [NSMutableArray arrayWithArray:[ModelBeli_Bayar isBeliStatus:0]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(reloadTable)
     name:@"errorFetch"
     object:nil];
    
}
-(void)load{
    [ModelBeli_Bayar getDataFromModelBeli:^(NSArray *beli, NSArray *bayar, NSError *error) {
        if (!error) {
            _tempData = bayar;
            NSLog(@"_temp data-->%@",_tempData);
            [self reloadTable];
        }
        else{
            [[NetraCommonFunction sharedCommonFunction]setAlert:@"Error" message:@"Terjadi kesalahan pada server, Silahkan coba beberapa saat lagi"];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"errorFetch" object:nil];
            ///[[NRealmSingleton sharedMORealmSingleton]deleteRealm];
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }
        
        
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self load];
    NSLog(@"selected data-->%d",self.tabBarController.selectedIndex);
    [self.tabBarController setNeedsStatusBarAppearanceUpdate];
    UIImage *tabBackground = [UIImage imageNamed:@"bayar-state"];
    [[UITabBar appearance] setBackgroundImage:tabBackground];
    // not supported on iOS4
    UITabBar *tabBar = [self.tabBarController tabBar];
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        NSLog(@"keen update");
        // set it just for this instance
        [tabBar setBackgroundImage:[UIImage imageNamed:@"bayar-state"]];
        
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
    [self.bayarTable reloadData];
}

- (IBAction)backButton:(id)sender {
    NSLog(@"123");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tempData count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    bayarTableViewCell *cell = [self.bayarTable dequeueReusableCellWithIdentifier:@"Cell"];
    cell.manager = [_tempData objectAtIndex:indexPath.row];
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
    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Bayar" bundle:nil];
    BayarDetailTableViewController *newView = [s instantiateViewControllerWithIdentifier:@"BayarDetailTableViewController"];
    newView.title = m.jsonMnama;
    newView.merchantId =[m.jsonMid integerValue];
    newView.merchantState = m.jsonMnama;
    newView.merchantSub =[_tempData objectAtIndex:(NSUInteger)indexPath.row];
    [self.navigationController pushViewController:newView animated:YES];
    
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
