//
//  CTFrameParserConfig.h
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 绘制配置类，用于配置绘制参数，如颜色，大小间距等
 这个Config用于配置整个文本一致的参数
 */
@interface CTFrameParserConfig : NSObject

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat fontSize;
@property (nonatomic, assign) CGFloat lineSpace;
@property (nonatomic, strong) UIColor *textColor;

@end
