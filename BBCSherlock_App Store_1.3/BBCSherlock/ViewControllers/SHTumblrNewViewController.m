//
//  SHTumblrNewViewController.m
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 11-12-22.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHTumblrNewViewController.h"
#import "TumblrIndexViewController.h"

#define BUTTONWIDTH 280
#define BUTTONHEIGHT 50

@interface SHTumblrNewViewController()
@property (nonatomic,retain) UIButton *cumberbatchwebButton;
@property (nonatomic,retain) UIButton *sherlockologyButton;
@end

@implementation SHTumblrNewViewController

@synthesize cumberbatchwebButton=_cumberbatchwebButton,sherlockologyButton=_sherlockologyButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"FANS";
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
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]]];
    
    self.cumberbatchwebButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cumberbatchwebButton setBackgroundImage:[UIImage imageNamed:@"cumberbatchweb.png"] forState:UIControlStateNormal];
    [self.cumberbatchwebButton setBackgroundImage:[UIImage imageNamed:@"cumberbatchweb-selected.png"] forState:UIControlStateSelected];
    [self.view addSubview:self.cumberbatchwebButton];
    [self.cumberbatchwebButton addTarget:self action:@selector(pushTumblrIndexController:) forControlEvents:UIControlEventTouchUpInside];
    self.cumberbatchwebButton.titleLabel.text = @"cumberbatchweb";
    self.cumberbatchwebButton.titleLabel.textColor = [UIColor clearColor];
    
    self.sherlockologyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.sherlockologyButton setBackgroundImage:[UIImage imageNamed:@"sherlockology.png"] forState:UIControlStateNormal];
    [self.sherlockologyButton setBackgroundImage:[UIImage imageNamed:@"sherlockology-selected.png"] forState:UIControlStateSelected];
    [self.view addSubview:self.sherlockologyButton];
    [self.sherlockologyButton addTarget:self action:@selector(pushTumblrIndexController:) forControlEvents:UIControlEventTouchUpInside];
    self.sherlockologyButton.titleLabel.text = @"sherlockology";
    self.sherlockologyButton.titleLabel.textColor = [UIColor clearColor];
    
    self.cumberbatchwebButton.frame = CGRectMake((self.view.frame.size.width-BUTTONWIDTH)/2, self.view.frame.size.height/2 - BUTTONHEIGHT - 40, BUTTONWIDTH, BUTTONHEIGHT);
    self.sherlockologyButton.frame = CGRectMake((self.view.frame.size.width-BUTTONWIDTH)/2, self.view.frame.size.height/2 - BUTTONHEIGHT + 40, BUTTONWIDTH, BUTTONHEIGHT);
    
}

- (void)pushTumblrIndexController:(id)sender
{
    UIButton *button = (UIButton*)sender;
    TumblrIndexViewController *detailViewController = [[TumblrIndexViewController alloc] initWithUrlString:[NSString stringWithFormat:@"%@%@%@",@"http://", button.titleLabel.text,@".tumblr.com/rss"]];
    detailViewController.title =  button.titleLabel.text;
    detailViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.cumberbatchwebButton = nil;
    self.sherlockologyButton = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.cumberbatchwebButton.frame = CGRectMake((self.view.frame.size.width-BUTTONWIDTH)/2, self.view.frame.size.height/2 - BUTTONHEIGHT - 40, BUTTONWIDTH, BUTTONHEIGHT);
    self.sherlockologyButton.frame = CGRectMake((self.view.frame.size.width-BUTTONWIDTH)/2, self.view.frame.size.height/2 - BUTTONHEIGHT + 40, BUTTONWIDTH, BUTTONHEIGHT);
}

@end
