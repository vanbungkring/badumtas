//
//  InformasiTableViewController.m
//  Dompetku
//
//  Created by Indosat on 12/3/14.
//
//

#import "InformasiTableViewController.h"
#import "InformasiDetail.h"
#import "HistoryTransaksiTableViewController.h"
#import "DompetkuNavbarHelper.h"
#import "DaftarMerchantCollectionViewController.h"
#import <FZBlackBox/SWRevealViewController.h>
@interface InformasiTableViewController ()<SWRevealViewControllerDelegate>
@property (nonatomic,strong)NSArray *arrayMenu;
@end

@implementation InformasiTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Informasi";
    [self setDefaultNavigationBar];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _arrayMenu = [NSArray arrayWithObjects:@"Histori Transaksi",@"Tentang Dompetku",@"Syarat & Ketentuan",@"Hubungi Kami",@"Daftar Merchant",@"Setor Tunai",@"Beli/Bayar",@"Kirim Uang",@"Tarik Tunai", nil];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    self.tableView.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    self.tableView.tableFooterView = [[UIView alloc]init];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.revealViewController.delegate = self;
    //    netraUserModel *modelUser = [netraUserModel getUserProfile];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 68;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _arrayMenu.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if(cell==nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
    }
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    }
    else{
        
        cell.contentView.backgroundColor  =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    }
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:16];
    cell.textLabel.text = [_arrayMenu objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storyboard ;
    
    if (indexPath.row ==0) {
        // Get the storyboard named secondStoryBoard from the main bundle:
        storyboard = [UIStoryboard storyboardWithName:@"HistoryTransaksi" bundle:nil];
        HistoryTransaksiTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"HistoryTransaksiTableViewController"];
        // Then push the new view controller in the usual way:
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    
    else if (indexPath.row ==4) {
        // Get the storyboard named secondStoryBoard from the main bundle:
        storyboard = [UIStoryboard storyboardWithName:@"ListMerchant" bundle:nil];
        DaftarMerchantCollectionViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"DaftarMerchantCollectionViewController"];
        // Then push the new view controller in the usual way:
        [self.navigationController pushViewController:controller animated:YES];
        
    }
    else{
        infomasiDetail *newView = [[infomasiDetail alloc]init];
        newView.title = [_arrayMenu objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:newView animated:YES];
    }
    
}
- (IBAction)openLeft:(id)sender {
    
}


@end
