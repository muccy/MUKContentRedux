#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentMiddleware.h>

/// A middleware which logs dispatches
@interface MUKContentLoggerMiddleware : NSObject <MUKContentMiddleware>
@end
