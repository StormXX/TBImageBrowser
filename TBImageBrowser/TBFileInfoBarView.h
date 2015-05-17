//
//  TBFileInfoBarView.h
//  Teambition
//
//  Created by DangGu on 15/4/14.
//  Copyright (c) 2015年 Teambition. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kInfoBarHeightKey 49

@interface TBFileInfoBarView : UIView

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSDictionary *imageInfo;

- (instancetype)initWithImageName:(NSString *)imageName andParameters:(NSDictionary *)imageInfo;
- (void)setCurrentImageName:(NSString *)imageName andParameters:(NSDictionary *)imageInfo;
@end
