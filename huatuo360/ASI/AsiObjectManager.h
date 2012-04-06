#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@protocol AsiObjectDelegate <NSObject> 
@optional
- (void) loadData:(NSDictionary*)data;
- (void) requestFailed:(NSError*)error;
@end

@interface AsiObjectManager: NSObject<NSObject> {
}

@property ( nonatomic) id<AsiObjectDelegate> delegate;

- (void)requestData:(NSMutableDictionary*)urlParam;
- (NSDictionary*)syncRequestData:(NSMutableDictionary*)urlParam;

@end