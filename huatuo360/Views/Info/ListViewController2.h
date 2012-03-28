//
//  ListViewController2.h
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController2 : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    NSArray* listData;
    int total;
    int page;
}

@property (nonatomic, strong)IBOutlet UITableView* listView;
@property (nonatomic, strong)NSString* tableTitle;
- (NSString*)getTitleByIndex:(int)index;

@end
