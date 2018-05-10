//
//  CTDisplayView.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTDisplayView.h"
#import "CoreTextData.h"
#import "CoreTextImageData.h"
@implementation CTDisplayView

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetTextMatrix(context, CGAffineTransformIdentity);
	CGContextTranslateCTM(context, 0, self.bounds.size.height);
	CGContextScaleCTM(context, 1, -1);
	
	if (self.data) {
		CTFrameDraw(self.data.ctFrame, context);
	}
	
	for (CoreTextImageData *data in self.data.images) {
		UIImage *image = [UIImage imageNamed:data.imageName];
		if (image) {
			CGContextDrawImage(context, data.imagePosition, image.CGImage);
		}
	}
	
}

@end
