//
//  Defines.h
//  HWforgeekHub3
//
//  Created by Roma on 09.11.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#ifndef HWforgeekHub3_Defines_h
#define HWforgeekHub3_Defines_h

#define PODCAST_ADRESS @"https://itunes.apple.com/ua/rss/toppodcasts/limit=50/genre=1304/explicit=true/xml"
#define PODCASTS_COMEDY @"https://itunes.apple.com/ua/rss/toppodcasts/limit=25/genre=1303/xml"
#define PODCASTS_OTHER @"http://auto.rpod.ru/rss.xml"

// теги для 1- го й 2- го:
#define ENTRY @"entry"
#define TITLE @"title"
#define UPDATED @"updated"
#define SUMMARY @"summary"
#define ICON_IMAGE @"im:image"

// теги для 3- го
#define ITEM_ @"item"
#define TITLE_ @"title"
#define AUTHOR_ @"author"
#define PUBDATE_ @"pubDate"
#define DESCRIPTION_ @"description"
#define IMAGE_ @"itunes:image"
#define AUDIO_TRACK_ @"enclosure"
#define DURATION_ @"itunes:duration"

#define screenSize [UIScreen mainScreen].bounds

#define IS_IPHONE5 (([[UIScreen mainScreen] bounds].size.height - 568) ? NO : YES)
#define IS_OS_5_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0)
#define IS_OS_6_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
#define IS_OS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#endif
