//
//  APPageScrollViewDelegate.h
//  BonaFilm
//
//  Created by Xingzhi Cheng on 11/18/11.
//  Copyright (c) 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPageScrollView;

@protocol APPageScrollViewDelegate <NSObject>
@optional
- (void) singleTapOnPageScrollView:(APPageScrollView*)pageScrollView;
- (void) pageScrollView:(APPageScrollView*)pageScrollView didShowPageAtIndex:(int)index;
@end