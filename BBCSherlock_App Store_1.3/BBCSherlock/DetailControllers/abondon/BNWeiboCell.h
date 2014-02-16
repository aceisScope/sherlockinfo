//
//  BNWeiboCell.h
//  BonaFilm
//
//  Created by  on 11-11-22.
//  Copyright (c) 2011年 NUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

#define kTextTag        @"text"
#define kStatusIdTag    @"id"
#define kProfileTag     @"profile_image_url"
#define kNameTag        @"screen_name"
#define kUserTag        @"user"

@interface BNWeiboCell : UITableViewCell

@property (nonatomic, retain) OHAttributedLabel* weiboLabel;
@property (nonatomic, retain) OHAttributedLabel* weiboName;
@property (nonatomic, retain) AsyncImageView *weiboImage;
@property (nonatomic, retain) AsyncImageView *avatarImage;
@property (nonatomic, retain) OHAttributedLabel* weiboDate;


-(void) loadWithDict:(NSDictionary*)dict;

-(CGFloat) heightForCell;

@end
