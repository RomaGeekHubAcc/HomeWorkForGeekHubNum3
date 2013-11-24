//
//  DetailVC.m
//  HWforgeekHub3
//
//  Created by Roma on 27.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import "DetailVC.h"
#import "PodcastAsset.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PodcastsPlayerVC.h"

@interface DetailVC ()

@end

@implementation DetailVC

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
    
    _titleLabel.text = _list.title;
    _descriptionLabel.text = _list.description;
    _updatedLabel.text = _list.pubDate;
    [_imageView setImageWithURL:_list.urlOfImage];
    _list.image = _imageView.image;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Actions
- (IBAction)player:(id)sender {
    PodcastsPlayerVC *playerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PodcastsPlayerVC"];
    playerVC.podcastAsset = _list;
    [self.navigationController pushViewController:playerVC animated:YES];
}
@end
