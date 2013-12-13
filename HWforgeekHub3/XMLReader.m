//
//  XMLReader.m
//  HWforgeekHub3
//
//  Created by Roma on 01.11.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//


#import "Defines.h"
#import "XMLReader.h"
#import "Podcastitem.h"

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
    if ([elementName isEqualToString:ITEM_]) {
        //
    }
    if ([elementName isEqual:AUDIO_TRACK_] && !flagAudioTrack)
    {
        if (!_currentAudioTrackAr) _currentAudioTrackAr = [[NSMutableArray alloc]init];
        flagAudioTrack = YES;
        [_currentAudioTrackAr addObject:[attributeDict objectForKey:@"url"]];
//        _currentAudioTrackAr = [attributeDict objectForKey:@"url"];
    }
    if ([elementName isEqualToString:IMAGE_] && !flagImage) {
        flagImage = YES;
        _currentImageStr = [attributeDict objectForKey:@"href"];
    }
    flagAudioTrack = NO;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([_currentElement isEqualToString:TITLE_]) {
        if (!_currentTitle) {
            _currentTitle = [[NSMutableString alloc]init];
        }
		[_currentTitle appendString:string];
	}
    else if ([_currentElement isEqualToString:PUBDATE_]) {
        if (!_currentPubDate) {
            _currentPubDate = [[NSMutableString alloc]init];
        }
		[_currentPubDate appendString:string];
    }
    else if ([_currentElement isEqualToString:DESCRIPTION_]) {
        if (!_currentDescription) {
            _currentDescription = [[NSMutableString alloc]init];
        }
        [_currentDescription appendString:string];
    }
//    else if ([_currentElement isEqualToString:IMAGE_]) {
//        _currentURL = [NSURL URLWithString:string];
//        if (!_currentImageStr) {
//            _currentImageStr =[[NSMutableString alloc]init];
//            [_currentImageStr appendString:string];
//        }
//        if (_currentURL) {
//            [_arrayWithURLs addObject:_currentURL];
//        }
//    }
    else if ([_currentElement isEqualToString:AUTHOR_]) {
        if (!_currentAuthor) {
            _currentAuthor = [[NSMutableString alloc]init];
        }
        [_currentAuthor appendString:string];
    }
    else if ([_currentElement isEqualToString:DURATION_]) {
        if (!_currentDuration) {
            _currentDuration = [[NSMutableString alloc]init];
        }
        [_currentDuration appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser
                didEndElement:(NSString *)elementName
                namespaceURI:(NSString *)namespaceURI
                qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:ITEM_]) {
 
        PodcastItem *contentList = [[PodcastItem alloc]init];
        contentList.title = _currentTitle;
        contentList.pubDate = _currentPubDate;
        contentList.description = _currentDescription;
        contentList.imageStr = _currentImageStr;
//        contentList.urlOfImage = _currentURL;
        contentList.durationPodcast = _currentDuration;
        contentList.audioFilePathArray = _currentAudioTrackAr;
        contentList.autor = _currentAuthor;
        
        if (!_arrayWithContentLists) {
            _arrayWithContentLists = [[NSMutableArray alloc]init];
        }
        [_arrayWithContentLists addObject:contentList];

        _currentElement = nil;
        _currentImageStr = nil;
        _currentTitle = nil;
        _currentDescription = nil;
        _currentPubDate = nil;
        _currentURL = nil;
        _currentDuration = nil;
        _currentAudioTrackAr = nil;
        
        flagAudioTrack = NO;
        flagImage = NO;
    }
}

@end
