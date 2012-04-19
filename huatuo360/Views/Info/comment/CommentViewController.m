//
//  CommentViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LoginViewController.h"
#import "Constants.h"

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize  btnRecommendSelected,btnNotRecommendSelected,btnRecommendNormal,btnNotRecommendNormal,tvComment,btnEndEdit,lbPlaceHolder,lbTitle,lbImpression,btnComment;
@synthesize params;

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        bRecommend = TRUE;
        self.title = @"华佗360";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    btnNotRecommendSelected.enabled = FALSE;
    btnRecommendSelected.enabled = FALSE;
    [self updateRadioButtonGroup];
    
    tvComment.layer.borderColor = [UIColor grayColor].CGColor;
    tvComment.layer.borderWidth = 1.0;    
    tvComment.layer.cornerRadius = 5.0;
    tvComment.text = @"";
    lbPlaceHolder.enabled = FALSE;
    lbPlaceHolder.text = @"输入评论";
    btnEndEdit.hidden = TRUE;
    if([params objectForKey:@"hospid"]){
        lbTitle.text = [NSString stringWithFormat:@"%@", [params objectForKey:@"_name"]];
        lbImpression.text = @"这个医院给你的印象：";
    }else {
        lbTitle.text = [NSString stringWithFormat:@"%@ 医生", [params objectForKey:@"_name"]];
        lbImpression.text = @"这位医生给你的印象：";
    }
    if(!isLogin){
        LoginViewController* lvc = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        isComment = true;
        userViewToShow = lvc;
        [self.tabBarController setSelectedIndex:2];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    btnComment.enabled = isLogin;
}


- (void)textViewDidBeginEditing:(UITextView *)textView
{
    lbPlaceHolder.text = @"";
    btnEndEdit.hidden = FALSE;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    btnEndEdit.hidden = TRUE;
    if ([textView.text length] == 0) 
    {
        lbPlaceHolder.text = @"输入评论";
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)announce:(id)sender
{
    [params setObject:_comment forKey:@"interfaceName"];
    [params setObject:userId forKey:@"userid"];
    if(bRecommend)
        [params setObject:@"1" forKey:@"impression"];
    else 
        [params setObject:@"0" forKey:@"impression"];
    [params setObject:[tvComment text] forKey:@"evaluation"];
    manager = [AsiObjectManager alloc];
    [manager setDelegate:self];
    [manager requestData:params];
}

- (void)loadData:(NSDictionary *)data
{
    NSLog(@"%@", data);   
    //评论成功返回上层页面并刷新数据
    flashView = true;
    [self.navigationController popViewControllerAnimated:true];
}

- (void) requestFailed:(NSError*)error
{
    //NSLog(@"%@", error); 
}

- (IBAction)recommend:(id)sender
{
    bRecommend = TRUE;
    [self updateRadioButtonGroup];
}

- (IBAction)recommendNot:(id)sender
{
    bRecommend = FALSE;
    [self updateRadioButtonGroup];
}

- (void)updateRadioButtonGroup
{
    [btnNotRecommendNormal setHidden:!bRecommend];
    [btnNotRecommendSelected setHidden:bRecommend];
    [btnRecommendNormal setHidden:bRecommend];
    [btnRecommendSelected setHidden:!bRecommend];
}

//- (IBAction)radioButtonSelect:(id)sender
//{
//    bRecommend = sender == btnRecommendNormal;
//    [self updateRadioButtonGroup];
//}

- (IBAction)endEditPressed:(id)sender
{
    [tvComment resignFirstResponder];
}
@end
