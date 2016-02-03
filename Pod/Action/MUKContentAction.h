#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentMiddleware.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Actions are payloads of information that send data from your application to your
 store. They are the only source of information for the store. Actions describe
 the fact that something happened, but don’t specify how the application’s state
 changes in response.
 
 You should create classes which implement this empty protocol and dispatch their
 instances to store in order to change state.
 */
@protocol MUKContentAction <MUKContentDispatchable>
@end


/// A concrete base action
@interface MUKContentTypedAction : NSObject <MUKContentAction>
/// Action type (you should bind it with an NS_ENUM)
@property (nonatomic, readonly) NSInteger type;
/// Info about action
@property (nonatomic, readonly, nullable) id payload;

/// Designated initializer
- (instancetype)initWithType:(NSInteger)type payload:(nullable id)payload NS_DESIGNATED_INITIALIZER;

/// @returns A new action with given type and payload
+ (instancetype)actionWithType:(NSInteger)type payload:(id)payload;

/// @returns A new action with given type and no payload
+ (instancetype)actionWithType:(NSInteger)type;

/// @returns Payload interpreted as NSDictionary, if possible
@property (nonatomic, readonly, copy, nullable) NSDictionary *payloadDictionary;

/// @returns Payload or nil if class doesn't match
- (nullable id)payloadIfIsKindOfClass:(nonnull Class)theClass;
@end

NS_ASSUME_NONNULL_END
