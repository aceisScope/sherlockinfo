//
//  TumblrIndexViewController.h
//  Sherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogRssParser.h"
#import "EGORefreshTableHeaderView.h"

@class BlogRssParser;
@class BlogRss;

@interface TumblrIndexViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,BlogRssParserDelegate,EGORefreshTableHeaderDelegate> 
{
	BlogRssParser * _rssParser;
	UITableView * _tableView;
	UIToolbar * _toolbar;
    
    UIView	*_blockerView;
    UIActivityIndicatorView	*_spinner;
}

@property (nonatomic,retain)  BlogRssParser * rssParser;
@property (nonatomic,retain)  UITableView * tableView;
@property (nonatomic,retain)  UIToolbar * toolbar;
@property (nonatomic,retain)  NSString *parserUrl;

-(void)toggleToolBarButtons:(BOOL)newState;

- (id)initWithUrlString:(NSString*)url;


@end
