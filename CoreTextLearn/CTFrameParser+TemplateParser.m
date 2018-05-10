//
//  CTFrameParser+TemplateLoad.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "CTFrameParser+TemplateParser.h"
#import "CTAttributeFactory.h"

@implementation CTFrameParser (TemplateParser)

+ (CoreTextData *)parseTemplateFile:(NSString *)path config:(CTFrameParserConfig *)config {
	NSAttributedString *content = [self loadTemplateFile:path config:config];
	return [self parseAttributeContent:content config:config];
}

+ (NSMutableAttributedString *)loadTemplateFile:(NSString *)path
										 config:(CTFrameParserConfig *)config {
	NSData *data = [NSData dataWithContentsOfFile:path];
	NSMutableAttributedString *mutableAttributeStr = [[NSMutableAttributedString alloc] init];
	if (data) {
		NSArray *array = [NSJSONSerialization JSONObjectWithData:data
														 options:NSJSONReadingAllowFragments
														   error:nil];
		if ([array isKindOfClass:[NSArray class]]) {
			for (NSDictionary *dict in array) {
				NSString *type = dict[@"type"];			// 获得当前这部分富文本的类型
				if ([type isEqualToString:@"txt"]) {
					NSAttributedString *attributeStr = [self parseAttributedContentFromNSDictionary:dict
																							 config:config];
					[mutableAttributeStr appendAttributedString:attributeStr];
				}
			}
		}
	}
	return mutableAttributeStr;
}

+ (NSAttributedString *)parseAttributedContentFromNSDictionary:(NSDictionary *)dict
														config:(CTFrameParserConfig *)config {
	NSMutableDictionary *attributes = [[CTAttributeFactory attributesWithConfigure:config] mutableCopy];
	// color
	UIColor *color = [self colorFromTemplate:dict[@"color"]];
	if (color) {
		attributes[(id)kCTForegroundColorAttributeName] = (id)color.CGColor;
	}
	// font
	CGFloat fontSize = [dict[@"size"] floatValue];
	if (fontSize > 0) {
		CTFontRef fontRef = CTFontCreateWithName((CFStringRef)@"ArialMT", fontSize, NULL);
		[attributes setObject:(id)kCTFontAttributeName forKey:(__bridge id)fontRef];
		CFRelease(fontRef);
	}
	return [[NSAttributedString alloc] initWithString:dict[@"content"] attributes:attributes];
}

+ (UIColor *)colorFromTemplate:(NSString *)name {
	if ([name isEqualToString:@"blue"]) {
		return [UIColor blueColor];
	} else if ([name isEqualToString:@"red"]) {
		return [UIColor redColor];
	} else if ([name isEqualToString:@"black"]) {
		return [UIColor blackColor];
	} else {
		return nil;
	}
}



@end
