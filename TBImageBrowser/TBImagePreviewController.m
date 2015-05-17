//
//  TBImagePreviewController.m
//  TBImageBrowser
//
//  Created by DangGu on 15/4/29.
//  Copyright (c) 2015年 Teambition. All rights reserved.
//

#import "TBImagePreviewController.h"
#import "TBWaitingView.h"
#import "constant.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface TBImagePreviewController () <UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) TBWaitingView *waitingView;
@property (nonatomic, strong) UIImage *thumbnailImage;
@property (nonatomic) BOOL isHightQualityImageExist;

@end

@implementation TBImagePreviewController

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.imageView) {
        [self resetImageViewToFitInScrollView:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WS(ws);
    [self.scrollView addSubview:self.imageView];
    [self.view addSubview:self.scrollView];
    
    [self isHighQualityImageExist:^(UIImage *image) {
        ws.imageView.image = image;
        [self reloadScrollView];
//        [self addLongPressForSavingToAlbum];
        ws.isHightQualityImageExist = YES;
//        oneTap.enabled = YES;
    } notExist:^{
        ws.isHightQualityImageExist = NO;
        [self isThumbnailImageExist:^(UIImage *image) {
            ws.imageView.image = image;
            self.thumbnailImage = image;
            [self reloadScrollView];
        } notExist:^{
            [self fetchThumbnailImage];
        }];
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.isHightQualityImageExist) {
        [self fetchHighQualityImage];
    }
}

- (void)viewWillLayoutSubviews {
    [self setZoomParametersForSize];
    if (self.scrollView.zoomScale < self.scrollView.minimumZoomScale) {
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    }
    [self recenterImageInScrollView];
}

- (void)viewDidLayoutSubviews {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - event response
- (void)resetImageViewToFitInScrollView:(UITapGestureRecognizer *)tap{
    if (tap) {
        [UIView animateWithDuration:0.33
                         animations:^{
                             self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
                             [self recenterImageInScrollView];
                         }];
    } else {
        self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
        [self recenterImageInScrollView];
    }
    
}

#pragma mark - private method
- (void)setZoomParametersForSize{
    CGSize imageSize = self.imageView.bounds.size;
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    CGFloat widthScale = scrollViewSize.width / imageSize.width;
    CGFloat heightScale = scrollViewSize.height / scrollViewSize.height;
    CGFloat minScale = MIN(widthScale, heightScale);
    
    self.scrollView.minimumZoomScale = minScale;
    self.scrollView.maximumZoomScale = 3.0;
}

- (void)recenterImageInScrollView{
    CGSize scrollViewSize = self.scrollView.bounds.size;
    CGSize imageSize = self.imageView.frame.size;
    
    CGFloat horizonalSpace = imageSize.width < scrollViewSize.width ? (scrollViewSize.width - imageSize.width) / 2 : 0;
    CGFloat verticalSpace = imageSize.height < scrollViewSize.height ? (scrollViewSize.height - imageSize.height) / 2 : 0;
    
    self.scrollView.contentInset = UIEdgeInsetsMake(verticalSpace, horizonalSpace, verticalSpace, horizonalSpace);
}

- (void)reloadScrollView{
    [self.imageView sizeToFit];
    [self setZoomParametersForSize];
    self.scrollView.contentSize = self.imageView.bounds.size;
    self.scrollView.zoomScale = self.scrollView.minimumZoomScale;
    [self recenterImageInScrollView];
}

- (void)fetchHighQualityImage {
    WS(ws)
    if (self.waitingView) {
        [self.waitingView removeFromSuperview];
    }
    [self.view addSubview:self.waitingView];
    
    [self.imageView sd_setImageWithURL:self.highQualityImageURL
                 placeholderImage:self.thumbnailImage
                          options:SDWebImageRetryFailed
                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                             ws.waitingView.progress = (CGFloat)receivedSize / expectedSize;
                         }
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image) {
                                [self reloadScrollView];
//                                [self addLongPressForSavingToAlbum];
//                                isHightQualityImageExist = YES;
//                                oneTap.enabled = YES;
                            }
                            [self.waitingView removeFromSuperview];
                        }];
}

- (void)fetchThumbnailImage {
    [self.imageView sd_setImageWithURL:self.thumbnailURL
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            if (image) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    self.thumbnailImage = image;
                                    [self reloadScrollView];
                                });
                            }
                        }];
}

- (void)isHighQualityImageExist:(void (^)(UIImage *image))exist notExist:(void (^)())noExist {
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    UIImage *highQualityImage = [imageCache imageFromDiskCacheForKey:[self.highQualityImageURL absoluteString]];
    if (highQualityImage) {
        exist(highQualityImage);
    } else {
        noExist();
    }
}

- (void)isThumbnailImageExist:(void(^)(UIImage *image))exist notExist:(void (^)())noExist {
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    UIImage *thumbnailImage = [imageCache imageFromDiskCacheForKey:[self.thumbnailURL absoluteString]];
    if (thumbnailImage) {
        exist(thumbnailImage);
    } else {
        noExist();
    }
}

#pragma mark - UIScrollView Delegate 
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self recenterImageInScrollView];
}

#pragma mark - getters and setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIImageView *)imageView {
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (TBWaitingView *)waitingView {
    if (_waitingView == nil) {
        _waitingView = [[TBWaitingView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        _waitingView.center = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    }
    return _waitingView;
}
@end
