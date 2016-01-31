//
//  MUKContentStore.m
//  ProvaReducer
//
//  Created by Marco on 26/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "MUKContentStore.h"
#import "MUKContentAction.h"
#import "MUKContentActionCreator.h"
#import "MUKContentReducer.h"

@interface MUKContentStore ()
@property (nonatomic, readwrite, nullable) id<MUKContent> content;
@property (nonatomic, readwrite, copy, nullable) NSDictionary<NSUUID *, MUKContentStoreSubscriber> *subscribersMap;
@end

@implementation MUKContentStore

- (instancetype)initWithReducer:(id<MUKContentReducer>)reducer {
    self = [super init];
    if (self) {
        _reducer = reducer;
        _dispatcher = [self newDefaultDispatcher];
    }
    
    return self;
}

#pragma mark - Overrides

- (instancetype)init {
    NSAssert(NO, @"Use designated initializer");
    return [self initWithReducer:(id<MUKContentReducer>)[NSNull null]];
}

#pragma mark - Methods

- (id<MUKContentAction>)dispatch:(id<MUKContentDispatchable>)actionOrActionCreator {
    return self.dispatcher(actionOrActionCreator);
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

#pragma mark - Dispatcher

- (MUKContentDispatcher)newDefaultDispatcher {
    __weak __typeof__(self) weakSelf = self;
    return [^id<MUKContentAction> (id<MUKContentDispatchable> _Nonnull dispatchableObject)
    {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) {
            return nil;
        }
        
        id<MUKContent> const oldContent = strongSelf.content;
        id<MUKContentAction> action;
        
        // Manage action creators by digging inside of them
        if ([dispatchableObject respondsToSelector:@selector(actionForContent:store:)])
        {
            id<MUKContentActionCreator> const actionCreator = (id<MUKContentActionCreator>)dispatchableObject;
            action = [actionCreator actionForContent:oldContent store:strongSelf];
        }
        else {
            action = (id<MUKContentAction>)dispatchableObject;
        }
        
        if (action) {
            // Create new content
            id<MUKContent> const newContent = [strongSelf.reducer contentFromContent:oldContent handlingAction:action];
            strongSelf.content = newContent;
        
            // Inform subscribers
            [strongSelf.subscribersMap.allValues enumerateObjectsUsingBlock:^(MUKContentStoreSubscriber _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop)
            {
                obj(oldContent, newContent);
            }];
        }
        
        return action;
    } copy];
}

- (MUKContentDispatcher)newLogDispatcher {
    MUKContentDispatcher const originalDispatcher = [self.dispatcher copy];
    
    __weak __typeof__(self) weakSelf = self;
    return [^id<MUKContentAction>(id<MUKContentDispatchable> dispatchableObject)
    {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        
        id<MUKContent> const oldContent = strongSelf.content;
        id<MUKContentAction> const action = originalDispatcher(dispatchableObject);
        id<MUKContent> const newContent = strongSelf.content;
        
        if (action) {
            NSLog(@"[%@] %@ --> %@", action, oldContent, newContent);
        }
        else {
            NSLog(@"[%@ has not produced an action]", dispatchableObject);
        }
        
        return action;
    } copy];
}

@end
