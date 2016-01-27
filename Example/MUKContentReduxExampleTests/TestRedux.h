//
//  TestRedux.h
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentRedux.h>

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
