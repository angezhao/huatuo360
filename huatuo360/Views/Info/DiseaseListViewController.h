//
//  DiseaseListViewController.h
//  huatuo360
//
//  Created by Zhao Ange on 12-3-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ListViewController2.h"

@interface DiseaseListViewController : ListViewController2<AsiObjectDelegate>
{
    Boolean firstAppear;
}
@property (nonatomic, strong) NSString* diseaseName;

@end
