//
//  Podcast.h
//  HWforgeekHub3
//
//  Created by Roman Rybachenko on 04.12.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PodcastItem;

@interface Podcast : NSObject

@property (nonatomic) PodcastItem *pItem;
@property (nonatomic) NSMutableArray *arrWithURLs;
@end
