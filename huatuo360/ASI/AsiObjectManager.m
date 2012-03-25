#import "AsiObjectManager.h"
#import "SBJson.h"
//#import "Constants.h"

static AsiObjectManager* sharedManager = nil;

@implementation AsiObjectManager
@synthesize delegate;
static ASIHTTPRequest* request = nil;
static SBJsonParser *parser = nil;  

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
    NSLog(@"%@", responseString);
    NSDictionary *jsonDic = [parser objectWithData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];  
	[delegate loadData:jsonDic];
}

- (void)requestFailed:(ASIHTTPRequest *)retrequest {    
	NSError *error = [retrequest error]; 
    NSLog(@"%@", error);
	
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