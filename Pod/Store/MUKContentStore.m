//
//  MUKContentStore.m
//  ProvaReducer
//
//  Created by Marco on 26/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "MUKContentStore.h"

@interface MUKContentStore ()
@property (nonatomic, readwrite, nullable) id<MUKContent> content;
@property (nonatomic, readwrite, copy, nullable) NSDictionary<NSUUID *, MUKContentStoreSubscriber> *subscribersMap;
@end

@implementation MUKContentStore

- (instancetype)initWithReducer:(id<MUKContentReducer>)reducer {
    self = [super init];
    if (self) {
        _reducer = reducer;
    }
    
    return self;
}

#pragma mark - Overrides

- (instancetype)init {
    NSAssert(NO, @"Use designated initializer");
    return [self initWithReducer:(id<MUKContentReducer>)[NSNull null]];
}

#pragma mark - Methods

- (id<MUKContentAction>)dispatch:(id<MUKContentAction>)action {
    id<MUKContent> const oldContent = self.content;
    self.content = [self.reducer contentFromContent:oldContent handlingAction:action];
    
    [self.subscribersMap.allValues enumerateObjectsUsingBlock:^(MUKContentStoreSubscriber _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        obj(oldContent, self.content);
    }];
    
    return action;
}

- (id<MUKContentAction>)dispatchActionCreator:(MUKContentActionCreator)actionCreator
{
    id<MUKContentAction> const action = actionCreator(self.content, self);
    
    if (action) {
        return [self dispatch:action];
    }
    
    return action;
}

- (id)subscribe:(MUKContentStoreSubscriber)subscriber {
    NSMutableDictionary<NSUUID *, MUKContentStoreSubscriber> *subscribersMap = [self.subscribersMap ?: @{} mutableCopy];

    NSUUID *const UUID = [NSUUID UUID];
    subscribersMap[UUID] = [subscriber copy];
    
    self.subscribersMap = subscribersMap;
    
    return UUID;
}

- (void)unsubscribe:(id)object {
    if (self.subscribersMap) {
        NSMutableDictionary<NSUUID *, MUKContentStoreSubscriber> *subscribersMap = [self.subscribersMap mutableCopy];
        [subscribersMap removeObjectForKey:object];
        self.subscribersMap = subscribersMap;
    }
}

@end
