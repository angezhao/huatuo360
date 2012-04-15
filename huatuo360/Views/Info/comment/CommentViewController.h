//
//  CommentViewController.h
//  huatuo360
//
//  Created by Alpha Wong on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsiObjectManager.h"

@interface CommentViewController : UIViewController<UITextViewDelegate,AsiObjectDelegate>
{
    //是否推荐
    Boolean bRecommend;
    AsiObjectManager* manager;
}
@property (nonatomic, strong)NSMutableDictionary* params;
//评论内容
@property (nonatomic, strong)IBOutlet UITextView *tvComment;
//子类赋值 XX医生（医院)
@property (nonatomic, strong)IBOutlet UILabel *lbTitle;
//子类赋值 这位医生（这个医院）给你的印象：
@property (nonatomic, strong)IBOutlet UILabel *lbImpression;
//发表按钮
@property (nonatomic, strong)IBOutlet UIButton *btnComment;
//子类重写，发表按钮响应
- (IBAction)announce:(id)sender;

//控件功能实现需要，不需理会
@property (nonatomic, strong)IBOutlet UIButton* btnRecommendNormal;
@property (nonatomic, strong)IBOutlet UIButton* btnRecommendSelected;
@property (nonatomic, strong)IBOutlet UIButton* btnNotRecommendNormal;
@property (nonatomic, strong)IBOutlet UIButton* btnNotRecommendSelected;
@property (nonatomic, strong)IBOutlet UIButton* btnEndEdit;
@property (nonatomic, strong)IBOutlet UILabel *lbPlaceHolder;

- (IBAction)recommendNot:(id)sender;
- (IBAction)recommend:(id)sender;
- (IBAction)endEditPressed:(id)sender;
@end
