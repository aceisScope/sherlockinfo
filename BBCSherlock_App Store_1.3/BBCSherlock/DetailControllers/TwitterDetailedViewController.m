//
//  TwitterDetailedViewController.m
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 11-12-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "TwitterDetailedViewController.h"
#import "SHK.h"
#import "SBJson.h"

@implementation TwitterDetailedViewController

@synthesize textLabel=_textLabel,tweetDict=_tweetDict,avatarImage=_avatarImage;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        // Custom initialization
        self.textLabel = [[[OHAttributedLabel alloc] initWithFrame:CGRectZero] autorelease];
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.textLabel];
        
        self.avatarImage = [[[AsyncImageView alloc] initWithFrame:CGRectZero] autorelease];
        [self.view addSubview:self.avatarImage];
    }
    return self;
}

- (id)initWithDict:(NSDictionary *)dict
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) 
    {
        self.textLabel = [[[OHAttributedLabel alloc] initWithFrame:CGRectMake(0,0,0,0)] autorelease];
        self.textLabel.backgroundColor = [UIColor clearColor];
        [self.view addSubview:self.textLabel];
        
        self.avatarImage = [[[AsyncImageView alloc] initWithFrame:CGRectZero] autorelease];
        [self.view addSubview:self.avatarImage];
        
        self.tweetDict = [NSDictionary dictionaryWithDictionary:dict];
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
    self.textLabel.frame = CGRectMake(20,220,290,200);
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc]
                                    initWithBarButtonSystemItem:UIBarButtonSystemItemAction
                                    target:self action:@selector(share)];
    self.navigationItem.rightBarButtonItem = shareButton;
	[shareButton release];
}

- (void)viewDidAppear:(BOOL)animated
{    
    NSString *content = [NSString stringWithString:[self.tweetDict objectForKey:@"text"]];
    
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:content];
    [attrStr setTextColor:[UIColor whiteColor] range:NSMakeRange(0,[attrStr length])];
    [attrStr setFont:[UIFont fontWithName:@"American Typewriter" size:16]];
    
    
    //===================@ http set colour=======================//
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"@[^\\.^\\,^:^;^!^\\?^\\s^#^@^。^，^：^；^！^？]+" options:nil error:nil];
    NSArray* matches = [expression matchesInString:content options:nil range:NSMakeRange(0, [content length])];
    
    if(nil != matches){
        for(int i = 0; i < [matches count]; i++){
            [attrStr setTextColor:[UIColor colorWithRed:0xfe/256.0 green:0xec/256.0 blue:0xd2/256.0 alpha:0.8] range:[[matches objectAtIndex:i] range]];
        }
    }
    
    expression = [NSRegularExpression regularExpressionWithPattern:@"#[^\\.^\\,^:^;^!^\\?^\\s^#^@^。^，^：^；^！^？]+#" options:nil error:nil];
    matches = [expression matchesInString:content options:nil range:NSMakeRange(0, [content length])];
    
    if(nil != matches){
        for(int i = 0; i < [matches count]; i++){
            [attrStr setTextColor:[UIColor colorWithRed:0xfe/256.0 green:0xec/256.0 blue:0xd2/256.0 alpha:0.8] range:[[matches objectAtIndex:i] range]];
        }
    } 
    //================================================================================//
    [attrStr setLineHeightMultiple:1.0];

    self.textLabel.attributedText = attrStr;
    
    ASIHTTPRequest *userRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/show.json?screen_name=%@",self.title]]];
    [userRequest setCompletionBlock:^(void)
     {
         NSDictionary *userInfo = [[userRequest responseString] JSONValue];
         
        NSString *avatarUrl = [NSString stringWithString:[userInfo objectForKey:@"profile_image_url"]];
        NSString *fileName = [[avatarUrl pathComponents] objectAtIndex:4];
        NSString *fileExtension = [avatarUrl pathExtension];
        NSString *finalUrl = [NSString stringWithFormat:@"%@%@%@%@",[avatarUrl substringWithRange:NSMakeRange(0, avatarUrl.length-fileName.length)],[fileName substringWithRange:NSMakeRange(0, fileName.length-(8+fileExtension.length))],@".",fileExtension];
        self.avatarImage.frame = CGRectMake(20,0,160,200);
        self.avatarImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.avatarImage loadImage:finalUrl withPlaceholdImage:nil];
     }
    ];
    [userRequest startAsynchronous];
    
}

- (void)share
{
//    NSLog(@"%@",[NSString stringWithFormat:@"%@%@%@",@"@",self.title,[self.tweetDict objectForKey:@"text"]]);
    SHKItem *item = [SHKItem text:[NSString stringWithFormat:@"%@%@%@%@",@"RT@",self.title,@" ",[self.tweetDict objectForKey:@"text"]]];
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
	[actionSheet showFromToolbar:self.navigationController.toolbar];
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

- (void)dealloc
{
    self.textLabel = nil;
    self.tweetDict = nil;
    [super dealloc];
}

@end
