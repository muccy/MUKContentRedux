//
//  CounterRedux.h
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentRedux.h>

// Actions

@interface CounterInitAction : NSObject <MUKContentAction>
@end

@interface CounterIncrementAction : NSObject <MUKContentAction>
@end

@interface CounterDecrementAction : NSObject <MUKContentAction>
@end


// Reducer

@interface CounterReducer : NSObject <MUKContentReducer>
@end


// Content

@interface CounterContent : NSObject <MUKContent>
@property (nonatomic, readonly) NSInteger integerValue;
- (instancetype)initWithIntegerValue:(NSInteger)integerValue;
@end
