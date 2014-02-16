//
//  TwitterDetailedViewController.h
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 11-12-20.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "AsyncImageView.h"

@interface TwitterDetailedViewController : UIViewController

@property (nonatomic, retain) OHAttributedLabel* textLabel;
@property (nonatomic, retain) AsyncImageView *avatarImage;
@property (nonatomic, retain) NSDictionary *tweetDict;

- (id)initWithDict:(NSDictionary *)dict;

@end
