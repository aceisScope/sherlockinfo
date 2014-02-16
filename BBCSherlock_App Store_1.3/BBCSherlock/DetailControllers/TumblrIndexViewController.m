//
//  TumblrIndexViewController.m
//  Sherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TumblrIndexViewController.h"
#import "BlogRssParser.h"
#import "BlogRss.h"
#import "TumblrDetailedViewController.h"
#import "ASIHTTPRequest.h"
#import "TweetCell.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface TumblrIndexViewController()
- (NSString*) pathForXMLWithFileName:(NSString*)name;
@property(nonatomic, retain) EGORefreshTableHeaderView * refreshHeaderView;
@property(nonatomic, readwrite) BOOL reloading;
@end


@implementation TumblrIndexViewController

@synthesize tableView = _tableView;
@synthesize toolbar = _toolbar;
@synthesize rssParser = _rssParser;
@synthesize parserUrl = _parserUrl;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize reloading = _reloading;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.parserUrl = @"hello";
    }
    return self;
}

- (id)initWithUrlString:(NSString*)url
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.parserUrl = [[[NSString alloc] initWithString:url] retain];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)toolbarInit
{
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc]
                                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                      target:self action:@selector(reloadRss)];
	refreshButton.enabled = NO;
	NSArray *items = [NSArray arrayWithObjects: refreshButton,  nil];
	[self.toolbar setItems:items animated:NO];
	[refreshButton release];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
	[super viewDidLoad];
        
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    self.tableView.separatorColor = [UIColor clearColor];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    if (self.refreshHeaderView == nil) 
    {
        self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)] autorelease];
        self.refreshHeaderView.delegate = self;
        [self.tableView addSubview:self.refreshHeaderView];
    }
    
    _blockerView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, self.view.frame.size.height)] autorelease];
	_blockerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
	_blockerView.alpha = 0.0;
	_blockerView.clipsToBounds = YES;
    [self.view addSubview: _blockerView];
    [self.view bringSubviewToFront:_blockerView];
    
    _rssParser = [[BlogRssParser alloc]init];
    _rssParser.url = [NSString stringWithString:self.parserUrl];
	self.rssParser.delegate = self;
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathForXMLWithFileName:[NSString stringWithFormat:@"%@%@",self.title,@".xml"]]]) 
    {   
        ////direct load json from file without download
        _rssParser.xmlfilePath = [self pathForXMLWithFileName:[NSString stringWithFormat:@"%@%@",self.title,@".xml"]];
    }
	[[self rssParser]startProcess];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.tableView = nil;
    self.toolbar = nil;
    self.rssParser = nil;
}

-(void)reloadRss
{
//	[self toggleToolBarButtons:NO];
	[[self rssParser]startProcess];
}

//-(void)toggleToolBarButtons:(BOOL)newState
//{
//	NSArray *toolbarItems = self.toolbar.items;
//	for (UIBarButtonItem *item in toolbarItems){
//		item.enabled = newState;
//	}	
//}

- (NSString*) pathForXMLWithFileName:(NSString*)name
{
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return [filePath stringByAppendingPathComponent:name];
}

#pragma mark-
#pragma mark- Blog Parser delegate

- (void)processStarted
{
    NSLog(@"rss process started");
    self.reloading = YES;
    
    [UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 1.0;
	[UIView commitAnimations];
    
    _spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
	_spinner.center = CGPointMake(_blockerView.bounds.size.width / 2 , _blockerView.bounds.size.height / 2);
	[_blockerView addSubview: _spinner];
    [_spinner startAnimating];
}

//Delegate method for blog parser will get fired when the process is completed
- (void)processCompleted
{
    NSLog(@"rss process completed");
	//reload the table view
    
    [_spinner stopAnimating];
    [_spinner removeFromSuperview];
    [UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 0.0;
	[UIView commitAnimations];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
	[self.tableView reloadData];
    self.reloading = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    ASIHTTPRequest *downloadRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.parserUrl]];
    [downloadRequest setDownloadDestinationPath:[self pathForXMLWithFileName:[NSString stringWithFormat:@"%@%@",self.title,@".xml"]]];
    [downloadRequest startAsynchronous];
}

-(void)processHasErrors
{
	//Might be due to Internet
    [_spinner stopAnimating];
    [_spinner removeFromSuperview];
    [UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 0.0;
	[UIView commitAnimations];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Unable to download tumblr rss. Please check if you are connected to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
    
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark-
#pragma mark- tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [[[self rssParser]rssItems]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"rssItemCell";
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) 
    {
        cell = [[[TweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (indexPath.row < [[self rssParser]rssItems].count) 
    {
//        [cell loadWithDict:[NSDictionary dictionaryWithObjectsAndKeys:[[[[self rssParser]rssItems]objectAtIndex:indexPath.row]title],@"title",[[[[self rssParser]rssItems]objectAtIndex:indexPath.row]pubDate],@"pubDate",nil]];
        [cell loadWithDict:[NSDictionary dictionaryWithObjectsAndKeys:[[[[self rssParser]rssItems]objectAtIndex:indexPath.row]title], kTextTag,@"",kAvatarTag,@"",kNameTag,[[[[self rssParser]rssItems]objectAtIndex:indexPath.row]pubDate],kTimeTag,@"",kTweetPicTag,nil]];
    }
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    
    NSLog(@"tumblr did select at %d",indexPath.row);
    TumblrDetailedViewController *detailViewController = [[TumblrDetailedViewController alloc] initWithNibName:nil bundle:nil];    

    detailViewController.hidesBottomBarWhenPushed = YES;
    detailViewController.currentlySelectedBlogItem = [[[self rssParser]rssItems]objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TweetCell *cell = (TweetCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell heightForCell];
}


- (void)dealloc 
{
	[_toolbar release];
	[_tableView release];
	[_rssParser release];
    [_parserUrl release];
    [super dealloc];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{	
	
	[self.refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	
	[self.refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    _rssParser.xmlfilePath = nil;
    [self reloadRss];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.reloading; // should return if data source model is reloading
}


@end
