//
//  APImageScrollView.h
//  BonaFilm
//
//  Created by Xingzhi Cheng on 11/18/11.
//  Copyright (c) 2011 NUS. All rights reserved.
//

#import "APPageScrollView.h"

@interface APImageScrollView : APPageScrollView

@property(nonatomic, retain) NSArray * imageList;

- (void) showImageAtIndex:(int)index inImageArray:(NSArray*)imageArray;
- (void) showImageAtIndex:(int)index inImageArray:(NSArray*)imageArray animatedFromRect:(CGRect) rect;

@end
