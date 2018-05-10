//
//  CoreTextImageData.h
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoreTextImageData : NSObject

@property (nonatomic, copy) NSString *imageName;

/**
 图片在绘制流的位置，图片前面有多少个字符的位置
 */
@property (nonatomic, assign) NSUInteger position;

@property (nonatomic, assign) CGRect imagePosition;

@end
