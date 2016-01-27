//
//  RemoteListItemsFetch.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "RemoteListItemsFetch.h"

@interface RemoteListItemsFetch ()
@property (nonatomic) NSURLSessionDataTask *task;
@end

@implementation RemoteListItemsFetch

- (void)cancel {
    [super cancel];
    [self.task cancel];
}

- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchResultType, id _Nullable, NSError * _Nullable))completionHandler
{
    self.task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://jsonplaceholder.typicode.com/users"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
    {
        if (error) {
            completionHandler(MUKContentFetchResultTypeFailed, nil, error);
        }
        else {
            completionHandler(MUKContentFetchResultTypeSuccess, data, nil);
        }
    }];
    
    [self.task resume];
}

- (void)transformRetrievedObject:(id)retrievedObject withCompletionHandler:(void (^)(MUKContentFetchResultType, id _Nullable, NSError * _Nullable))completionHandler
{
    if (![retrievedObject isKindOfClass:[NSData class]]) {
        completionHandler(MUKContentFetchResultTypeFailed, nil, nil);
        return;
    }
    
    NSError *error = nil;
    NSArray *items = [NSJSONSerialization JSONObjectWithData:retrievedObject options:0 error:&error];
    
    if ([items isKindOfClass:[NSArray class]]) {
        completionHandler(MUKContentFetchResultTypeSuccess, items, nil);
    }
    else {
        completionHandler(MUKContentFetchResultTypeFailed, nil, error);
    }
}

@end
