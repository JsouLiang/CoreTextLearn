//
//  UIFont+FontVariation.h
//  CoreTextLearn
//
//  Created by Liang on 2018/5/12.
//  Copyright © 2018年 Liang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (FontVariation)

UIFont *GetVariationOfFontWithTrait(UIFont *baseFont, CTFontSymbolicTraits traits);

@end
