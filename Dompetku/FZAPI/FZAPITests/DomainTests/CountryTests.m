//
//  CountryTests.m
//  FZAPI
//
//  Created by OlivierDemolliens on 8/6/14.
//  Copyright (c) 2014 Google. All rights reserved.
//

#import <XCTest/XCTest.h>

//Tested
#import "Country.h"

@interface CountryTests : XCTestCase

@end

@implementation CountryTests

#pragma mark - Init

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Tests

- (void)testCountryWithDictionary {
    
    NSDictionary *aDictionary = [FZResponseLoader readJSONFromFile:@"getcountries" withClass:[NSDictionary dictionary]];
    
    NSArray *countriesListTemp = [aDictionary objectForKey:@"countryDtoList"];
    
    for(NSDictionary *countryDict in countriesListTemp){
        
        //Country *country = [Country countryWithDictionary:countryDict error:error];
        [Country countryWithDictionary:countryDict successBlock:^(id object) {
            XCTAssertNotNil([country code], @"Country : code is nil");
            XCTAssertNotNil([country name], @"Country : name is nil");
            XCTAssertNotNil([country phone_prefix], @"Country : phone_prefix is nil");
            XCTAssertNotNil([country reference], @"Country : reference is nil");
        } failureBlock:^(Error *error) {
            XCTFail(@"Country : can't instantiate object");
        }];
    }
}






@end

