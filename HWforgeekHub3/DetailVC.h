//
//  DetailVC.h
//  HWforgeekHub3
//
//  Created by Roma on 27.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PodcastItem;

@interface DetailVC : UIViewController <UITextViewDelegate, NSURLConnectionDataDelegate>
{
    NSMutableData *receivedData;
    long long expectedDataLength;
    float stepProgress;
    NSMutableArray *buttonsDownloadArr;
    int buttonDownloadingTag;
    BOOL isDownloading;
    NSFileHandle *fh;
    NSMutableArray *audiotrackNames;
    
}

@property (nonatomic) PodcastItem *list;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *viewOverScrollView;

@property (weak, nonatomic) IBOutlet UIButton *playerOutlet;
@property (weak, nonatomic) IBOutlet UIButton *goToOutlet;
- (IBAction)goToAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
- (IBAction)swipeGesRes:(id)sender;
- (IBAction)player:(id)sender;




@end
