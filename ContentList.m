//
//  List.m
//  HWGeekHub3
//
//  Created by Roma on 25.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import "ContentList.h"

@implementation ContentList

- (id)init{
    self = [super init];
    if (self) {
        _title = [[NSMutableString alloc]init];
        _updated = [[NSMutableString alloc]init];
        _description  = [[NSMutableString alloc]init];
        _bigImageStr = [[NSMutableString alloc]init];
    }
    return self;
}

@end
