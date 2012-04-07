//
//  HUDManger.h
//  huatuo360
//
//  Created by Alpha Wong on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"
@interface HUDManger : NSObject<MBProgressHUDDelegate>
{
//    NSMutableDictionary* huds;
}
//+ (NSMutableDictionary*) huds;
+ (void)showHUD:(UIView*)hudParent token:(NSString*)token;
+ (void)hideHUD:(NSString*)token;
@end
