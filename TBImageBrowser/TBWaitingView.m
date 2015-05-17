//
//  TBWaitingView.m
//  Teambition
//
//  Created by DangGu on 15/4/16.
//  Copyright (c) 2015年 Teambition. All rights reserved.
//

#import "TBWaitingView.h"

static CGFloat const kTBWaitingViewMargin = 10.0;

@interface TBWaitingView()
@property (nonatomic, strong) UIImageView *logoView;
@end

@implementation TBWaitingView
@synthesize logoView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
//        self.backgroundColor = [UIColor blackColor];
        self.clipsToBounds = YES;
        
        logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-logo-white"]];
        logoView.center = self.center;
        [self addSubview:logoView];
        
    }
    return self;
}

- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    [self setNeedsDisplay];
    if (progress > 1) {
        [self removeFromSuperview];
    }
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    CGFloat centerX = rect.size.width / 2;
    CGFloat centerY = rect.size.height / 2;
    
    [[UIColor whiteColor] set];
    
    CGContextSetLineWidth(currentContext, 2);
    CGContextSetLineCap(currentContext, kCGLineCapRound);
    CGFloat start = - M_PI / 2;
    CGFloat end = - M_PI / 2 + self.progress * M_PI * 2 + 0.05;
    CGFloat radius = MIN(rect.size.width, rect.size.height) / 2 - kTBWaitingViewMargin;
    CGContextAddArc(currentContext, centerX, centerY, radius, start, end, 0);
    CGContextStrokePath(currentContext);
}

@end
