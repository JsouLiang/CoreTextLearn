//
//  CoreTextData.h
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

/**
 CoreText绘制所需数据，CTFrame
 */
@interface CoreTextData : NSObject

@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, assign) CGFloat height;

@end
