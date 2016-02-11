#import <Foundation/Foundation.h>

@protocol MUKContentAction, MUKContent;

NS_ASSUME_NONNULL_BEGIN

/// Something which can be dispatched
@protocol MUKContentDispatchable <NSObject>
@end

/// A block which dispatches things
typedef id<MUKContentAction> _Nullable (^MUKContentDispatcher)(id<MUKContentDispatchable> dispatchableObject);

/// A block which returns the content
typedef id<MUKContent> _Nullable (^MUKContentGetter)(void);

/*
 Helper typedef for MUKContentMiddleware definition.
 
 Snippet:
 ^(MUKContentDispatcher next) {
     return ^(id<MUKContentDispatchable> dispatchableObject) {
         <#code#>
     };
 };
 */
typedef MUKContentDispatcher _Nonnull (^MUKContentMiddlewareBlock)(MUKContentDispatcher _Nonnull next);
/**
 Middleware provides a third-party extension point between dispatching an action,
 and the moment it reaches the reducer. People use middleware for logging,
 crash reporting, talking to an asynchronous API, routing, and more.
 Middleware is an object which returns a block which returns a dispatcher. This
 dispatcher has access to current state (via `getter` parameter), may dispatch
 other actions (via `dispatcher` parameter) and it is encouraged to chain with 
 other dispatchers (via `next` parameter).
 */
@protocol MUKContentMiddleware <NSObject>
@required
- (MUKContentMiddlewareBlock)blockForDispatcher:(nullable MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter;
@end

NS_ASSUME_NONNULL_END
