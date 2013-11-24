//
//  DetailVC.h
//  HWforgeekHub3
//
//  Created by Roma on 27.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PodcastAsset;

@interface DetailVC : UIViewController

@property (nonatomic) PodcastAsset *list;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
- (IBAction)player:(id)sender;

@end
