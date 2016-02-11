#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentAction.h>
#import <MUKContentRedux/MUKContentStore.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Action creator is an entity which takes store and content state and returns the
 action.
 You can use action creators to dispatch to store async actions.
 */
@protocol MUKContentActionCreator <MUKContentDispatchable>
@required
- (nullable id<MUKContentAction>)actionForContent:(nullable id<MUKContent>)content store:(MUKContentStore *)store;
@end

/// A concrete action creator which generates actions with a block
@interface MUKBlockContentActionCreator<__covariant ContentType:id<MUKContent>> : NSObject <MUKContentActionCreator>
/// Type of block used on -actionForContent:store: invocations
typedef id<MUKContentAction> _Nullable (^MUKBlockContentActionCreatorBlock)(ContentType _Nullable content, MUKContentStore<ContentType> *store);
/// Designated initializer
- (instancetype)initWithBlock:(MUKBlockContentActionCreatorBlock)block NS_DESIGNATED_INITIALIZER;
/// @returns A new action creator
+ (instancetype)actionCreatorWithBlock:(MUKBlockContentActionCreatorBlock)block;
@end

NS_ASSUME_NONNULL_END
