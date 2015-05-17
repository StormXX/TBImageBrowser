//
//  TBImagePreviewController.h
//  TBImageBrowser
//
//  Created by DangGu on 15/4/29.
//  Copyright (c) 2015年 Teambition. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TBImagePreviewController : UIViewController
@property (nonatomic) NSInteger index;
@property (nonatomic, copy) NSURL *thumbnailURL;
@property (nonatomic, copy) NSURL *highQualityImageURL;
@end
