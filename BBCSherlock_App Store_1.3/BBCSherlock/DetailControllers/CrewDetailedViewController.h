//
//  CrewDetailedViewController.h
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-16.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrewDetailedViewController : UIViewController
{
    UIWebView *crewWebView;
}

@property (nonatomic, retain) NSDictionary *crewDict;
- (id)initWithDict:(NSDictionary *)dict;

@end
