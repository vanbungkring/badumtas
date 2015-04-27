//
//  ListTransferBankViewController.m
//  Dompetku
//
//  Created by Indosat on 12/2/14.
//
//

#import "ListTransferBankViewController.h"
#import "transactionNameCell.h"
#import "TransferViewController.h"
#import "bankTransferViewController.h"
@interface ListTransferBankViewController ()

@property (nonatomic,strong)NSArray *list_;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@end

@implementation ListTransferBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    _list_ = [NSArray arrayWithObjects:@" Dompetku",@"Operator Lain",@"Rekening Bank", nil];
    self.tableView.tableFooterView = [[UIView alloc]init];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    self.title = @"Transfer";
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -6;// it was -6 in iOS 6
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, _backButton, nil] animated:NO];
}
- (IBAction)dismiss:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    
    // not supported on iOS4
    UITabBar *tabBar = [self.tabBarController tabBar];
    if ([tabBar respondsToSelector:@selector(setBackgroundImage:)])
    {
        NSLog(@"keen update");
        // set it just for this instance
        [tabBar setBackgroundImage:[UIImage imageNamed:@"transfer-state"]];
        
        // set for all
        // [[UITabBar appearance] setBackgroundImage: ...
    }
    else
    {
        // ios 4 code here
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return _list_.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    transactionNameCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.transactionName.text = [_list_ objectAtIndex:indexPath.row];
    if(indexPath.row%2==0){
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1];
    }
    else{
        
        cell.contentView.backgroundColor  =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
        cell.backgroundColor =[UIColor colorWithRed:0.902 green:0.902 blue:0.902 alpha:1];
    }
    switch (indexPath.row) {
        case 0:
            [cell.transactionImage setImage:[UIImage imageNamed:@"money"]];
            break;
        case 1:
            [cell.transactionImage setImage:[UIImage imageNamed:@"money"]];
            break;
        default:
             [cell.transactionImage setImage:[UIImage imageNamed:@"bank"]];
            break;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row==0) {
        TransferViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferViewController"];
        newView.isDompetku = 1;
        newView.title = [_list_ objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:newView animated:YES];
    }
    if (indexPath.row==1) {
        TransferViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"TransferViewController"];
        newView.isDompetku = 0;
        newView.title = [_list_ objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:newView animated:YES];
    }
    if (indexPath.row==2){
        bankTransferViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"bankTransferViewController"];
        newView.title = [_list_ objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:newView animated:YES];
    }
}

@end
