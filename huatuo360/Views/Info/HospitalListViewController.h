//
//  HospitalListViewController.h
//  huatuo360
//
//  Created by Alpha Wong on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ListViewController1.h"

@interface HospitalListViewController : ListViewController1<AsiObjectDelegate>
{
    Boolean firstAppear;
    UIBarButtonItem *btnCity;
}
@property (nonatomic, strong)NSString* diseaseName;

@end
