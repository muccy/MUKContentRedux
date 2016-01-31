//
//  MUKContentDispatch.h
//  
//
//  Created by Marco on 31/01/16.
//
//

#import <Foundation/Foundation.h>

@protocol MUKContentAction;

NS_ASSUME_NONNULL_BEGIN

/// Something which can be dispatched
@protocol MUKContentDispatchable <NSObject>
@end

/// A block which dispatches things
typedef id<MUKContentAction> _Nullable (^MUKContentDispatcher)(id<MUKContentDispatchable> dispatchableObject);

NS_ASSUME_NONNULL_END
