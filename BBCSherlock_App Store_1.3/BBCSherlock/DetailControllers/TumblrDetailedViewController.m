//
//  TumblrDetailedViewController.m
//  Sherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TumblrDetailedViewController.h"
#import "SHK.h"

@implementation TumblrDetailedViewController

@synthesize titleTextView = _titleTextView;
@synthesize descriptionWebView = _descriptionWebView;
@synthesize toolbar = _toolbar;
@synthesize currentlySelectedBlogItem = _currentlySelectedBlogItem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"POSTS";
    
    self.titleTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, 50)];
    self.titleTextView.font =[UIFont systemFontOfSize:17]; 
    CGSize size = [[self.currentlySelectedBlogItem title] sizeWithFont:[UIFont systemFontOfSize:20] constrainedToSize:CGSizeMake(320, 1000) lineBreakMode:UILineBreakModeWordWrap];
    self.titleTextView.frame = CGRectMake(0, 44, self.view.bounds.size.width, size.height*1.3<=200?size.height*1.3:200);
    [self.view addSubview:self.titleTextView];
        
    self.descriptionWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, self.titleTextView.frame.size.height + 44, self.view.bounds.size.width, self.view.bounds.size.height  - self.titleTextView.frame.size.height - 88)];
    [self.view addSubview:self.descriptionWebView];
    self.descriptionWebView.delegate = self;
    
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 44, self.view.bounds.size.width, 44)];
    self.toolbar.barStyle = UIBarStyleBlackTranslucent;
    [self.view addSubview:self.toolbar];

    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc]initWithTitle:@"safari" style:UIBarButtonItemStyleBordered target:self action:@selector(openWebLink)];
	NSArray *items = [NSArray arrayWithObjects: actionButton,nil];
	[self.toolbar setItems:items animated:NO];
	[actionButton release];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = shareButton;
	[shareButton release];
}

-(void)openWebLink
{
	// open a dialog with an OK and cancel button
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Do you want to open current item in browser?"
															 delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"OK" otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    [actionSheet showFromToolbar:self.toolbar];
	[actionSheet release];	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	if(buttonIndex == 0){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.currentlySelectedBlogItem linkUrl]]];
	}
}

- (void)share
{
//    NSLog(@"%@",[self.currentlySelectedBlogItem linkUrl]);
    SHKItem *item = [SHKItem URL:[NSURL URLWithString:[self.currentlySelectedBlogItem linkUrl]] title:[self.currentlySelectedBlogItem title]];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromToolbar:self.navigationController.toolbar]; 
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [self.descriptionWebView stopLoading];
    self.titleTextView = nil;
    self.descriptionWebView = nil;
    self.toolbar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	self.titleTextView.text = [self.currentlySelectedBlogItem title];
//    NSLog(@"tumblr description:%@",[self.currentlySelectedBlogItem description]);
    [self.descriptionWebView loadHTMLString:[self.currentlySelectedBlogItem description] baseURL:[NSURL URLWithString:@"http://tumblr.com"]];

}

- (void)viewDidAppear:(BOOL)animated
{
   
}

- (void)viewWillDisappear:(BOOL)animated
{
     [self.descriptionWebView stopLoading];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [_toolbar release];
    [_titleTextView release];
    [_descriptionWebView release];
    [super dealloc];
}

#pragma mark-
#pragma mark- UIWebView Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;    
{
    ////////////////open link in safari
    NSURL *requestURL =[ [ request URL ] retain ];
    if ( ( [ [ requestURL scheme ] isEqualToString: @"http" ] || [ [ requestURL scheme ] isEqualToString: @"https" ] || [ [ requestURL scheme ] isEqualToString: @"mailto" ])
        && ( navigationType == UIWebViewNavigationTypeLinkClicked ) ) {
        return ![ [ UIApplication sharedApplication ] openURL: [ requestURL autorelease ] ];
    }
    [ requestURL release ];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"tumblr description start load");
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"tumblr description finish load");
}

@end
