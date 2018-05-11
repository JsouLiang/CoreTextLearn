//
//  CTTextDrawer.h
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>
@interface CTTextDrawer : NSObject

/**
 提供frame和lines执行CoreText绘制

 @param frame CoreText绘制需要的frame
 @param numberOfLines 如果numberOfLine = 0 不会限制行数
 */
+ (void)drawWithFrame:(CTFrameRef)frame numberOfLines:(NSUInteger)numberOfLines;

@end
