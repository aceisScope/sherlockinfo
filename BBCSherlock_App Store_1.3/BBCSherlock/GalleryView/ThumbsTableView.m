//
//  ThumbsTableView.m
//  Wretch.Album
//
//  Created by Xingzhi Cheng on 5/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ThumbsTableView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ThumbsTableView

@synthesize dataSource = _dataSource;
@synthesize thumbsViewDelegate = _thumbsViewDelegate;
@synthesize scrollingType, numberOfColsPerPage, numberOfRowsPerPage, selectedIndex;
@synthesize numberOfPages;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.pagingEnabled = YES;
		self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
		self.delegate = self;	// it is usually a bad idea to assign one's delegate to itself...
				
		numberOfRowsPerPage = 1;
		numberOfColsPerPage = 2;
		firstVisibleCellIndex = 0;
		lastVisibleCellIndex = 0;
        selectedIndex = 0;
        
        scrollingType = ScrollingTypeHorizonal;
		
		_resusableThumbsViews = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)dealloc
{    
    self.delegate = nil;
	self.dataSource = nil;
	self.thumbsViewDelegate = nil;
    
    [_placeHoldImage release];
    [_resusableThumbsViews release];
    
    [super dealloc];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self reloadData];
}

- (int) currentPage {
    if (scrollingType == ScrollingTypeHorizonal) {
        return (int)(self.contentOffset.x / self.frame.size.width + 0.01);
    }
    return (int)(self.contentOffset.y / self.frame.size.height + 0.01);
}

#pragma mark -
#pragma mark  reuse cells

- (UIView *)dequeueReusableImageView {
    UIImageView *cell = [_resusableThumbsViews anyObject];
    if (cell) {
        // the only object retaining the cell is our reusableCells set, so we have to retain/autorelease it
        // before returning it so that it's not immediately deallocated when we remove it from the set
        [[cell retain] autorelease];
        [_resusableThumbsViews removeObject:cell];
    }
//	cell.image = nil;
//    cell.contentMode = UIViewContentModeScaleAspectFill;

    return cell;
}

#pragma mark -
#pragma mark views

#define CELLTAG 1000
static const CGFloat margin = 10;

- (CGRect)frameForCellAtIndex:(int)index 
{
	CGFloat w = 1./numberOfColsPerPage * (self.frame.size.width);// - 2 * margin;
	CGFloat h = 1./numberOfRowsPerPage * (self.frame.size.height);// - 2 * margin;
    CGFloat x, y;
    if (scrollingType == ScrollingTypeVertical) {
        x = (index % numberOfColsPerPage) * w;
        y = (index / numberOfColsPerPage) * h;
    }
    else {
        x = (index / numberOfRowsPerPage) * w;
        y = (index % numberOfRowsPerPage) * h;
    }
    return CGRectMake(x + 0.02*w, y+0.02*h, 0.96*w, 0.96*h);
}

- (void) reloadData 
{
	for (UIView * cell in [self subviews]) 
    {
		if ([cell isKindOfClass:[UIImageView class]]) {
			[_resusableThumbsViews addObject:cell];
			[cell removeFromSuperview];
		}
	}
	
	numberOfImages = [self.dataSource numberOfImagesForThumbsTableView:self];
	if (numberOfImages == 0) return;
	
	int numberOfCellsPerPage = numberOfRowsPerPage * numberOfColsPerPage;
	numberOfPages = (numberOfImages-1)/numberOfCellsPerPage + 1;
	int currentPage = MIN(numberOfPages-1, firstVisibleCellIndex/numberOfCellsPerPage);
	
	firstVisibleCellIndex = currentPage * numberOfCellsPerPage;
	lastVisibleCellIndex = MIN(numberOfImages-1, currentPage*numberOfCellsPerPage + numberOfCellsPerPage-1);
	
    if (scrollingType == ScrollingTypeVertical) {
        self.contentSize = CGSizeMake(self.frame.size.width, numberOfPages * self.frame.size.height);
        self.contentOffset = CGPointMake(0, currentPage * self.frame.size.height);
    }
    else {
        self.contentSize = CGSizeMake(numberOfPages * self.frame.size.width, self.frame.size.height);
        self.contentOffset = CGPointMake(currentPage * self.frame.size.width, 0);
    }
	
	[_placeHoldImage release];
	_placeHoldImage = nil;
	
//	[self performSelectorInBackground:@selector(_layoutSubviewsInBackground) withObject:nil];
    [self _layoutSubviewsInBackground];
}

- (void) _layoutSubviewsInBackground {
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
	for (UIImageView * cell in [self subviews]) {
		if ([cell isKindOfClass:[UIImageView class]]) 
		{
			if (cell.tag - CELLTAG  < firstVisibleCellIndex || (cell.tag - CELLTAG > lastVisibleCellIndex)) {
				[_resusableThumbsViews addObject:cell];
				[cell removeFromSuperview];
			}
		}
	}
	
	for (int i = firstVisibleCellIndex; i <= lastVisibleCellIndex ; ++i) {
		UIImageView * cell = (UIImageView*)[self viewWithTag:i+CELLTAG];
		if (cell == nil) {
			cell = [self.dataSource thumbsTableView:self thumbsViewForIndex:i];
			cell.tag = i+CELLTAG;
			cell.frame = [self frameForCellAtIndex:i];
//			NSLog(@"%d, cell %d, frame %@", numberOfRowsPerPage, i, NSStringFromCGRect(cell.frame));
			[self addSubview:cell];
		}
	}
	
	[pool drain];
}

- (UIImageView*) imageViewAtIndex:(int)index {
	if (index < firstVisibleCellIndex || (index > lastVisibleCellIndex))
		return nil;
	
	return (UIImageView*) [self viewWithTag:CELLTAG+index];
}

- (void) reloadDataInRange:(NSRange)range {
    if ((firstVisibleCellIndex > range.location && (firstVisibleCellIndex < range.location + range.length))
        || (lastVisibleCellIndex > range.location && (lastVisibleCellIndex < range.location + range.length)))
    {
        [self reloadData];
    }
}

- (void) setSelectedIndex:(int)selectedIndex_ 
{    
    UIImageView * imgView = [self imageViewAtIndex:selectedIndex];
    [imgView.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    
    imgView = [self imageViewAtIndex:selectedIndex_];
    [imgView.layer setBorderColor:[[UIColor yellowColor] CGColor]];
    
    selectedIndex = selectedIndex_;
}

- (void) scrollToImageAtIndex:(int)index {
    if (index >= firstVisibleCellIndex && (index <= lastVisibleCellIndex)) {
        [self setSelectedIndex:index];
        return;
    }
    int numberOfCellsPerPage = (numberOfColsPerPage * numberOfRowsPerPage);
    firstVisibleCellIndex = index / numberOfCellsPerPage * numberOfCellsPerPage;
    selectedIndex = index;
    [self reloadData];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff

- (BOOL) updateVisibleCellsRange 
{	
    int newFirstVisibleCellIndex, newLastVisibleCellIndex;

    if (scrollingType == ScrollingTypeVertical) {
        CGFloat offset = self.contentOffset.y + margin;
        int row = offset * numberOfRowsPerPage / self.frame.size.height;
        CGFloat row_offset = row * self.frame.size.height / numberOfRowsPerPage;
        
        int numberOfCellsPerPage = numberOfColsPerPage * numberOfRowsPerPage;
        
        newFirstVisibleCellIndex = row * numberOfColsPerPage;
        newLastVisibleCellIndex = newFirstVisibleCellIndex + ((offset < row_offset + 2 * margin) ? numberOfCellsPerPage-1 : numberOfCellsPerPage-1+numberOfColsPerPage);
        newLastVisibleCellIndex = MIN(numberOfImages - 1, newLastVisibleCellIndex);
        newFirstVisibleCellIndex = MAX(newFirstVisibleCellIndex, 0);
	}
    else {
        CGFloat offset = self.contentOffset.x + margin;
        int col = offset * numberOfColsPerPage / self.frame.size.width;
        CGFloat col_offset = col * self.frame.size.width / numberOfColsPerPage;
        
        int numberOfCellsPerPage = numberOfColsPerPage * numberOfRowsPerPage;
        
        newFirstVisibleCellIndex = col * numberOfRowsPerPage;
        newLastVisibleCellIndex = newFirstVisibleCellIndex + ((offset < col_offset + 2 * margin) ? numberOfCellsPerPage-1 : numberOfCellsPerPage-1+numberOfRowsPerPage);
        newLastVisibleCellIndex = MIN(numberOfImages - 1, newLastVisibleCellIndex);
        newFirstVisibleCellIndex = MAX(newFirstVisibleCellIndex, 0);
    }
    
	BOOL hasChanged = (newFirstVisibleCellIndex != firstVisibleCellIndex || (newLastVisibleCellIndex != lastVisibleCellIndex));
	firstVisibleCellIndex = newFirstVisibleCellIndex;
	lastVisibleCellIndex = newLastVisibleCellIndex;
	
	return hasChanged;
}

- (void) layoutCellsIfNeeded {
	BOOL visibleCellsRangeHasChanged = [self updateVisibleCellsRange];
	if (visibleCellsRangeHasChanged) {
//		[self performSelectorInBackground:@selector(_layoutSubviewsInBackground) withObject:nil];
        [self _layoutSubviewsInBackground];
	}
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView 
{	
	[self layoutCellsIfNeeded];
}

#pragma mark -
#pragma mark touch events;

- (void) singleTapMethod 
{
	for (int i = firstVisibleCellIndex; i <= lastVisibleCellIndex; ++i) {
		UIImageView * cell = [self imageViewAtIndex:i];
		CGPoint location = [self convertPoint:gestureStartPoint toView:cell];
		
		if (!CGRectContainsPoint(cell.bounds, location)) continue;
		
		if ([_thumbsViewDelegate respondsToSelector:@selector(thumbsTableView:didSelectThumbsViewAt:)])
			[_thumbsViewDelegate thumbsTableView:self didSelectThumbsViewAt:i];
	}
}

- (void) singleLongTapMethod 
{
	for (int i = firstVisibleCellIndex; i <= lastVisibleCellIndex; ++i) {
		UIImageView * cell = [self imageViewAtIndex:i];
		CGPoint location = [self convertPoint:gestureStartPoint toView:cell];
		
		if (!CGRectContainsPoint(cell.bounds, location)) continue;
        
		if ([_thumbsViewDelegate respondsToSelector:@selector(thumbsTableView:didLongTapThumbsViewAt:)])
			[_thumbsViewDelegate thumbsTableView:self didLongTapThumbsViewAt:i];
	}
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	if ([event allTouches].count == 1) {
		UITouch * touch = [touches anyObject];
		NSUInteger numTaps = [touch tapCount];
		
		if (numTaps == 1) {
            gestureStartPoint = [touch locationInView:self];
            [self performSelector:@selector(singleLongTapMethod) withObject:nil afterDelay:.8];
		}
	}
	else {
		[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleLongTapMethod) object:nil];
	}
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleLongTapMethod) object:nil];
	
	if ([event allTouches].count == 1) {
		UITouch * touch = [touches anyObject];
		NSUInteger numTaps = [touch tapCount];
		
		if (numTaps == 1) {
            [self singleTapMethod];
		}
	}
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(singleLongTapMethod) object:nil];
}


@end
