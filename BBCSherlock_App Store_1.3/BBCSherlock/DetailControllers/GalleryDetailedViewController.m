//
//  GalleryDetailedViewController.m
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "GalleryDetailedViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface GalleryDetailedViewController()
- (void) toggleNavigationBar;
@end

@implementation GalleryDetailedViewController
@synthesize detailedView = _detailedView;

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
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.detailedView = [[[APImageScrollViewWithDescription alloc] initWithFrame:self.view.bounds] autorelease];
    self.detailedView.delegate = self;
    self.detailedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.detailedView];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.detailedView = nil;
}

- (void) viewWillAppear:(BOOL)animated 
{
    [super viewWillAppear:animated];
    
	self.navigationController.navigationBar.translucent = YES;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	self.navigationController.navigationBar.tintColor = nil;
    
    if (![self.navigationController isNavigationBarHidden]) 
    {
        [self toggleNavigationBar];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isInImageDetailedViewMode"];
}

- (void) viewWillDisappear:(BOOL)animated 
{
	[super viewWillDisappear:animated];
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
	self.navigationController.navigationBar.translucent = NO;
	[self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.navigationController setToolbarHidden:YES];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isInImageDetailedViewMode"];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) toggleNavigationBar 
{
    BOOL shouldHide = ![self.navigationController isNavigationBarHidden];
    [self.navigationController setNavigationBarHidden:shouldHide animated:YES];
}

#pragma mark-
#pragma mark- APPageScrollViewDelegate

- (void) singleTapOnPageScrollView:(APPageScrollView *)pageScrollView
{
    [self toggleNavigationBar];
}

- (void) showImageAtIndex:(int)index inImageArray:(NSArray *)imageArray_ animatedFromRect:(CGRect)rect 
{
    [self view];
    [self.detailedView showImageAtIndex:index inImageArray:imageArray_ animatedFromRect:rect];
    self.detailedView.frame = self.view.bounds;
}


@end
