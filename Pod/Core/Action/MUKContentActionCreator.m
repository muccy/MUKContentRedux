#import "MUKContentActionCreator.h"

@interface MUKBlockContentActionCreator ()
@property (nonatomic, readonly, copy) MUKBlockContentActionCreatorBlock block;
@end

@implementation MUKBlockContentActionCreator

- (instancetype)initWithBlock:(MUKBlockContentActionCreatorBlock)block {
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    
    return self;
}

+ (instancetype)actionCreatorWithBlock:(MUKBlockContentActionCreatorBlock)block {
    return [[self alloc] initWithBlock:block];
}

- (instancetype)init {
    return [self initWithBlock:^id<MUKContentAction> _Nullable(id<MUKContent>  _Nullable content, MUKContentStore * _Nonnull store)
    {
        return nil;
    }];
}

- (id<MUKContentAction>)actionForContent:(id<MUKContent>)content store:(MUKContentStore *)store
{
    return self.block(content, store);
}

@end
