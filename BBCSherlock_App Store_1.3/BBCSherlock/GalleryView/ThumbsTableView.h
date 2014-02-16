//
//  ThumbsTableView.h
//  Wretch.Album
//
//  Created by Xingzhi Cheng on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ThumbsTableViewDelegate;
@protocol ThumbsTableViewDataSource;

typedef enum {
    ScrollingTypeHorizonal, ScrollingTypeVertical
} ScrollingType;

@interface ThumbsTableView : UIScrollView <UIScrollViewDelegate>
{    
    UIImage * _placeHoldImage;
    NSMutableSet * _resusableThumbsViews;
	
	int numberOfImages;
    int numberOfPages;
	int numberOfColsPerPage;
	int numberOfRowsPerPage;
	
	int firstVisibleCellIndex;
	int lastVisibleCellIndex;
    int selectedIndex;
    
    ScrollingType scrollingType;
    
    CGPoint gestureStartPoint;
    
	id<ThumbsTableViewDataSource> _dataSource;
	id<ThumbsTableViewDelegate> _thumbsViewDelegate;
}
@property(nonatomic, assign) id<ThumbsTableViewDataSource> dataSource;
@property(nonatomic, assign) id<ThumbsTableViewDelegate> thumbsViewDelegate;
@property(nonatomic, readwrite) ScrollingType scrollingType;
@property(nonatomic, readwrite) int numberOfColsPerPage;
@property(nonatomic, readwrite) int numberOfRowsPerPage;
@property(nonatomic, readwrite) int selectedIndex;
@property(nonatomic, readonly) int numberOfPages;
@property(nonatomic, readonly) int currentPage;
// reload cells
- (void) reloadData;
- (void) reloadDataInRange:(NSRange)range;

// cell scrolling
- (void) scrollToImageAtIndex:(int)index;

// cell view;
- (UIView *)dequeueReusableImageView;
- (UIImageView*) imageViewAtIndex:(int)index;
@end

///////////////// protocol definitions ////////////////

@protocol ThumbsTableViewDataSource<NSObject>
@required
- (int) numberOfImagesForThumbsTableView:(ThumbsTableView*)thumbsTableView;
- (UIImage *) placeHoldImageForThumbsTableView:(ThumbsTableView*)thumbsTableView;
- (UIImageView*) thumbsTableView:(ThumbsTableView*)thumbsTableView thumbsViewForIndex:(int)index;
@end

@protocol ThumbsTableViewDelegate<NSObject>
@optional
- (void)thumbsTableView:(ThumbsTableView *)thumbsTableView didSelectThumbsViewAt:(int)index;
- (void)thumbsTableView:(ThumbsTableView *)thumbsTableView didLongTapThumbsViewAt:(int)index;
@end

