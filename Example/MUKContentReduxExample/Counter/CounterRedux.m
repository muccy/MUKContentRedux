//
//  CounterRedux.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "CounterRedux.h"

typedef NS_ENUM(NSInteger, ActionType) {
    ActionTypeIncrement
};

@implementation CounterActionFactory

+ (id<MUKContentAction>)incrementAction {
    return [MUKContentTypedAction actionWithType:ActionTypeIncrement payload:@1];
}

+ (id<MUKContentAction>)decrementAction {
    return [MUKContentTypedAction actionWithType:ActionTypeIncrement payload:@(-1)];
}

@end

@implementation CounterReducer

- (CounterContent * _Nullable)contentFromContent:(CounterContent * _Nullable)oldContent handlingAction:(MUKContentTypedAction *)action
{
    switch ((ActionType)action.type) {
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

- (NSString *)description {
    return [NSString stringWithFormat:@"%lu", (long)self.integerValue];
}

@end


@implementation CounterOddMiddleware

- (MUKContentMiddlewareBlock)blockForDispatcher:(MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter
{
    return ^(MUKContentDispatcher next) {
        return ^(id<MUKContentDispatchable> dispatchableObject) {
            id<MUKContentAction> const action = next(dispatchableObject);
            
            CounterContent *const content = getter();
            if (content.integerValue % 2 != 0) {
                NSLog(@"%li is odd!", (long)content.integerValue);
            }
            
            return action;
        };
    };
}

@end


@implementation CounterKeepPositiveMiddleware

- (MUKContentMiddlewareBlock)blockForDispatcher:(MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter
{
    return ^(MUKContentDispatcher next) {
        return ^(id<MUKContentDispatchable> dispatchableObject) {
            BOOL invokeNext = YES;
            
            if ([dispatchableObject isKindOfClass:[MUKContentTypedAction class]]) {
                MUKContentTypedAction *const action = (MUKContentTypedAction *)dispatchableObject;
                
                if (action.type == ActionTypeIncrement && [[action payloadIfIsKindOfClass:[NSNumber class]] integerValue] < 0)
                {
                    CounterContent *const content = getter();
                    if (content.integerValue <= 0) {
                        invokeNext = NO;
                    }
                }
            }
            
            id<MUKContentAction> const action = invokeNext ? next(dispatchableObject) : nil;
            
            if (!invokeNext) {
                NSLog(@"Keeping positive :)");
            }
            
            return action;
        };
    };
}

@end
