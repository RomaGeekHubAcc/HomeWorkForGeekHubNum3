//
//  PodcastsPlayer.h
//  HWforgeekHub3
//
//  Created by Roma on 09.11.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@class PodcastItem;

@interface PodcastsPlayerVC : UIViewController 
{
    UIImage *image;
    
    AVAudioPlayer *avPlayer;
    AVPlayer *player;
    
    NSData *audioData;
    
    NSTimer *timer;
    float duration;
    int podcastNumber;
    
    __weak IBOutlet UILabel *timingLabel;
    __weak IBOutlet UIImageView *podcastImageView;
    __weak IBOutlet UIImageView *backgroundImageView;
    __weak IBOutlet UISlider *sliderOutlet;
    __weak IBOutlet UIButton *nextButtonOutlet;
    __weak IBOutlet UIButton *pauseButtonOutlet;
    __weak IBOutlet UIButton *back15secButtonOutlet;
    __weak IBOutlet UILabel *anyLabel;
    __weak IBOutlet UILabel *podcastTitleLabel;
    __weak IBOutlet UILabel *autorLabel;
}

@property (nonatomic) PodcastItem *podcastItem;
@property (nonatomic) NSString *audioFileName;

- (IBAction)slider:(id)sender;
- (IBAction)back15secButton:(id)sender;
- (IBAction)playPauseButton:(id)sender;
- (IBAction)nextPodcastButton:(id)sender;


//@property (nonatomic) PodcastItem *pAsset;

@end
