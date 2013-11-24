//
//  PodcastsPlayer.h
//  HWforgeekHub3
//
//  Created by Roma on 09.11.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PodcastAsset;

@interface PodcastsPlayerVC : UIViewController
{
    UIImage *image;
    
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

@property (nonatomic) PodcastAsset *podcastAsset;

- (IBAction)slider:(id)sender;
- (IBAction)back15secButton:(id)sender;
- (IBAction)pauseButton:(id)sender;
- (IBAction)nextPodcastButton:(id)sender;


@property (nonatomic) PodcastAsset *pAsset;

@end
