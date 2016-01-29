//
//  CounterViewController.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "CounterViewController.h"
#import "CounterRedux.h"

@interface CounterViewController ()
@property (nonatomic, readonly) MUKContentStore<CounterContent *> *store;
@property (nonatomic, readwrite) id storeSubscription;

@property (nonatomic, weak) IBOutlet UILabel *counterLabel;
@end

@implementation CounterViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _store = [[MUKContentStore alloc] initWithReducer:[CounterReducer new]];
        [self.store dispatch:[CounterActionFactory initAction]];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.storeSubscription) {
        __weak __typeof__(self) weakSelf = self;
        self.storeSubscription = [self.store subscribe:^(CounterContent * _Nullable oldContent, CounterContent * _Nullable newContent)
        {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf updateUI];
        }];
        
        // First update
        [self updateUI];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.storeSubscription) {
        [self.store unsubscribe:self.storeSubscription];
    }
}

#pragma mark - Actions

- (IBAction)incrementButtonTapped:(UIButton *)sender {
    [self.store dispatch:[CounterActionFactory incrementAction]];
}

- (IBAction)decrementButtonTapped:(UIButton *)sender {
    [self.store dispatch:[CounterActionFactory decrementAction]];
}

#pragma mark - Private

- (void)updateUI {
    self.counterLabel.text = [NSString stringWithFormat:@"%li", self.store.content.integerValue];
}

@end
