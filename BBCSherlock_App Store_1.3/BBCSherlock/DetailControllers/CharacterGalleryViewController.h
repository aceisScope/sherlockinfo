//
//  CharacterGalleryViewController.h
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionedPhotoView.h"

@interface CharacterGalleryViewController : UIViewController<SectionedPhotoViewDelegate, SectionedPhotoViewDataSource>


@property(nonatomic, retain) SectionedPhotoView * photoView;
@property(nonatomic,retain) NSArray *jsonGalleryArray;

@end
