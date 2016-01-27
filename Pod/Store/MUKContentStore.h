//
//  MUKContentStore.h
//  ProvaReducer
//
//  Created by Marco on 26/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentAction.h>
#import <MUKContentRedux/MUKContent.h>
#import <MUKContentRedux/MUKContentReducer.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The store has the following responsibilities:
 • holds and allows access to immutable content state;
 • notifies state updates via -subscribe:
 • allows state to be updated via -dispatch:
 */
@interface MUKContentStore<__covariant ContentType:id<MUKContent>> : NSObject
/// The immutable stored state
@property (nonatomic, readonly, nullable) ContentType content;
/// The reducer that brings content and action to new content
@property (nonatomic, readonly) id<MUKContentReducer> reducer;
/**
 Dispatch an action to update content
 @returns Dispatched action
 */
- (id<MUKContentAction>)dispatch:(id<MUKContentAction>)action NS_REQUIRES_SUPER;
/**
 Dispatch an action executing the actionCreator
 @return Dispatched action
 */
- (nullable id<MUKContentAction>)dispatchActionCreator:(MUKContentActionCreator)actionCreator NS_REQUIRES_SUPER;
/// A subscriber is a block notified of store state changes
typedef void (^MUKContentStoreSubscriber)(ContentType _Nullable oldContent, ContentType _Nullable newContent);
/**
 Subscribe to content changes
 @param subscriber A block called everytime content is updated
 @returns A token to be used to unsubscribe from store
 */
- (id)subscribe:(MUKContentStoreSubscriber)subscriber NS_REQUIRES_SUPER;
/**
 Unsubscribe from content changes
 @param token The token obtained via -subscribe:
 */
- (void)unsubscribe:(id)token NS_REQUIRES_SUPER;

/// Designated initializer
- (instancetype)initWithReducer:(id<MUKContentReducer>)reducer NS_DESIGNATED_INITIALIZER;
@end

NS_ASSUME_NONNULL_END
