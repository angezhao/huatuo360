//
//  DropDownList.h
//  huatuo360
//
//  Created by Alpha Wong on 12-4-3.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDownList : UITableViewController
{
    NSMutableArray* resultList;
    NSArray* srcList;
    UIView* parent;
}

- (void)setHidden:(BOOL)hidden;
- (void)setParent:(UIView*)container;
- (void)update:(NSString*)filter;
@property (nonatomic, strong)UISearchBar* delegate;
@end
