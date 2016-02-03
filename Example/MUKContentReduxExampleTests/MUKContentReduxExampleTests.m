//
//  MUKContentReduxExampleTests.m
//  MUKContentReduxExampleTests
//
//  Created by Marco on 26/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestRedux.h"

@interface MUKContentReduxExampleTests : XCTestCase
@end

@implementation MUKContentReduxExampleTests

- (void)testInitialization {
    Reducer *const reducer = [[Reducer alloc] init];
    id const content = @"Hello";

    {
        Middleware *const middleware = [[Middleware alloc] init];
        MUKContentStore *const store = [[MUKContentStore alloc] initWithReducer:reducer content:content middlewares:@[middleware]];
        XCTAssertEqualObjects(reducer, store.reducer);
        XCTAssertEqualObjects(content, store.content);
    }
    
    {
        MUKContentStore *const store = [MUKContentStore storeWithReducer:reducer content:content];
        XCTAssertEqualObjects(reducer, store.reducer);
        XCTAssertEqualObjects(content, store.content);
    }
    
    {
        MUKContentStore *const store = [MUKContentStore storeWithReducer:reducer];
        XCTAssertEqualObjects(reducer, store.reducer);
        XCTAssertNil(store.content);
    }
}

- (void)testDispatch {
    MUKContentStore *const store = [MUKContentStore storeWithReducer:[Reducer new]];
    
    id const newContent = @"Hello";
    SetContentAction *const action = [[SetContentAction alloc] initWithContent:newContent];
    id<MUKContentAction> const dispatchedAction = [store dispatch:action];
    
    XCTAssertEqualObjects(action, dispatchedAction);
    XCTAssertEqualObjects(store.content, newContent);
}

- (void)testDispatchWithCreator {
    MUKContentStore *const store = [MUKContentStore storeWithReducer:[Reducer new]];

    id const newContent = @"Hello";
    SetContentActionCreator *const actionCreator = [[SetContentActionCreator alloc] initWithContent:newContent];
    
    id<MUKContentAction> const dispatchedAction = [store dispatch:actionCreator];
    
    XCTAssertFalse([dispatchedAction respondsToSelector:@selector(actionForContent:store:)]);
    XCTAssertEqualObjects(store.content, newContent);
}

- (void)testSubscribe {
    MUKContentStore *const store = [MUKContentStore storeWithReducer:[Reducer new]];

    id const newContent = @"Hello";
    SetContentAction *const action = [[SetContentAction alloc] initWithContent:newContent];
    
    __block BOOL blockCalled = NO;
    id const token = [store subscribe:^(id<MUKContent> _Nullable oldContent, id<MUKContent> _Nullable c)
    {
        XCTAssertNil(oldContent);
        XCTAssertEqualObjects(newContent, c);
        
        blockCalled = YES;
    }];
    
    XCTAssertNotNil(token);
    
    [store dispatch:action];
    XCTAssertTrue(blockCalled);
}

- (void)testUnsubscribe {
    MUKContentStore *const store = [MUKContentStore storeWithReducer:[Reducer new]];
    SetContentAction *const action = [[SetContentAction alloc] initWithContent:@"Hello"];

    __block BOOL blockCalled = NO;
    id const token = [store subscribe:^(id<MUKContent> _Nullable oldContent, id<MUKContent> _Nullable newContent)
    {
        blockCalled = YES;
    }];
    
    XCTAssertNotNil(token);
    [store unsubscribe:token];
    
    [store dispatch:action];
    XCTAssertFalse(blockCalled);
}

- (void)testMiddlewareWhichChangesAction {
    MUKContentStore *const store = [[MUKContentStore alloc] initWithReducer:[Reducer new] content:(id)@"No" middlewares:@[ [[ActionChangerMiddleware alloc] initWithString:@" World"], [Middleware new] ]];
    XCTAssertEqualObjects(store.content, @"No");
    
    [store dispatch:[[SetContentAction alloc] initWithContent:@"Hello"]];
    XCTAssertEqualObjects(store.content, @"Hello World");
}

- (void)testMiddlewareWhichDispatches {
    MUKContentStore *const store = [[MUKContentStore alloc] initWithReducer:[Reducer new] content:(id)@"Hello" middlewares:@[ [DispatcherMiddleware new], [Middleware new] ]];
    XCTAssertEqualObjects(store.content, @"Hello");
    
    id<MUKContentAction> const action = [store dispatch:[[SetContentAction alloc] initWithContent:@"Hello World"]];
    XCTAssertEqualObjects(store.content, @"Goodbye");
    XCTAssertNil(action);
}

@end
