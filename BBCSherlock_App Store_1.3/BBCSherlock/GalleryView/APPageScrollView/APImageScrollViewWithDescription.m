//
//  APImageScrollViewWithDescription.m
//  BonaFilm
//
//  Created by 曹 怀志 on 11-12-19.
//  Copyright (c) 2011年 NUS. All rights reserved.
//

#import "APImageScrollViewWithDescription.h"
#import "FullyLoaded.h"
#import "AsyncImageView.h"

@implementation APImageScrollViewWithDescription

- (void) dealloc {
    [super dealloc];
}

- (UIView*) pageView       // _pageView 初始化
{
    AsyncImageView * imgView = [[AsyncImageView alloc] initWithFrame:self.bounds];
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    imgView.tag=1000;
    
    UILabel *descriptionLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)] autorelease];
    descriptionLabel.numberOfLines=0;
    descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    descriptionLabel.textColor=[UIColor whiteColor];
    descriptionLabel.backgroundColor=[UIColor clearColor];
    descriptionLabel.tag=2000;
    descriptionLabel.font = [UIFont fontWithName:@"Palatino" size:12];
    
    UIView *view=[[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    [view addSubview:imgView];
    [view addSubview:descriptionLabel];
    
    return view;
}

- (void) reloadDataForPageAtLocation:(int) location   // 重载 _pageView 的显示
{
    int index = self.currentPageNum+location-1;
    if (index < 0 || index >= [self numberOfPages]) return;
    
    NSString * imageURL = [[self.imageList objectAtIndex:index] objectForKey:@"image"];
    NSString * description = [NSMutableString stringWithString:[[self.imageList objectAtIndex:index] objectForKey:@"story"]];
    
    unichar chr[1] = {'\n'};
    NSString *singleCR = [NSString stringWithCharacters:(const unichar *)chr length:1];
    description = [description stringByReplacingOccurrencesOfString:@"\\n" withString:singleCR];
//    for (int i=0; i<[description length]; i++) 
//    {
//        NSLog(@"%c",[description characterAtIndex:i]);
//    }
   
    [((AsyncImageView*)[_pageView[location] viewWithTag:1000]) setImage:[UIImage imageNamed:imageURL]];
    ((UILabel*)[_pageView[location] viewWithTag:2000]).numberOfLines = 0;
    ((UILabel*)[_pageView[location] viewWithTag:2000]).text= description;
    [(UILabel*)[_pageView[location] viewWithTag:2000] sizeToFit];
    ((UILabel*)[_pageView[location] viewWithTag:2000]).frame=CGRectMake((320-((UILabel*)[_pageView[location] viewWithTag:2000]).frame.size.width)/2, self.frame.size.height-((UILabel*)[_pageView[location] viewWithTag:2000]).frame.size.height-10, ((UILabel*)[_pageView[location] viewWithTag:2000]).frame.size.width, ((UILabel*)[_pageView[location] viewWithTag:2000]).frame.size.height);

}
@end
