//
//  AlertViewManager.m
//  huatuo360
//
//  Created by Zhao Ange on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AlertViewManager.h"

@implementation AlertViewManager
@synthesize delegate;
UIAlertView *alert = nil;

-(void)showAlter:(NSString*)msg success:(BOOL)success
{
    issuccess = success;
    alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:msg
                                         delegate:nil                                       
                                 cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector: @selector(closeAlert) userInfo:nil repeats:NO];
    [self performSelector:@selector(closeAlert) withObject:nil afterDelay:2];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if(delegate != nil)
        [delegate finishAlert:issuccess];
}

- (void)closeAlert
{
    [alert dismissWithClickedButtonIndex:0 animated:NO];
    if(delegate != nil)
        [delegate finishAlert:issuccess];
}

@end
