//
//  SHYoutubeCell.m
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "SHYoutubeCell.h"
#import <QuartzCore/QuartzCore.h>
//#import "RegexKitLite.h"
//#import "RKLMatchEnumerator.h"

#define FONT_SIZE_NAME 18.0f
#define FONT_SIZE 12.0f
#define DATE_FONT_SIZE 12.0f

#define MARGIN_TO_LEFT 15
#define MARGIN_TO_RIGHT 10
#define MARGIN_TO_BOTTOM 10
#define MARGIN_TO_TOP    10
#define MARGIN_TO_IMG  15
#define PADDING 25

#define FRM_DATE_WIDTH 120
#define FRM_DATE_HEIGHT 20

#define IMG_HEIGHT 100
#define IMG_WIDTH  100

#define PROFILE_WIDTH 100
#define PROFILE_HEIGHT 70


@implementation SHYoutubeCell

@synthesize weiboLabel = _weiboLabel;
@synthesize weiboImage  = _weiboImage;
@synthesize weiboDate = _weiboDate;
@synthesize avatarImage = _avatarImage;
@synthesize weiboName = _weiboName;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.weiboLabel = [[[OHAttributedLabel alloc] initWithFrame:CGRectMake(0,0,0,0)] autorelease];
        self.weiboLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.weiboLabel];
        
        self.weiboImage = [[[AsyncImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
        [self addSubview:self.weiboImage];
        
        self.weiboDate  = [[[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        [self addSubview:self.weiboDate];
        
        self.avatarImage = [[[AsyncImageView alloc] initWithFrame:CGRectZero] autorelease];
        [self addSubview:self.avatarImage];
        self.avatarImage.clipsToBounds = YES;
        self.avatarImage.layer.cornerRadius = 10;
        self.avatarImage.layer.borderColor = [UIColor blackColor].CGColor;
        self.avatarImage.layer.borderWidth = 1.5f;
        
        self.weiboName  = [[[OHAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)] autorelease];
        self.weiboName.backgroundColor = [UIColor clearColor];
        [self addSubview:self.weiboName];
        
        self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"videocell_background.png"]];
    }
    return self;
}

-(void) adjustWithString:(NSString*)content withImage:(NSString*) url andDate:(NSString*) date andAvatar:(NSString*)profileUrl andName:(NSString*)name
{
    [self.weiboLabel setFrame:CGRectMake(0, 0, 0, 0)];
    [self.weiboImage setFrame:CGRectMake(0, 0, 0, 0)];
    [self.weiboLabel setNumberOfLines:0];
    
    UIFont *font = [UIFont fontWithName:@"AmericanTypewriter-Condensed" size:FONT_SIZE];
    CGSize size = CGSizeMake(180,3200);
    
    CGSize labelsize = [content sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    
    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:content];
    [attrStr setTextColor:[UIColor whiteColor] range:NSMakeRange(0,[attrStr length])];
    [attrStr setFont:font];
    
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
    
    [attrStr setLineHeightMultiple:1.0];
    
    self.weiboLabel.attributedText = attrStr;
    self.weiboLabel.userInteractionEnabled = NO;
    
    self.weiboName.frame = CGRectMake(MARGIN_TO_LEFT+PROFILE_WIDTH+PADDING, MARGIN_TO_TOP, 210, 20);
    NSMutableAttributedString *nameAttr = [NSMutableAttributedString attributedStringWithString:name];
    [nameAttr setTextColor:[UIColor redColor]];
    self.weiboName.attributedText = nameAttr;
    
    [self.weiboLabel setFrame:CGRectMake(MARGIN_TO_LEFT+PROFILE_WIDTH+PADDING, MARGIN_TO_TOP, labelsize.width, labelsize.height*1.3)];
    
    CGFloat currentHeight = self.weiboLabel.frame.origin.y + labelsize.height*1.3;
    
    ///////头像图片
    if(profileUrl && [profileUrl isKindOfClass:[NSString class]])
    {
        [self.avatarImage setFrame:CGRectMake(MARGIN_TO_LEFT, MARGIN_TO_TOP/2, PROFILE_WIDTH, PROFILE_HEIGHT)];
        //self.avatarImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.avatarImage loadImage:profileUrl withPlaceholdImage:[UIImage imageNamed:@"placeholder.png"]];
        currentHeight =self.weiboLabel.frame.origin.y + labelsize.height*1.3 ;
    }
    
    /////////微博图片
    if(url && [url isKindOfClass:[NSString class]]){
        [self.weiboImage setFrame:CGRectMake(MARGIN_TO_LEFT+PROFILE_WIDTH+PADDING, labelsize.height*1.3+MARGIN_TO_IMG + 25, IMG_WIDTH, IMG_HEIGHT)];
        self.weiboImage.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.weiboImage loadImage:url withPlaceholdImage:[UIImage imageNamed:@"placeholder.png"]];
        currentHeight = labelsize.height*1.3+MARGIN_TO_IMG+IMG_HEIGHT+25;
        //self.frame = self.bounds = CGRectMake(0, 0, 320, labelsize.height*1.3+MARGIN_TO_IMG+IMG_HEIGHT+MARGIN_TO_BOTTOM);
    }
    
    
    ///////////日期
    self.weiboDate.frame = CGRectMake(320-FRM_DATE_WIDTH - MARGIN_TO_RIGHT, currentHeight+2*MARGIN_TO_BOTTOM-FRM_DATE_HEIGHT,  FRM_DATE_WIDTH, FRM_DATE_HEIGHT);
    
    NSMutableAttributedString* dateAttr = [NSMutableAttributedString attributedStringWithString:date];
    //[dateAttr setTextColor:[UIColor colorWithRed:0xfe/256.0 green:0xec/256.0 blue:0xd2/256.0 alpha:0.8]];
    [dateAttr setTextColor:[UIColor whiteColor]];
    self.weiboDate.attributedText = dateAttr;
    
    [self.weiboDate setFont:[UIFont systemFontOfSize:DATE_FONT_SIZE]];
    [self.weiboDate setBackgroundColor:[UIColor clearColor]];
    
    self.frame = self.bounds = CGRectMake(0, 0, 320, (currentHeight+2*MARGIN_TO_BOTTOM>=MARGIN_TO_TOP+PROFILE_HEIGHT)?currentHeight+2*MARGIN_TO_BOTTOM:MARGIN_TO_TOP+PROFILE_HEIGHT);
}

-(void) loadWithDict:(NSDictionary*)dict
{        

    NSString *text =[[dict objectForKey:@"title"] objectForKey:@"$t"];
        
    NSString * date  = [[dict objectForKey:@"updated"] objectForKey:@"$t"];
    
//    NSString *content = [[dict objectForKey:@"content"] objectForKey:@"$t"];
//    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"src=\"([^>]+)\"[^>]*" options:nil error:nil];
//    NSArray* matches = [expression matchesInString:content options:nil range:NSMakeRange(0, [content length])];
//    
//    
//    NSRange range = [[matches objectAtIndex:0] range];
    
    NSString *avatar = [[[[dict objectForKey:@"media$group"] objectForKey:@"media$thumbnail"] objectAtIndex:2] objectForKey:@"url"];

    [self adjustWithString:text withImage:nil andDate:date andAvatar:avatar andName:nil];
    
//    [self adjustWithString:text withImage:nil andDate:date andAvatar:[content substringWithRange:NSMakeRange(range.location + 5, range.length - 6)] andName:nil];
}

-(CGFloat) heightForCell
{
    return self.frame.size.height;
}

-(void) dealloc
{
    self.weiboLabel = nil;
    self.weiboImage  = nil;
    self.weiboDate = nil;
    self.avatarImage = nil;
    self.weiboName = nil;
    
    [super dealloc];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
