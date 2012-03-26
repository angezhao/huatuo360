#import "AsiObjectManager.h"
#import "SBJson.h"
//#import "Constants.h"

static AsiObjectManager* sharedManager = nil;
static SBJsonParser *parser = nil;
static NSError *error;  

@implementation AsiObjectManager
@synthesize delegate;
static ASIHTTPRequest* request = nil; 

extern NSString* const _baseUrl;

- (void)requestData:(NSMutableDictionary*)urlParam { 
    NSString *url = [NSString stringWithFormat:@"%@%@", _baseUrl,[urlParam objectForKey:(@"interfaceName")]];  
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request startAsynchronous]; 

}   

- (void)requestFinished:(ASIHTTPRequest *)retrequest {   
    [request  setResponseEncoding:(NSUTF8StringEncoding)];
    NSString* responseString=[retrequest responseString];
    //NSLog(@"%@", responseString);
    NSDictionary *jsonDict = [parser objectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];  
    NSNumber *status = [jsonDict objectForKey:@"status"];
    NSLog(@"%@",status); 
    if ([status intValue] == 0) {
        error = [[NSError alloc] initWithDomain:@"requestFailed" code:[status integerValue] userInfo:nil];
        [delegate requestFailed:error];
    }

    //NSArray *myArray = [jsonDic objectForKey:@"data"];
    //for (NSDictionary *dict in myArray) {
    //    NSArray *keys;
    //    int i, count;
    //    id key, value;
    //    keys = [dict allKeys];
    //    count = [keys count];
    //    for (i = 0; i < count; i++)
    //    {
    //        key = [keys objectAtIndex: i];
    //        value = [dict objectForKey: key];
    //        NSLog (@"Key: %@ for value: %@", key, value);
    //    }
    //}
    [delegate loadData:jsonDict];
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