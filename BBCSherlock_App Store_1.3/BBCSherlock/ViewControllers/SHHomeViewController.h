//
//  SHHomeViewController.h
//  BBCSherlock
//
//  Created by B.H.Liu appublisher on 12-1-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHHomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, retain) UITableView *tableView;

@end
