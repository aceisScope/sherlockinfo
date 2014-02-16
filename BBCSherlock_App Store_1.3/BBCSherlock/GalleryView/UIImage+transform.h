//
//  UIImage+transform.h
//  Miu Ptt HD
//
//  Created by Xingzhi Cheng on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorRGBA(r, g, b, a) [UIColor colorWithRed:(r) green:(g) blue:(b) alpha:(a)]

@interface UIImage (transform)
+ (UIImage*) blankImageWithTopColor:(UIColor*)topColor bottomColor:(UIColor*)botColor ofSize:(CGSize)size;
+ (UIImage*) blankImageWithColor:(UIColor*)color ofSize:(CGSize)size;
+ (UIImage*) blankImageOfSize:(CGSize)size;

@end
