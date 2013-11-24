//
//  LangPackDownloader.m
//  NativeSpeaker-free
//
//  Created by Oksanka on 07.07.13.
//  Copyright (c) 2013 Oksanka. All rights reserved.
//

#import "Downloader.h"

@implementation Downloader

+ (id)downloaderWorker:(id)arg {
    @autoreleasepool {
        while (YES) {
            @autoreleasepool {
                NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.25]];
                NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - start;
                if (elapsed < 0.25) [NSThread sleepForTimeInterval:0.25 - elapsed];
            }
        }
    }
}

+ (NSThread *)workingThread {
    static NSThread *thread;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(downloaderWorker:) object:nil];
        [thread start];
    });
    return thread;
}

+ (void)downloadWithRequest:(NSURLRequest *)request
               outputStream:(NSOutputStream *)outStream
            progressHandler:(void(^)(long long current, long long total, BOOL *stop))progressHandler
          completionHandler:(void(^)(BOOL success, NSError *error))completionHandler {
    
    if (!progressHandler) progressHandler = ^(long long current, long long total, BOOL *stop) {};
    if (!completionHandler) completionHandler = ^(BOOL success, NSError *error) {};
    
    Downloader *downloader = [[Downloader alloc] init];

    if (!downloader || !request) {
        completionHandler(NO, nil);
        return;
    }
    
    downloader->request = request;
    downloader->outputStream = outStream;
    downloader->lastActivity = [NSDate timeIntervalSinceReferenceDate];
    downloader->progressHandler = progressHandler;
    downloader->completionHandler = completionHandler;
    [downloader performSelector:@selector(startDownloader) onThread:[Downloader workingThread] withObject:nil waitUntilDone:NO];
}

- (void)startDownloader {
    if (outputStream.streamStatus == NSStreamStatusNotOpen) [outputStream open];
    conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [self sendProgressEvent];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    expectedLength = response.expectedContentLength;
    [self sendProgressEvent];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSUInteger pos = 0;
    const unsigned char *bytes = data.bytes;
    NSUInteger len = data.length;
    
    while (pos < len) {
        NSUInteger written = [outputStream write:bytes + pos maxLength:len - pos];
        if (written > 0) {
            pos += written;
            numBytes += written;
            [self sendProgressEvent];
        }
        else {
            break;
        }
    }
    
    if (outputStream.streamStatus == NSStreamStatusError) {
        [self finishWithSuccess:NO error:outputStream.streamError];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self finishWithSuccess:NO error:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self finishWithSuccess:YES error:nil];
}

- (void)sendProgressEvent {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(failWithTimeout) object:nil];
    [self performSelector:@selector(failWithTimeout) withObject:nil afterDelay:3 * 60];
    BOOL stop = NO;
    progressHandler(numBytes, expectedLength, &stop);
    if (!stop) return;
    [self finishWithSuccess:NO error:nil];
}

- (void)failWithTimeout {
    [self finishWithSuccess:NO error:nil];
}

- (void)finishWithSuccess:(BOOL)success error:(NSError *)error {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(failWithTimeout) object:nil];
    if (error) NSLog(@"Downloader error: %@", error);
    [conn cancel];
    [outputStream close];
    completionHandler(success, error);
}

@end
