//
//  RemoteListRedux.h
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentRedux.h>
#import <MUKContentFetch/MUKContentFetchResponse.h>

NS_ASSUME_NONNULL_BEGIN

// Actions

@interface RemoteListRequestItemsActionCreator : NSObject <MUKContentActionCreator>
@property (nonatomic, readonly) BOOL loadMore;
- (instancetype)initWithLoadMore:(BOOL)loadMore;
@end


// Reducer

@interface RemoteListReducer : NSObject <MUKContentReducer>
@end


// Content

typedef NS_ENUM(NSInteger, RemoteListContentStatus) {
    RemoteListContentStatusIdle,
    RemoteListContentStatusRefreshing,
    RemoteListContentStatusLoadingMore
};

@interface RemoteListContent : NSObject <MUKContent>
@property (nonatomic, readonly, nullable) NSArray *items;
@property (nonatomic, readonly, nullable) NSError *error;
@property (nonatomic, readonly) RemoteListContentStatus status;

- (instancetype)initWithItems:(nullable NSArray *)items error:(nullable NSError *)error status:(RemoteListContentStatus)status;
@end

NS_ASSUME_NONNULL_END
