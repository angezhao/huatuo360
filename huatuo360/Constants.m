//
//  Constant.c
//  huatuo360
//
//  Created by Alpha Wong on 12-3-26.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Constants.h"

NSString* const _baseUrl = @"http://www.huatuo360.com/m/";

//login.php?userId=username&password=passwd
NSString* const _login = @"login.php?";

//regist.php?userId=username&password=passwd&email=email@e.com
NSString* const _regist = @"regist.php?";

//comment.php?hospid=医院id&impression=1(0推荐与否)&evaluation=评价&userId=用户id
NSString* const _comment = @"comment.php?";

//科室列表接口(分医院部分地区)getDepartmentList.php?hospid=医院id
NSString* const _departmentList = @"getDepartmentList.php?";

//评论列表getCommentList.php?hospid=医院id&doctorid=医生id&page=页数&perpage=分页数目
NSString* const _commentList = @"getCommentList.php?";

//医生介绍getDoctor.php?id=医生id
NSString* const _doctor = @"getDoctor.php?";

//医院介绍getHospital.php?id=220
NSString* const _hospital = @"getHospital.php?";

//医院排行getHospitalList.php?deptid=疾病/科室id&hospital=搜索的医院名&city=城市id&page=页数&perpage=分页数目
NSString* const _hospitalList = @"getHospitalList.php?";

//医生列表getDoctorList.php?deptid=疾病/科室id&hospid=医院id&doctor=医生名字&city=城市id&page=页数&perpage=分页数目
NSString* const _doctorList = @"getDoctorList.php?";

//疾病排行getDiseaseList.php?disease=搜索的疾病名&page=第几页&perpage=分页数目
NSString* const _diseaseList = @"getDiseaseList.php?";


//全局变量
UIViewController* infoViewToShow = nil;
NSString* userId;
Boolean isLogin = false;
NSString* gcityId;
NSString* gcityName;
NSDictionary *departments;