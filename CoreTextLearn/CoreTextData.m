//
//  CoreTextData.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CoreTextData.h"

@implementation CoreTextData

- (void)setCtFrame:(CTFrameRef)ctFrame {
	if (_ctFrame != ctFrame) {
		if (_ctFrame != NULL) {
			CFRelease(_ctFrame);
		}
		CFRetain(ctFrame);
		_ctFrame = ctFrame;
	}
}

- (void)dealloc {
	if (_ctFrame != NULL) {
		CFRelease(_ctFrame);
		_ctFrame = NULL;
	}
}

@end
