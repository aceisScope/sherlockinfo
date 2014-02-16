//
//  UIImage+transform.m
//  Miu Ptt HD
//
//  Created by Xingzhi Cheng on 10/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIImage+transform.h"

@implementation UIImage (transform)

+ (UIImage*) blankImageWithColor:(UIColor*)color ofSize:(CGSize)size {
    // Create a graphics context with the target size
	// On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
	// On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
	if (NULL != UIGraphicsBeginImageContextWithOptions)
		UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	else
		UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
	
	// Retrieve the screenshot image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	return image;
}

+ (UIImage*) blankImageOfSize:(CGSize)size {
    return [self blankImageWithColor:[UIColor clearColor] ofSize:size];
}

+ (UIImage*) blankImageWithTopColor:(UIColor*)topColor bottomColor:(UIColor*)botColor ofSize:(CGSize)size {
    // Create a graphics context with the target size
	// On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
	// On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
	if (NULL != UIGraphicsBeginImageContextWithOptions)
		UIGraphicsBeginImageContextWithOptions(size, NO, 0);
	else
		UIGraphicsBeginImageContext(size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor(context, [topColor CGColor]);
	CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height/2));
    
	CGContextSetFillColorWithColor(context, [botColor CGColor]);
	CGContextFillRect(context, CGRectMake(0, size.height/2, size.width, size.height/2));
	
	// Retrieve the screenshot image
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	return image;
}

@end
