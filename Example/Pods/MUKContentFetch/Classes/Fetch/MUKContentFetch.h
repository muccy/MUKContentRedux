#import <Foundation/Foundation.h>
#import <MUKContentFetch/MUKContentFetchResponse.h>
#import <MUKContentFetch/MUKContentFetchResultType.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The fetch of a request which leads to a response
 */
@interface MUKContentFetch : NSObject
/**
 Produced response
 */
@property (nonatomic, readonly, nullable) MUKContentFetchResponse *response;
/**
 YES when -startWithCompletionHandler: has been called
 */
@property (nonatomic, readonly, getter=isStarted) BOOL started;
/**
 YES when -cancel has been called
 */
@property (nonatomic, readonly, getter=isCancelled) BOOL cancelled;
/**
 Start fetch
 @param completionHandler A block called on main queue when fetch finished
 */
- (void)startWithCompletionHandler:(void (^)(MUKContentFetchResponse *response))completionHandler;
/*
 Cancel started fetch
 @discussion You can override this method to cancel started operations, if any, but
 remember to call super implementation. 
 If you call this method completionHandler provided to -startWithCompletionHandler:
 is properly called and response is set.
 */
- (void)cancel;
@end

@interface MUKContentFetch (MethodsToOverride)
/**
 Retrieve requested resource.
 @discussion You have to override this method. You can retrieve your resource how
 you want but you have to call completionHandler in any case.
 @param completionHandler A block you must call when you finish to retrieve the 
 resource. You can call this block from any queue.
 */
- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchResultType resultType, id _Nullable retrievedObject, NSError * _Nullable error))completionHandler;
/**
 Transform retrieved resource into content object.
 @discussion You have to override this method. You can transform your object how
 you want but you have to call completionHandler in any case.
 @param completionHandler A block you must call when you finish to transform the
 resource. You can call this block from any queue.
 */
- (void)transformRetrievedObject:(nullable id)retrievedObject withCompletionHandler:(void (^)(MUKContentFetchResultType resultType, id _Nullable transformedObject, NSError *_Nullable error))completionHandler;
@end

NS_ASSUME_NONNULL_END
