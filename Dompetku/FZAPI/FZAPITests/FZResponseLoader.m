//
//  FZResponseLoader.m
//  FZAPI
//
//  Created by OlivierDemolliens on 7/22/14.
//  Copyright (c) 2014 Flashiz All rights reserved.
//

#import "FZResponseLoader.h"

@implementation FZResponseLoader

/*
 Parse JSON string and return an dictionnary
 */
+(NSDictionary*)parseJSONDictionnary:(NSString*)json
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* e = nil;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
    if(e){
        return nil;
    }else{
        return dic;
    }
}

/*
 Parse JSON string and return an array
 */
+(NSArray*)parseJSONArray:(NSString*)json
{
    NSData* data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* e = nil;
    NSArray* array = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    
    if(e){
        return nil;
    }else{
        return array;
    }
}

/*
 Read file in NSMainBundle and return the content
 fileName -> file name without extension
 */
+(id)readJSONFromFile:(NSString*)fileName withClass:(NSObject*)object
{
    NSString *content = [FZResponseLoader readType:@"txt" fromFile:fileName];
    
    if(content==nil){
        return nil;
    }
    
    if([object isKindOfClass:[NSDictionary class]]){
        return [FZResponseLoader parseJSONDictionnary:content];
    }else if([object isKindOfClass:[NSArray class]]){
        return [FZResponseLoader parseJSONArray:content];
    }else{
        return nil;
    }
}


/*
 Read file in the bundle containing the class specified and return the content
 fileName -> file name without extension
 */
+(NSString *)readType:(NSString *)aType fromFile:(NSString *)aFileName {
    
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:aFileName ofType:aType];
    
    //NSLog(@"pathBundle : %@",pathBundle);
    
    NSError *e = nil;
    
    NSString *content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:&e];
    
    if(e || [content length] == 0){
        return nil;
    } else {
        return content;
    }
}

/*
 Read a CSV file
 */
+(NSMutableArray *)readCVSFromFile:(NSString*)fileName
{
    NSString *content = [FZResponseLoader readType:@"csv" fromFile:fileName];
    
    return [FZResponseLoader parseCVSDictionary:content];
}

/*
 Parse the CSV file to return an MutableArray
 */
+(NSMutableArray *)parseCVSDictionary:(NSString *)csv {
    
    NSMutableArray *setOfParamsFromFile = [[[NSMutableArray alloc] init] autorelease];
    
    //Get all lines in an array
    NSArray *linesArray = [csv componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    NSArray *keys = nil;
    
    //for each line
    int nbOfLines = [linesArray count];
    for (int i = 0; i < nbOfLines; i++) {
        
        NSString * string = [linesArray objectAtIndex:i];
        
        //get all columns of this line
        NSArray *columnArray=[string componentsSeparatedByString:@";"];
        
        if(keys) { //if we have already the header of each columns (the first line of the file)
            NSMutableDictionary *aSetOfParams = [[NSMutableDictionary alloc] init];
            
            int nbOfColumns = [columnArray count];
            for (int col = 0; col < nbOfColumns; col ++) {
                //store all column's variable in an array
                [aSetOfParams setObject:[columnArray objectAtIndex:col] forKey:[keys objectAtIndex:col]];
            }
            
            //add the line to the mutableArray
            [setOfParamsFromFile addObject:aSetOfParams];
            [aSetOfParams release];
        } else { //get the column's header
            keys = [NSArray arrayWithArray:columnArray];
        }
    }
    
    if ([setOfParamsFromFile count] > 0) {
        return setOfParamsFromFile;
    } else {
        return nil;
    }
}

@end