//
//  LeftMenuTableViewController.m
//  Dompetku
//
//  Created by Indosat on 12/18/14.
//
//

#import "LeftMenuTableViewController.h"
#import <SWRevealViewController.h>
#import "NetraUserInquiry.h"
#import "AdministrasiListTableViewController.h"
#import "InformasiTableViewController.h"
#import "NRealmSingleton.h"
#import "InboxTableViewController.h"
#import "HomeViewController.h"
#import "FavoritTableViewController.h"
#import "QRViewController.h"
@interface LeftMenuTableViewController ()
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *inboxLabek;
@property (strong, nonatomic) IBOutlet UILabel *qrcodeLabel;
@property (strong, nonatomic) IBOutlet UILabel *FavoriteLabel;
@property (strong, nonatomic) IBOutlet UILabel *AdministrasiLabel;
@property (strong, nonatomic) IBOutlet UILabel *InformasiLabel;
@property (strong, nonatomic) IBOutlet UILabel *logoutLabel;
@property(nonatomic) NSInteger lastState;
@property(nonatomic) NSInteger indexNow;
@end

@implementation LeftMenuTableViewController

- (void)viewDidLoad {
    _lastState = 0;
    [super viewDidLoad];
    NetraUserInquiry *n = [NetraUserInquiry getUserInquiry];
    
    if (![n.name isEqualToString:@""]) {
        _userName.text = n.name;
    }
    else{
        _userName.text =@"User";
    }
    self.tableView.backgroundColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
    [self.tableView setSeparatorColor:[UIColor colorWithRed:0.455 green:0.455 blue:0.455 alpha:1]];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView reloadData];
    //
    self.tableView.tableFooterView = [[UIView alloc]init];
    //    [self openState];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(resetSideMenu)
     name:@"resetSideMenu"
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(useNotificationWithString)
     name:@"gotoHome"
     object:nil];
}
-(void)useNotificationWithString{
    UIStoryboard *storyboard;
    UINavigationController *nav = (UINavigationController *) self.revealViewController.frontViewController;
    // Get the storyboard named secondStoryBoard from the main bundle:
    storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HomeViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    [self resetSideMenu];
    // Then push the new view controller in the usual way:
    nav.viewControllers = [NSArray arrayWithObjects:controller, nil];
    // Then push the new view controller in the usual way:
    [self.revealViewController pushFrontViewController:nav animated:YES];
}
-(void)resetSideMenu{
    _lastState = 0;
    _logoutLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
    _qrcodeLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
    _FavoriteLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
    _AdministrasiLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
    _inboxLabek.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
    _InformasiLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
    [self.tableView reloadData];
}
-(void)openState{
    [self.tableView reloadData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self openState];
    NetraUserInquiry *n = [NetraUserInquiry getUserInquiry];
    
    if (![n.name isEqualToString:@""]) {
        _userName.text = n.name;
    }
    else{
        _userName.text =@"User";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    //    // Force your tableview margins (this may be a bad idea)
    //    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
    //        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    //    }
    //
    //    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
    //        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    //    }
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row %2==0) {
        cell.backgroundColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
    }
    else{
        cell.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
    }
    if(indexPath.row==0){
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navbar"]];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    
    else{
        if(indexPath.row==_lastState){
            UIView *customColorView = [[UIView alloc] init];
            customColorView.backgroundColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            cell.selectedBackgroundView =  customColorView;
            cell.backgroundColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            cell.textLabel.textColor = [UIColor orangeColor];
        }
        else{
            if (indexPath.row %2==0) {
                cell.backgroundColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
            }
            else{
                cell.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
            }
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 6;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSLog(@"index path row-->%d",indexPath.row);
//        if (indexPath.row %2==0) {
//            cell.backgroundColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
//        }
//        else{
//            cell.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
//        }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UINavigationController *nav = (UINavigationController *) self.revealViewController.frontViewController;
    NSIndexPath *ip  =[NSIndexPath indexPathForRow:_lastState inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:ip];
    if(indexPath.row !=_lastState){
        if (_lastState%2==0) {
            cell.backgroundColor = [UIColor colorWithRed:0.353 green:0.353 blue:0.353 alpha:1];
            [self.tableView reloadData];
        }
        else{
            cell.backgroundColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1];
            [self.tableView reloadData];
        }
        NSLog(@"last state is different");
    }
    else{
        NSLog(@"last state is same");
    }
    _lastState = indexPath.row;
    UIStoryboard *storyboard;
    if (indexPath.row==1) {
        // Get the storyboard named secondStoryBoard from the main bundle:
        storyboard = [UIStoryboard storyboardWithName:@"Inbox" bundle:nil];
        InboxTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"InboxTableViewController"];
        nav.viewControllers = [NSArray arrayWithObjects:controller, nil];
        // Then push the new view controller in the usual way:
        [self.revealViewController pushFrontViewController:nav animated:YES];
    }
//    if (indexPath.row==2) {
//        // Get the storyboard named secondStoryBoard from the main bundle:
//        storyboard = [UIStoryboard storyboardWithName:@"qrcode" bundle:nil];
//        InboxTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"QRViewController"];
//        nav.viewControllers = [NSArray arrayWithObjects:controller, nil];
//        // Then push the new view controller in the usual way:
//        [self.revealViewController pushFrontViewController:nav animated:YES];
//    }
    if (indexPath.row==2) {
        
        // Get the storyboard named secondStoryBoard from the main bundle:
        storyboard = [UIStoryboard storyboardWithName:@"Favorite" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"FavoritTableViewController"];
        nav.viewControllers = [NSArray arrayWithObjects:controller, nil];
        // Then push the new view controller in the usual way:
        [self.revealViewController pushFrontViewController:nav animated:YES];
        
    }
    if (indexPath.row==3) {
        // Get the storyboard named secondStoryBoard from the main bundle:
        storyboard = [UIStoryboard storyboardWithName:@"Administrasi" bundle:nil];
        UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"AdministrasiView"];
        nav.viewControllers = [NSArray arrayWithObjects:controller, nil];
        // Then push the new view controller in the usual way:
        [self.revealViewController pushFrontViewController:nav animated:YES];
    }
    if (indexPath.row==4) {
        // Get the storyboard named secondStoryBoard from the main bundle:
        storyboard = [UIStoryboard storyboardWithName:@"Informasi" bundle:nil];
        InformasiTableViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"InformasiTableViewController"];
        nav.viewControllers = [NSArray arrayWithObjects:controller, nil];
        // Then push the new view controller in the usual way:
        [self.revealViewController pushFrontViewController:nav animated:YES];
    }
    if (indexPath.row==5) {
        [self logout];
    }
    switch (indexPath.row) {
            
        case 1:
            _qrcodeLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _FavoriteLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _AdministrasiLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _inboxLabek.textColor = [UIColor colorWithRed:0.953 green:0.431 blue:0.122 alpha:1];
            _InformasiLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _logoutLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            break;
//                    case 2:
//                        _qrcodeLabel.textColor = [UIColor colorWithRed:0.953 green:0.431 blue:0.122 alpha:1];
//                        _FavoriteLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
//                        _AdministrasiLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
//                        _inboxLabek.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
//                        _InformasiLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
//                        _logoutLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
//                        break;
        case 2:
            _qrcodeLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _FavoriteLabel.textColor = [UIColor colorWithRed:0.953 green:0.431 blue:0.122 alpha:1];
            _AdministrasiLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _inboxLabek.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _InformasiLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _logoutLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            break;
        case 3:
            _qrcodeLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _FavoriteLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _AdministrasiLabel.textColor = [UIColor colorWithRed:0.953 green:0.431 blue:0.122 alpha:1];
            _inboxLabek.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _InformasiLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _logoutLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            break;
        case 4:
            _qrcodeLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _FavoriteLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _AdministrasiLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _inboxLabek.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _InformasiLabel.textColor =[UIColor colorWithRed:0.953 green:0.431 blue:0.122 alpha:1];
            _logoutLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            break;
        case 5:
            _qrcodeLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _FavoriteLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _AdministrasiLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _inboxLabek.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _InformasiLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _logoutLabel.textColor =[UIColor colorWithRed:0.953 green:0.431 blue:0.122 alpha:1];
            break;
        default:
            _qrcodeLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _FavoriteLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _AdministrasiLabel.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _inboxLabek.textColor = [UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _InformasiLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            _logoutLabel.textColor =[UIColor colorWithRed:0.859 green:0.859 blue:0.859 alpha:1];
            
            break;
    }
    
    
    
}
- (void)logout
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:@"Anda yakin ingin keluar dari aplikasi?"
                                                   delegate:self
                                          cancelButtonTitle:@"Batal"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex ==1){
        UINavigationController *nav = (UINavigationController *) self.revealViewController.frontViewController;
        [[NRealmSingleton sharedMORealmSingleton]deleteRealm];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *myVC =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        nav.viewControllers = @[myVC];
        [self.revealViewController pushFrontViewController:nav animated:YES];
        [self resetSideMenu];
    }
    else{
        [self resetSideMenu];
    }
}
/*
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
 
 // Configure the cell...
 
 return cell;
 }
 */

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
