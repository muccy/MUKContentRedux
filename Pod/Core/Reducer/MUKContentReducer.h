//
//  MUKContentReducer.h
//  
//
//  Created by Marco on 27/01/16.
//
//

#import <Foundation/Foundation.h>

@protocol MUKContent, MUKContentAction;

NS_ASSUME_NONNULL_BEGIN

/// A reducer describe how the content state changes in response of an action
@protocol MUKContentReducer <NSObject>
@required
/**
 @param oldContent  Content to be changed
 @param action      Action to apply to change oldContent
 @returns New content
 */
- (nullable id<MUKContent>)contentFromContent:(nullable id<MUKContent>)oldContent handlingAction:(id<MUKContentAction>)action;
@end


/// A reducer which combines other reducers
@interface MUKCombinedContentReducer : NSObject <MUKContentReducer>
- (instancetype)initWithReducers:(NSArray<id<MUKContentReducer>> *)reducers NS_DESIGNATED_INITIALIZER;
@end
   
NS_ASSUME_NONNULL_END
