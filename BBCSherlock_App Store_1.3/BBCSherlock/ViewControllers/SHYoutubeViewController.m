//
//  BNWeiboViewController.m
//  BonaFilm
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-11-18.
//  Copyright (c) 2011年 NUS. All rights reserved.
//

#import "SHYoutubeViewController.h"
#import "SHYoutubeCell.h"
#import "YoutubeDetailedViewController.h"
#import "TweetCell.h"
#import "SBJson.h"
#import "CMPopTipView.h"

typedef enum 
{
    DEFAULT,BBCSHERLOCK,SHERLOCKOLOGY
}RSSTYPE;

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface SHYoutubeViewController()<UIActionSheetDelegate,CMPopTipViewDelegate>
@property(nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView;
@property(nonatomic, readwrite) BOOL reloading;
@property (nonatomic,assign) RSSTYPE type;
@property (nonatomic,retain) CMPopTipView *myPopTipView;
@end

@implementation SHYoutubeViewController

@synthesize jsonDict=_jsonDict;
@synthesize refreshHeaderView = _refreshHeaderView,myPopTipView=_myPopTipView;
@synthesize reloading = _reloading;
@synthesize parserUrl=_parserUrl,switchUrl=_switchUrl,type=_type;
@synthesize request = _request;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"VIDEOS";
//        NSString *youtubeTagUrl = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://aceisbored.co.cc/youtuberss.json"] encoding:NSUTF8StringEncoding error:nil];
//        SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
//        self.parserUrl = [[NSDictionary dictionaryWithDictionary:[parser objectWithString:youtubeTagUrl]] objectForKey:@"url"];
        self.switchUrl = @"http://gdata.youtube.com/feeds/api/videos/-/bbc/sherlock?orderby=published&alt=json";
        self.parserUrl = @"http://gdata.youtube.com/feeds/api/users/sherlockology/uploads?alt=json";
        self.type = SHERLOCKOLOGY;
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
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showPopTipView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *popupButton = [[UIBarButtonItem alloc]initWithCustomView:infoButton];
    self.navigationItem.leftBarButtonItem = popupButton;
	[popupButton release];
    
    
    UIBarButtonItem *switchItem = [[UIBarButtonItem alloc]initWithTitle:@"switch" style:UIBarButtonItemStyleBordered target:self action:@selector(switchYoutube)];
    self.navigationItem.rightBarButtonItem = switchItem;
    
    self.tableView.separatorColor = [UIColor clearColor];
    
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
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.parserUrl]];  
    [self.request setDelegate:self];
    [self.request setDidStartSelector:@selector(startRequest:)];
    [self.request setDidFinishSelector:@selector(reload:)];
    [self.request setDidFailSelector:@selector(fail:)];
    [self.request startAsynchronous];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
}

- (void)switchYoutube
{    
    UIActionSheet *sheet = [[[UIActionSheet alloc] initWithTitle:@"Switch Video Source" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil, nil] autorelease]; 
    if (self.type == SHERLOCKOLOGY) 
    {
        [sheet addButtonWithTitle:@"BBC Sherlock"];
    }
    else
    {
        [sheet addButtonWithTitle:@"Sherlockology"];
    }
    
    sheet.delegate = self;
    
    [sheet showFromToolbar:self.navigationController.toolbar];
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
    if (_spinner) 
    {
        [_spinner stopAnimating];
        [_spinner removeFromSuperview];
    }
    [UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 0.0;
	[UIView commitAnimations];
    
    //self.tableView.separatorColor = [UIColor lightGrayColor];
    
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    self.jsonDict =[parser objectWithString:[request responseString]] ;
    [parser release];
    [self.tableView reloadData];
    
    //    self.tableView.frame = CGRectMake(0, 44, self.tableView.frame.size.width, self.tableView.frame.size.height);
    self.tableView.frame = self.navigationController.view.bounds;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 68);
    
    self.reloading = NO;
	[self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    if (self.switchUrl.length > self.parserUrl.length)
    {
        self.type = SHERLOCKOLOGY;
    }
    else
    {
        self.type = BBCSHERLOCK;
    }
}

- (void)fail:(ASIHTTPRequest*)request
{
    if (_spinner) 
    {
        [_spinner stopAnimating];
        [_spinner removeFromSuperview];
    }
    [UIView beginAnimations: nil context: nil];
	_blockerView.alpha = 0.0;
	[UIView commitAnimations];
    
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Unable to download youtube feed. Please check if you are connected to internet." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];	
	[alert release];
    
    self.reloading = NO;
    [self.refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
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
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, self.tableView.frame.size.height - 68);
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
    return YES;
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"orientation");
}

- (void)dealloc
{
    [_jsonDict release];
    [self.refreshHeaderView removeFromSuperview];
	self.refreshHeaderView = nil;
    
    self.request.delegate = nil;
    [self.request cancel];
    self.request = nil;
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
    return [[[self.jsonDict objectForKey:@"feed"] objectForKey:@"entry"]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //UILabel *label = nil;
    SHYoutubeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) 
    {
        cell = [[[SHYoutubeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [cell loadWithDict:[[[self.jsonDict objectForKey:@"feed"] objectForKey:@"entry"]objectAtIndex:indexPath.row] ];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SHYoutubeCell *cell = (SHYoutubeCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    return [cell heightForCell];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    YoutubeDetailedViewController *detailViewController = [[YoutubeDetailedViewController alloc]initWithNibName:nil bundle:nil];    
    detailViewController.hidesBottomBarWhenPushed = YES;
    detailViewController.urlforRequest = [NSString stringWithString:[[[[[[self.jsonDict objectForKey:@"feed"] objectForKey:@"entry"]objectAtIndex:indexPath.row]objectForKey:@"link"]objectAtIndex:0]objectForKey:@"href"]];
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{	
	
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
    self.request.delegate = nil;
    [self.request cancel];
    
    self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.parserUrl]];   
	[self.request startAsynchronous];
    [self.request setDelegate:self];
    [self.request setDidStartSelector:@selector(startRequest:)];
    [self.request setDidFinishSelector:@selector(reload:)];
	[self.request setDidFailSelector:@selector(fail:)];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
	return self.reloading; // should return if data source model is reloading
}

#pragma mark-
#pragma mark- UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) 
    {
        NSString *temp = [NSString stringWithString:self.parserUrl];
        self.parserUrl = [NSString stringWithString:self.switchUrl];
        self.switchUrl = [NSString stringWithString:temp];
        
        NSLog(@"parserUrl %@",self.parserUrl);
        
        self.request.delegate = nil;
        [self.request cancel];
        
        self.request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.parserUrl]];   
        [self.request startAsynchronous];
        [self.request setDelegate:self];
        [self.request setDidStartSelector:@selector(startRequest:)];
        [self.request setDidFinishSelector:@selector(reload:)];
        [self.request setDidFailSelector:@selector(fail:)];
    }
}

#pragma mark-
#pragma mark- pop up view
- (void)showPopTipView 
{
    if(self.myPopTipView!= nil) return;
    NSString *message = @"The videos are either from 'BBC Sherlock' search tag or uploaded by Sherlockology";
    CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:message];
    popTipView.delegate = self;
    popTipView.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:74.0/255.0 blue:110.0/255.0 alpha:.3];
    [popTipView presentPointingAtBarButtonItem:self.navigationItem.leftBarButtonItem animated:YES];
    
    self.myPopTipView = popTipView;
    [popTipView release];
}

- (void)dismissPopTipView 
{
    [self.myPopTipView dismissAnimated:NO];
    self.myPopTipView = nil;
}

@end
