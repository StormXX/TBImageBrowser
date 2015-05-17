//
//  TBImageBrowser.m
//  TBImageBrowser
//
//  Created by DangGu on 15/4/29.
//  Copyright (c) 2015年 Teambition. All rights reserved.
//

#import "TBImageBrowser.h"
#import "TBFileInfoBarView.h"
#import "TBImagePreviewController.h"
#import "constant.h"
#import <Masonry/Masonry.h>

static CGFloat const kPageSpacingKey =  20;

@interface TBImageBrowser () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) TBFileInfoBarView *infoBar;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic) NSInteger totalCount;

@end

@implementation TBImageBrowser

#pragma mark - life cycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self constructViewControllers];
    
    [self.pageViewController setViewControllers:@[self.viewControllers[self.currentIndex]]
                                      direction:UIPageViewControllerNavigationDirectionForward animated:NO
                                     completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.view addSubview:self.infoBar];
    
    [self layoutPageViews];
    NSLog(@"wtf");
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [self.view layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - event response

#pragma mark - private methods
- (void)layoutPageViews {
    WS(ws);
    [self.infoBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view);
        make.right.equalTo(ws.view);
        make.bottom.equalTo(ws.view);
        make.height.equalTo(@kInfoBarHeightKey);
    }];
}

- (void)constructViewControllers {
    if (self.imageNameArray.count != self.totalCount || self.thumbnailURLArray.count != self.totalCount || self.highQualityImageURLArray.count != self.totalCount) {
        return;
    }
    for (int i = 0; i < self.totalCount; i++) {
        TBImagePreviewController *imagePreviewController = [[TBImagePreviewController alloc] init];
        imagePreviewController.index = i;
        imagePreviewController.thumbnailURL = self.thumbnailURLArray[i];
        imagePreviewController.highQualityImageURL = self.highQualityImageURLArray[i];
        [self.viewControllers addObject:imagePreviewController];
    }
}

#pragma mark - UIPageViewController DataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(TBImagePreviewController *)viewController {
    if (viewController.index > 0) {
        return self.viewControllers[viewController.index - 1];
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(TBImagePreviewController *)viewController {
    if (viewController.index < self.totalCount - 1) {
        return self.viewControllers[viewController.index + 1];
    }
    return nil;
}

#pragma mark - UIPageViewController Delegate

#pragma mark - getters and setters
- (UIPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        _pageViewController = [[UIPageViewController alloc]
                              initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                              options:@{
                                        UIPageViewControllerOptionInterPageSpacingKey : @(kPageSpacingKey)
                                        }];
        _pageViewController.view.frame = self.view.frame;
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
}

- (TBFileInfoBarView *)infoBar {
    if (_infoBar == nil) {
        _infoBar = [[TBFileInfoBarView alloc] initWithImageName:@"Loading..." andParameters:nil];
        _infoBar.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _infoBar;
}

- (NSMutableArray *)viewControllers {
    if (_viewControllers == nil) {
        _viewControllers = [[NSMutableArray alloc] init];
    }
    return _viewControllers;
}

- (NSInteger)totalCount {
    if (_totalCount != self.thumbnailURLArray.count) {
        _totalCount = self.thumbnailURLArray.count;
    }
    return _totalCount;
}
@end
