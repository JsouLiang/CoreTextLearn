//
//  ViewController.m
//  CoreTextLearn
//
//  Created by Liang on 2018/5/10.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import "ViewController.h"
#import "CTDisplayView.h"
#import "CTFrameParserConfig.h"
#import "CoreTextData.h"
#import "CTFrameParser.h"
#import "CTFrameParser+TemplateParser.h"
#import "UIView+FrameAdjust.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet CTDisplayView *ctView;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	
	CTFrameParserConfig *config = [[CTFrameParserConfig alloc] init];
	config.textColor = [UIColor redColor];
	config.width = self.ctView.width;
	NSString *normalString = @"CTFrameParser parseContent:normalStringCTFrameParser parseContent:normalStringCTFrameParser parseContent:normalStringCTFrameParser parseContent:normalStringCTFrameParser parseContent:normalString";
//	CoreTextData *data = [CTFrameParser parseContent:normalString
//											  config:config];
//	NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:normalString];
//	[attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 7)];
	
	NSString *path = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"json"];
	CoreTextData *data = [CTFrameParser parseTemplateFile:path config:config];
	self.ctView.data = data;
	self.ctView.height = data.height;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
