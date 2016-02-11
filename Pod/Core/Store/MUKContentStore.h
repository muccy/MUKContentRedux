#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentMiddleware.h>

@protocol MUKContent, MUKContentAction, MUKContentReducer;

NS_ASSUME_NONNULL_BEGIN

extern NSString *const MUKContentStoreIllegalDispatchException;

/**
 The store has the following responsibilities:
 • holds and allows access to immutable content state;
 • notifies state updates via -subscribe:
 • allows state to be updated via -dispatch:
 */
@interface MUKContentStore<__covariant ContentType:id<MUKContent>> : NSObject
/// The immutable stored state
@property (nonatomic, readonly, nullable) ContentType content;
/// The reducer that brings content and action to new content
@property (nonatomic, readonly) id<MUKContentReducer> reducer;
/// The dispatcher of actions
/**
 Dispatch an action to update content
 @param dispatchableObject Generally you dispatch an action, but middlewares may
 extend the range of dispatchable objects.
 @throws MUKContentStoreIllegalDispatchException Reducers may not dispatch 
 actions.
 @returns Generally the dispatched action, but middlewares may vary returned
 object.
 */
- (nullable id)dispatch:(id<MUKContentDispatchable>)dispatchableObject NS_REQUIRES_SUPER;
/// A subscriber is a block notified of store state changes
typedef void (^MUKContentStoreSubscriber)(ContentType _Nullable oldContent, ContentType _Nullable newContent);
/**
 Subscribe to content changes
 @param subscriber A block called everytime content is updated
 @returns A token to be used to unsubscribe from store
 */
- (id)subscribe:(MUKContentStoreSubscriber)subscriber NS_REQUIRES_SUPER;
/**
 Unsubscribe from content changes
 @param token The token obtained via -subscribe:
 */
- (void)unsubscribe:(id)token NS_REQUIRES_SUPER;

/// Designated initializer
- (instancetype)initWithReducer:(id<MUKContentReducer>)reducer content:(nullable id<MUKContent>)content middlewares:(nullable NSArray<id<MUKContentMiddleware>> *)middlewares NS_DESIGNATED_INITIALIZER;

/// @returns A new store with given reducer and no content and middleware
+ (instancetype)storeWithReducer:(id<MUKContentReducer>)reducer;

/// @returns A new store with given reducer and content, but no middleware
+ (instancetype)storeWithReducer:(id<MUKContentReducer>)reducer content:(id<MUKContent>)content;
@end

NS_ASSUME_NONNULL_END
