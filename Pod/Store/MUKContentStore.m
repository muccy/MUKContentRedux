//
//  MUKContentStore.m
//  ProvaReducer
//
//  Created by Marco on 26/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "MUKContentStore.h"
#import "MUKContentAction.h"
#import "MUKContentReducer.h"

#define DEBUG_LOG_DISPATCH  0

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

- (id<MUKContentAction>)dispatch:(id<MUKContentDispatchable>)actionOrActionCreator
{
#if DEBUG_LOG_DISPATCH
    NSLog(@"Dispatch action: %@", action);
#endif
    id<MUKContent> const oldContent = self.content;
    
    // Manage action creators by digging inside of them
    if ([actionOrActionCreator respondsToSelector:@selector(actionForContent:store:)]) {
        id<MUKContentActionCreator> const actionCreator = (id<MUKContentActionCreator>)actionOrActionCreator;
        id<MUKContentAction> const innerAction = [actionCreator actionForContent:oldContent store:self];
        return innerAction ? [self dispatch:innerAction] : nil; // Recursion
    }
    
    id<MUKContentAction> const action = (id<MUKContentAction>)actionOrActionCreator;
    self.content = [self.reducer contentFromContent:oldContent handlingAction:action];
#if DEBUG_LOG_DISPATCH
    NSLog(@"Content changed: (%@) ---> (%@)", oldContent, self.content);
#endif
    
    [self.subscribersMap.allValues enumerateObjectsUsingBlock:^(MUKContentStoreSubscriber _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
    {
        obj(oldContent, self.content);
    }];
    
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
