#import "MUKContentAction.h"

@implementation MUKContentTypedAction

- (instancetype)initWithType:(NSInteger)type payload:(id)payload {
    self = [super init];
    if (self) {
        _type = type;
        _payload = payload;
    }
    
    return self;
}

- (instancetype)init {
    return [self initWithType:0 payload:nil];
}

+ (instancetype)actionWithType:(NSInteger)type payload:(nonnull id)payload {
    return [[self alloc] initWithType:type payload:payload];
}

+ (instancetype)actionWithType:(NSInteger)type {
    return [[self alloc] initWithType:type payload:nil];
}

- (nullable NSDictionary *)payloadDictionary {
    return [self payloadIfIsKindOfClass:[NSDictionary class]];
}

- (nullable id)payloadIfIsKindOfClass:(nonnull Class)theClass {
    return [self.payload isKindOfClass:theClass] ? self.payload : nil;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: type = %ld%@", NSStringFromClass([self class]), (long)self.type, self.payload ? [NSString stringWithFormat:@", payload = %@", self.payload] : @""];
}

@end