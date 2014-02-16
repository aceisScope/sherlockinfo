//
//  EpisodeViewController.h
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APWebScrollView.h"

@interface EpisodeViewController : UIViewController

@property (nonatomic,retain) APWebScrollView *episodeView;
@property (nonatomic,retain) NSArray *webArray;

@end
