//
//  CharacterGalleryViewController.m
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "CharacterGalleryViewController.h"
#import "SBJson.h"
#import "UIImage+transform.h"
#import "UIImageExtras.h"
#import "CMPopTipView.h"

#import "GalleryDetailedViewController.h"

@interface CharacterGalleryViewController()<CMPopTipViewDelegate>
@property (nonatomic,retain) CMPopTipView *myPopTipView;
@end

@implementation CharacterGalleryViewController
@synthesize photoView = _photoView;
@synthesize jsonGalleryArray=_jsonGalleryArray;
@synthesize myPopTipView = _myPopTipView;

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
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showPopTipView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *popupButton = [[UIBarButtonItem alloc]initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = popupButton;
	[popupButton release];
    
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    self.jsonGalleryArray = [parser objectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"character" ofType:@"json"]]];
    
    self.photoView =[[[SectionedPhotoView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)] autorelease];
    self.photoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.photoView.photoDataSource = self;
    self.photoView.photoDelegate = self;
    self.photoView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.photoView];
    [self.photoView reloadData];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    self.view.frame = self.navigationController.view.bounds;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark sectioned photo view


- (NSInteger)numberOfSectionsInSectionedPhotoView:(SectionedPhotoView*)photoView 
{
    return [self.jsonGalleryArray count];
}

- (NSInteger)sectionedPhotoView:(SectionedPhotoView *)photoView numberOfPhotosInSection:(NSInteger)section 
{
    return [[self.jsonGalleryArray objectAtIndex:section]count];
}

- (NSString *)sectionedPhotoView:(SectionedPhotoView *)photoView photoURLAtIndexPath:(NSIndexPath *)indexPath 
{
    return [[[self.jsonGalleryArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] objectForKey:@"image"];
}   

- (NSString *)sectionedPhotoView:(SectionedPhotoView *)photoView titleForHeaderInSection:(NSInteger)section 
{
    if (section ==0) 
    {
        return @"MAIN";
    }
    else 
    {
        return @"RECURRING";
    }
}

- (void)sectionedPhotoView:(SectionedPhotoView *)photoView didSelectPhotoAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"section photo view tapped on %@", indexPath);
    
    UIView * imageView = [photoView imageViewForPhotoAtIndex:indexPath];
    CGRect rect = [self.view convertRect:imageView.frame fromView:imageView.superview];
    
    GalleryDetailedViewController* detailed = [[GalleryDetailedViewController alloc] initWithNibName:nil bundle:nil];
    detailed.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailed animated:NO];
    [detailed showImageAtIndex:indexPath.row inImageArray:[self.jsonGalleryArray objectAtIndex:indexPath.section] animatedFromRect:rect];
    [detailed release];
}

- (UIView *)sectionedPhotoView:(SectionedPhotoView *)photoView viewForHeaderInSection:(NSInteger)section 
{
    UIView * view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 4)] autorelease];
    view.backgroundColor = [UIColor clearColor];
    
    UILabel * label = [[[UILabel alloc] initWithFrame:CGRectMake(-10, 2, 0, 0)] autorelease];
    label.text = [NSString stringWithFormat:@"      %@    ", [self sectionedPhotoView:photoView titleForHeaderInSection:section]];
    label.font = [UIFont boldSystemFontOfSize:14];
    [label sizeToFit];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage blankImageWithTopColor:UIColorRGBA(.3, .4, 0.6, 1.) bottomColor:UIColorRGBA(.2, .3, .5, 1.) ofSize:CGSizeMake(1, label.frame.size.height)]];
    label.textColor = [UIColor whiteColor];
    label.layer.cornerRadius = 6.f;
    [view addSubview:label];
    
    return  view;
}

- (CGFloat)sectionedPhotoView:(SectionedPhotoView *)photoView heightForHeaderInSection:(NSInteger)section {
    return  22;
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
