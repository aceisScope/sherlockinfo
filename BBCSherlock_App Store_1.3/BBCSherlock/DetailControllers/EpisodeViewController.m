//
//  EpisodeViewController.m
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EpisodeViewController.h"
#import "SBJson.h"
#import "CMPopTipView.h"

@interface EpisodeViewController()<CMPopTipViewDelegate>
@property (nonatomic,retain) CMPopTipView *myPopTipView;
@end

@implementation EpisodeViewController
@synthesize episodeView = _episodeView;
@synthesize webArray = _webArray;
@synthesize myPopTipView = _myPopTipView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Episodes";
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
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showPopTipView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *popupButton = [[UIBarButtonItem alloc]initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = popupButton;
	[popupButton release];
    
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    self.webArray = [parser objectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"episode" ofType:@"json"]]];
    
    self.episodeView = [[APWebScrollView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height - 44)];
    self.episodeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.episodeView];
    [self.episodeView showPageAtIndex:0 inWebArray:self.webArray];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.episodeView = nil;
    self.webArray = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark-
#pragma mark- pop up view
- (void)showPopTipView 
{
    if(self.myPopTipView!= nil) return;
    NSString *message = @"Copyright of all the images and words belongs to BBC. No infringement intended.";
    CMPopTipView *popTipView = [[CMPopTipView alloc] initWithMessage:message];
    popTipView.delegate = self;
    popTipView.backgroundColor = [UIColor colorWithRed:134.0/255.0 green:74.0/255.0 blue:110.0/255.0 alpha:.3];
    [popTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    
    self.myPopTipView = popTipView;
    [popTipView release];
}

- (void)dismissPopTipView 
{
    [self.myPopTipView dismissAnimated:NO];
    self.myPopTipView = nil;
}

@end
