//
//  BlogRssParser.m
//  RssFun
//
//  Created by Imthiaz Rafiq on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "BlogRssParser.h"
#import "BlogRss.h"

@implementation BlogRssParser

@synthesize currentItem = _currentItem;
@synthesize currentItemValue = _currentItemValue;
@synthesize rssItems = _rssItems;
@synthesize delegate = _delegate;
@synthesize retrieverQueue = _retrieverQueue;
@synthesize url=_url;
@synthesize xmlfilePath = _xmlfilePath;


- (id)init
{
	if(![super init])
    {
		return nil;
	}
	_rssItems = [[NSMutableArray alloc]init];
    _url = [NSString string];
    _xmlfilePath = [NSString string];
	return self;
}

- (NSOperationQueue *)retrieverQueue {
	if(nil == _retrieverQueue) {
		_retrieverQueue = [[NSOperationQueue alloc] init];
		_retrieverQueue.maxConcurrentOperationCount = 1;
	}
	return _retrieverQueue;
}

- (void)startProcess
{
	SEL method = @selector(fetchAndParseRss);
	[[self rssItems] removeAllObjects]; //comment or crash 
	NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self 
																	 selector:method 
																	   object:nil];
	[self.retrieverQueue addOperation:op];
	[op release];
//    if([self.delegate respondsToSelector:@selector(processStarted)]) [self.delegate processStarted];
    [(id)[self delegate] performSelectorOnMainThread:@selector(processStarted)
                                          withObject:nil
                                       waitUntilDone:NO];

}

-(BOOL)fetchAndParseRss{
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	//To suppress the leak in NSXMLParser
	[[NSURLCache sharedURLCache] setMemoryCapacity:0];
	[[NSURLCache sharedURLCache] setDiskCapacity:0];
	
	BOOL success = NO;
    NSXMLParser *parser;
	if(self.xmlfilePath == nil || [self.xmlfilePath length] == 0) 
    {
        parser = [[NSXMLParser alloc]initWithContentsOfURL:[NSURL URLWithString:self.url]];
    }
    else
    {
        parser = [[NSXMLParser alloc]initWithData:[NSData dataWithContentsOfFile:self.xmlfilePath]];
    }
	[parser setDelegate:self];
	[parser setShouldProcessNamespaces:YES];
	[parser setShouldReportNamespacePrefixes:YES];
	[parser setShouldResolveExternalEntities:NO];
	success = [parser parse];
	[parser release];
	[pool drain];
	return success;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict{
	if(nil != qualifiedName){
		elementName = qualifiedName;
	}
	if ([elementName isEqualToString:@"item"]) {
		self.currentItem = [[[BlogRss alloc]init]autorelease];
	}else if ([elementName isEqualToString:@"media:thumbnail"]) {
		self.currentItem.mediaUrl = [attributeDict valueForKey:@"url"];
	} else if([elementName isEqualToString:@"title"] || 
			  [elementName isEqualToString:@"description"] ||
			  [elementName isEqualToString:@"link"] ||
			  [elementName isEqualToString:@"guid"] ||
			  [elementName isEqualToString:@"pubDate"]) {
		self.currentItemValue = [NSMutableString string];
	} else {
		self.currentItemValue = nil;
	}	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	if(nil != qName){
		elementName = qName;
	}
	if([elementName isEqualToString:@"title"]){
		self.currentItem.title = self.currentItemValue;
	}
    else if([elementName isEqualToString:@"description"])
    {
		self.currentItem.description = self.currentItemValue;
        
	}
    else if([elementName isEqualToString:@"link"])
    {
		self.currentItem.linkUrl = self.currentItemValue;
	}
    else if([elementName isEqualToString:@"guid"])
    {
		self.currentItem.guidUrl = self.currentItemValue;
	}
    else if([elementName isEqualToString:@"pubDate"])
    {
//		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//		[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		self.currentItem.pubDate = self.currentItemValue;
//		[formatter release];
	}
    else if([elementName isEqualToString:@"item"])
    {
		[[self rssItems] addObject:self.currentItem];
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if(nil != self.currentItemValue){
		[self.currentItemValue appendString:string];
	}
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
	//Not needed for now
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
	if(parseError.code != NSXMLParserDelegateAbortedParseError) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		[(id)[self delegate] performSelectorOnMainThread:@selector(processHasErrors)
		 withObject:nil
		 waitUntilDone:NO];
	}
}



- (void)parserDidEndDocument:(NSXMLParser *)parser {
	[(id)[self delegate] performSelectorOnMainThread:@selector(processCompleted)
	 withObject:nil
	 waitUntilDone:NO];
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}


-(void)dealloc{
	self.currentItem = nil;
	self.currentItemValue = nil;
	self.delegate = nil;
	
	[_rssItems release];
	[super dealloc];
}

@end
