//
//  StartVC.h
//  HWforgeekHub3
//
//  Created by Roma on 27.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PodcastItem;
@class Podcast;

@interface StartVC : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, NSXMLParserDelegate>
{
    int countTegsWithImage;
    UIAlertView *alertView;
    
    NSString *textFieldContent;
}
@property (nonatomic) Podcast *podcast;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *labelUrlPodcasts1;
@property (weak, nonatomic) IBOutlet UILabel *labelUrlPodcasts2;
@property (weak, nonatomic) IBOutlet UILabel *labelUrlPodcasts3;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

//@property (nonatomic) NSString *textFieldContent;

@property (nonatomic, retain) NSMutableData *rssData;

@property (nonatomic, retain) NSString * currentElement;
@property (nonatomic) NSMutableString *currentTitle;
@property (nonatomic) NSMutableString *currentUpdated;
@property (nonatomic) NSMutableString *currentDescription;
@property (nonatomic) NSString *currentBigImageStr;

- (IBAction)tapLabel1:(id)sender;
- (IBAction)tapLabel2:(id)sender;
- (IBAction)tapLabel3:(id)sender;

@end
