//
//  DataBaseManager.m
//  HWforgeekHub3
//
//  Created by Roman Rybachenko on 13.12.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import "DataBaseManager.h"
#import "FMDatabase.h"


@implementation DataBaseManager

- (id)init {
    self = [super init];
    if (self) {
        dbFileName = @"Player.sqlite";
        databasePath = [self getPathToDataBase];
        [self openDataBase];
        
    }
    return self;
}

- (void)openDataBase {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL dataBaseExist = [fileManager fileExistsAtPath:databasePath];
    if (!dataBaseExist) {
        NSString *defaultDatabasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:dbFileName];
        [fileManager copyItemAtPath:defaultDatabasePath toPath:databasePath error:nil];
    }
    FMDatabase *fmDataBase = [FMDatabase databaseWithPath:databasePath];
    if (![fmDataBase open]) {
        fmDataBase = nil;
        NSLog(@"Error! Failed to open data base");
    }
}

- (NSString*)getPathToDataBase {
    
    NSString *documentDirectoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

    
    return [documentDirectoryPath stringByAppendingPathComponent:dbFileName];
}

@end
