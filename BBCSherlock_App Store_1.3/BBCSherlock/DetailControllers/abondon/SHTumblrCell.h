//
//  SHTumblrCell.h
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-9.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
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

@interface SHTumblrCell: UITableViewCell

@property (nonatomic, retain) OHAttributedLabel* weiboLabel;
@property (nonatomic, retain) OHAttributedLabel* weiboName;
@property (nonatomic, retain) AsyncImageView *weiboImage;
@property (nonatomic, retain) AsyncImageView *avatarImage;
@property (nonatomic, retain) OHAttributedLabel* weiboDate;


-(void) loadWithDict:(NSDictionary*)dict;

-(CGFloat) heightForCell;

@end

