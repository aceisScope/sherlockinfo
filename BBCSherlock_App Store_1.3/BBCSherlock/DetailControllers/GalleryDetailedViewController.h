//
//  GalleryDetailedViewController.h
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APPageScrollViewDelegate.h"
#import "APImageScrollViewWithDescription.h"
#import "APImageScrollView.h"

@interface GalleryDetailedViewController : UIViewController<APPageScrollViewDelegate> {
}

@property(nonatomic, retain) APImageScrollViewWithDescription * detailedView;

- (void) showImageAtIndex:(int)index inImageArray:(NSArray *)imageArray_ animatedFromRect:(CGRect)rect;

@end
