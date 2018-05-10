//
//  CTFrameParser+TemplateLoad.h
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTFrameParser.h"
@class CoreTextData, CTFrameParserConfig;

@interface CTFrameParser (TemplateParser)
+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config;
@end
