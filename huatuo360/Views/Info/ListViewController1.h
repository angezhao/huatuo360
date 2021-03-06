//
//  ListViewController1.h
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface ListViewController1 : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray* listData;
    int total;
    int page;
    AsiObjectManager* manager;
}
//@property (nonatomic, retain)IBOutlet UISearchBar* searchBar;
@property (nonatomic, strong)IBOutlet UITableView* listView;
@property (nonatomic, strong)NSString* tableTitle;
@property (nonatomic, strong)NSMutableDictionary* params;
- (NSString*)getTitleByIndex:(int)index;
- (NSString*)getIntroByIndex:(int)index;

@end
