#import "AsiObjectManager.h"
#import "SBJson.h"
#import "Constants.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>

#import "HUDManger.h"

@implementation AsiObjectManager
@synthesize delegate;

- (void)requestData:(NSMutableDictionary*)urlParam { 
    //增加网络链接状态判断是否需要请求
    if (![self connectedToNetwork]) {
        [self alertNoInternet];
        return;
    } 
    NSString *url = [self getUrl:urlParam];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"Accepts-Encoding" value:@"gzip"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    if(delegate != nil && [[delegate class] isSubclassOfClass:[UIViewController class]]) 
    {
        UIViewController* vc = (UIViewController*)delegate;
        [HUDManger showHUD:vc.view token:url];
    }
}   

- (NSDictionary*)syncRequestData:(NSMutableDictionary*)urlParam {
    //增加网络链接状态判断是否需要请求
    if (![self connectedToNetwork]) {
        [self alertNoInternet];
        return nil;
    } 
    NSString *url = [self getUrl:urlParam];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"Accepts-Encoding" value:@"gzip"];
    [request startSynchronous]; 
    [request setResponseEncoding:(NSUTF8StringEncoding)];
    NSString *responseString = [request responseString];
    //NSLog(@"%@", responseString);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonDict = [parser objectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];  
    //NSLog(@"%@", jsonDict);
    NSNumber *status = [jsonDict objectForKey:@"status"];
    NSLog(@"status=%@",status); 
    if ([status intValue] == 1) {
        return jsonDict;
    } else if([jsonDict objectForKey:@"msg"]){
        [self showAlter:[jsonDict objectForKey:@"msg"] success:NO];
    }   
    return nil;
}

-(NSString*)getUrl:(NSMutableDictionary*)urlParam{
    NSString *url = nil;
    NSString *param = [NSString stringWithFormat:@"%@=%i",@"perpage", perpage];
    if(![gcityId isEqualToString:@""])
        param = [NSString stringWithFormat:@"%@&%@=%@", param, @"city", gcityId]; 
    //NSLog(@"param=%@",param); 
    //NSLog(@"urlParam=%@",urlParam); 
    for (NSString *key in urlParam)
    {
        if([key hasPrefix:@"_"])//过滤附加参数
            continue;
        if([key isEqual:@"interfaceName"])
            url = [NSString stringWithFormat:@"%@%@", _baseUrl,[urlParam objectForKey: key]];
        else
            param = [NSString stringWithFormat:@"%@&%@=%@", param, key, [urlParam objectForKey: key]]; 
    }
    url = [NSString stringWithFormat:@"%@%@", url, param]; 
    //NSLog(@"url=%@",url); 
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
    NSLog(@"url=%@",url); 
    return url;
}

- (void)requestFinished:(ASIHTTPRequest *)request {   
    [request  setResponseEncoding:(NSUTF8StringEncoding)];
    NSString* responseString=[request responseString];
    //NSLog(@"%@", responseString);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonDict = [parser objectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];  
    NSLog(@"%@", jsonDict);
    [HUDManger hideHUD:request.originalURL.absoluteString];
    NSNumber *status = [jsonDict objectForKey:@"status"];
    NSLog(@"status=%@",status); 
    //判断异常delegate是否为空
    if(delegate != nil){
        if (status == nil || [status intValue] != 1) {
            NSString *msg = @"请求失败!";
            if([jsonDict objectForKey:@"msg"])
                msg = [NSString stringWithFormat:@"%@%@", msg, [jsonDict objectForKey:@"msg"]];
            [self showAlter:msg success:NO];
        }else {
            if([request.originalURL.absoluteString rangeOfString:_comment].length > 0){
                [self showAlter:@"评论成功" success:YES];
            }else {
                [delegate loadData:jsonDict];
            }
        }
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request {  
    [HUDManger hideHUD:request.originalURL.absoluteString];  
	NSError *error = [request error]; 
    NSLog(@"error=%@", error);
    //弹框提示
    NSString *msg = @"请求失败，服务器繁忙，请稍后再试！";
    msg = [NSString stringWithFormat:@"%@ errcode=%i,errstr=%@", msg, [error code], [error domain]];
    [self showAlter:msg success:NO];
}


//Snip, you know we're in the implementation...
- (BOOL) connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

- (void)alertNoInternet
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(version >= 5.0)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:@"当前网络没有连接，请先设置网络！"
                                         delegate:self                                       
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:@"设置", nil];
        [alert show];
    }
    else 
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                          message:@"当前网络没有连接，请先设置网络！"
                                         delegate:nil                                       
                                cancelButtonTitle:@"确定"
                                otherButtonTitles:nil];
        [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSURL*url=[NSURL URLWithString:@"prefs:root=General&path=Network"];
        [[UIApplication sharedApplication] openURL:url];
    }
    if(delegate != nil)
        [delegate requestFailed:nil];
}

-(void)showAlter:(NSString*)msg success:(BOOL)success
{
    alertManager = [AlertViewManager alloc];
    [alertManager setDelegate:self];
    [alertManager showAlter:msg success:success];
}

- (void)finishAlert:(BOOL)success
{
    if(delegate != nil){
        if (success) {
            [delegate loadData:nil];
        }else {
            [delegate requestFailed:nil];
        }
    }
}

@end