//
//  TumblrIndexViewController.h
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-8.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"

@interface TumblrIndexViewController : UITableViewController<ASIHTTPRequestDelegate,EGORefreshTableHeaderDelegate>
{
    UIView	*_blockerView;
    UIActivityIndicatorView	*_spinner;
}

@property (nonatomic,retain) NSDictionary *jsonDict;
@property (nonatomic,retain)  NSString *parserUrl;
@property (nonatomic,retain) NSString *title;

- (id)initWithUrlString:(NSString*)url;

@end
