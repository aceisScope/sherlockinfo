//
//  APWebScrollView.m
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "APWebScrollView.h"

@implementation APWebScrollView
@synthesize webList = _webList;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.contentView.delaysContentTouches = NO;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    self.webList = nil;
    [super dealloc];
}

- (void)showPageAtIndex:(int)index inWebArray:(NSArray *)webArray
{
    self.webList = webArray;
    
    self.currentPageNum = 0;
    numberOfPages = [webArray count];
    
    [super showPageAtIndex:index];
}

- (UIView*) pageView     
{
    UIWebView * webView = [[[UIWebView alloc] initWithFrame:CGRectZero] autorelease];
    webView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    webView.opaque = NO;
    webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    webView.tag = 2345;
    webView.delegate = self;
    
    UIButton * nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"arrow-right.png"] forState:UIControlStateNormal];
    nextButton.frame = CGRectMake(280, 5, 36, 36);
    nextButton.tag = 1234;
//    [nextButton addTarget:self action:@selector(nextButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    UIView * aView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [aView addSubview:webView];
    [aView addSubview:nextButton];
    return  aView;
}

- (void) reloadDataForPageAtLocation:(int) location   // 重载 _pageView 的显示
{
    int index = self.currentPageNum+location-1;
    if (index < 0 || index >= [self numberOfPages]) return;
    
    NSDictionary * webDict = [self.webList objectAtIndex:index];
    NSString * template = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"episode-template.html" ofType:nil]
                                                    encoding:NSUTF8StringEncoding error:nil];
    
    NSString * htmlString = [NSString stringWithFormat:template,[webDict objectForKey:@"title"],[[webDict objectForKey:@"images"]objectAtIndex:0],[[webDict objectForKey:@"images"]objectAtIndex:1],[webDict objectForKey:@"story"],[webDict objectForKey:@"url"],[webDict objectForKey:@"url"]];
    [((UIWebView*) [_pageView[location] viewWithTag:2345]) loadHTMLString:htmlString baseURL:[[NSBundle mainBundle]resourceURL]];
        
    // 处理箭头
    UIView * button = [_pageView[location] viewWithTag:1234];
    button.hidden = ([self numberOfPages] == (index + 1));
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
