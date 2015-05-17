//
//  TBImageBrowser.h
//  TBImageBrowser
//
//  Created by DangGu on 15/4/29.
//  Copyright (c) 2015年 Teambition. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBImageBrowser : UIViewController

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, copy) NSArray *thumbnailURLArray;
@property (nonatomic, copy) NSArray *highQualityImageURLArray;
@property (nonatomic, copy) NSArray *imageNameArray;
@property (nonatomic) BOOL isFullScreenMode;

@end
