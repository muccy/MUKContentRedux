#import "MUKContentFetchResponse.h"

@implementation MUKContentFetchResponse

- (instancetype)initWithResultType:(MUKContentFetchResultType)resultType object:(id)object error:(NSError *)error
{
    self = [super init];
    if (self) {
        _resultType = resultType;
        _object = object;
        _error = error;
    }
    
    return self;
}

- (BOOL)isEqualToContentFetchResponse:(MUKContentFetchResponse *)response {
    BOOL const sameResultType = self.resultType == response.resultType;
    BOOL const sameObject = [self.object isEqual:response.object];
    BOOL const sameError = (!self.error && !response.error) || [self.error isEqual:response.error];
    return sameResultType && sameObject && sameError;
}

#pragma mark - Overrides

- (instancetype)init {
    return [self initWithResultType:MUKContentFetchResultTypeCancelled object:nil error:nil];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return YES;
    }
    
    if ([object isKindOfClass:[self class]]) {
        return [self isEqualToContentFetchResponse:object];
    }
    
    return NO;
}

- (NSUInteger)hash {
    return 58493 ^ self.resultType ^ [self.object hash] ^ [self.error hash];
}

@end
