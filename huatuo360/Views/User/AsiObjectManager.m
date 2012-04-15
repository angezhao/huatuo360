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
        NSLog(@"conect fail");
        return;
    } 
    NSString *url = [self getUrl:urlParam];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"Accepts-Encoding" value:@"gzip"];
    [request setDelegate:self];
    [request startAsynchronous];
    
    if([[delegate class] isSubclassOfClass:[UIViewController class]]) 
    {
        UIViewController* vc = (UIViewController*)delegate;
        [HUDManger showHUD:vc.view token:url];
    }
}   

- (NSDictionary*)syncRequestData:(NSMutableDictionary*)urlParam {
    //增加网络链接状态判断是否需要请求
    if (![self connectedToNetwork]) {
        NSLog(@"conect fail");
        return nil;
    } 
    NSString *url = [self getUrl:urlParam];
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request addRequestHeader:@"Accepts-Encoding" value:@"gzip"];
    [request startSynchronous]; 
    [request setResponseEncoding:(NSUTF8StringEncoding)];
    NSString *responseString = [request responseString];
    NSLog(@"%@", responseString);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonDict = [parser objectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];  
    NSLog(@"%@", jsonDict);
    NSNumber *status = [jsonDict objectForKey:@"status"];
    NSLog(@"%@",status); 
    if ([status intValue] == 1 && [jsonDict objectForKey:@"data"]) {
        return [jsonDict objectForKey:@"data"];
    }    
    return nil;
}

-(NSString*)getUrl:(NSMutableDictionary*)urlParam{
    NSString *url = nil;
    NSString *param = [NSString stringWithFormat:@"%@=%i",@"perpage", perpage];
    if(![gcityId isEqualToString:@""])
        param = [NSString stringWithFormat:@"%@&%@=%@", param, @"city", gcityId]; 
    NSLog(@"param=%@",param); 
    NSLog(@"urlParam=%@",urlParam); 
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
    NSLog(@"url=%@",url); 
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
    NSLog(@"url=%@",url); 
    return url;
}

- (void)requestFinished:(ASIHTTPRequest *)request {   
    [request  setResponseEncoding:(NSUTF8StringEncoding)];
    NSString* responseString=[request responseString];
    NSLog(@"%@", responseString);
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    NSDictionary *jsonDict = [parser objectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];  
    NSLog(@"%@", jsonDict);
    NSNumber *status = [jsonDict objectForKey:@"status"];
    NSLog(@"%@",status); 
    //判断异常delegate是否为空
    if ([status intValue] != 1) {
        NSError *error = [[NSError alloc] initWithDomain:@"requestFailed" code:[status integerValue] userInfo:nil];
        [delegate requestFailed:error];
    }else {
        [delegate loadData:jsonDict];
    }
    
//    NSLog(@"%@", request.originalURL.absoluteString);
    [HUDManger hideHUD:request.originalURL.absoluteString];

    //NSString *test = @"{\"data\":{\"212\":\"你好\",\"213\":\"你好\"},\"total\":31}";
    //NSString *test = @"{\"data\":[\"评论1\",\"评论2\",\"评论3\"]}";
    //NSDictionary *jsonDic = [parser objectWithData:[test dataUsingEncoding:NSUTF8StringEncoding]];  
    //NSLog(@"%@",jsonDic); 
    
    /*
    //NSString *test = @"{\"data\":{\"212\":\"你好\",\"213\":\"你好\"},\"total\":31}";
    NSDictionary *dict = [jsonDic objectForKey:@"data"];
    NSLog(@"%@",dict); 
    NSArray *keys;
    id key, value;
    keys = [dict allKeys];
    for (int i = 0; i < [keys count]; i++)
    {
        key = [keys objectAtIndex: i];
        value = [dict objectForKey: key];
        NSLog (@"Key: %@ for value: %@", key, value);
    }
    */
    
    /*
    //NSString *test = @"{\"data\":[\"评论1\",\"评论2\",\"评论3\"]}";
    NSArray *myArray = [jsonDic objectForKey:@"data"];
    NSLog(@"%@",myArray); 
    for (NSString *dict in myArray) {
        NSLog (@"dict: %@", dict);
    }
    */
}

- (void)requestFailed:(ASIHTTPRequest *)request {  
    [HUDManger hideHUD:request.originalURL.absoluteString];  
	NSError *error = [request error]; 
    NSLog(@"%@", error);
    [delegate requestFailed:error];
//    request.url.
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

@end