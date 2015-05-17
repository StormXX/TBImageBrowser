//
//  TBFileInfoBarView.m
//  Teambition
//
//  Created by DangGu on 15/4/14.
//  Copyright (c) 2015年 Teambition. All rights reserved.
//

#import "TBFileInfoBarView.h"
#import <Masonry/Masonry.h>
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface TBFileInfoBarView()

@property (nonatomic,strong) UIImageView *commentLogo;
@property (nonatomic,strong) UILabel *fileTitleLabel;

@end

@implementation TBFileInfoBarView


#pragma mark - life cycle
- (instancetype)initWithImageName:(NSString *)imageName andParameters:(NSDictionary *)imageInfo{
    self = [super init];
    if (self) {
        self.imageName = imageName;
        self.imageInfo = imageInfo;
    }
    
    self.backgroundColor = [UIColor lightTextColor];
    [self addSubview:self.commentLogo];
    [self addSubview:self.fileTitleLabel];
    
    [self layoutPageSubviews];
    
    return self;
}

- (void)layoutSubviews{
    [self layoutIfNeeded];
    
}

#pragma mark - private method
- (void)layoutPageSubviews {
    WS(ws);
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    [self.fileTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.mas_left).offset(15);
        make.bottom.equalTo(ws.mas_bottom).offset(-15);
        make.width.equalTo(@(width - 15 - ws.commentLogo.frame.size.width - 22));
    }];
    
    [self.commentLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws.mas_right).offset(-20);
        make.bottom.equalTo(ws.mas_bottom).offset(-12);
    }];
    
}

- (void)setCurrentImageName:(NSString *)imageName andParameters:(NSDictionary *)imageInfo {
    if (![imageName isEqualToString:self.imageName] && ![imageInfo isEqualToDictionary:self.imageInfo]) {
        self.imageName = imageName;
        self.imageInfo = imageInfo;
    }
}

#pragma mark - getters and setters 

- (UIImageView *)commentLogo {
    if (_commentLogo == nil) {
        _commentLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-file-comment"]];
        _commentLogo.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _commentLogo;
}

- (UILabel *)fileTitleLabel {
    if (_fileTitleLabel == nil) {
        _fileTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _fileTitleLabel.text = self.imageName;
        _fileTitleLabel.textColor = [UIColor grayColor];
        _fileTitleLabel.font = [UIFont systemFontOfSize:17.0];
        _fileTitleLabel.lineBreakMode = NSLineBreakByWordWrapping | NSLineBreakByTruncatingTail ;
        _fileTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _fileTitleLabel;
}
@end
