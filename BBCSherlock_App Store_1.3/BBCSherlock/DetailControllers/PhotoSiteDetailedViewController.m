//
//  PhotoSiteDetailedViewController.m
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-10.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "PhotoSiteDetailedViewController.h"
#import "SHK.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

@interface PhotoSiteDetailedViewController()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate>
- (void)shareMyPhoto;
@end

@implementation PhotoSiteDetailedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
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
    
    OHAttributedLabel *textLabel = [[[OHAttributedLabel alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width - 60, self.view.frame.size.height - 200)] autorelease];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    [textLabel setNumberOfLines:0];
    [self.view addSubview:textLabel];
    
    NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:@"  Take your photo of \n Sherlock Sites \n share it with a \n hashtag \n #SherlockSite !"];
    [attrStr setTextColor:[UIColor whiteColor] range:NSMakeRange(0,[attrStr length])];
    [attrStr setFont:[UIFont fontWithName:@"Times New Roman" size:30]];
    
    textLabel.attributedText = attrStr;
    [textLabel setTextAlignment:UITextAlignmentCenter];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cameraButton setBackgroundImage:[UIImage imageNamed:@"camera.png"] forState:UIControlStateNormal];
    cameraButton.frame = CGRectMake(0, 300, 60, 60);
    cameraButton.center = CGPointMake(160, 330);
    [self.view addSubview:cameraButton];
    [cameraButton addTarget:self action:@selector(shareMyPhoto) forControlEvents:UIControlEventTouchUpInside];
    
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

#pragma mark -
#pragma mark image picker

#define ACTION_IMAGE_SOURCE_TAG 20002

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info 
{
    [picker dismissModalViewControllerAnimated:NO];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{ 
    
    if (!error)
    {
        SHKItem *item = [SHKItem image:image title:@"#SherlockSite"];
        SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
        [actionSheet showFromToolbar:self.navigationController.toolbar];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"Please make sure there's enough space in the album" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker 
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void) showPickerCamera 
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void) showPickerAlbum 
{
    UIImagePickerController * picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentModalViewController:picker animated:YES];
    [picker release];
}

- (void) shareMyPhoto 
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) 
    {
        UIActionSheet * actions = [[UIActionSheet alloc] initWithTitle:@"Photo the site" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take a photo", @"My Album", nil];
        actions.tag = ACTION_IMAGE_SOURCE_TAG;
        [actions showInView:self.view];
        [actions release];
    }
    else {
        [self showPickerAlbum];
    }
}

#pragma mark -
#pragma mark UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == ACTION_IMAGE_SOURCE_TAG) {
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            [self showPickerCamera];
        }
        else if (buttonIndex == actionSheet.firstOtherButtonIndex+1) {
            [self showPickerAlbum];
        }
    }
}

@end
