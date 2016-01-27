#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Actions are payloads of information that send data from your application to your
 store. They are the only source of information for the store. Actions describe
 the fact that something happened, but don’t specify how the application’s state
 changes in response.
 
 You should create classes which implement this empty protocol and dispatch their
 instances to store in order to change state.
 */
@protocol MUKContentAction <NSObject>
@end

@class MUKContentStore;
@protocol MUKContent;
/**
 Action creator is a block which takes store and content state and returns the
 action.
 You can use action creators to dispatch to store async actions.
 */
typedef id<MUKContentAction> _Nullable (^MUKContentActionCreator)(id<MUKContent> _Nullable content, MUKContentStore *store);

NS_ASSUME_NONNULL_END
