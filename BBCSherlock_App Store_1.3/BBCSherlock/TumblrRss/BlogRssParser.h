//
//  BlogRssParser.h
//  RssFun
//
//  Created by Imthiaz Rafiq on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BlogRss;

@protocol BlogRssParserDelegate;

@interface BlogRssParser : NSObject <NSXMLParserDelegate>{
	BlogRss * _currentItem;
	NSMutableString * _currentItemValue;
	NSMutableArray * _rssItems;
	id<BlogRssParserDelegate> _delegate;
	NSOperationQueue *_retrieverQueue;
}


@property(nonatomic, retain) BlogRss * currentItem;
@property(nonatomic, retain) NSMutableString * currentItemValue;
@property(nonatomic, retain) NSString *url;
@property(readonly) NSMutableArray * rssItems;

@property(nonatomic, assign) id<BlogRssParserDelegate> delegate;
@property(nonatomic, retain) NSOperationQueue *retrieverQueue;

@property(nonatomic, retain) NSString *xmlfilePath;

- (void)startProcess;
- (id)initWithUrl:(NSString*)url;


@end

@protocol BlogRssParserDelegate <NSObject>
-(void)processStarted;
-(void)processCompleted;
-(void)processHasErrors;

@end
