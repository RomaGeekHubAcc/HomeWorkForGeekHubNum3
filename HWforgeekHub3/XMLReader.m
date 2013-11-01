//
//  XMLReader.m
//  HWforgeekHub3
//
//  Created by Roma on 01.11.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#define PODCAST_ADRESS @"https://itunes.apple.com/ua/rss/toppodcasts/limit=50/genre=1304/explicit=true/xml"
#define PODCASTS_COMEDY @"https://itunes.apple.com/ua/rss/toppodcasts/limit=25/genre=1303/xml"

// теги:
#define ENTRY @"entry"
#define TITLE @"title"
#define UPDATED @"updated"
#define SUMMARY @"summary"
#define ICON_IMAGE @"im:image"

#import "XMLReader.h"
#import "ContentList.h"

@implementation XMLReader

- (id)init {
    self = [super init];
    if (self) {
        countTegsIm = 0;
        countTegsWithImage = 0;
        _arrayWithContentLists = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)parseXMLFileAtURL:(NSURL *)URL parseXMLFile:(NSData *)fileData parseError:(NSError **)error
{
	NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:URL];

	[parser setDelegate:self];

	[parser parse];
	
	NSError *parserError = [parser parserError];
	if(parserError && error)
	{
		*error = parserError;
	}
}

- (NSMutableArray*)parseXMLwithData:(NSData*)data {
    if (!_arrayWithURLs) {
        _arrayWithURLs = [[NSMutableArray alloc]init];
    }
    else [_arrayWithURLs removeAllObjects];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    
    [parser parse];
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:_arrayWithContentLists];
    return array;
}

- (NSMutableArray*)getArrayWithURLs {
    return _arrayWithURLs;
}

#pragma mark - Parsing

- (void)parser:(NSXMLParser *)parser
            didStartElement:(NSString *)elementName
            namespaceURI:(NSString *)namespaceURI
            qualifiedName:(NSString *)qualifiedName
            attributes:(NSDictionary *)attributeDict  {
    
    _currentElement = elementName;
    if ([elementName isEqualToString:ENTRY]) {
        //
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([_currentElement isEqualToString:TITLE]) {
        if (!_currentTitle) {
            _currentTitle = [[NSMutableString alloc]init];
        }
		[_currentTitle appendString:string];
	}
    else if ([_currentElement isEqualToString:UPDATED]) {
        if (!_currentUpdated) {
            _currentUpdated = [[NSMutableString alloc]init];
        }
		[_currentUpdated appendString:string];
    }
    else if ([_currentElement isEqualToString:SUMMARY]) {
        if (!_currentDescription) {
            _currentDescription = [[NSMutableString alloc]init];
        }
        [_currentDescription appendString:string];
    }
    else if ([_currentElement isEqualToString:ICON_IMAGE]) {
        _currentURL = [NSURL URLWithString:string];
        if (_currentBigImageStr) {
            _currentBigImageStr = [[NSMutableString alloc]init];
        }
        _currentBigImageStr = [NSString stringWithString:string];
        if (_currentURL) {
            [_arrayWithURLs addObject:_currentURL];
        }
    }
}

- (void)parser:(NSXMLParser *)parser
                didEndElement:(NSString *)elementName
                namespaceURI:(NSString *)namespaceURI
                qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:ENTRY]) {
        
        ContentList *contentList = [[ContentList alloc]init];
        contentList.title = _currentTitle;
        contentList.updated = _currentUpdated;
        contentList.description = _currentDescription;
        contentList.bigImageStr = _currentBigImageStr;
        contentList.urlOfImage = _currentURL;
        
        if (!_arrayWithContentLists) {
            _arrayWithContentLists = [[NSMutableArray alloc]init];
        }
        [_arrayWithContentLists addObject:contentList];

        _currentElement = nil;
        _currentBigImageStr = nil;
        _currentTitle = nil;
        _currentDescription = nil;
        _currentUpdated = nil;
        _currentURL = nil;
    }
}

@end
