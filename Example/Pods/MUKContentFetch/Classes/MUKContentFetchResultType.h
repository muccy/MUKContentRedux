#import <Foundation/Foundation.h>

/**
 Result type
 */
typedef NS_ENUM(NSInteger, MUKContentFetchResultType) {
    /**
     Failed
     */
    MUKContentFetchResultTypeFailed       = 0,
    /**
     Success
     */
    MUKContentFetchResultTypeSuccess      = 1,
    /**
     Cancelled
     */
    MUKContentFetchResultTypeCancelled    = 2
};
