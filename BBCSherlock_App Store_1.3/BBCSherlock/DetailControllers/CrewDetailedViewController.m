//
//  CrewDetailedViewController.m
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "CrewDetailedViewController.h"

#define kImageTag       @"image"
#define kOccupationTag  @"occupation"
#define kTitleTag       @"title"
#define kBriefTag       @"brief"

@implementation CrewDetailedViewController
@synthesize crewDict=_crewDict;

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) 
    {
        self.crewDict = [NSDictionary dictionaryWithDictionary:dict];
    }
    return self;
}

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
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    crewWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 44)];
    crewWebView.backgroundColor=[UIColor clearColor];
    crewWebView.opaque = NO;
    crewWebView.autoresizingMask=UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:crewWebView];
    
    
    NSString * template = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"crew_template.html" ofType:nil] encoding:NSUTF8StringEncoding error:nil];
    NSString * titleImageURL = [self.crewDict valueForKey:kImageTag];
    NSURL * baseURL = [[NSBundle mainBundle] resourceURL];

//    if ([FullyLoaded tmpFileExistsForResourceAtURL:titleImageURL]) {
//        titleImageURL = [NSString stringWithFormat:@"file://%@", [FullyLoaded tmpFilePathForResourceAtURL:titleImageURL]];
//    }
    NSString * htmlString = [NSString stringWithFormat:template, titleImageURL,
                             [self.crewDict objectForKey:kOccupationTag],
                             [self.crewDict objectForKey:kTitleTag],
                             [self.crewDict objectForKey:kBriefTag]];

    [crewWebView loadHTMLString:htmlString baseURL:baseURL];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
