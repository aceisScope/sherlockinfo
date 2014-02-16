//
//  SHGalleryViewController.m
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "SHGalleryViewController.h"
#import "SBJson.h"
#import "UIImage+transform.h"
#import "UIImageExtras.h"
#import "CrewDetailedViewController.h"
#import "CMPopTipView.h"

@interface SHGalleryViewController()<CMPopTipViewDelegate>
@property (nonatomic,retain) CMPopTipView *myPopTipView;
@end

@implementation SHGalleryViewController
@synthesize photoView = _photoView;
@synthesize jsonGalleryArray = _jsonGalleryArray;
@synthesize posterView=_posterView;
@synthesize myPopTipView=_myPopTipView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"CREW";
        self.jsonGalleryArray = [NSArray array];
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
    
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    self.jsonGalleryArray = [[parser objectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"crew" ofType:@"json"]]]objectForKey:@"images"];

    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self action:@selector(showPopTipView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *popupButton = [[UIBarButtonItem alloc]initWithCustomView:infoButton];
    self.navigationItem.rightBarButtonItem = popupButton;
	[popupButton release];
    
    self.posterView = [[[ThumbsTableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)] autorelease];
    self.posterView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.posterView.thumbsViewDelegate = self;
    self.posterView.dataSource = self;
    self.posterView.numberOfColsPerPage = 3;
    self.posterView.numberOfRowsPerPage = 3;
    self.posterView.scrollingType = ScrollingTypeVertical;
    self.posterView.backgroundColor = [UIColor blackColor]; //[UIColor colorWithRed:0.5 green:.5 blue:.55 alpha:1.];
    [self.view addSubview:self.posterView];  
    [self.posterView reloadData];
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
    return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark-
#pragma mark- pop up view
- (void)showPopTipView 
{
    if(self.myPopTipView!= nil) return;
    NSString *message = @"All of the images and information about crew is basically from Sherlockology.(http://sherlockology.com)";
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


#pragma mark CMPopTipViewDelegate methods
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView 
{
    // User can tap CMPopTipView to dismiss it
    self.myPopTipView = nil;
}

#pragma mark -
#pragma mark sectioned photo view


- (NSInteger)numberOfSectionsInSectionedPhotoView:(SectionedPhotoView*)photoView 
{
    return [self.jsonGalleryArray count];
}

- (NSInteger)sectionedPhotoView:(SectionedPhotoView *)photoView numberOfPhotosInSection:(NSInteger)section 
{
    return [[[self.jsonGalleryArray objectAtIndex:section] valueForKey:@"images"] count];
}

- (NSString *)sectionedPhotoView:(SectionedPhotoView *)photoView photoURLAtIndexPath:(NSIndexPath *)indexPath 
{
//    NSLog(@"photo:%@",[[[self.jsonGalleryArray objectAtIndex:indexPath.section] valueForKey:@"images"] objectAtIndex:indexPath.row]);
    return [[[self.jsonGalleryArray objectAtIndex:indexPath.section] valueForKey:@"images"] objectAtIndex:indexPath.row];
}

- (NSString *)sectionedPhotoView:(SectionedPhotoView *)photoView titleForHeaderInSection:(NSInteger)section 
{
 //   NSLog(@"title %@ for section %d", [[self.jsonGalleryArray objectAtIndex:section] valueForKey:@"title"], section);
    return [[self.jsonGalleryArray objectAtIndex:section] valueForKey:@"title"];
}

- (void)sectionedPhotoView:(SectionedPhotoView *)photoView didSelectPhotoAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"section photo view tapped on %@", indexPath);
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

#pragma mark -
#pragma mark thumb table view datasource

- (int) numberOfImagesForThumbsTableView:(ThumbsTableView*)thumbsTableView
{
    return [self.jsonGalleryArray count];
}

- (UIImage *) placeHoldImageForThumbsTableView:(ThumbsTableView*)thumbsTableView
{
    return nil;   //此处需要添加
}

- (UIImageView*) thumbsTableView:(ThumbsTableView*)thumbsTableView thumbsViewForIndex:(int)index
{
    UIImageView * imageView = (UIImageView*)[thumbsTableView dequeueReusableImageView];
    
    if (imageView == nil) 
    {
        imageView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 1.f;
        imageView.layer.borderColor = [[UIColor grayColor] CGColor];
    }
    imageView.image = [[UIImage imageNamed:[self.jsonGalleryArray objectAtIndex:index]] imageScalingToHalfFromSide:1];
    return imageView;
}

#pragma mark -
#pragma mark thumb table view delegate
- (void)thumbsTableView:(ThumbsTableView *)thumbsTableView didSelectThumbsViewAt:(int)index
{
    NSLog(@"thumbsTableView didSelectThumbsViewAt:%d",index);
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    CrewDetailedViewController *detailedViewController = [[CrewDetailedViewController alloc]initWithDict:[[[parser objectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"crew" ofType:@"json"]]]objectForKey:@"info"]objectAtIndex:index]];
    detailedViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailedViewController animated:YES];
    [detailedViewController release];
}

- (void)thumbsTableView:(ThumbsTableView *)thumbsTableView didLongTapThumbsViewAt:(int)index
{
    NSLog(@"thumbsTableView didLongTapThumbsViewAt:%d",index);

}



@end
