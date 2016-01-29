# MUKContentRedux

[![CI Status](http://img.shields.io/travis/muccy/MUKContentRedux.svg?style=flat)](https://travis-ci.org/muccy/MUKContentRedux)
[![Version](https://img.shields.io/cocoapods/v/MUKContentRedux.svg?style=flat)](http://cocoadocs.org/docsets/MUKContentRedux)
[![License](https://img.shields.io/cocoapods/l/MUKContentRedux.svg?style=flat)](http://cocoadocs.org/docsets/MUKContentRedux)
[![Platform](https://img.shields.io/cocoapods/p/MUKContentRedux.svg?style=flat)](http://cocoadocs.org/docsets/MUKContentRedux)

`MUKContentRedux` provides a store for immutable data which can be updated only applying actions. It is inspired by [ReSwift](https://github.com/ReSwift/ReSwift) but very very less ambitious. Please refer to their project to discover the benefits of streamlining the interaction flow in our code.

## Usage

First of all you should describe the content you expose to user via your `UIViewController` instance. To do that you have to create a new immutable object which conforms to `<MUKContent>`, actually an empty protocol.
Say we are making a counter screen:

```objective-c
@interface CounterContent : NSObject <MUKContent>
@property (nonatomic, readonly) NSInteger integerValue;
- (instancetype)initWithIntegerValue:(NSInteger)integerValue NS_DESIGNATED_INITIALIZER;
@end
```

This `CounterContent` is a state. It does not behave. The only way to change it is by defining actions by creating other immutable objects which conform to `<MUKContentAction>`, another empty protocol.
    
```objective-c
@interface CounterIncrementAction : NSObject <MUKContentAction>
@end

@interface CounterDecrementAction : NSObject <MUKContentAction>
@end
```

Those actions do not behave. The only carry the request to change state. This request can only be dispatched to a store. `MUKContentStore` is the only concrete class this library contains. You should not override it but you should create a store providing a reducer. The reducer is an object which conforms to `<MUKContentReducer>`, a protocol with only a required method: `-contentFromContent:handlingAction:`. Reducers have the only key job to apply an action to existing content in order to return a new state.
    
```objective-c
@implementation CounterReducer

- (nullable CounterContent *)contentFromContent:(nullable CounterContent *)oldContent handlingAction:(id<MUKContentAction>)action
{
    if ([action isKindOfClass:[CounterIncrementAction class]]) {
        return [[CounterContent alloc] initWithIntegerValue:oldContent.integerValue + 1];
    }
    else if ([action isKindOfClass:[CounterDecrementAction class]]) {
        return [[CounterContent alloc] initWithIntegerValue:oldContent.integerValue - 1];
    }
    else {
        return oldContent;
    }
}
```

Now you have everything you need to create your store inside your view controller:

```objective-c
MUKContentStore<CounterContent *> *const store = [[MUKContentStore alloc] initWithReducer:[CounterReducer new]];
self.store = store;
```

You send actions to store via `-dispatch:` method:

```objective-c
- (IBAction)incrementButtonPressed:(id)sender {
    [self.store dispatch:[CounterIncrementAction new]];
}
```

You receive content updates by registering a block with `-subscribe:` method:

```objective-c
__weak __typeof__(self) weakSelf = self;
[self.store subscribe:^(CounterContent * _Nullable oldContent, CounterContent * _Nullable newContent) {
    __strong __typeof__(weakSelf) strongSelf = weakSelf;
    [strongSelf updateUI];
}];
```

I encourage you to note that data flow is unidirectional and always predictable with this system: view controller dispatches an action to store; store asks reducer to apply action to existing content; reducer sends new content to store; store sends content update to subscribers. Each component is well isolated and side effects are minimal.

Everything shines in this golden synchronous world. What about the real async world? This is a typical use case of action creators. An action creator is an object which conforms to `<MUKActionCreator>`, a protocol with only one required method: `-actionForContent:store:`. An action creator only creates a new action and it is used with `-dispatch:`. The store does not pass the action creator to reducer directly, but it extracts the returned action.
    
Action creators could be handy to dispatch async actions to store:

```objective-c
@implementation FetchInfosActionCreator

- (nullable __kindof id<MUKContentAction>)actionForContent:(nullable Content *)content store:(MUKContentStore *)store
{
    [APIClient() fetch:^(NSData *data, NSError *error) {
        if (data) {
            [store dispatch:[[FetchSuccessAction alloc] initWithData:data]];
        }
        else {
            [store dispatch:[[FetchFailAction alloc] initWithError:error]];
        }
    }];
    
    return [FetchStartAction new]; // e.g.: this will show spinner
}

@end
```

You view controller will use action creators transparently:

```objective-c
[self.store dispatch:[FetchInfosActionCreator new]];
```

## Requirements

* iOS 7 SDK.
* Minimum deployment target: iOS 7.

## Installation

`MUKContentRedux` is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "MUKContentRedux"
	
## Author

Marco Muccinelli, muccymac@gmail.com

## License

`MUKContentRedux` is available under the MIT license. See the LICENSE file for more info.
