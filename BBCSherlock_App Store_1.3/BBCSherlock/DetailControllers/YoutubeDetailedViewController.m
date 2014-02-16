//
//  YoutubeDetailedViewController.m
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "YoutubeDetailedViewController.h"
#import "SHK.h"

@implementation YoutubeDetailedViewController

@synthesize urlforRequest = _urlforRequest;
@synthesize toolbar=_toolbar;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
    
    _activityDetailedView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    _activityDetailedView.delegate = self;
    _activityDetailedView.opaque = NO;
    _activityDetailedView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_activityDetailedView];
    [_activityDetailedView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlforRequest]]];
    
    loadBalance = 0;
    
    self.toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height - 88, self.view.bounds.size.width, 44)];
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

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if(buttonIndex == 0){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.urlforRequest]];
	}
}

- (void)share
{
    SHKItem *item = [SHKItem URL:[NSURL URLWithString:self.urlforRequest] title:@"from youtube BBC Sherlock tag "];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromToolbar:self.navigationController.toolbar]; 
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.toolbar = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([[UIApplication sharedApplication] statusBarOrientation]== UIInterfaceOrientationPortrait) 
    {
        _activityDetailedView.frame = CGRectMake(0, 0, 320, 460 - 44);
    }
    else
    {
        _activityDetailedView.frame = CGRectMake(0, 0, 460, 320 - 44);
        
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    NSLog(@"orientation");
    if ([[UIApplication sharedApplication] statusBarOrientation]== UIInterfaceOrientationPortrait) 
    {
        _activityDetailedView.frame = CGRectMake(0, 0, 320, 460 - 44);
    }
    else
    {
        _activityDetailedView.frame = CGRectMake(0, 0, 460, 320 - 44);

    }
}

- (void)dealloc
{
    [_activityDetailedView release];
    [super dealloc];
}

#pragma mark-
#pragma mark- UIWebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    loadBalance ++;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    loadBalance --;
}


@end
