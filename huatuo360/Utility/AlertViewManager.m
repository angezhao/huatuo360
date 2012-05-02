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

-(void)showAlter:(NSString*)msg success:(BOOL)success
{
    issuccess = success;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:msg
                                         delegate:nil                                       
                                 cancelButtonTitle:@"确定"
                                otherButtonTitles:nil, nil];
    [alert show];
    [self performSelector:@selector(closeAlert:) withObject:alert afterDelay:3];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   if(delegate != nil)
        [delegate finishAlert:issuccess];
}

- (void)closeAlert:(UIAlertView*)alert
{
    [alert dismissWithClickedButtonIndex:0 animated:NO];
    if(delegate != nil)
        [delegate finishAlert:issuccess];
}

@end
