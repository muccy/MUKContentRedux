//
//  CounterRedux.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "CounterRedux.h"

@implementation CounterInitAction
@end

@implementation CounterDecrementAction
@end

@implementation CounterIncrementAction
@end


@implementation CounterReducer

- (CounterContent * _Nullable)contentFromContent:(CounterContent * _Nullable)oldContent handlingAction:(id<MUKContentAction>)action
{
    if ([action isKindOfClass:[CounterInitAction class]]) {
        return [[CounterContent alloc] initWithIntegerValue:0];
    }
    else if ([action isKindOfClass:[CounterIncrementAction class]]) {
        return [[CounterContent alloc] initWithIntegerValue:oldContent.integerValue + 1];
    }
    else if ([action isKindOfClass:[CounterDecrementAction class]]) {
        return [[CounterContent alloc] initWithIntegerValue:oldContent.integerValue - 1];
    }
    else {
        return oldContent;
    }
}

@end


@implementation CounterContent

- (instancetype)initWithIntegerValue:(NSInteger)integerValue {
    self = [super init];
    if (self) {
        _integerValue = integerValue;
    }
    
    return self;
}

@end