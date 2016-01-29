//
//  CounterRedux.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "CounterRedux.h"

typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeInit,
    ActionTypeIncrement
};

MUK_DECLARE_ACTION(Counter, ActionType);

@implementation CounterActionFactory

+ (id<MUKContentAction>)initAction {
    return [CounterAction actionWithType:ActionTypeInit];
}

+ (id<MUKContentAction>)incrementAction {
    return [CounterAction actionWithType:ActionTypeIncrement payload:@1];
}

+ (id<MUKContentAction>)decrementAction {
    return [CounterAction actionWithType:ActionTypeIncrement payload:@(-1)];
}

@end

@implementation CounterReducer

- (CounterContent * _Nullable)contentFromContent:(CounterContent * _Nullable)oldContent handlingAction:(CounterAction *)action
{
    switch (action.type) {
        case ActionTypeInit:
            return [[CounterContent alloc] initWithIntegerValue:0];
            break;
            
        case ActionTypeIncrement: {
            NSInteger const increment = [[action payloadIfIsKindOfClass:[NSNumber class]] integerValue];
            return [[CounterContent alloc] initWithIntegerValue:oldContent.integerValue + increment];
            break;
        }
            
        default:
            return oldContent;
            break;
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