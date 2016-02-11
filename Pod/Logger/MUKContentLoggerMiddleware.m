#import "MUKContentLoggerMiddleware.h"

@implementation MUKContentLoggerMiddleware

- (MUKContentMiddlewareBlock)blockForDispatcher:(nullable MUKContentDispatcher)dispatcher getter:(MUKContentGetter)getter
{
    return ^(MUKContentDispatcher next) {
        return ^(id<MUKContentDispatchable> dispatchableObject) {
            NSLog(@"[!] Dispatching %@...", dispatchableObject);
            
            id<MUKContentAction> const action = next(dispatchableObject);
            id<MUKContent> const newContent = getter();
            
            if (action) {
                NSLog(@"[!] Dispatched %@ ==> %@", action, newContent);
            }
            else {
                NSLog(@"[!] No action produced");
            }
            
            return action;
        };
    };
}

@end
