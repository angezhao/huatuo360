//
//  CommentDetailVC.h
//  huatuo360
//
//  Created by Zhao Ange on 12-5-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface CommentDetailVC : UIViewController<AsiObjectDelegate, UITableViewDelegate, UITableViewDataSource>
{
    AsiObjectManager* manager;
    NSDictionary* commentData;
    Boolean needRequest;
}

@property (nonatomic, strong)IBOutlet UITableView* detailView;
@property (nonatomic, strong)NSMutableDictionary* params;
@end
