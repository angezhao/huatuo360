//
//  CommentViewController.m
//  huatuo360
//
//  Created by Alpha Wong on 12-4-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CommentViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CommentViewController ()

@end

@implementation CommentViewController
@synthesize  btnRecommendSelected,btnNotRecommendSelected,btnRecommendNormal,btnNotRecommendNormal,tvComment,btnEndEdit,lbPlaceHolder,lbTitle,lbImpression;

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
