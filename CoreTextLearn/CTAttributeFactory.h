//
//  CTAttributeFactory.h
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CTFrameParserConfig;
@interface CTAttributeFactory : NSObject
+ (NSDictionary *)attributesWithConfigure:(CTFrameParserConfig *)config;
@end
