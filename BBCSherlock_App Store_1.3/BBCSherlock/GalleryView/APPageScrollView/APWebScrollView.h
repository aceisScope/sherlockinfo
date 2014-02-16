//
//  APWebScrollView.h
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPageScrollView.h"

@interface APWebScrollView : APPageScrollView  <UIWebViewDelegate>

@property(nonatomic, retain) NSArray * webList;

- (void) showPageAtIndex:(int)index inWebArray:(NSArray*)webArray;

@end
