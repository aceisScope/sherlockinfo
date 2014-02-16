//
//  BNWeiboViewController.m
//  BonaFilm
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-11-18.
//  Copyright (c) 2011年 NUS. All rights reserved.
//

#import "TumblrIndexViewController.h"
#import "SHTumblrCell.h"


#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface TumblrIndexViewController()
@property(nonatomic, retain) EGORefreshTableHeaderView * refreshHeaderView;
@property(nonatomic, readwrite) BOOL reloading;
- (NSString*) pathForJSONWithFileName:(NSString*)name;
- (void)directReload;
@end

@implementation TumblrIndexViewController

@synthesize jsonDict=_jsonDict;
@synthesize refreshHeaderView = _refreshHeaderView;
@synthesize reloading = _reloading;
@synthesize parserUrl;
@synthesize title;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.separatorColor = [UIColor clearColor];
    
    if (self.refreshHeaderView == nil) 
    {
        self.refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)] autorelease];
        self.refreshHeaderView.delegate = self;
        [self.tableView addSubview:self.refreshHeaderView];
    }
    
    _blockerView = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 460)] autorelease];
	_blockerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
	_blockerView.center = CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2);
	_blockerView.alpha = 0.0;
	_blockerView.clipsToBounds = YES;
    [self.view addSubview: _blockerView];
    [self.view bringSubviewToFront:_blockerView];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self pathForJSONWithFileName:[NSString stringWithFormat:@"%@%@",self.title,@".json"]]]) 
    {   
        ////direct load json from file without download
        [self directReload];
        return;
    }
    
    ASIHTTPRequest * php_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.parserUrl]]; 
	[php_request startAsynchronous];
    [php_request setDelegate:self];
    [php_request setDidStartSelector:@selector(startRequest:)];
    [php_request setDidFinishSelector:@selector(reload:)];
}

- (void)directReload
{
    NSString* jsonString = [NSString stringWithContentsOfFile: [self pathForJSONWithFileName:[NSString stringWithFormat:@"%@%@",self.title,@".json"]]];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    self.jsonDict =[parser objectWithString:jsonString] ;
    [parser release];
    [self.tableView reloadData];
}

- (void)startRequest:(ASIHTTPRequest*)request
{
    self.reloading = YES;
    
    [UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 1.0;
	[UIView commitAnimations];
    
    _spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite] autorelease];
	_spinner.center = CGPointMake(_blockerView.bounds.size.width / 2 , _blockerView.bounds.size.height / 2 -44);
	[_blockerView addSubview: _spinner];
    [_spinner startAnimating];
}

- (void)reload:(ASIHTTPRequest*)request
{
    [_spinner stopAnimating];
    [_spinner removeFromSuperview];
    [UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 0.0;
	[UIView commitAnimations];
    
    self.tableView.separatorColor = [UIColor lightGrayColor];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    self.jsonDict =[parser objectWithString:[request responseString]] ;
    [parser release];
    [self.tableView reloadData];
    
    self.tableView.frame = self.navigationController.view.bounds;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 44);
    
    self.reloading = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    
    ASIHTTPRequest *downloadRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.parserUrl]];
    [downloadRequest setDownloadDestinationPath:[self pathForJSONWithFileName:[[self.parserUrl pathComponents]objectAtIndex:4]]];
    [downloadRequest startSynchronous];
    
}

- (NSString*) pathForJSONWithFileName:(NSString*)name
{
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
    
    [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return [filePath stringByAppendingPathComponent:name];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.refreshHeaderView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tableView.frame = self.navigationController.view.bounds;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 44);
    //self.tableView.frame = CGRectMake(0, 44, self.tableView.frame.size.width, 480-44-49);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [_jsonDict release];
    self.title = nil;
    [self.refreshHeaderView removeFromSuperview];
	self.refreshHeaderView = nil;
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.jsonDict objectForKey:@"value"] objectForKey:@"items"]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UILabel *label = nil;
    SHTumblrCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[SHTumblrCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
     [cell loadWithDict:[[[self.jsonDict objectForKey:@"value"] objectForKey:@"items"]objectAtIndex:indexPath.row] ];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHTumblrCell *cell = (SHTumblrCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell heightForCell];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    //    BNWeiboDetailedViewController *detailViewController = [[BNWeiboDetailedViewController alloc] initWithDict:[self.jsonDictArray objectAtIndex:indexPath.row]];
    //    detailViewController.hidesBottomBarWhenPushed = YES;
    //    [self.navigationController pushViewController:detailViewController animated:YES];
    //    [detailViewController release];
    
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
	
    ASIHTTPRequest * php_request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.parserUrl]];   
	[php_request startAsynchronous];
    [php_request setDelegate:self];
    [php_request setDidStartSelector:@selector(startRequest:)];
    [php_request setDidFinishSelector:@selector(reload:)];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.reloading; // should return if data source model is reloading
}

@end
