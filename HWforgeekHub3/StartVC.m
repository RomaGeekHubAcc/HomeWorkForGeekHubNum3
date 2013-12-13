//
//  StartVC.m
//  HWforgeekHub3
//
//  Created by Roma on 27.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//


#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"
#import "StartVC.h"
#import "MyCell.h"
#import "PodcastItem.h"
#import "DetailVC.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreFoundation/CoreFoundation.h>
#import "XMLReader.h"
#import "Defines.h"
#import "Podcast.h"

@interface StartVC ()

@end

@implementation StartVC

#pragma mark -viewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    countTegsWithImage = 0;
    _tableView.hidden = YES;
    _activityIndicator.hidden = YES;
    _tableView.backgroundColor = [UIColor lightGrayColor];
    
    _podcast = [[Podcast alloc]init];
    
    _labelUrlPodcasts1.text = @"Podcasts about automobiles";
    _labelUrlPodcasts2.text = @"Podcasts about memories";
    _labelUrlPodcasts3.text = @"Podcasts about sport";
    _labelUrlPodcasts1.userInteractionEnabled = YES;
    _labelUrlPodcasts2.userInteractionEnabled = YES;
    _labelUrlPodcasts3.userInteractionEnabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    NSLog(@"touchesBegan:withEvent:");
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _podcast.arrWithURLs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    PodcastItem *podcastItem = [_podcast.arrWithURLs objectAtIndex:indexPath.row];
    
    cell.titleOutlet.text = podcastItem.title;
    cell.updatedOutlet.text = podcastItem.pubDate;
    
    NSURL *url = [NSURL URLWithString:podcastItem.imageStr];
    [cell.imgView setImageWithURL:url];

    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.list = [_podcast.arrWithURLs objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor colorWithRed:220.0f/255.0f green:220.0f/255.0f blue:220.0f/255.0f alpha:1.0f];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    textField.backgroundColor = [UIColor whiteColor];
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textFieldContent = _textField.text;
    
    BOOL netStatus = [StartVC networkStatus];
    NSLog(@"- Network Status - %d", netStatus);
    if (!netStatus) {
        alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Sorry, network connection is disable. Connect and try again." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        alertView.tag = 1;
        [alertView show];
    }
    
    [textField resignFirstResponder];
    
    _activityIndicator. hidden = NO;
    [_activityIndicator startAnimating];
    [self.view bringSubviewToFront:_activityIndicator];
    
#warning тут я задаю адресу, за якою завантажувати подкаст
    [self loadDataFromPath:_textField.text];
    
    [self hideLabelsWithPodcastName];
    
    return YES;
}

#pragma mark - Network Status
+ (NetworkStatus)networkStatus {
    static Reachability *reach = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        reach = [Reachability reachabilityForInternetConnection];
    });
    
    NSLog(@"----Internet status - %@", reach);
    
    return [reach currentReachabilityStatus];
}


#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_rssData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"---Error - %@", error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *result = [[NSString alloc] initWithData:_rssData encoding:NSUTF8StringEncoding];
    NSLog(@"-----Result - %@",result);
    XMLReader *reader = [[XMLReader alloc]init];
    _podcast.arrWithURLs = [reader parseXMLwithData:_rssData];
       
    if (_podcast.arrWithURLs.count > 0) {
        
        _tableView.frame = CGRectMake(0, 64, 320, screenSize.size.height - 64);
        _tableView.hidden = NO;
        [_activityIndicator stopAnimating];
        _activityIndicator.hidden = YES;
        [_tableView reloadData];
    }
}


#pragma mark - Others

- (void)loadDataFromPath:(NSString *)path {
    
    NSURL *url = [NSURL URLWithString:path];
    
    NSURLRequest *request=[NSURLRequest requestWithURL:url
                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                       timeoutInterval:60.0];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request
                                                                   delegate:self];
    if (theConnection) {
         self.rssData = [NSMutableData data];
        [self showActivityIndicator];
    }
    
}

- (void)hideLabelsWithPodcastName {
    _labelUrlPodcasts1.hidden = YES;
    _labelUrlPodcasts2.hidden = YES;
    _labelUrlPodcasts3.hidden = YES;
}

- (void)showActivityIndicator {
    _activityIndicator. hidden = NO;
    [_activityIndicator startAnimating];
    [self.view bringSubviewToFront:_activityIndicator];
}

#pragma mark - Actions

- (IBAction)tapLabel1:(id)sender {
    _textField.text = PODCASTS_OTHER;
    [self loadDataFromPath:PODCASTS_OTHER];
    [self hideLabelsWithPodcastName];
}

- (IBAction)tapLabel2:(id)sender {
    _textField.text = PODCASTS_ABOUT_MEMORY;
    [self loadDataFromPath:PODCASTS_ABOUT_MEMORY];
    [self hideLabelsWithPodcastName];
}

- (IBAction)tapLabel3:(id)sender {
    _textField.text = PODCASTS_SPORT;
    [self loadDataFromPath:PODCASTS_SPORT];
    [self hideLabelsWithPodcastName];
}

@end
