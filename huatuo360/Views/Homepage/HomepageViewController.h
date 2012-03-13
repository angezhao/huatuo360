//
//  HomepageViewController.h
//  huatuo360
//
//  Created by Alpha Wong on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomepageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{
    NSArray *listData;
    int searchType;
//    UISearchBar* searchBar;
    NSArray *searchBarHolders;
    
}
//@property (nonatomic, retain)IBOutlet UISearchBar* searchBar;
@property (nonatomic, retain)NSArray* listData;
@property (nonatomic, retain)NSArray* searchBarHolders;
@end
