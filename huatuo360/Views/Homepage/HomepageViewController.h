//
//  HomepageViewController.h
//  huatuo360
//
//  Created by Alpha Wong on 12-3-11.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityListVC.h"
@class DropDownList;

@interface HomepageViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, CityListDelegate>
{
    NSArray *listData;
    int searchType;
//    UISearchBar* searchBar;
    NSArray *searchBarHolders;
    DropDownList* ddList;
    UIBarButtonItem *btnCity;
    CityListVC *cityListVC;
    UIViewController* rootViewController;
}
@property (nonatomic, strong)IBOutlet UISearchBar* searchBarRef;
@property (nonatomic, strong)IBOutlet UIBarButtonItem* btnCity;

//- (IBAction)showCityList:(id)sender;
//@property (nonatomic, retain)IBOutlet UINavigationBar* navigationBar;

//@property (nonatomic, retain)NSArray* listData;
//@property (nonatomic, retain)NSArray* searchBarHolders;
@end
