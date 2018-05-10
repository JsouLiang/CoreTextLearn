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
	
	CoreTextData *data = [CTFrameParser pareContent:@"完成以上 4 个类之后，我们就可以简单地在ViewController.m文件中，加入如下代码来配置CTDisplayView的显示内容，位置，高度，字体，颜色等信息。"
											 config:config];
	self.ctView.data = data;
	self.ctView.height = data.height;
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}


@end
