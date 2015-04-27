//
//  searchBankTableViewController.m
//  Dompetku
//
//  Created by Indosat on 12/2/14.
//
//

#import "searchBankTableViewController.h"

@interface searchBankTableViewController ()<UISearchBarDelegate>{
    UIView *disableViewOverlay;
}
@property (nonatomic,strong)NSArray *bank;
@property (nonatomic,strong)NSMutableArray *kodeBank;
@property (nonatomic,strong)NSMutableArray *namaBank;
@property (nonatomic,strong)NSMutableArray *bankCopy;
@property (nonatomic,strong)NSArray *searchResult;
@property (nonatomic,strong)NSArray *searchResultCode;

@end
BOOL is_searchs =0;
@implementation searchBankTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    is_searchs =0;
    [self setBackButton];
    self.title = @"Pilih Bank";
    self.view.backgroundColor = [UIColor whiteColor];
    disableViewOverlay.backgroundColor = [UIColor blackColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navbar"] forBarMetrics:UIBarMetricsDefault];
    _namaBank = [[NSMutableArray alloc]init];
    _kodeBank = [[NSMutableArray alloc]init];
    NSString *bankMaster = @"BANK BRI;002,BANK EKSPOR INDONESIA;003,BANK MANDIRI;008,BANK BNI;009,BANK DANAMON;011, PERMATA BANK;013,BANK BCA;014,BANK BII;016,BANK PANIN;019,BANK ARTA NIAGA KENCANA;020,BANK NIAGA;022,BANK BUANA IND;023,BANK LIPPO;026,BANK NISP;028,AMERICAN EXPRESS BANK LTD;030,CITI BANK N.A.;031,JP.MORGAN CHASE BANK N.A.;032,BANK OF AMERICA N.A;033,ING INDONESIA BANK;034,BANK MULTICOR TBK.;036,BANK ARTHA GRAHA;037,BANK CREDIT AGRICOLE INDOSUEZ;039,THE BANGKOK BANK COMP. LTD;040,THE HONGKONG & SHANGHAI B.C.;041,THE BANK OF TOKYO MITSUBISHI UFJ LTD;042,BANK SUMITOMO MITSUI INDONESIA;045,BANK DBS INDONESIA;046,BANK RESONA PERDANIA;047,BANK MIZUHO INDONESIA;048,STANDARD CHARTERED BANK;050,BANK ABN AMRO;052,BANK KEPPEL TATLEE BUANA;053,BANK CAPITAL INDONESIA TBK.;054,BANK BNP PARIBAS INDONESIA;057,BANK UOB INDONESIA;058,KOREA EXCHANGE BANK DANAMON;059,RABO BANK INTERNASIONAL INDONESIA;060,ANZ PANIN BANK;061,DEUTSCHE BANK AG.;067,BANK WOORI INDONESIA;068,BANK OF CHINA LIMITED;069,BANK BUMI ARTA;076,BANK EKONOMI;087,BANK ANTARDAERAH;088,BANK HAGA;089,BANK IFI;093,BANK CENTURY TBK.;095,BANK MAYAPADA;097,BANK JABAR;110,BANK DKI;111,BPD DIY;112,BANK JATENG;113,BANK JATIM;114,BPD JAMBI;115,BPD ACEH;116,BANK SUMUT;117,BANK NAGARI;118,BANK RIAU;119,BANK SUMSEL;120,BANK LAMPUNG;121,BPD KALSEL;122,BPD KALIMANTAN BARAT;123,BPD KALTIM;124,BPD KALTENG;125,BPD SULSEL;126,BANK SULUT;127,BPD NTB;128,BPD BALI;129,BANK NTT;130,BANK MALUKU;131,BPD PAPUA;132,BANK BENGKULU;133,BPD SULAWESI TENGAH;134,BANK SULTRA;135,BANK NUSANTARA PARAHYANGAN;145,BANK SWADESI;146,BANK MUAMALAT;147,BANK MESTIKA;151,BANK METRO EXPRESS;152,BANK SHINTA INDONESIA;153,BANK MASPION;157,BANK HAGAKITA;159,BANK GANESHA;161,BANK WINDUKENTJANA;162,HALIM INDONESIA BANK;164,BANK HARMONI INTERNATIONAL;166,BANK KESAWAN;167,BANK TABUNGAN NEGARA (PERSERO);200,BANK HIMPUNAN SAUDARA 1906 TBK.;212,BANK TABUNGAN PENSIUNAN NASIONAL;213,BANK SWAGUNA;405,BANK JASA ARTA;422,BANK MEGA;426,BANK JASA JAKARTA;427,BANK BUKOPIN;441,BANK SYARIAH MANDIRI;451,BANK BISNIS INTERNASIONAL;459,BANK SRI PARTHA;466,BANK JASA JAKARTA;472,BANK BINTANG MANUNGGAL;484,BANK BUMIPUTERA;485,BANK YUDHA BHAKTI;490,BANK MITRANIAGA;491,BANK AGRO NIAGA;494,BANK INDOMONEX;498,BANK ROYAL INDONESIA;501,BANK ALFINDO;503,BANK SYARIAH MEGA;506,BANK INA PERDANA;513,BANK HARFA;517,PRIMA MASTER BANK;520,BANK PERSYARIKATAN INDONESIA;521,BANK AKITA;525,LIMAN INTERNATIONAL BANK;526,ANGLOMAS INTERNASIONAL BANK;531,BANK DIPO INTERNATIONAL;523,BANK KESEJAHTERAAN EKONOMI;535,BANK UIB;536,BANK ARTOS IND;542,BANK PURBA DANARTA;547,BANK MULTI ARTA SENTOSA;548,BANK MAYORA;553,BANK INDEX SELINDO;555,BANK VICTORIA INTERNATIONAL;566,BANK EKSEKUTIF;558,CENTRATAMA NASIONAL BANK;559,BANK FAMA INTERNASIONAL;562,BANK SINAR HARAPAN BALI;564,BANK HARDA;567,BANK FINCONESIA;945,BANK MERINCORP;946,BANK MAY BANK INDOCORP;947,BANK OCBC ñ INDONESIA;948,BANK CHINA TRUST INDONESIA;949,BANK COMMONWEALTH;950";
//    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    _bank = [bankMaster componentsSeparatedByString:@","];
    for (int i=0; i<_bank.count; i++) {
        NSRange range = [[_bank objectAtIndex:i] rangeOfString:@";"];
        if([[_bank objectAtIndex:i] substringFromIndex:range.location]){
//            NSLog(@"data ke->%d adlah->%@",i,[[[_bank objectAtIndex:i] substringFromIndex:range.location] stringByReplacingOccurrencesOfString:@";" withString:@""]);
//            
            if(![_kodeBank containsObject:[[[_bank objectAtIndex:i] substringFromIndex:range.location] stringByReplacingOccurrencesOfString:@";" withString:@""]]){
                [_kodeBank addObject:[[[_bank objectAtIndex:i] substringFromIndex:range.location] stringByReplacingOccurrencesOfString:@";" withString:@""]];
            }
            
            NSArray *a = [[_bank objectAtIndex:i]componentsSeparatedByString:@";"];
            if(![_namaBank containsObject:a[0]]){
                [_namaBank addObject:a[0]];
            }
        }
        else{
            NSLog(@"data->%@",[_bank objectAtIndex:i]);
        }
    }
    searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

-(void)setBackButton{
    UIBarButtonItem *backButton =
    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                  target:self
                                                  action:@selector(goBack)];
    self.navigationItem.leftBarButtonItem = backButton;
}
-(void)goBack{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    is_searchs=0;
    [self.tableView reloadData];
}
- (void)hideKeyboardWithSearchBar:(UISearchBar *)searchBars
{
    [searchBars resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText length]!=0) {
        is_searchs =1;
        _searchResult = nil;
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self CONTAINS[cd]%@",searchText];
        _searchResult = [_namaBank filteredArrayUsingPredicate:resultPredicate];
        _searchResultCode = [_bank filteredArrayUsingPredicate:resultPredicate];
        NSLog(@"search Result code->%@",_searchResultCode);
        [self.tableView reloadData];
    }
    else{
        is_searchs =0;
        [self.tableView reloadData];
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (!is_searchs) {
        return _namaBank.count;
    }
    else{
        return _searchResult.count;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    if (is_searchs) {
        NSString *kodeBank =[[[_searchResultCode objectAtIndex:indexPath.row] componentsSeparatedByString:@";"]lastObject];
        cell.textLabel.text =[NSString stringWithFormat:@"%@ - %@",kodeBank,[_searchResult objectAtIndex:indexPath.row]];
    }
    else{
        cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",[_kodeBank objectAtIndex:indexPath.row],[_namaBank objectAtIndex:indexPath.row]];
    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *stasiunName;
    NSString *bankCode;
    if(is_searchs)
        stasiunName = [_searchResult objectAtIndex:indexPath.row];
    else
        stasiunName = [_namaBank objectAtIndex:indexPath.row];
        bankCode = [_kodeBank objectAtIndex:indexPath.row];
    NSDictionary *data = @{@"key":bankCode,@"value":stasiunName};
    NSLog(@"data-->%@",data);
    [[NSNotificationCenter defaultCenter]postNotificationName:@"postBackBank" object:self userInfo:data];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
@end
