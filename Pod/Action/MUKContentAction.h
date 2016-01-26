#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Type of action (you will typically use NS_ENUM)
typedef NSInteger MUKContentActionType;

/**
 Actions are payloads of information that send data from your application to your
 store. They are the only source of information for the store. Actions describe
 the fact that something happened, but don’t specify how the application’s state
 changes in response.
 */
@interface MUKContentAction : NSObject
/// Type of action
@property (nonatomic, readonly) MUKContentActionType type;
/// Payload
@property (nonatomic, readonly, nullable) id info;

/// @returns An instantiated action
- (instancetype)initWithType:(MUKContentActionType)type info:(nullable id)info NS_DESIGNATED_INITIALIZER;

/// @returns New action without info object
+ (instancetype)actionWithType:(MUKContentActionType)type;
@end


@interface MUKContentAction (Dictionary)
/// @returns Info interpretated as dictionary
@property (nonatomic, readonly, copy, nullable) NSDictionary *infoDictionary;
/// @returns New action with given type and info
+ (instancetype)actionWithType:(MUKContentActionType)type infoDictionary:(NSDictionary *)infoDict;
@end

NS_ASSUME_NONNULL_END
