# MUKContentFetch

[![CI Status](http://img.shields.io/travis/muccy/MUKContentFetch.svg?style=flat)](https://travis-ci.org/muccy/MUKContentFetch)
[![Version](https://img.shields.io/cocoapods/v/MUKContentFetch.svg?style=flat)](http://cocoadocs.org/docsets/MUKContentFetch)
[![License](https://img.shields.io/cocoapods/l/MUKContentFetch.svg?style=flat)](http://cocoadocs.org/docsets/MUKContentFetch)
[![Platform](https://img.shields.io/cocoapods/p/MUKContentFetch.svg?style=flat)](http://cocoadocs.org/docsets/MUKContentFetch)

A simple infrastracture to retrieve requested data and transform it to content object.

## Usage

Say you want to get and parse a JSON resource to show its entries inside a table view. You should isolate that fetch in a dedicated class not to pollute you view controller.

```objective-c
@interface DucksFetch : MUKContentFetch
@end

@implementation DucksFetch

- (void)retrieveResourceWithCompletionHandler:(void (^)(MUKContentFetchStepResultType resultType, id retrievedObject, NSError *error))completionHandler
{
	dispatch_async(myQueue, ^{
		NSData *JSONData = ...;
		completionHandler(MUKContentFetchStepResultTypeSuccess, JSONData, nil);
	});
}

- (void)transformRetrievedObject:(id)retrievedObject withCompletionHandler:(void (^)(MUKContentFetchStepResultType resultType, id transformedObject, NSError *error))completionHandler
{
	dispatch_async(myQueue, ^{
		NSArray *ducks = ParseDucks(retrievedObject);
		completionHandler(MUKContentFetchStepResultTypeSuccess, ducks, nil);
	});
}

@end
```
	
To get data is now simple and clean.

```objective-c
DucksFetch *fetch = [[DucksFetch alloc] init];
[fetch startWithCompletionHandler:^(MUKContentFetchResponse *response) {
	self.ducks = response.object;
	[self updateUI];
}];
```
	
Obviously this is a small and incomplete example which does not mind about cancellation and error handling, two things you have (almost) for free using `MUKContentFetch`.

## Requirements

* iOS 7 SDK.
* Minimum deployment target: iOS 7.

## Installation

`MUKContentFetch` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MUKContentFetch"

## Author

Marco Muccinelli, muccymac@gmail.com

## License

`MUKContentFetch` is available under the MIT license. See the LICENSE file for more info.
