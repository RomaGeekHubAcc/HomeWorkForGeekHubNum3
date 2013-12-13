//
//  List.m
//  HWGeekHub3
//
//  Created by Roma on 25.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import "Podcastitem.h"

@implementation PodcastItem

- (id)init{
    self = [super init];
    if (self) {
        _title = [[NSString alloc]init];
        _pubDate = [[NSString alloc]init];
        _description  = [[NSString alloc]init];
        _imageStr = [[NSString alloc]init];
    }
    return self;
}

@end
