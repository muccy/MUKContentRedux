//
//  MUKContentReduxExampleTests.m
//  MUKContentReduxExampleTests
//
//  Created by Marco on 26/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <MUKContentRedux/MUKContentRedux.h>

@interface IdentityReducer : NSObject <MUKContentReducer>
@end

@implementation IdentityReducer

- (id<MUKContent>)contentFromContent:(id<MUKContent>)oldContent handlingAction:(id<MUKContentAction>)action
{
    return oldContent;
}

@end

#pragma mark -

@interface MUKContentReduxExampleTests : XCTestCase
@end

@implementation MUKContentReduxExampleTests

- (void)testInitialization {
    IdentityReducer *const reducer = [[IdentityReducer alloc] init];
    MUKContentStore *const store = [[MUKContentStore alloc] initWithReducer:reducer];
    XCTAssertEqualObjects(reducer, store.reducer);
}

@end
