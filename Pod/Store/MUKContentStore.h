#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentDispatch.h>

@protocol MUKContent, MUKContentAction, MUKContentReducer;

NS_ASSUME_NONNULL_BEGIN

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
@property (nonatomic, copy) MUKContentDispatcher dispatcher;
/**
 Dispatch an action to update content
 @param actionOrActionCreator An action or an action creator to be evaluated to 
 update store state
 @returns Dispatched action
 */
- (nullable id<MUKContentAction>)dispatch:(id<MUKContentDispatchable>)actionOrActionCreator NS_REQUIRES_SUPER;
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
- (instancetype)initWithReducer:(id<MUKContentReducer>)reducer NS_DESIGNATED_INITIALIZER;
@end

@interface MUKContentStore (Dispatcher)
/// @returns A new default dispatcher
- (MUKContentDispatcher)newDefaultDispatcher;
/// @returns A dispatcher which encapsulates current one and logs dispatch infos
- (MUKContentDispatcher)newLogDispatcher;
@end

NS_ASSUME_NONNULL_END
