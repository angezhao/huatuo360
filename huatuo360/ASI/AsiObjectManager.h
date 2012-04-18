#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@protocol AsiObjectDelegate <NSObject> 
@required
- (void) loadData:(NSDictionary*)data;
- (void) requestFailed:(NSError*)error;
@end

@interface AsiObjectManager: NSObject<UIAlertViewDelegate> {
}

@property ( nonatomic) id<AsiObjectDelegate> delegate;

- (void)requestData:(NSMutableDictionary*)urlParam;
- (NSDictionary*)syncRequestData:(NSMutableDictionary*)urlParam;

@end