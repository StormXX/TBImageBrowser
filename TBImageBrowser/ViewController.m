//
//  ViewController.m
//  TBImageBrowser
//
//  Created by DangGu on 15/4/28.
//  Copyright (c) 2015年 Teambition. All rights reserved.
//

#import "ViewController.h"
#import "TBImageBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    NSMutableArray *thumbnailUrlArray = [NSMutableArray array];
    NSMutableArray *imageNameArray = [NSMutableArray array];
    for (int i = 1; i <= 8; i++) {
        NSString *urlStr = [NSString stringWithFormat:@"http://myimagestorage.qiniudn.com/%d.pic.jpg",i];
        NSURL *url = [NSURL URLWithString:urlStr];
        NSString *imageName = [NSString stringWithFormat:@"%d.pic.jpg",i];
        [thumbnailUrlArray addObject:url];
        [imageNameArray addObject:imageName];
    }
    
    TBImageBrowser *browser = [[TBImageBrowser alloc] init];
    browser.thumbnailURLArray = thumbnailUrlArray;
    browser.highQualityImageURLArray = thumbnailUrlArray;
    browser.imageNameArray = imageNameArray;
    browser.currentIndex = 0;
    [self.navigationController pushViewController:browser animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end