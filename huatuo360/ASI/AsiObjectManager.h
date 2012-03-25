#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@protocol AsiObjectDelegate <NSObject> 
@optional
- (void) loadData:(NSDictionary*)data;
@end

@interface AsiObjectManager: NSObject<NSObject> {
}

@property ( nonatomic) id<AsiObjectDelegate> delegate;

- (void)requestData:(NSMutableDictionary*)urlParam;

+ (AsiObjectManager*)sharedManager;


+ (void)setSharedManager:(AsiObjectManager*)manager;

/// @name Initializing an Object Manager

/**
 Create and initialize a new object manager. If this is the first instance created
 it will be set as the shared instance
 */
+ (AsiObjectManager*)initManager;

@end