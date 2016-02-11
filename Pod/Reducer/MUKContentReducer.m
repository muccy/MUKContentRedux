#import "MUKContentReducer.h"

@interface MUKCombinedContentReducer ()
@property (nonatomic, readonly, nullable, copy) NSArray<id<MUKContentReducer>> *reducers;
@end

@implementation MUKCombinedContentReducer

- (instancetype)initWithReducers:(NSArray<id<MUKContentReducer>> *)reducers {
    self = [super init];
    if (self) {
        _reducers = [reducers copy];
    }
    
    return self;
}

#pragma mark - Overrides

- (instancetype)init {
    return [self initWithReducers:@[]];
}

#pragma mark - <MUKContentReducer>

- (id<MUKContent>)contentFromContent:(id<MUKContent>)oldContent handlingAction:(id<MUKContentAction>)action
{
    __block id<MUKContent> content = oldContent;
    
    [self.reducers enumerateObjectsUsingBlock:^(id<MUKContentReducer> _Nonnull reducer, NSUInteger idx, BOOL * _Nonnull stop)
    {
        content = [reducer contentFromContent:content handlingAction:action];
    }];
    
    return content;
}

@end
