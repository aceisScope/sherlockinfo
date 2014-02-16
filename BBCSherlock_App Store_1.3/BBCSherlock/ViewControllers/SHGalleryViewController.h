//
//  SHGalleryViewController.h
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-14.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionedPhotoView.h"
#import "ThumbsTableView.h"

@interface SHGalleryViewController : UIViewController<SectionedPhotoViewDelegate, SectionedPhotoViewDataSource,ThumbsTableViewDataSource,ThumbsTableViewDelegate>

@property(nonatomic, retain) SectionedPhotoView * photoView;
@property(nonatomic, retain) ThumbsTableView * posterView;
@property(nonatomic,retain) NSArray *jsonGalleryArray;

@end
