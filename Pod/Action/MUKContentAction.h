#import <Foundation/Foundation.h>
#import <MUKContentRedux/MUKContentStore.h>

NS_ASSUME_NONNULL_BEGIN

/// Something which can be dispatched to a store
@protocol MUKContentDispatchable <NSObject>
@end

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


/**
 Action creator is an entity which takes store and content state and returns the
 action.
 You can use action creators to dispatch to store async actions.
 */
@protocol MUKContentActionCreator <MUKContentDispatchable>
@required
- (nullable id<MUKContentAction>)actionForContent:(nullable id<MUKContent>)content store:(MUKContentStore *)store;
@end


/// A concrete action creator which generates actions with a block
@interface MUKBlockContentActionCreator<__covariant ContentType:id<MUKContent>> : NSObject <MUKContentActionCreator>
/// Type of block used on -actionForContent:store: invocations
typedef id<MUKContentAction> _Nullable (^MUKBlockContentActionCreatorBlock)(ContentType _Nullable content, MUKContentStore<ContentType> *store);
/// Designated initializer
- (instancetype)initWithBlock:(MUKBlockContentActionCreatorBlock)block NS_DESIGNATED_INITIALIZER;
/// @returns A new action creator
+ (instancetype)actionCreatorWithBlock:(MUKBlockContentActionCreatorBlock)block;
@end

NS_ASSUME_NONNULL_END

#pragma mark - Macros

/**
 A macro to generate header of a standard concrete action header
 @see MUK_DECLARE_ACTION
 */
#define MUK_DECLARE_ACTION_H(theName, theEnumType) \
@interface theName ## Action : NSObject <MUKContentAction> \
@property (nonatomic, readonly) theEnumType type; \
@property (nonatomic, readonly, nullable) id payload; \
- (instancetype)initWithType:(theEnumType)type payload:(nullable id)payload NS_DESIGNATED_INITIALIZER; \
+ (instancetype)actionWithType:(theEnumType)type payload:(nonnull id)payload; \
+ (instancetype)actionWithType:(theEnumType)type; \
\
@property (nonatomic, readonly, copy, nullable) NSDictionary *payloadDictionary; \
- (nullable id)payloadIfIsKindOfClass:(nonnull Class)theClass; \
@end\

/**
 A macro to generate header of a standard concrete action implementation
 @see MUK_DECLARE_ACTION
 */
#define MUK_DECLARE_ACTION_M(theName, theEnumType) \
@implementation theName ## Action \
- (instancetype)initWithType:(theEnumType)type payload:(nullable id)payload { \
    self = [super init]; \
    if (self) { \
        _type = type; \
        _payload = [payload respondsToSelector:@selector(copy)] ? [payload copy] : payload; \
    } \
    return self; \
} \
- (instancetype)init { \
    return [self initWithType:0 payload:nil]; \
} \
+ (instancetype)actionWithType:(theEnumType)type payload:(nonnull id)payload { \
    return [[self alloc] initWithType:type payload:payload]; \
} \
+ (instancetype)actionWithType:(theEnumType)type { \
    return [[self alloc] initWithType:type payload:nil]; \
} \
- (nullable NSDictionary *)payloadDictionary { \
    return [self payloadIfIsKindOfClass:[NSDictionary class]]; \
} \
- (nullable id)payloadIfIsKindOfClass:(nonnull Class)theClass { \
    return [self.payload isKindOfClass:theClass] ? self.payload : nil; \
} \
@end

/**
 A macro to generate a standard concrete action.
 @param theName     Action name
 @param theEnumType Typed enumeration used for type ivar
 
 Generated class will have "theName + Action" name (e.g.: if theName is 'Counter'
 generated class name will be 'CounterAction') and two ivars: `type` and `payload`.
 `type` is typed as you specify with theEnumType parameter (e.g.: if you define a
 `NS_ENUM(NSInteger, ActionType)` you can feed that one in order to get 
 `@property (nonatomic, readonly) ActionType type;`.
 `payload` is a nullable generic object which is copied on initialization if possible
 (e.g.: if you initialize the action with an `NSDictionary` that dictionary is 
 copied because it responds to -copy selector). Payload can be accessed directly
 or by testing class with -payloadIfIsKindOfClass: generated method. The property
 payloadDictionary is a shortend to test `NSDictionary` class and to cast returned
 payload.
 */
#define MUK_DECLARE_ACTION(theName, theEnumType) \
MUK_DECLARE_ACTION_H(theName, theEnumType) \
MUK_DECLARE_ACTION_M(theName, theEnumType)
