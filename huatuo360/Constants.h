//
//  Constants.h
//  huatuo360
//
//  Created by Zhao Ange on 12-3-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//
#define perpage 10
extern NSString* const _baseUrl;
extern NSString* const _login;
extern NSString* const _regist;
extern NSString* const _editPwd;
extern NSString* const _resetPwd;
extern NSString* const _comment;
extern NSString* const _departmentList;
extern NSString* const _commentList;
extern NSString* const _doctor;
extern NSString* const _hospital;
extern NSString* const _hospitalList;
extern NSString* const _doctorList;
extern NSString* const _diseaseList;

//全局变量
extern UIViewController *infoViewToShow;
extern UIViewController *userViewToShow;
extern NSString* userId;
extern NSString* email;
extern NSString* gcityId;
extern NSString* gcityName;
extern NSDictionary *departments;
extern Boolean isLogin;
extern Boolean isComment;
extern Boolean flashView;

//UITableView常量
#define INTRO_FONT_SIZE 16.0f
#define INFO_FONT_SIZE 16.0f
//整行宽度
#define CELL_CONTENT_WIDTH 320.0f
//#define CELL_CONTENT_MARGIN 0.0f
//两个UILabel在一个cell里面，正文宽度（右边的label）
#define CELL_RIGHT_CONTENT_WIDTH 200.0f