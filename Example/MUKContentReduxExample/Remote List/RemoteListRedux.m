//
//  RemoteListRedux.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "RemoteListRedux.h"
#import "RemoteListItemsFetch.h"

#pragma mark - Private Actions

@interface RemoteListItemsRequestStartAction : NSObject <MUKContentAction>
@property (nonatomic, readonly) BOOL loadMore;
- (instancetype)initWithLoadMore:(BOOL)loadMore;
@end

@interface RemoteListItemsRequestFinishAction : NSObject <MUKContentAction>
@property (nonatomic, readonly, nullable) NSArray *items;
@property (nonatomic, readonly, nullable) NSError *error;

- (instancetype)initWithItems:(nullable NSArray *)items error:(nullable NSError *)error;
@end

@interface RemoteListReceivedItemsActionCreator : NSObject <MUKContentActionCreator>
@property (nonatomic, readonly) MUKContentFetchResponse *response;
- (instancetype)initWithResponse:(MUKContentFetchResponse *)response;
@end

#pragma mark - Actions

@implementation RemoteListRequestItemsActionCreator

- (instancetype)initWithLoadMore:(BOOL)loadMore {
    self = [super init];
    if (self) {
        _loadMore = loadMore;
    }
    
    return self;
}

- (id<MUKContentAction> _Nullable)actionForContent:(RemoteListContent * _Nullable)content store:(MUKContentStore *)store
{
    if (content.status != RemoteListContentStatusIdle) {
        return nil;
    }
    
    RemoteListItemsFetch *const fetch = [[RemoteListItemsFetch alloc] init];
    [fetch startWithCompletionHandler:^(MUKContentFetchResponse * _Nonnull response)
    {
        RemoteListReceivedItemsActionCreator *actionCreator = [[RemoteListReceivedItemsActionCreator alloc] initWithResponse:response];
        [store dispatch:actionCreator];
    }];
    
    return [[RemoteListItemsRequestStartAction alloc] initWithLoadMore:self.loadMore];
}

@end

@implementation RemoteListReceivedItemsActionCreator

- (instancetype)initWithResponse:(MUKContentFetchResponse *)response {
    self = [super init];
    if (self) {
        _response = response;
    }
    
    return self;
}

- (id<MUKContentAction> _Nullable)actionForContent:(RemoteListContent * _Nullable)content store:(MUKContentStore *)store
{
    id<MUKContentAction> action;
    
    switch (self.response.resultType) {
        case MUKContentFetchResultTypeSuccess:
            action = [[RemoteListItemsRequestFinishAction alloc] initWithItems:self.response.object error:nil];
            break;
            
        case MUKContentFetchResultTypeFailed:
            action = [[RemoteListItemsRequestFinishAction alloc] initWithItems:nil error:self.response.error];
            break;
            
        default:
            action = nil;
            break;
    }
    
    return action;
}

@end

@implementation RemoteListItemsRequestStartAction

- (instancetype)initWithLoadMore:(BOOL)loadMore {
    self = [super init];
    if (self) {
        _loadMore = loadMore;
    }
    
    return self;
}

@end

@implementation RemoteListItemsRequestFinishAction

- (instancetype)initWithItems:(NSArray *)items error:(NSError *)error {
    self = [super init];
    if (self) {
        _items = [items copy];
        _error = error;
    }
    
    return self;
}

@end

#pragma mark - Reducer

@implementation RemoteListReducer

- (RemoteListContent * _Nullable)contentFromContent:(RemoteListContent * _Nullable)oldContent handlingAction:(id<MUKContentAction>)action
{
    if ([action isKindOfClass:[RemoteListItemsRequestStartAction class]]) {
        return [self setRefreshingAndLoadingMoreWithAction:action oldContent:oldContent];
    }
    else if ([action isKindOfClass:[RemoteListItemsRequestFinishAction class]])
    {
        return [self setItemsAndErrorWithAction:action oldContent:oldContent];
    }
    else {
        return oldContent;
    }
}

- (RemoteListContent *)setRefreshingAndLoadingMoreWithAction:(RemoteListItemsRequestStartAction *)action oldContent:(RemoteListContent *)oldContent
{
    return [[RemoteListContent alloc] initWithItems:oldContent.items error:oldContent.error status:action.loadMore ? RemoteListContentStatusLoadingMore : RemoteListContentStatusRefreshing];
}

- (RemoteListContent *)setItemsAndErrorWithAction:(RemoteListItemsRequestFinishAction *)action oldContent:(RemoteListContent *)oldContent
{
    if (oldContent.status == RemoteListContentStatusRefreshing) {
        return [[RemoteListContent alloc] initWithItems:action.items ?: oldContent.items error:action.error status:RemoteListContentStatusIdle];
    }
    else if (oldContent.status == RemoteListContentStatusLoadingMore) {
        NSMutableArray *const items = [oldContent.items ?: @[] mutableCopy];
        [items addObjectsFromArray:action.items ?: @[]];
        return [[RemoteListContent alloc] initWithItems:items error:action.error status:RemoteListContentStatusIdle];
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
