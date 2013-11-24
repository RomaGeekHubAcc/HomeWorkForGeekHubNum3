//
//  List.h
//  HWGeekHub3
//
//  Created by Roma on 25.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentList : NSObject

@property (nonatomic) NSMutableString *title;
@property (nonatomic) NSMutableString *updated;
@property (nonatomic) NSMutableString *description;
@property (nonatomic) NSString *bigImageStr;
@property (nonatomic) NSURL *urlOfImage;

- (id)init;

@end
