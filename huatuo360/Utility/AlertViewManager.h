//
//  AlertViewManager.h
//  huatuo360
//
//  Created by Zhao Ange on 12-4-20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertViewDelegate <NSObject> 
@required
- (void) finishAlert:(BOOL)success;
@end

@interface AlertViewManager : NSObject<UIAlertViewDelegate>
{
    BOOL issuccess;
}

@property ( nonatomic) id<AlertViewDelegate> delegate;

-(void)showAlter:(NSString*)msg success:(BOOL)success;
@end


