//
//  StartVC.m
//  HWforgeekHub3
//
//  Created by Roma on 27.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#define PODCAST_ADRESS @"https://itunes.apple.com/ua/rss/toppodcasts/limit=50/genre=1304/explicit=true/xml"
#define PODCASTS_COMEDY @"https://itunes.apple.com/ua/rss/toppodcasts/limit=25/genre=1303/xml"

// теги:
#define ENTRY @"entry"
#define TITLE @"title"
#define UPDATED @"updated"
#define SUMMARY @"summary"
#define ICON_IMAGE @"im:image"

#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"
#import "StartVC.h"
#import "MyCell.h"
#import "ContentList.h"
#import "DetailVC.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreFoundation/CoreFoundation.h>
#import "XMLReader.h"

@interface StartVC ()

@end

@implementation StartVC

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
	
    arrWithURLs = [[NSMutableArray alloc]init];
    countTegsWithImage = 0;
    _tableView.hidden = YES;
    _activityIndicator.hidden = YES;
    _tableView.backgroundColor = [UIColor lightGrayColor];
    if (!_theList) {
        _theList = [[ContentList alloc]init];
    }
    
    if (!_myArray) {
        _myArray = [[NSMutableArray alloc]init];
    }
    
    _urlPodcast.text = PODCASTS_COMEDY;
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
    return _myArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[MyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    ContentList *list = [_myArray objectAtIndex:indexPath.row];
    
    cell.titleOutlet.text = list.title;
    cell.updatedOutlet.text = list.updated;
    
    
    NSURL *url = list.urlOfImage;
    [cell.imgView setImageWithURL:url];
    NSLog(@"--- list.url- %@", list.urlOfImage);
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailVC *detailVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DetailVC"];
    detailVC.list = [_myArray objectAtIndex:indexPath.row];
    
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
    _textFieldContent = _textField.text;
    
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
    [self loadDataFromPath:PODCAST_ADRESS /*_textField.text*/ ];
    
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
    _myArray = [reader parseXMLwithData:_rssData];
    
    NSMutableArray *testAr = [reader getArrayWithURLs];
    
    if (testAr.count > 0 ) {
        for (int i = 1; i < testAr.count+1; i++) {
            if (i%3 == 0) {
                [arrWithURLs addObject:[testAr objectAtIndex:i-1]];
            }
        }
    }
    for (int i = 0; i < _myArray.count; i++) {
        ContentList * l = [_myArray objectAtIndex:i];
        l.urlOfImage = [arrWithURLs objectAtIndex:i];
        [_myArray replaceObjectAtIndex:i withObject:l];
    }
    
    if (_myArray.count > 0) {
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
    }
    
}


@end
