//
//  TwitterIndexViewController.h
//  BBCSherlock
//
//  Created by 北京爱普之亮科技有限公司 appublisher on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "ASIHTTPRequest.h"
#import "EGORefreshTableHeaderView.h"

@interface TwitterIndexViewController : UITableViewController<ASIHTTPRequestDelegate,EGORefreshTableHeaderDelegate>
{
    UIView	*_blockerView;
    UIActivityIndicatorView	*_spinner;
}

@property (nonatomic,retain) NSArray *jsonDictArray;
@property (nonatomic,retain)  NSString *parserUrl;

- (id)initWithUrlString:(NSString*)url;

@end

