#import "AsiObjectManager.h"
#import "SBJson.h"
#import "Constants.h"

static AsiObjectManager* sharedManager = nil;
static SBJsonParser *parser = nil;
static NSError *error;  

@implementation AsiObjectManager
@synthesize delegate;
static ASIHTTPRequest* request = nil; 

- (void)requestData:(NSMutableDictionary*)urlParam { 
    NSString *url = nil;
    NSString *param = [NSString stringWithFormat:@"%@%i",@"perpage=",perpage];
    //还要处理地区
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
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startAsynchronous]; 

}   

- (void)requestFinished:(ASIHTTPRequest *)retrequest {   
    [request  setResponseEncoding:(NSUTF8StringEncoding)];
    NSString* responseString=[retrequest responseString];
    NSLog(@"%@", responseString);
    NSDictionary *jsonDict = [parser objectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];  
    NSLog(@"%@", jsonDict);
    NSNumber *status = [jsonDict objectForKey:@"status"];
    NSLog(@"%@",status); 
    if ([status intValue] != 1) {
        error = [[NSError alloc] initWithDomain:@"requestFailed" code:[status integerValue] userInfo:nil];
        [delegate requestFailed:error];
    }else {
        [delegate loadData:jsonDict];
    }

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

- (void)requestFailed:(ASIHTTPRequest *)retrequest {    
	error = [retrequest error]; 
    NSLog(@"%@", error);
    [delegate requestFailed:error];
}

+ (AsiObjectManager*)sharedManager {
	return sharedManager;
}

+ (void)setSharedManager:(AsiObjectManager*)manager {
    sharedManager = manager;
}

+ (AsiObjectManager*)initManager {
    parser = [[SBJsonParser alloc] init];
    AsiObjectManager* manager = [AsiObjectManager alloc];
	if (nil == sharedManager) {
		[AsiObjectManager setSharedManager:manager];
	}
	return manager;
}

@end