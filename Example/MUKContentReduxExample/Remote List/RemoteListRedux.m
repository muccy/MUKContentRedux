//
//  RemoteListRedux.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "RemoteListRedux.h"
#import "RemoteListItemsFetch.h"

#pragma mark - Actions

typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeRequestStart,
    ActionTypeRequestFinish
};

@implementation RemoteListActionCreator

+ (id<MUKContentThunk>)requestItemsToLoadMore:(BOOL)loadMore {
    return [MUKBlockContentThunk thunkWithBlock:^id _Nullable(MUKContentDispatcher _Nullable dispatcher, MUKContentGetter _Nonnull getter)
    {
        RemoteListContent *const content = getter();
        
        if (content.status != RemoteListContentStatusIdle) {
            return nil;
        }
        
        // Start request
        id<MUKContentAction> const action = [RemoteListActionCreator requestStartToLoadMore:loadMore];
        dispatcher(action);
        
        RemoteListItemsFetch *const fetch = [[RemoteListItemsFetch alloc] init];
        [fetch startWithCompletionHandler:^(MUKContentFetchResponse * _Nonnull response)
        {
            id<MUKContentAction> const action = [RemoteListActionCreator itemsReceivedWithResponse:response];
            if (action) {
                dispatcher(action);
            }
        }];
        
        return action;
    }];
}

+ (id<MUKContentAction>)requestStartToLoadMore:(BOOL)loadMore {
    return [MUKContentTypedAction actionWithType:ActionTypeRequestStart payload:@(loadMore)];
}

+ (id<MUKContentAction>)requestFinishWithItems:(nonnull NSArray *)items {
    return [MUKContentTypedAction actionWithType:ActionTypeRequestFinish payload:items];
}

+ (id<MUKContentAction>)requestFinishWithError:(nullable NSError *)error {
    return [MUKContentTypedAction actionWithType:ActionTypeRequestFinish payload:error];
}

+ (nullable id<MUKContentAction>)itemsReceivedWithResponse:(nonnull MUKContentFetchResponse *)response
{
    id<MUKContentAction> action;
    
    switch (response.resultType) {
        case MUKContentFetchResultTypeSuccess:
            action = [RemoteListActionCreator requestFinishWithItems:response.object];
            break;
            
        case MUKContentFetchResultTypeFailed:
            action = [RemoteListActionCreator requestFinishWithError:response.error];
            break;
            
        default:
            action = nil;
            break;
    }
    
    return action;
}

@end

#pragma mark - Reducer

@implementation RemoteListReducer

- (RemoteListContent * _Nullable)contentFromContent:(RemoteListContent * _Nullable)oldContent handlingAction:(MUKContentTypedAction *)action
{
    switch ((ActionType)action.type) {
        case ActionTypeRequestStart:
            return [self setRefreshingAndLoadingMoreWithAction:action oldContent:oldContent];
            break;
            
        case ActionTypeRequestFinish:
            return [self setItemsAndErrorWithAction:action oldContent:oldContent];
            break;
            
        default:
            return oldContent;
            break;
    }
}

- (RemoteListContent *)setRefreshingAndLoadingMoreWithAction:(MUKContentTypedAction *)action oldContent:(RemoteListContent *)oldContent
{
    BOOL loadMore = [[action payloadIfIsKindOfClass:[NSNumber class]] boolValue];
    return [[RemoteListContent alloc] initWithItems:oldContent.items error:oldContent.error status:loadMore ? RemoteListContentStatusLoadingMore : RemoteListContentStatusRefreshing];
}

- (RemoteListContent *)setItemsAndErrorWithAction:(MUKContentTypedAction *)action oldContent:(RemoteListContent *)oldContent
{
    NSArray *const items = [action payloadIfIsKindOfClass:[NSArray class]];
    NSError *const error = [action payloadIfIsKindOfClass:[NSError class]];
    
    if (oldContent.status == RemoteListContentStatusRefreshing) {
        return [[RemoteListContent alloc] initWithItems:items ?: oldContent.items error:error status:RemoteListContentStatusIdle];
    }
    else if (oldContent.status == RemoteListContentStatusLoadingMore) {
        NSMutableArray *const newItems = [oldContent.items ?: @[] mutableCopy];
        [newItems addObjectsFromArray:items ?: @[]];
        return [[RemoteListContent alloc] initWithItems:newItems error:error status:RemoteListContentStatusIdle];
    }
    else {
        return oldContent;
    }
}

@end

#pragma mark - Content

@implementation RemoteListContent

- (instancetype)initWithItems:(NSArray *)items error:(NSError *)error status:(RemoteListContentStatus)status
{
    self = [super init];
    if (self) {
        _items = [items copy];
        _error = error;
        _status = status;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%lu items; error? %@; status = %li", self.items.count, self.error ? @"Y" : @"N", (long)self.status];
}

@end
