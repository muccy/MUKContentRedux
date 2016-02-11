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
@property (nonatomic, readonly, copy) MUKContentDispatcher dispatcher;
@end

@implementation MUKContentStore

- (instancetype)initWithReducer:(id<MUKContentReducer>)reducer content:(nullable id<MUKContent>)content middlewares:(nullable NSArray<id<MUKContentMiddleware>> *)middlewares
{
    self = [super init];
    if (self) {
        _reducer = reducer;
        _content = content;
        _dispatcher = [self newDispatcherWithMiddlewares:middlewares];
    }
    
    return self;
}

+ (instancetype)storeWithReducer:(id<MUKContentReducer>)reducer {
    return [[self alloc] initWithReducer:reducer content:nil middlewares:nil];
}

+ (instancetype)storeWithReducer:(id<MUKContentReducer>)reducer content:(id<MUKContent>)content
{
    return [[self alloc] initWithReducer:reducer content:content middlewares:nil];
}

#pragma mark - Overrides

- (instancetype)init {
    NSAssert(NO, @"Use designated initializer");
    return [self initWithReducer:(id<MUKContentReducer>)[NSNull null] content:nil middlewares:nil];
}

#pragma mark - Methods

- (id)dispatch:(id<MUKContentDispatchable>)dispatchableObject {
    return self.dispatcher(dispatchableObject);
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

#pragma mark - Private — Dispatcher

- (nonnull MUKContentDispatcher)newDispatcherWithMiddlewares:(nullable NSArray<id<MUKContentMiddleware>> *)middlewares
{
    __weak __typeof__(self) weakSelf = self;
    __block MUKContentDispatcher dispatcher = ^(id<MUKContentDispatchable> _Nonnull dispatchableObject)
    {
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        id<MUKContentAction> action;

        if (strongSelf) {
            id<MUKContent> const oldContent = strongSelf.content;
            
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
                [strongSelf.subscribersMap.allValues enumerateObjectsUsingBlock:^(MUKContentStoreSubscriber _Nonnull subscriber, NSUInteger idx, BOOL * _Nonnull stop)
                {
                    subscriber(oldContent, newContent);
                }];
            }
        }
        else {
            action = nil;
        }
        
        return action;
    };
    
    if (middlewares.count > 0) {
        MUKContentDispatcher const storeDispatcher = [^(id<MUKContentDispatchable> dispatchableObject)
        {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            return strongSelf.dispatcher(dispatchableObject);
        } copy];
        
        MUKContentGetter const storeGetter = [^{
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            return strongSelf.content;
        } copy];
        
        [middlewares enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id<MUKContentMiddleware> _Nonnull middleware, NSUInteger idx, BOOL * _Nonnull stop)
        {
            MUKContentDispatcher const next = [dispatcher copy];
            dispatcher = [middleware blockForDispatcher:storeDispatcher getter:storeGetter](next);
        }];
    }
    
    return [dispatcher copy];
}

@end
