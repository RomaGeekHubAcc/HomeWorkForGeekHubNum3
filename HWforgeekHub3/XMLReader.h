//
//  XMLReader.h
//  HWforgeekHub3
//
//  Created by Roma on 01.11.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PodcastAsset.h"

@interface XMLReader : NSObject <NSXMLParserDelegate>
{
    int countTegsWithImage;
    int countTegsIm;
    BOOL flagAudioTrack;
    BOOL flagImage;
}

@property (nonatomic) PodcastAsset *theList;

@property (nonatomic, retain) NSString * currentElement;
@property (nonatomic) NSMutableString *currentTitle;
@property (nonatomic) NSMutableString *currentPubDate;
@property (nonatomic) NSMutableString *currentDescription;
@property (nonatomic) NSMutableString *currentImageStr;
@property (nonatomic) NSMutableArray *arrayWithContentLists;
@property (nonatomic) NSURL *currentURL;
@property (nonatomic) NSMutableString *currentAudioTrack;
@property (nonatomic) NSMutableString *currentDuration;
@property (nonatomic) NSMutableString *currentAuthor;

@property (nonatomic) NSMutableArray *arrayWithURLs;

-(void)parseXMLFileAtURL:(NSURL *)URL parseXMLFile:(NSData *)fileData parseError:(NSError **)error;
- (NSMutableArray*)parseXMLwithData:(NSData*)data;
- (NSMutableArray*)getArrayWithURLs;

@end
