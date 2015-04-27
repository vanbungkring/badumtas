//
//  detaiSharedViewController.m
//  Dompetku
//
//  Created by Indosat on 11/28/14.
//
//

#import "detaiSharedViewController.h"
#import "ModelBeli+Bayar.h"
#import "ModelBayar.h"
#import "modelSubMerchant.h"
#import "NetraDataManager.h"
#import "SharedTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "transactionMapping.h"
#import "fieldTransaction.h"
#import "TranscationDetailSharedViewController.h"
@interface detaiSharedViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableDetail;
@property (strong, nonatomic) ModelBeli *merchants_beli;
@property (strong, nonatomic) ModelBayar *merchants_bayar;
@property (strong, nonatomic) modelSubMerchant *sub;
@property (strong,nonatomic)NSArray *merchant_detail_name,*merchant_detail_Image,*merchant_detail_id;

@end

@implementation detaiSharedViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _title_;
    _tableDetail.delegate = self;
    _tableDetail.dataSource = self;
    _tableDetail.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    _tableDetail.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    _tableDetail.tableFooterView = [[UIView alloc]init];
    
}
-(void)reset{
    //    [self.navigationController popToRootViewControllerAnimated:NO];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SharedTableViewCell *cell = [_tableDetail dequeueReusableCellWithIdentifier:@"Cell"];
    [cell.merchantImage setImageWithURL:[NSURL URLWithString:[_merchant_detail_Image objectAtIndex:indexPath.row]] placeholderImage:nil];
    cell.merhcantName.hidden = YES;
    cell.merhcantName.text = [_merchant_detail_name objectAtIndex:indexPath.row];
    if([[_merchant_detail_Image objectAtIndex:indexPath.row] isEqualToString:@""] ||[[_merchant_detail_Image objectAtIndex:indexPath.row] isEqual:[NSNull null]]){
        cell.merhcantName.hidden = NO;
    }
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    }
    else{
        
        cell.contentView.backgroundColor  =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TranscationDetailSharedViewController *t = [[TranscationDetailSharedViewController alloc]init];
    t.transactionJenis =[_merchant_detail_id objectAtIndex:indexPath.row];
    t.state = _state;
    t.transactionNameParent = _title_;
    SharedTableViewCell *customCell = (SharedTableViewCell*)[_tableDetail cellForRowAtIndexPath:indexPath];
    
    t.title =customCell.merhcantName.text;
    
    //    [transactionMapping getTransactionByMerchant:[_merchant_detail_id objectAtIndex:indexPath.row]];
    [transactionMapping getTransactionByCategory:_state merchant:[_merchant_detail_id objectAtIndex:indexPath.row]];
    NSArray *data = [transactionMapping getTransactionByCategory:_state merchant:[_merchant_detail_id objectAtIndex:indexPath.row]];
    [self.navigationController pushViewController:t animated:YES];
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_merchant_detail_name count];
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
