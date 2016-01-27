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

@end

@implementation SetContentActionCreator

- (instancetype)initWithContent:(id)content {
    self = [super init];
    if (self) {
        _content = content;
    }
    
    return self;
}

- (__kindof id<MUKContentAction> _Nullable)actionForContent:(__kindof id<MUKContent> _Nullable)content store:(MUKContentStore *)store
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
