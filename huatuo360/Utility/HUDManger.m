//
//  HUDManger.m
//  huatuo360
//
//  Created by Alpha Wong on 12-4-7.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "HUDManger.h"
//#import "MBProgressHUD.h"

static NSMutableDictionary* huds;
static HUDManger* instance;
@implementation HUDManger 

+(void)showHUD:(UIView*)hudParent token:(NSString*)token;
{
    if(nil == instance)
    {
        huds = [NSMutableDictionary dictionaryWithCapacity:0];
        instance = [[HUDManger alloc]init];
    }
    
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:hudParent];
	[hudParent addSubview:HUD];
    HUD.labelText = @"数据加载中";
    HUD.delegate = instance;
    [HUD show:TRUE];
    [huds setObject:HUD forKey:token];
}

+(void)hideHUD:(NSString*)token;
{
    MBProgressHUD *HUD = [huds objectForKey:token];
    [HUD hide:TRUE];
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [hud removeFromSuperview];
}
@end
