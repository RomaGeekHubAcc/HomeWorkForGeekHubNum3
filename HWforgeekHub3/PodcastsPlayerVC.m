//
//  PodcastsPlayer.m
//  HWforgeekHub3
//
//  Created by Roma on 09.11.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import "PodcastsPlayerVC.h"
#import "Defines.h"
#import "UIImage+RoundedCorner.h"
#import "PodcastAsset.h"

@interface PodcastsPlayerVC ()

@end

@implementation PodcastsPlayerVC

#pragma mark - viewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    image = [_podcastAsset.image roundedCornerImage:4 borderSize:1];
	podcastImageView.image = image;
    podcastTitleLabel.text = _podcastAsset.title;
    [self createCustomSlider];
    
    if (IS_OS_7_OR_LATER) {
//        podcastImageView.frame = CGRectMake(podcastImageView.frame.origin.x, podcastImageView.frame.origin.y+60, podcastImageView.frame.size.width, podcastImageView.frame.size.height);
        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tabBar.png"] forBarMetrics:UIBarMetricsDefault];
    }

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)slider:(id)sender {
}

- (IBAction)back15secButton:(id)sender {
}

- (IBAction)pauseButton:(id)sender {
}

- (IBAction)nextPodcastButton:(id)sender {
}

#pragma mark - custom

- (void)createCustomSlider {
//    UIImage *sliderImage = [UIImage imageNamed:@"scroll_Image.png"];
//    sliderOutlet.maximumValueImage = sliderImage;
    
    [sliderOutlet setThumbImage:[UIImage imageNamed:@"sliderHandle.png"] forState:UIControlStateNormal];
    
//    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0.0f, 2.0f, 0.0f, 0.0f);
//    sliderImage = [sliderImage resizableImageWithCapInsets:edgeInsets];
//    [sliderOutlet setMinimumTrackImage:sliderImage forState:UIControlStateNormal];
    
//    [sliderOutlet setThumbImage:[UIImage imageNamed:@"scroll_Image@2x.png"] forState:UIControlStateNormal];
//    [sliderOutlet setMinimumTrackImage:[UIImage imageNamed:@"scroll_Image@2x.png"] forState:UIControlStateNormal];
    //[sliderOutlet setMaximumTrackImage:[UIImage imageNamed:@"scroll_Image@2x.png"] forState:UIControlStateNormal];
}


@end
