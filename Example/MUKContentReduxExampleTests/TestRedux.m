//
//  TestRedux.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "TestRedux.h"

@implementation SetContentAction

- (instancetype)initWithContent:(id)content {
    self = [super init];
    if (self) {
        _content = content;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Set content to: %@", self.content];
}

@end

@implementation SetContentActionCreator

- (instancetype)initWithContent:(id)content {
    self = [super init];
    if (self) {
        _content = content;
    }
    
    return self;
}

- (id<MUKContentAction> _Nullable)actionForContent:(id<MUKContent> _Nullable)content store:(MUKContentStore *)store
{
    return [[SetContentAction alloc] initWithContent:self.content];
}

@end

@implementation Reducer

- (id<MUKContent>)contentFromContent:(id<MUKContent>)oldContent handlingAction:(id<MUKContentAction>)action
{
    if ([action isKindOfClass:[SetContentAction class]]) {
        SetContentAction *const contentAction = action;
        return contentAction.content;
    }
    else {
        return oldContent;
    }
}

@end

@implementation Middleware

- (MUKContentMiddlewareBlock)blockForDispatcher:(MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter
{
    return ^(MUKContentDispatcher next) {
        return ^(id<MUKContentDispatchable> dispatchableObject) {
            return next(dispatchableObject);
        };
    };
}

@end

@implementation ActionChangerMiddleware

- (instancetype)initWithString:(NSString *)string {
    self = [super init];
    if (self) {
        _string = [string copy];
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithString:nil];
}

- (MUKContentMiddlewareBlock)blockForDispatcher:(MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter
{
    // Don't retain "self"
    NSString *const substitutionString = self.string;
    
    return ^(MUKContentDispatcher next) {
        return ^(id<MUKContentDispatchable> dispatchableObject) {
            id<MUKContentDispatchable> objectToDispatchToNext = dispatchableObject;
            
            if (substitutionString.length > 0) {
                if ([dispatchableObject isKindOfClass:[SetContentAction class]])
                {
                    SetContentAction *const action = (SetContentAction *)dispatchableObject;
                    
                    if ([action.content isKindOfClass:[NSString class]]) {
                        NSString *const string = action.content;
                        NSString *const newString = [string stringByAppendingString:substitutionString];
                        objectToDispatchToNext = [[SetContentAction alloc] initWithContent:newString];
                    }
                }
            }

            return next(objectToDispatchToNext);
        };
    };
}

@end

@implementation DispatcherMiddleware

- (MUKContentMiddlewareBlock)blockForDispatcher:(MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter
{
    return ^(MUKContentDispatcher next) {
        return ^(id<MUKContentDispatchable> dispatchableObject) {
            NSString *const string = (NSString *)getter();
            SetContentAction *const action = (SetContentAction *)dispatchableObject;
            BOOL passToNext = YES;
            
            if (dispatcher && [string isKindOfClass:[NSString class]] &&
                [action isKindOfClass:[SetContentAction class]] &&
                ![action.content hasPrefix:@"Goodbye"])
            {
                if ([string hasPrefix:@"Hello"]) {
                    NSString *const newString = [string stringByReplacingOccurrencesOfString:@"Hello" withString:@"Goodbye"];
                    passToNext = NO;
                    dispatcher([[SetContentAction alloc] initWithContent:newString]);
                }
            }
            
            return passToNext ? next(dispatchableObject) : nil;
        };
    };
}

@end
