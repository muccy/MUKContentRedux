//
//  TestRedux.h
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentRedux.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetContentAction : NSObject <MUKContentAction>
@property (nonatomic, readonly) id content;
- (instancetype)initWithContent:(id)content;
@end

#pragma mark -

@interface Reducer : NSObject <MUKContentReducer>
@end

@interface AppenderReducer : NSObject <MUKContentReducer>
@property (nonatomic, readonly) NSString *string;
@end

@interface DispatchingReducer : NSObject <MUKContentReducer>
@property (nonatomic, weak) MUKContentStore *store;
@end

#pragma mark -

@interface Middleware : NSObject <MUKContentMiddleware>
@end

@interface ActionChangerMiddleware : NSObject <MUKContentMiddleware>
@property (nonatomic, readonly, nullable, copy) NSString *string;
- (instancetype)initWithString:(nullable NSString *)string NS_DESIGNATED_INITIALIZER;
@end

@interface DispatcherMiddleware : NSObject <MUKContentMiddleware>
@end

NS_ASSUME_NONNULL_END
