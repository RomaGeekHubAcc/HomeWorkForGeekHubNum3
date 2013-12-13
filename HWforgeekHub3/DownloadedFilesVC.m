//
//  DownloadedFilesVC.m
//  HWforgeekHub3
//
//  Created by Roman Rybachenko on 21.11.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import "Defines.h"
#import "DownloadedFilesVC.h"
#import "PodcastsPlayerVC.h"

@interface DownloadedFilesVC ()

@end

@implementation DownloadedFilesVC

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
	
    [scrollView setScrollEnabled:YES];
    
    audiotrackNamesArray = [self getArrayWithAudioTrackNames];
    arrayLabelsButtons = [NSMutableArray array];
    
    float yAdd = (labelPodcastHeight*audiotrackNamesArray.count);
    if (yAdd+86 > 568) {
        viewOverScrollView.frame = CGRectMake(0, 0, 320, 86+(yAdd-1));
    }
    [scrollView setContentSize:viewOverScrollView.frame.size];
    [self createLabelsAndButtonsForDownload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)playAudiofile:(UIButton *)sender {
    PodcastsPlayerVC *playerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PodcastsPlayerVC"];
    playerVC.audioFileName = [audiotrackNamesArray objectAtIndex:sender.tag];
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (void)deleteAudiofile:(UIButton*)sender {
    butDeleteTag = sender.tag;
    alertView = [[UIAlertView alloc]initWithTitle:@"Warning!" message:@"Are you sure you want to delete it podcast?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alertView.tag = 1;
    alertView.alertViewStyle = 0;
    [alertView show];
}

#pragma mark - AlertView

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self deleteAudiofileAtPaht:[audiotrackNamesArray objectAtIndex:butDeleteTag]];
        
        NSDictionary *dict = [arrayLabelsButtons objectAtIndex:butDeleteTag];
        
//        UILabel *l = [dict objectForKey:labelKey];
//        [l removeFromSuperview];
//        l = nil;
        
        [[dict objectForKey:labelKey] removeFromSuperview];
        [[dict objectForKey:buttonPlKey] removeFromSuperview];
        [[dict objectForKey:buttonDelKey] removeFromSuperview];
        
        [arrayLabelsButtons removeObjectAtIndex:butDeleteTag];
        [self viewDidLoad];
        butDeleteTag = -1;
    }
}

#pragma mark - Others

- (void)deleteAudiofileAtPaht:(NSString*)path {
    NSFileManager*fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

- (NSMutableArray*)getArrayWithAudioTrackNames {
    NSString*path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)lastObject];
    path=[path stringByAppendingPathComponent:PathToArrayWithAudioNames];
    
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:path];
    if (!arr) {
        arr = [NSMutableArray new];
    }
    return arr;
}

- (void)createLabelsAndButtonsForDownload {
    for (int i = 0; i < audiotrackNamesArray.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 86+(i*labelPodcastHeight), 100, 26)];
        label.tag = i;
        label.backgroundColor = [UIColor clearColor];
        label.textColor=[UIColor blackColor];
        label.numberOfLines=1;
        label.text = [NSString stringWithFormat:@"Podcast %i", i+1 ];
        [viewOverScrollView addSubview:label];
        
        UIButton *bP = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bP.tag = i;
        [bP addTarget:self
                   action:@selector(playAudiofile:)
         forControlEvents:UIControlEventTouchDown];
        bP.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        [bP setTitle:@"Play" forState:UIControlStateNormal];
        bP.frame = CGRectMake(130, 86+(i*labelPodcastHeight), 60, 30);
        [viewOverScrollView addSubview:bP];
        
        UIButton *bDel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        bDel.tag = i;
        [bDel addTarget:self
                   action:@selector(deleteAudiofile:)
         forControlEvents:UIControlEventTouchDown];
        bDel.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
        [bDel setTitle:@"Del" forState:UIControlStateNormal];
        bDel.frame = CGRectMake(254, 86+(i*labelPodcastHeight), 46, 30);
        [viewOverScrollView addSubview:bDel];
        
        NSDictionary *dict = @{ labelKey : label,
            buttonPlKey : bP,
            buttonDelKey : bDel};
        [arrayLabelsButtons addObject:dict];
    }
}


@end
