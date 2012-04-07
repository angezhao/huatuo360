//
//  CityListVC.h
//  huatuo360
//
//  Created by Alpha Wong on 12-4-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CityListDelegate <NSObject> 
@required
- (void) selectCity:(NSString*)cityId cityName:(NSString*)cityName;
@end

@interface CityListVC : UIViewController<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSMutableArray *names;
    NSMutableArray *searchResultList;
    NSArray  *keys;
    NSDictionary *data;
    NSMutableDictionary *cityName2Id;
    
    BOOL    isSearching;
    
    id<CityListDelegate> delegate;
}
@property (nonatomic, strong) IBOutlet UITableView *table;
@property (nonatomic, strong) IBOutlet UISearchBar *search;

- (void) setDelegate:(id)del;
@end
