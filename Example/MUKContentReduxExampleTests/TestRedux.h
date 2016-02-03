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

@interface SetContentActionCreator : NSObject <MUKContentActionCreator>
@property (nonatomic, readonly) id content;
- (instancetype)initWithContent:(id)content;
@end

@interface Reducer : NSObject <MUKContentReducer>
@end

@interface Middleware : NSObject <MUKContentMiddleware>
@end

@interface ActionChangerMiddleware : NSObject <MUKContentMiddleware>
@property (nonatomic, readonly, nullable, copy) NSString *string;
- (instancetype)initWithString:(nullable NSString *)string NS_DESIGNATED_INITIALIZER;
@end

@interface DispatcherMiddleware : NSObject <MUKContentMiddleware>
@end

NS_ASSUME_NONNULL_END
