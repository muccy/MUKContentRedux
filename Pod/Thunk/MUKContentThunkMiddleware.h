#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentMiddleware.h>

NS_ASSUME_NONNULL_BEGIN

/// A thunk is a function that wraps an expression to delay its evaluation
@protocol MUKContentThunk <MUKContentDispatchable>
@required
- (nullable id)valueWithDispatcher:(nullable MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter;
@end


/// A concrete thunk implemented with block
@interface MUKBlockContentThunk : NSObject <MUKContentThunk>
typedef id _Nullable (^MUKContentThunkBlock)(MUKContentDispatcher _Nullable dispatcher, MUKContentGetter getter);
- (instancetype)initWithBlock:(MUKContentThunkBlock)block NS_DESIGNATED_INITIALIZER;
+ (instancetype)thunkWithBlock:(MUKContentThunkBlock)block;
@end


/// Middleware which enables thunks to be executed like actions
@interface MUKContentThunkMiddleware : NSObject <MUKContentMiddleware>
@end

NS_ASSUME_NONNULL_END
