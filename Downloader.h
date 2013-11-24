//
//  LangPackDownloader.h
//  NativeSpeaker-free
//
//  Created by Oksanka on 07.07.13.
//  Copyright (c) 2013 Oksanka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject {
    NSURLConnection *conn;
    NSTimeInterval lastActivity;
    NSURLRequest *request;
    long long numBytes;
    long long expectedLength;
    NSOutputStream *outputStream;
    void(^progressHandler)(long long current, long long total, BOOL *stop);
    void (^completionHandler)(BOOL success, NSError *error);
}

+ (void)downloadWithRequest:(NSURLRequest *)request
               outputStream:(NSOutputStream *)outStream
            progressHandler:(void(^)(long long current, long long total, BOOL *stop))progressHandler
          completionHandler:(void(^)(BOOL success, NSError *error))completionHandler;

@end
