#import "MUKContentThunkMiddleware.h"

@interface MUKBlockContentThunk ()
@property (nonatomic, readonly, copy, nonnull) MUKContentThunkBlock block;
@end

@implementation MUKBlockContentThunk

- (instancetype)initWithBlock:(MUKContentThunkBlock)block {
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    
    return self;
}

- (instancetype)init {
    NSAssert(NO, @"Use designated initializer");
    return [self initWithBlock:^id _Nullable(MUKContentDispatcher _Nullable dispatcher, MUKContentGetter _Nonnull getter)
    {
        return nil;
    }];
}

+ (instancetype)thunkWithBlock:(MUKContentThunkBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (id)valueWithDispatcher:(MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter
{
    return self.block(dispatcher, getter);
}

@end


@implementation MUKContentThunkMiddleware

- (MUKContentMiddlewareBlock)blockForDispatcher:(nullable MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter
{
    return ^(MUKContentDispatcher next) {
        return ^(id<MUKContentDispatchable> dispatchableObject) {
            if ([dispatchableObject respondsToSelector:@selector(valueWithDispatcher:getter:)])
            {
                id<MUKContentThunk> const thunk = (id<MUKContentThunk>)dispatchableObject;
                return [thunk valueWithDispatcher:dispatcher getter:getter];
            }
            else {
                return next(dispatchableObject);
            }
        };
    };
}

@end
