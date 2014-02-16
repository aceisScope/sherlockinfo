//
//  YoutubeDetailedViewController.h
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-7.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YoutubeDetailedViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate>
{
    UIWebView *_activityDetailedView;
    int loadBalance;

}

@property(nonatomic,retain) NSString*urlforRequest;
@property (nonatomic, retain) UIToolbar * toolbar;

@end
