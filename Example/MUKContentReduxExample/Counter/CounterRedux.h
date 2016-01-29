//
//  CounterRedux.h
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentRedux.h>

NS_ASSUME_NONNULL_BEGIN

// Actions

@interface CounterActionFactory : NSObject
+ (id<MUKContentAction>)initAction;
+ (id<MUKContentAction>)incrementAction;
+ (id<MUKContentAction>)decrementAction;
@end

// Reducer

@interface CounterReducer : NSObject <MUKContentReducer>
@end


// Content

@interface CounterContent : NSObject <MUKContent>
@property (nonatomic, readonly) NSInteger integerValue;
- (instancetype)initWithIntegerValue:(NSInteger)integerValue;
@end

NS_ASSUME_NONNULL_END
