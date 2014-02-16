//
//  APImageScrollView.m
//  BonaFilm
//
//  Created by Xingzhi Cheng on 11/18/11.
//  Copyright (c) 2011 NUS. All rights reserved.
//

#import "APImageScrollView.h"
#import "FullyLoaded.h"
#import "AsyncImageView.h"

@implementation APImageScrollView
@synthesize imageList = _imageList;

- (void) dealloc {
    self.imageList = nil;
    [super dealloc];
}

- (void) showImageAtIndex:(int)index inImageArray:(NSArray *)imageArray 
{
    self.imageList = imageArray;
    
    self.currentPageNum = 0;
    numberOfPages = [imageArray count];
    
    [super showPageAtIndex:index];
}

- (void) showImageAtIndex:(int)index inImageArray:(NSArray*)imageArray animatedFromRect:(CGRect) rect 
{
    self.imageList = imageArray;
    
    self.currentPageNum = 0;
    numberOfPages = [imageArray count];
    
    [super showPageAtIndex:index animatedFromRect:rect];
}

- (UIView*) pageView       // _pageView 初始化
{
    AsyncImageView * imgView = [[AsyncImageView alloc] initWithFrame:self.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    return [imgView autorelease];
}

- (void) reloadDataForPageAtLocation:(int) location   // 重载 _pageView 的显示
{
    int index = self.currentPageNum+location-1;
    if (index < 0 || index >= [self numberOfPages]) return;
    
    NSString * imageURL = [[self.imageList objectAtIndex:index] objectForKey:@"image"];
    //[((AsyncImageView*) _pageView[location]) loadImage:imageURL withPlaceholdImage:thumbImage];
    [((AsyncImageView*)[_pageView[location] viewWithTag:1000]) setImage:[UIImage imageNamed:imageURL]];
}

- (int)  numberOfPages                             // 总共多少页
{
    return  numberOfPages;
}

- (void) willDisplayPageAtIndex:(int)index         // 提供页面切换的接口
{
    [super willDisplayPageAtIndex:index];
}
@end