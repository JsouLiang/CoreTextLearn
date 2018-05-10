//
//  CTFrameParserConfig.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTFrameParserConfig.h"

@implementation CTFrameParserConfig

- (instancetype)init {
	if (self = [super init]) {
		_width = 200.f;
		_fontSize = 16.f;
		_lineSpace = 8.f;
		_textColor = [UIColor blackColor];
	}
	return self;
}

@end
