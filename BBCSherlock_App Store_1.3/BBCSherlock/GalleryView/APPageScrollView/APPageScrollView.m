//
//  APPageScrollView.m
//  BonaFilm
//
//  Created by Xingzhi Cheng on 11/17/11.
//  Copyright (c) 2011 NUS. All rights reserved.
//

#import "APPageScrollView.h"
#import "APPageScrollViewDelegate.h"
#import <QuartzCore/QuartzCore.h>

#define PREV 0
#define CURRENT 1
#define NEXT 2

@interface APPageScrollView ()
- (CGRect) frameForPageAtLocation:(int) index;
- (void) _nextPage;
- (void) _prevPage;
@end


@implementation APPageScrollView

@synthesize contentView = _contentView;
@synthesize currentPageNum;
@synthesize delegate = _delegate;

- (void)dealloc
{
    self.contentView = nil;
    
    for (int i = 0; i < 3; ++i) {
        [_pageView[i] release];
    }
    
    [super dealloc];
}

- (id) initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self != nil) {
		self.currentPageNum = 0;
		numberOfPages = 0;
		
		self.backgroundColor = [UIColor blackColor];
		self.clipsToBounds = YES;
		
		self.contentView = [[[UIScrollView alloc] initWithFrame:self.bounds] autorelease];
		self.contentView.backgroundColor = [UIColor blackColor];
		self.contentView.pagingEnabled = YES;
		self.contentView.delegate = self;
		
		[self addSubview:self.contentView];
		
		for (int i = 0; i < 3; ++i) {
			_pageView[i] = [[self pageView] retain];
			_pageView[i].frame = [self frameForPageAtLocation:i];
			[self.contentView addSubview:_pageView[i]];
		}
		
		UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapEvent:)];
		tapRecognizer.numberOfTapsRequired = 1;
		[self.contentView addGestureRecognizer:tapRecognizer];
		[tapRecognizer release];
	}
	return self;
}

- (void) backward {
    if (self.currentPageNum == 0) return;
    [self _prevPage];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.contentView.contentOffset = CGPointMake(self.currentPageNum*self.bounds.size.width, 0);
    [UIView commitAnimations];
}

- (void) forward {
    if (self.currentPageNum >= [self numberOfPages]-1) return;
    
    [self _nextPage];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    self.contentView.contentOffset = CGPointMake(self.currentPageNum*self.bounds.size.width, 0);
    [UIView commitAnimations];
}


#pragma mark -
#pragma makr scrollview delegates and image rotation


- (void) _prevPage {
    if (currentPageNum > 0) {
        --currentPageNum;
        
        UIView * tmp = _pageView[NEXT];
        _pageView[NEXT] = _pageView[CURRENT];
        _pageView[CURRENT] = _pageView[PREV];
        _pageView[PREV] = tmp;
        
        _pageView[PREV].frame = [self frameForPageAtLocation:PREV];
        [self reloadDataForPageAtLocation:PREV];
        
        [self willDisplayPageAtIndex:currentPageNum];
    }
}

- (void) _nextPage 
{
    if (currentPageNum < [self numberOfPages] - 1) {
        ++currentPageNum;
        
        UIView * tmp = _pageView[PREV];
        _pageView[PREV] = _pageView[CURRENT];
        _pageView[CURRENT] = _pageView[NEXT];
        _pageView[NEXT] = tmp;
        
        _pageView[NEXT].frame = [self frameForPageAtLocation:NEXT];
        [self reloadDataForPageAtLocation:NEXT];
        
        [self willDisplayPageAtIndex:currentPageNum];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int pageNum = round( scrollView.contentOffset.x / scrollView.frame.size.width);
    if (pageNum == currentPageNum + 1) {
        [self _nextPage];
    } else if (pageNum == currentPageNum - 1) {
        [self _prevPage];
    }
}

#pragma mark -
#pragma mark private functions

- (CGRect) frameForPageAtLocation:(int) index {
    int real_index = index + currentPageNum - 1;
    if (real_index < 0 || (real_index >= [self numberOfPages])) return CGRectZero;
    
    return CGRectMake(self.contentView.frame.size.width * real_index, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}


#pragma mark -
#pragma mark introductory labels

- (void) showIntroductoryLabel {
    UILabel * mainLabel = [[[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width-240, 100, 240, 50)] autorelease];
//    mainLabel.text = @"左右滑动查看更多";
    mainLabel.text = @"";
    mainLabel.textColor = [UIColor whiteColor];
    mainLabel.font = [UIFont systemFontOfSize:20];
    mainLabel.layer.borderWidth = 1.f;
    mainLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    mainLabel.layer.cornerRadius = 4.f;
    mainLabel.backgroundColor = [UIColor colorWithRed:.35 green:.35 blue:.35 alpha:.0];
    
    CALayer * bgLayer = [CALayer layer];
    bgLayer.frame = CGRectMake(0, mainLabel.bounds.size.height/2, mainLabel.bounds.size.width, mainLabel.bounds.size.height/2);
    bgLayer.backgroundColor = [[UIColor colorWithRed:0. green:0. blue:0. alpha:.25] CGColor];
//    [mainLabel.layer addSublayer:bgLayer];
    
	UILabel * right = [[UILabel alloc] initWithFrame:CGRectMake(mainLabel.bounds.size.width-50, 0, 50, mainLabel.bounds.size.height)];
	right.backgroundColor = [UIColor clearColor];
	right.textColor = [UIColor whiteColor];
	right.text = @"⇨";
	right.font = [UIFont systemFontOfSize:40];
    right.frame = CGRectMake(0, 0, 50, mainLabel.bounds.size.height);
//	[mainLabel addSubview:right];
	[right release];
    
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"arrow_more.png"]];
    arrow.frame = CGRectMake(0, 0, 50, mainLabel.bounds.size.height);
    [mainLabel addSubview:arrow];
    [arrow release];
    
    mainLabel.frame = CGRectMake(self.bounds.size.width-50, 100, 45, 50);
    [self addSubview:mainLabel];
    [mainLabel performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2.5f];
}

#pragma mark -
#pragma mark exit

- (void) handleTapEvent:(UIGestureRecognizer *)recognizer 
{
	// empty cache before exiting.    
    if ([self.delegate respondsToSelector:@selector(singleTapOnPageScrollView:)]) {
        [self.delegate singleTapOnPageScrollView:self];
    }
}

#pragma mark -
#pragma mark rotation

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    self.contentView.delegate = nil;	// to avoid miscall to the delegate method
	self.contentView.frame = self.bounds;
	
	self.contentView.contentSize = CGSizeMake([self numberOfPages] * self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.contentView.contentOffset = CGPointMake(self.currentPageNum * self.contentView.frame.size.width, 0);
    self.contentView.delegate = self;
	
    _pageView[PREV].frame = [self frameForPageAtLocation:PREV];
    _pageView[CURRENT].frame = [self frameForPageAtLocation:CURRENT];
    _pageView[NEXT].frame = [self frameForPageAtLocation:NEXT];    
}


#pragma mark -
#pragma mark to be orverriden in subclasses

/////////////////////////////////////////////
// 需要覆盖，这里就是演示
- (void) showPageAtIndex:(int)index 
{
    self.currentPageNum = index;
    
    self.contentView.contentSize = CGSizeMake([self numberOfPages] * self.contentView.frame.size.width, self.contentView.frame.size.height);
    self.contentView.contentOffset = CGPointMake(self.currentPageNum * self.contentView.frame.size.width, 0);
    
    _pageView[PREV].frame = [self frameForPageAtLocation:PREV];
    _pageView[CURRENT].frame = [self frameForPageAtLocation:CURRENT];
    _pageView[NEXT].frame = [self frameForPageAtLocation:NEXT];
    
    [self reloadDataForPageAtLocation:CURRENT];
    [self reloadDataForPageAtLocation:PREV];
    [self reloadDataForPageAtLocation:NEXT];
    
    if(numberOfPages>1) [self showIntroductoryLabel];
}

- (void) showPageAtIndex:(int)index animatedFromRect:(CGRect)rect 
{
    [self showPageAtIndex:index];
    
    CGRect defaultFrame = [self frameForPageAtLocation:CURRENT];
    _pageView[CURRENT].frame = CGRectMake(defaultFrame.origin.x+rect.origin.x, defaultFrame.origin.y+rect.origin.y, rect.size.width, rect.size.height);
    _pageView[CURRENT].contentMode = UIViewContentModeScaleAspectFill;
    
    self.alpha = .3;
    [UIView beginAnimations:@"show" context:nil];
    [UIView setAnimationDuration:0.5];
    self.alpha = 1.;
    _pageView[CURRENT].contentMode = UIViewContentModeScaleAspectFit;
    _pageView[CURRENT].frame = defaultFrame;
    [UIView commitAnimations];
}

/////////////////////////////////////////////
// 需要覆盖，这里负责提供 _pageView[3] 的初始化
- (UIView*) pageView;
{
    UILabel * aView = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
    return aView;
}

/////////////////////////////////////////////
// 需要覆盖，这里负责重载 _pageView[3] 的显示
- (void) reloadDataForPageAtLocation:(int)index 
{
    // to do sth here;
    UILabel * label = (UILabel*)_pageView[index];
    [label setText:[NSString stringWithFormat:@"第%d页", self.currentPageNum+index-1]];
}


/////////////////////////////////////////////
// 需要覆盖，这里负责提供 total number of pages
- (int) numberOfPages {
    return numberOfPages;
}

/////////////////////////////////////////////
// 如果需要标签等，可以在这里添加
- (void) willDisplayPageAtIndex:(int)index {
    // do nothing
    // to show the label if needed;
    if ([self.delegate respondsToSelector:@selector(pageScrollView:didShowPageAtIndex:)]) {
        [self.delegate pageScrollView:self didShowPageAtIndex:index];
    }
}

@end