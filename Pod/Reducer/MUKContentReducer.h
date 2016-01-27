//
//  MUKContentReducer.h
//  
//
//  Created by Marco on 27/01/16.
//
//

#import <Foundation/Foundation.h>

@protocol MUKContent, MUKContentAction;
@class MUKContentStore;

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
   
NS_ASSUME_NONNULL_END
