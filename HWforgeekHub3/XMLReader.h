//
//  XMLReader.h
//  HWforgeekHub3
//
//  Created by Roma on 01.11.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContentList.h"

@interface XMLReader : NSObject <NSXMLParserDelegate>
{
    int countTegsWithImage;
    int countTegsIm;
}

@property (nonatomic) ContentList *theList;

@property (nonatomic, retain) NSString * currentElement;
@property (nonatomic) NSMutableString *currentTitle;
@property (nonatomic) NSMutableString *currentUpdated;
@property (nonatomic) NSMutableString *currentDescription;
@property (nonatomic) NSString *currentBigImageStr;
@property (nonatomic) NSMutableArray *arrayWithContentLists;
@property (nonatomic) NSURL *currentURL;

@property (nonatomic) NSMutableArray *arrayWithURLs;

-(void)parseXMLFileAtURL:(NSURL *)URL parseXMLFile:(NSData *)fileData parseError:(NSError **)error;
- (NSMutableArray*)parseXMLwithData:(NSData*)data;
- (NSMutableArray*)getArrayWithURLs;

@end
