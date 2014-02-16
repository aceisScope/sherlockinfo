//
//  SHHomeViewController.m
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SHHomeViewController.h"
#import "PhotoSiteDetailedViewController.h"
#import "CharacterGalleryViewController.h"
#import "EpisodeViewController.h"

#import "SHK.h"
#import <QuartzCore/QuartzCore.h>

@implementation SHHomeViewController
@synthesize tableView=_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"HOME";
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    }
    return self;
}

- (void)dealloc
{
    self.tableView = nil;
    [super dealloc];
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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:IS_IPHONE_5?@"home_background-568h.png":@"home_background.png"]];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.opaque=NO;
    self.tableView.backgroundView = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollEnabled=NO;
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem *logoutItem = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
    self.navigationItem.rightBarButtonItem = logoutItem;
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
    if ([self.tabBarController.view.subviews count] == 3) return YES;
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -

- (void)logout
{
	[[[[UIAlertView alloc] initWithTitle:SHKLocalizedString(@"Logout")
								 message:SHKLocalizedString(@"Are you sure to logout of all share services?")
								delegate:self
					   cancelButtonTitle:SHKLocalizedString(@"Cancel")
					   otherButtonTitles:@"Logout",nil] autorelease] show];
	
	[SHK logoutOfAll];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	if (buttonIndex == 0)
		[SHK logoutOfAll];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) 
    {
        cell=[[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.textLabel.font = [UIFont fontWithName:@"Zapfino" size:20];
    if (indexPath.row == 0) 
    {
        cell.textLabel.text = @"Characters";
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.layer.shadowColor = [UIColor whiteColor].CGColor;
        cell.textLabel.layer.shadowOffset = CGSizeMake(1, 1);
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"Episodes";
        cell.textLabel.textAlignment = UITextAlignmentRight;
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"Photo the site";
        cell.textLabel.textAlignment = UITextAlignmentLeft;
    }
    cell.textLabel.textColor =[UIColor whiteColor]; 
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if ([[UIApplication sharedApplication]statusBarOrientation] == UIInterfaceOrientationPortrait) 
    {
        return 124;
    }
    else
        return 77;
	
}

#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"select on cell %d",indexPath.row);
    if (indexPath.row == 0) 
    {
        CharacterGalleryViewController *detailViewController = [[CharacterGalleryViewController alloc]initWithNibName:nil bundle:nil]; 
        detailViewController.title = @"Characters";
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    else if (indexPath.row == 2)
    {
        PhotoSiteDetailedViewController *detailViewController = [[PhotoSiteDetailedViewController alloc]initWithNibName:nil bundle:nil]; 
        detailViewController.title = @"Photo the Site";
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    else
    {
        EpisodeViewController *detailViewController = [[EpisodeViewController alloc]initWithNibName:nil bundle:nil]; 
        detailViewController.title = @"Episodes";
        detailViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
}

@end
