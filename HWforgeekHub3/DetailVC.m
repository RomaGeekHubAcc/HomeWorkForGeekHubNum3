//
//  DetailVC.m
//  HWforgeekHub3
//
//  Created by Roma on 27.10.13.
//  Copyright (c) 2013 Roma. All rights reserved.
//

#import "DetailVC.h"
#import "PodcastItem.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PodcastsPlayerVC.h"
#import "Defines.h"
#import "Downloader.h"
#import "DownloadedFilesVC.h"

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
    
    if (IS_OS_7_OR_LATER) {
        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
        [[UINavigationBar appearance] setBarTintColor:[UIColor yellowColor]];
    }
    
    audiotrackNames = [self getArrayWithAudioTrackNames];
    
    _progressView.hidden = YES;
    _titleLabel.text = _list.title;
    _authorLabel.text = _list.autor;
    _updatedLabel.text = _list.pubDate;
    [_imageView setImageWithURL: [NSURL URLWithString:_list.imageStr]];
    _list.image = _imageView.image;
    
    _textViewDescription.delegate = self;
    _textViewDescription.text = _list.description;
    
    [_scrollView setScrollEnabled:YES];

    
    
    buttonsDownloadArr = [[NSMutableArray alloc]init];
    float yAdd = (labelPodcastHeight*_list.audioFilePathArray.count);
    if (_list.audioFilePathArray.count ==1) {
        yAdd = 0;
        _viewOverScrollView.frame = CGRectMake(0, 0, 320, 568);
    }
    else _viewOverScrollView.frame = CGRectMake(0, 0, 320, 460+(yAdd-1));
    
    _goToOutlet.frame = CGRectMake(20, _viewOverScrollView.frame.size.height-40, 185, 38);
    
    [_scrollView setContentSize:_viewOverScrollView.frame.size];
    

    [self createLabelsAndButtonsForDownload];
    
    if (!IS_OS_7_OR_LATER) {
        if (buttonsDownloadArr.count == 1) {
            _goToOutlet.frame = CGRectMake(20, 496, 185, 38);
            _playerOutlet.frame = CGRectMake(235, 496, 60, 38);
        }
    }
}

- (void)changeProgressViewValue {
    float step = receivedData.length/(float)expectedDataLength;
    [_progressView setProgress:step animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeProgressViewValue) name:@"notifChangeReceivedData" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"notifChangeReceivedData" object:nil];
}
#pragma mark - Actions

- (IBAction)goToAction:(id)sender {
    DownloadedFilesVC *downloaddeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"DownloadedFilesVC"];
    [self.navigationController pushViewController:downloaddeVC animated:YES];
}

- (IBAction)swipeGesRes:(id)sender {
    PodcastsPlayerVC *playerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PodcastsPlayerVC"];
    playerVC.podcastItem = _list;
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (IBAction)player:(id)sender {
    PodcastsPlayerVC *playerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"PodcastsPlayerVC"];
    playerVC.podcastItem = _list;
    [self.navigationController pushViewController:playerVC animated:YES];
}

- (void)downloadPodcast:(UIButton *)sender {
    if (isDownloading) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Зараз завантажується інший файл" message:@"Дочекайся закінчення й спробуй ще раз" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    NSURL *url = [NSURL URLWithString:[_list.audioFilePathArray objectAtIndex:sender.tag]];
    
    NSString *trackName = [self getNameForAudiotrack];
    NSString* pathToDownload = [self getPathForDownloadAudioWithName:trackName];
    isDownloading = YES;
    buttonDownloadingTag = sender.tag;
    sender.hidden = YES;
    _progressView.hidden = NO;
    [_progressView setProgress:0 animated:NO];
    
    CGRect frameProgressView = CGRectMake(sender.frame.origin.x, sender.frame.origin.y+(sender.frame.size.height/2), 114, _progressView.bounds.size.height);
    _progressView.frame = frameProgressView;
    
//    NSOutputStream *oStream = [NSOutputStream outputStreamToFileAtPath:pathToDownload append:NO];
    
//    [Downloader downloadWithRequest:[NSURLRequest requestWithURL:url]
//                       outputStream:oStream
//                    progressHandler:^(long long current, long long total, BOOL *stop) {
//                        dispatch_async(dispatch_get_main_queue(), ^{
//                            //показати прогрес..
//                            
//                            float step = current/(float)total;
//                            [_progressView setProgress:step animated:YES];
//                            //[[NSNotificationCenter defaultCenter] postNotificationName:@"notifChangeReceivedData"object:nil];
//                            
//                        });
//                    }
//                  completionHandler:^(BOOL success, NSError *dError) {
//                      dispatch_async(dispatch_get_main_queue(), ^{
//                          if (success) {
//                              //файл скачався, проапдейтити UI і хз, що там тобі ще треба..
//                              
//                              _progressView.hidden = YES;
//                              UIButton *button = [buttonsDownloadArr objectAtIndex:buttonDownloadingTag];
//                              button.hidden = NO;
//                              button.enabled = NO;
//                              button.titleLabel.textAlignment = NSTextAlignmentCenter;
//                              button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
//                              button.titleLabel.textColor = [UIColor grayColor];
//                              [button setTitle:@"Downloaded" forState:UIControlStateNormal];
//                          }
//                          else {
//                              //видалити файл, бо він не докачався і буде тепер лежати невірне
//                              
//                              [self deleteAudiofileAtPaht:pathToDownload];
//                              _progressView.hidden = YES;
//                              UIButton *button = [buttonsDownloadArr objectAtIndex:buttonDownloadingTag];
//                              button.hidden = NO;
//                              isDownloading = NO;
//                          }
//                      });
//                  }];
    
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:300];
    
    request.HTTPMethod = @"GET";
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        isDownloading = YES;
        buttonDownloadingTag = sender.tag;
        sender.hidden = YES;
        _progressView.hidden = NO;
        CGRect frameProgressView = CGRectMake(sender.frame.origin.x, sender.frame.origin.y+(sender.frame.size.height/2), 114, _progressView.bounds.size.height);
        _progressView.frame = frameProgressView;
        [_progressView setProgress:0 animated:NO];
        
    }
    else {
        // щось вивести про помилку з'єднання чи т.п.
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

#pragma mark - Custom

//- (void)downloadingFileWithUrl:(NSURL*)url toPath:(NSString*)path{
//    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url]
//                                       queue:[NSOperationQueue mainQueue]
//                                        completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
//                                                    [data writeToFile:path atomically:YES];
//                                        }];
//}

- (void)createLabelsAndButtonsForDownload {
    for (int i = 0; i < _list.audioFilePathArray.count; i++) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 412+(i*labelPodcastHeight), 150, 26)];
        label.tag = i;
        label.backgroundColor = [UIColor clearColor];
        label.textColor=[UIColor blackColor];
        label.numberOfLines=1;
        label.text = [NSString stringWithFormat:@"Podcast %i", i+1 ];
        [_viewOverScrollView addSubview:label];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.tag = i;
        [button addTarget:self
                   action:@selector(downloadPodcast:)
         forControlEvents:UIControlEventTouchDown];
        [button setTitle:@"Download" forState:UIControlStateNormal];
        button.frame = CGRectMake(180, 412+(i*labelPodcastHeight), 116, 26);
        [_viewOverScrollView addSubview:button];
        [buttonsDownloadArr addObject:button];
    }
    UIButton *b = [buttonsDownloadArr lastObject];
    _goToOutlet.frame = CGRectMake(20, b.frame.origin.y+labelPodcastHeight+6, 170, 38);
    _playerOutlet.frame = CGRectMake(235, b.frame.origin.y+labelPodcastHeight+6, 60, 38);
}

- (NSString*)getPathForDownloadAudioWithName:(NSString*)trackName {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cashDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [cashDirectory stringByAppendingPathComponent:trackName];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
        return dataPath;
    }
    return dataPath;
}


////////////////////////////////////////////////////////////////////////
- (NSString*)getSimpleTestPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *dataPath = [docDirectory stringByAppendingPathComponent:@"audiofle"];
    NSError *error;
    if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:&error];
        return dataPath;
    }
    
    return dataPath;
}
////////////////////////////////////////////////////////////////////////

- (NSMutableArray*)getArrayWithAudioTrackNames {
    NSString*path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)lastObject];
    path=[path stringByAppendingPathComponent:PathToArrayWithAudioNames];
    
    NSMutableArray *arr = [NSMutableArray arrayWithContentsOfFile:path];
    if (!arr) {
        arr = [NSMutableArray new];
    }
    return arr;
}

- (void)saveArrayWithAudioTrackNamesToFile {
    NSString*path=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES)lastObject];
    path=[path stringByAppendingPathComponent:PathToArrayWithAudioNames];
    
    [audiotrackNames writeToFile:path atomically:YES];
}

- (NSString*)getNameForAudiotrack {
    return [NSString stringWithFormat:@"audioFile%lu", (unsigned long)audiotrackNames.count];
}

- (void)deleteAudiofileAtPaht:(NSString*)path {
    NSFileManager*fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    // получен ответ от сервера
    receivedData = [NSMutableData dataWithLength:0];
    
    if ([response statusCode] == 200) {
        expectedDataLength = [response expectedContentLength];
        //stepProgress = (float)1.0/expectedDataLength;
    }
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"notifChangeReceivedData"object:nil];
//    if (!fh) {
//        NSString *trackName = [self getNameForAudiotrack];
//        fh = [NSFileHandle fileHandleForReadingAtPath:[self createFolderForDownloadAudioWithName:trackName]];
//    }
//    [fh writeData:receivedData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    // данные получены
    _progressView.hidden = YES;
    UIButton *button = [buttonsDownloadArr objectAtIndex:buttonDownloadingTag];
    button.hidden = NO;
    button.enabled = NO;
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
    button.titleLabel.textColor = [UIColor grayColor];
    [button setTitle:@"Downloaded" forState:UIControlStateNormal];
    
    NSLog(@"--receivedData. count - %lu", (unsigned long)receivedData.length);
    isDownloading = NO;
    
    NSString *trackName = [self getNameForAudiotrack];
    NSLog(@"%@", trackName);
    NSData* arhData = [NSKeyedArchiver archivedDataWithRootObject:receivedData];
    [arhData writeToFile:[self getSimpleTestPath] atomically:YES];
    
//    [receivedData writeToFile:[self getPathForDownloadAudioWithName:trackName] atomically:YES];
//    [audiotrackNames addObject:trackName];
//    trackName = nil;
//    [self saveArrayWithAudioTrackNamesToFile];
    
//    fh = nil;
    
    NSLog(@"-- audiotracks count - %d",audiotrackNames.count);
    NSLog(@"--- Names ---");
    for (int i = 0; i < audiotrackNames.count; i++) {
        NSLog(@"--- %@", [audiotrackNames objectAtIndex:i]);
    }
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    fh = nil;
    
    // выводим сообщение об ошибке
    NSString *errorString = [[NSString alloc] initWithFormat:@"Connection failed! Error - %@ %@ %@",
                             [error localizedDescription],
                             [error description],
                             [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]];
    NSLog(@"%@",errorString);
}



@end
