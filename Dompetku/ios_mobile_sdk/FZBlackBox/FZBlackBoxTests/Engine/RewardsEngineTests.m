//
//  RewardsEngineTests.m
//  FZBlackBox
//
//  Created by Matthieu Barile on 17/07/2014.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "RewardsEngine.h"

//Utils
#import <FZAPI/Invoice.h>
#import <FZAPI/LoyaltyProgram.h>

@interface RewardsEngineTests : XCTestCase

@property (nonatomic, retain) Invoice *invoiceWithoutProgram;
@property (nonatomic, retain) Invoice *invoiceProgramPermanentPercentagediscount;
@property (nonatomic, retain) Invoice *invoiceProgramPercentageCoupons;
@property (nonatomic, retain) Invoice *invoiceProgramCashCoupons;

@end

@implementation RewardsEngineTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    [self createInvoiceWithoutProgram];
    [self createInvoiceProgramPercentageCoupons];
    [self createInvoiceProgramCashCoupons];
    [self createInvoiceProgramPermanentPercentageDiscount];
    
    NSLog(@"Setup passed");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


/*
 //Common
 @property (copy, nonatomic) NSString *invoiceId;
 @property (nonatomic) double amount;
 @property (copy, nonatomic) NSString *currency;
 @property (copy, nonatomic) NSString *comment;
 
 //European only
 @property (nonatomic) BOOL isCredit;
 @property (nonatomic) BOOL withRefill;
 @property (nonatomic) double newBalanceWithRefill;
 @property (nonatomic) double newBalanceWithoutRefill;
 @property (nonatomic) int numberOfRefill;
 @property (nonatomic) double takenAmount;
 @property (copy, nonatomic) NSString *type;
 @property (copy, nonatomic) NSString *otherMail;
 @property (copy, nonatomic) NSString *otherName;
 
 //fidelitiz part
 //Common
 @property (nonatomic) BOOL hasLoyaltyCard;
 @property (nonatomic) double permanentPercentageDiscount;
 @property (nonatomic) double correctedInvoiceAmountWithPercentage;
 @property (copy, nonatomic) NSArray *couponList;
 @property (retain, nonatomic) LoyaltyProgram *currentLoyaltyProgram;
 
 //European only
 @property (nonatomic) double balance;
 
 
 //Indonesian only
 //@property (copy, nonatomic) NSString *receiver;
 @property (copy, nonatomic) NSString *status;
 //fidelitiz part
 //Indonesian only
 @property (copy, nonatomic) NSNumber *fidelitizId;
 */
- (void)createInvoiceProgramPercentageCoupons {
    
    // TODO: use data from server
    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] init];
    
    [aDictionary setObject:@"10.00" forKey:@"amount"];
    [aDictionary setObject:@"test@test.com" forKey:@"receiver"];
    [aDictionary setObject:@"test@test.com" forKey:@"mail"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isCredit"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"withRefill"];
    [aDictionary setObject:@"90.00" forKey:@"newBalanceWithRefill"];
    [aDictionary setObject:@"90.00" forKey:@"newBalanceWithoutRefill"];
    [aDictionary setObject:@"0" forKey:@"numberOfRefill"];
    [aDictionary setObject:@"0"  forKey:@"takenAmount"];
    [aDictionary setObject:@"42" forKey:@"invoiceId"];
    [aDictionary setObject:@"test" forKey:@"comment"];
    [aDictionary setObject:@"100.00" forKey:@"balance"];
    [aDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"hasLoyaltyCard"];
    [aDictionary setObject:@"0" forKey:@"permanentPercentageDiscount"];
    [aDictionary setObject:@"0" forKey:@"correctedInvoiceAmountWithPercentage"];
    
    NSMutableDictionary *aDictionaryCoupon = [[NSMutableDictionary alloc] init];
    [aDictionaryCoupon setObject:@"10.00" forKey:@"amount"];
    [aDictionaryCoupon setObject:@"EUR" forKey:@"currency"];
    [aDictionaryCoupon setObject:@"42" forKey:@"couponId"];
    [aDictionaryCoupon setObject:@"PERCENT" forKey:@"couponType"];
    [aDictionaryCoupon setObject:@"42" forKey:@"fidelitizId"];
    [aDictionaryCoupon setObject:@"42" forKey:@"loyaltyCardId"];
    [aDictionaryCoupon setObject:@"42" forKey:@"loyaltyProgramId"];
    [aDictionaryCoupon setObject:@"1421362800000" forKey:@"validityEndDate"];//timestamps
    
    NSMutableArray *aListOfCoupons = [[NSMutableArray alloc] init];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    
    [aDictionary setObject:aListOfCoupons forKey:@"couponList"];
    
    //[aDictionary setObject:@"EUR" forKey:@"currency"];
    //[aDictionary setObject:@"" forKey:@"type"];
    //[aDictionary setObject:@"test" forKey:@"otherName"];
    //[aDictionary setObject:@"" forKey:@"currentLoyaltyProgram"];
    //[aDictionary setObject:@"test" forKey:@"status"];
    //[aDictionary setObject:@"42" forKey:@"fidelitizId"];
    
    //@"amount", @"receiver", @"mail", @"isCredit", @"withRefill", @"newBalanceWithRefill", @"newBalanceWithoutRefill", @"numberOfRefill", @"takenAmount", @"invoiceId", @"comment",@"balance", @"hasLoyaltyCard", @"permanentPercentageDiscount", @"correctedInvoiceAmountWithPercentage",
    
    //_invoiceProgramPercentageCoupons = [Invoice invoiceWithDictionary:aDictionary error:nil];
    [Invoice invoiceWithDictionary:aDictionary successBlock:^(id object) {
        _invoiceProgramPercentageCoupons = (Invoice *)object;
        XCTAssertNotNil(_invoiceProgramPercentageCoupons,@"No invoiceProgramPercentageCoupons");
    } failureBlock:^(Error *error) {
        XCTFail(@"No invoiceProgramPercentageCoupons");
    }];
    
    [aDictionaryCoupon release];
    [aListOfCoupons release];
    [aDictionary release];
}

- (void)createInvoiceProgramCashCoupons {
    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] init];
    
    [aDictionary setObject:@"10.50" forKey:@"amount"];
    [aDictionary setObject:@"test@test.com" forKey:@"receiver"];
    [aDictionary setObject:@"test@test.com" forKey:@"mail"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isCredit"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"withRefill"];
    [aDictionary setObject:@"89.50" forKey:@"newBalanceWithRefill"];
    [aDictionary setObject:@"89.50" forKey:@"newBalanceWithoutRefill"];
    [aDictionary setObject:@"0" forKey:@"numberOfRefill"];
    [aDictionary setObject:@"0"  forKey:@"takenAmount"];
    [aDictionary setObject:@"42" forKey:@"invoiceId"];
    [aDictionary setObject:@"test" forKey:@"comment"];
    [aDictionary setObject:@"100.00" forKey:@"balance"];
    [aDictionary setObject:[NSNumber numberWithBool:YES] forKey:@"hasLoyaltyCard"];
    [aDictionary setObject:@"0" forKey:@"permanentPercentageDiscount"];
    [aDictionary setObject:@"0" forKey:@"correctedInvoiceAmountWithPercentage"];
    
    NSMutableDictionary *aDictionaryCoupon = [[NSMutableDictionary alloc] init];
    [aDictionaryCoupon setObject:@"1.00" forKey:@"amount"];
    [aDictionaryCoupon setObject:@"EUR" forKey:@"currency"];
    [aDictionaryCoupon setObject:@"42" forKey:@"couponId"];
    [aDictionaryCoupon setObject:@"CASH" forKey:@"couponType"];//COUPON_TYPE_PERCENT
    [aDictionaryCoupon setObject:@"42" forKey:@"fidelitizId"];
    [aDictionaryCoupon setObject:@"42" forKey:@"loyaltyCardId"];
    [aDictionaryCoupon setObject:@"42" forKey:@"loyaltyProgramId"];
    [aDictionaryCoupon setObject:@"1421362800000" forKey:@"validityEndDate"];//timestamps
    
    NSMutableArray *aListOfCoupons = [[NSMutableArray alloc] init];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    [aListOfCoupons addObject:aDictionaryCoupon];
    
    [aDictionary setObject:aListOfCoupons forKey:@"couponList"];
    
    //[aDictionary setObject:@"EUR" forKey:@"currency"];
    //[aDictionary setObject:@"" forKey:@"type"];
    //[aDictionary setObject:@"test" forKey:@"otherName"];
    //[aDictionary setObject:@"" forKey:@"currentLoyaltyProgram"];
    //[aDictionary setObject:@"test" forKey:@"status"];
    //[aDictionary setObject:@"42" forKey:@"fidelitizId"];
    
    //@"amount", @"receiver", @"mail", @"isCredit", @"withRefill", @"newBalanceWithRefill", @"newBalanceWithoutRefill", @"numberOfRefill", @"takenAmount", @"invoiceId", @"comment",@"balance", @"hasLoyaltyCard", @"permanentPercentageDiscount", @"correctedInvoiceAmountWithPercentage",

    //_invoiceProgramCashCoupons = [Invoice invoiceWithDictionary:aDictionary error:nil];
    [Invoice invoiceWithDictionary:aDictionary successBlock:^(id object) {
        _invoiceProgramCashCoupons = (Invoice *)object;
        XCTAssertNotNil(_invoiceProgramCashCoupons, @"No invoiceProgramCashCoupons");
    } failureBlock:^(Error *error) {
        XCTFail(@"No invoiceProgramCashCoupons");
    }];
    
    [aDictionaryCoupon release];
    [aListOfCoupons release];
    [aDictionary release];
}

- (void)createInvoiceWithoutProgram {
    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] init];
    
    [aDictionary setObject:@"10.00" forKey:@"amount"];
    [aDictionary setObject:@"test@test.com" forKey:@"receiver"];
    [aDictionary setObject:@"test@test.com" forKey:@"mail"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isCredit"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"withRefill"];
    [aDictionary setObject:@"32.00" forKey:@"newBalanceWithRefill"];
    [aDictionary setObject:@"32.00" forKey:@"newBalanceWithoutRefill"];
    [aDictionary setObject:@"0" forKey:@"numberOfRefill"];
    [aDictionary setObject:@"0"  forKey:@"takenAmount"];
    [aDictionary setObject:@"42" forKey:@"invoiceId"];
    [aDictionary setObject:@"test" forKey:@"comment"];
    [aDictionary setObject:@"100.00" forKey:@"balance"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"hasLoyaltyCard"];
    [aDictionary setObject:@"0" forKey:@"permanentPercentageDiscount"];
    [aDictionary setObject:@"0" forKey:@"correctedInvoiceAmountWithPercentage"];
    
    //@"amount", @"receiver", @"mail", @"isCredit", @"withRefill", @"newBalanceWithRefill", @"newBalanceWithoutRefill", @"numberOfRefill", @"takenAmount", @"invoiceId", @"comment",@"balance", @"hasLoyaltyCard", @"permanentPercentageDiscount", @"correctedInvoiceAmountWithPercentage",
    
    _invoiceWithoutProgram = [Invoice invoiceWithDictionary:aDictionary error:nil];
    [Invoice invoiceWithDictionary:aDictionary successBlock:^(id object) {
        _invoiceWithoutProgram = (Invoice *)object;
        XCTAssertNotNil(_invoiceWithoutProgram, @"No invoiceWithoutProgram");
    } failureBlock:^(Error *error) {
        XCTFail( @"No invoiceWithoutProgram");
    }];
    
    [aDictionary release];
}

- (void)createInvoiceProgramPermanentPercentageDiscount {
    NSMutableDictionary *aDictionary = [[NSMutableDictionary alloc] init];
    
    [aDictionary setObject:@"10.00" forKey:@"amount"];
    [aDictionary setObject:@"test@test.com" forKey:@"receiver"];
    [aDictionary setObject:@"test@test.com" forKey:@"mail"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isCredit"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"withRefill"];
    [aDictionary setObject:@"32.00" forKey:@"newBalanceWithRefill"];
    [aDictionary setObject:@"32.00" forKey:@"newBalanceWithoutRefill"];
    [aDictionary setObject:@"0" forKey:@"numberOfRefill"];
    [aDictionary setObject:@"0"  forKey:@"takenAmount"];
    [aDictionary setObject:@"42" forKey:@"invoiceId"];
    [aDictionary setObject:@"test" forKey:@"comment"];
    [aDictionary setObject:@"100.00" forKey:@"balance"];
    [aDictionary setObject:[NSNumber numberWithBool:NO] forKey:@"hasLoyaltyCard"];
    [aDictionary setObject:@"15.00" forKey:@"permanentPercentageDiscount"];
    [aDictionary setObject:@"7.5" forKey:@"correctedInvoiceAmountWithPercentage"];
    
    //@"amount", @"receiver", @"mail", @"isCredit", @"withRefill", @"newBalanceWithRefill", @"newBalanceWithoutRefill", @"numberOfRefill", @"takenAmount", @"invoiceId", @"comment",@"balance", @"hasLoyaltyCard", @"permanentPercentageDiscount", @"correctedInvoiceAmountWithPercentage",
    
    _invoiceProgramPermanentPercentagediscount = [Invoice invoiceWithDictionary:aDictionary error:nil];
    [Invoice invoiceWithDictionary:aDictionary successBlock:^(id object) {
        _invoiceProgramPermanentPercentagediscount = (Invoice *)object;
        XCTAssertNotNil(_invoiceProgramPermanentPercentagediscount, @"No invoiceProgramPermanentPercentagediscount");
    } failureBlock:^(Error *error) {
        XCTFail( @"No invoiceProgramPermanentPercentagediscount");
    }];
    
    [aDictionary release];
}

#pragma mark - Tests

- (void)testComputeDiscountForInvoiceNoUsedCouponsNoLivePPD { //no refill
    
    XCTAssertNotNil(_invoiceWithoutProgram, @"No invoiceWithoutProgram");
    
    InvoiceCorrectedParameters * invoiceCorrectedParameters = [RewardsEngine computeDiscountForInvoice:_invoiceWithoutProgram AndNbOfUsedCoupons:0 LivePPD:0];
    
    XCTAssertTrue([invoiceCorrectedParameters correctedInvoiceAmount] == [_invoiceWithoutProgram amount], @"");
    XCTAssertTrue([invoiceCorrectedParameters newBalanceWithRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters nbOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters hasLoyaltyCard] == NO, @"");
    XCTAssertTrue([invoiceCorrectedParameters newWithRefill] == NO, @"");
    XCTAssertTrue([invoiceCorrectedParameters amountOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters discount] == 0, @"");
}

- (void)testComputeDiscountForInvoiceNoUsedCouponsNoLivePPDWithRefillNeeded { //refill
    
    [_invoiceWithoutProgram setBalance:0];
    
    XCTAssertNotNil(_invoiceWithoutProgram, @"No invoiceWithoutProgram");
    XCTAssertLessThan([_invoiceWithoutProgram balance], [_invoiceWithoutProgram amount], @"No refill is needed");
    
    InvoiceCorrectedParameters * invoiceCorrectedParameters = [RewardsEngine computeDiscountForInvoice:_invoiceWithoutProgram AndNbOfUsedCoupons:0 LivePPD:0];
    
    XCTAssertTrue([invoiceCorrectedParameters correctedInvoiceAmount] == [_invoiceWithoutProgram amount], @"");
    XCTAssertTrue([invoiceCorrectedParameters newBalanceWithRefill] == -10, @"");
    XCTAssertTrue([invoiceCorrectedParameters nbOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters hasLoyaltyCard] == NO, @"");
    XCTAssertTrue([invoiceCorrectedParameters newWithRefill] == YES, @"");
    XCTAssertTrue([invoiceCorrectedParameters amountOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters discount] == 0, @"");
}

- (void)testComputeDiscountForInvoiceUsedCashCouponsNoLivePPD { //CASH
    
    XCTAssertNotNil(_invoiceProgramCashCoupons, @"No invoiceProgramCashCoupons");
    
    InvoiceCorrectedParameters * invoiceCorrectedParameters = [RewardsEngine computeDiscountForInvoice:_invoiceProgramCashCoupons AndNbOfUsedCoupons:2 LivePPD:0];
    
    XCTAssertTrue([invoiceCorrectedParameters correctedInvoiceAmount] == [_invoiceProgramCashCoupons amount] - [invoiceCorrectedParameters discount], @"");
    XCTAssertTrue([invoiceCorrectedParameters newBalanceWithRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters nbOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters hasLoyaltyCard] == YES, @"");
    XCTAssertTrue([invoiceCorrectedParameters newWithRefill] == NO, @"");
    XCTAssertTrue([invoiceCorrectedParameters amountOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters discount] == 2, @"");
}

- (void)testComputeDiscountForInvoiceUsedPercentCouponsNoLivePPD { //PERCENT
    
    XCTAssertNotNil(_invoiceProgramPercentageCoupons, @"No invoiceProgramCashCoupons");
    
    InvoiceCorrectedParameters * invoiceCorrectedParameters = [RewardsEngine computeDiscountForInvoice:_invoiceProgramPercentageCoupons AndNbOfUsedCoupons:1 LivePPD:0];
    
    XCTAssertTrue([invoiceCorrectedParameters correctedInvoiceAmount] == [_invoiceProgramPercentageCoupons amount] - [invoiceCorrectedParameters discount], @"");
    XCTAssertTrue([invoiceCorrectedParameters newBalanceWithRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters nbOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters hasLoyaltyCard] == YES, @"");
    XCTAssertTrue([invoiceCorrectedParameters newWithRefill] == NO, @"");
    XCTAssertTrue([invoiceCorrectedParameters amountOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters discount] == 1, @"");
}

- (void)testComputeDiscountForInvoiceNoUsedCouponsLivePPD { //PPD
    
    XCTAssertNotNil(_invoiceProgramPermanentPercentagediscount, @"No invoiceProgramPermanentPercentagediscount");
    
    InvoiceCorrectedParameters * invoiceCorrectedParameters = [RewardsEngine computeDiscountForInvoice:_invoiceProgramPermanentPercentagediscount AndNbOfUsedCoupons:0 LivePPD:15];
    
    XCTAssertTrue([invoiceCorrectedParameters correctedInvoiceAmount] == [_invoiceProgramPercentageCoupons amount] - [invoiceCorrectedParameters discount], @"");
    XCTAssertTrue([invoiceCorrectedParameters newBalanceWithRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters nbOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters hasLoyaltyCard] == YES, @"");
    XCTAssertTrue([invoiceCorrectedParameters newWithRefill] == NO, @"");
    XCTAssertTrue([invoiceCorrectedParameters amountOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters discount] == 1.5, @"");
}

- (void)testComputeDiscountForInvoiceUsedCashCouponsNoLivePPDNoRefillNeededAnymore { //CASH no refill needed anymore
    
    [_invoiceProgramCashCoupons setBalance:9.0];
    
    XCTAssertNotNil(_invoiceProgramCashCoupons, @"No invoiceProgramCashCoupons");
    XCTAssertLessThan([_invoiceProgramCashCoupons balance], [_invoiceProgramCashCoupons amount], @"No refill is needed");
    
    InvoiceCorrectedParameters * invoiceCorrectedParameters = [RewardsEngine computeDiscountForInvoice:_invoiceProgramCashCoupons AndNbOfUsedCoupons:2 LivePPD:0];
    
    XCTAssertTrue([invoiceCorrectedParameters correctedInvoiceAmount] == [_invoiceProgramCashCoupons amount] - [invoiceCorrectedParameters discount], @"");
    XCTAssertTrue([invoiceCorrectedParameters newBalanceWithRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters nbOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters hasLoyaltyCard] == YES, @"");
    XCTAssertTrue([invoiceCorrectedParameters newWithRefill] == NO, @"");
    XCTAssertTrue([invoiceCorrectedParameters amountOfRefill] == 0, @"");
    XCTAssertTrue([invoiceCorrectedParameters discount] == 2, @"");
}

- (void)testComputeDiscountForInvoiceUsedCashCouponsNoLivePPDRefillStillNeeded { //CASH refill still needed
    
    [_invoiceProgramCashCoupons setBalance:8.0];
    
    XCTAssertNotNil(_invoiceProgramCashCoupons, @"No invoiceProgramCashCoupons");
    XCTAssertLessThan([_invoiceProgramCashCoupons balance], [_invoiceProgramCashCoupons amount], @"No refill is needed");
    
    InvoiceCorrectedParameters * invoiceCorrectedParameters = [RewardsEngine computeDiscountForInvoice:_invoiceProgramCashCoupons AndNbOfUsedCoupons:2 LivePPD:0];
    
    XCTAssertTrue([invoiceCorrectedParameters correctedInvoiceAmount] == [_invoiceProgramCashCoupons amount] - [invoiceCorrectedParameters discount], @"");
    XCTAssertTrue([invoiceCorrectedParameters newBalanceWithRefill] == -0.5, @"");
    XCTAssertTrue([invoiceCorrectedParameters nbOfRefill] == 0, @"");//because no rules
    XCTAssertTrue([invoiceCorrectedParameters hasLoyaltyCard] == YES, @"");
    XCTAssertTrue([invoiceCorrectedParameters newWithRefill] == YES, @"");
    XCTAssertTrue([invoiceCorrectedParameters amountOfRefill] == 0, @"");//because no rules
    XCTAssertTrue([invoiceCorrectedParameters discount] == 2, @"");
}

/*
 + (NSInteger)computeNbOfPointsEarnWithCorrectedInvoiceAmount:(double) amount andProgram:(LoyaltyProgram *) loyaltyProgram;
 */
//Not used
/*
- (void)testComputeNbOfPointsEarnWithCorrectedInvoiceAmount {
    
}
*/

/*
 + (NSInteger)optimalNbOfCoupons:(Invoice*)invoice;
 */
- (void)testOptimalNbOfCouponsForCouponsInPercent {
    
    XCTAssertNotNil(_invoiceProgramPercentageCoupons, @"No invoiceProgramPercentageCoupons");
    XCTAssertNotNil([_invoiceProgramPercentageCoupons couponList], @"No couponList in invoiceProgramPercentageCoupons");
    XCTAssertGreaterThanOrEqual([[_invoiceProgramPercentageCoupons couponList] count], 0, @"No coupon in couponList in invoiceProgramPercentageCoupons");
    
    NSInteger nbOptimalOfCoupons = [RewardsEngine optimalNbOfCoupons:_invoiceProgramPercentageCoupons];
    
    XCTAssertTrue(nbOptimalOfCoupons == 1, @"ProgramPercentageCoupons calculation failed");
}

- (void)testOptimalNbOfCouponsForCouponsInCash {
    XCTAssertNotNil(_invoiceProgramCashCoupons, @"No invoiceProgramPercentageCoupons");
    XCTAssertNotNil([_invoiceProgramCashCoupons couponList], @"No couponList in invoiceProgramPercentageCoupons");
    XCTAssertGreaterThanOrEqual([[_invoiceProgramCashCoupons couponList] count], 0, @"No coupon in couponList in invoiceProgramPercentageCoupons");
    
    NSInteger nbOptimalOfCoupons = [RewardsEngine optimalNbOfCoupons:_invoiceProgramCashCoupons];
    
    XCTAssertTrue(nbOptimalOfCoupons == 10, @"ProgramCashCoupons calculation failed");
}

- (void)testOptimalNbOfCouponsForNoCoupon {
    XCTAssertNotNil(_invoiceWithoutProgram, @"No _invoiceWithoutProgram");
    XCTAssertNotNil([_invoiceWithoutProgram couponList], @"No couponList in _invoiceWithoutProgram");
    XCTAssertGreaterThanOrEqual([[_invoiceWithoutProgram couponList] count], 0, @"No coupon in couponList in _invoiceWithoutProgram");
    
    NSInteger nbOptimalOfCoupons = [RewardsEngine optimalNbOfCoupons:_invoiceWithoutProgram];
    
    XCTAssertTrue(nbOptimalOfCoupons == 0, @"ProgramWithoutCoupons calculation failed");
}

/*
+ (NSInteger)optimalNbOfRefill:(double)diff takenAmount:(int)_takenAmount;
*/
- (void)testOptimalNbOfRefillTakenAmountWithEntireDivision {
    
    double missingMoney = 40.0;
    int amountOfTheTopUpRule = 20.0;
    
    NSInteger nbOfRefill = [RewardsEngine optimalNbOfRefill:-missingMoney takenAmount:amountOfTheTopUpRule];
    
    XCTAssertTrue(nbOfRefill == 2, @"Incorrect number of refill");
}

- (void)testOptimalNbOfRefillTakenAmountWithNonEntireDivision {
    
    double missingMoney = 37.0;
    int amountOfTheTopUpRule = 20.0;
    
    NSInteger nbOfRefill = [RewardsEngine optimalNbOfRefill:-missingMoney takenAmount:amountOfTheTopUpRule];
    
    XCTAssertTrue(nbOfRefill == 2, @"Incorrect number of refill");
}

- (void)testOptimalNbOfRefillTakenAmountWithNoRuleSet {
    
    double missingMoney = 37.0;
    int amountOfTheTopUpRule = 0.0;
    
    NSInteger nbOfRefill = [RewardsEngine optimalNbOfRefill:-missingMoney takenAmount:amountOfTheTopUpRule];
    
    XCTAssertTrue(nbOfRefill == 0, @"Incorrect number of refill");
}

#pragma mark - Performances

- (void)testPerformanceComputeDiscountForInvoiceAndNbOfUsedCouponsLivePPD { //CASH refill still needed
    [self measureBlock:^{
        [_invoiceProgramCashCoupons setBalance:8.0];
        [RewardsEngine computeDiscountForInvoice:_invoiceProgramCashCoupons AndNbOfUsedCoupons:2 LivePPD:0];
    }];
}
/*
 [Time, seconds] average: 0.000, relative standard deviation: 201.177%, values: [0.000047, 0.000008, 0.000003, 0.000002, 0.000001, 0.000001, 0.000001, 0.000001, 0.000001, 0.000001], performanceMetricID:com.apple.XCTPerformanceMetric_WallClockTime, baselineName: "", baselineAverage: , maxPercentRegression: 10.000%, maxPercentRelativeStandardDeviation: 10.000%, maxRegression: 0.100, maxStandardDeviation: 0.100
*/

#pragma mark - MM

- (void)dealloc {
    [super dealloc];
    
    [_invoiceWithoutProgram release];
    [_invoiceProgramPermanentPercentagediscount release];
    [_invoiceProgramPercentageCoupons release];
    [_invoiceProgramCashCoupons release];
}

@end
