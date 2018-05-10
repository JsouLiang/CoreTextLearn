//
//  CTFrameParser.h
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreTextData.h"

@class CTFrameParserConfig;
/**
 通过ParserConfig 生成 CTFrameRef
 */
@interface CTFrameParser : NSObject

+ (CoreTextData *)parseAttributeContent:(NSAttributedString *)attributeString config:(CTFrameParserConfig *)config;

+ (CoreTextData *)parseContent:(NSString *)content config:(CTFrameParserConfig *)config;

@end
