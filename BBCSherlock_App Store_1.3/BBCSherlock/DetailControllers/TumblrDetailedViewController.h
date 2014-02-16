//
//  TumblrDetailedViewController.h
//  Sherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-4.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlogRss.h"

@interface TumblrDetailedViewController : UIViewController<UIWebViewDelegate,UIActionSheetDelegate>
{
    UIWebView *_descriptionWebView;
    UITextView * _titleTextView;
    UIToolbar * _toolbar;
}

@property (nonatomic, retain) UITextView * titleTextView;
@property (nonatomic, retain) UIWebView *descriptionWebView;
@property (nonatomic, retain) UIToolbar * toolbar;

@property (readwrite,retain) BlogRss * currentlySelectedBlogItem;

@end
