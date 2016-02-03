//
//  RemoteListViewController.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "RemoteListViewController.h"
#import "RemoteListRedux.h"
#import "RemoteListDataSource.h"
#import <MUKPullToRevealControl/MUKCirclePullToRefreshControl.h>

@interface RemoteListViewController ()
@property (nonatomic, readonly) MUKContentStore<RemoteListContent *> *store;
@property (nonatomic, readwrite) id storeSubscription;
@property (nonatomic, readwrite, weak) MUKCirclePullToRefreshControl *pullToRefreshControl;
@end

@implementation RemoteListViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _store = [MUKContentStore storeWithReducer:[RemoteListReducer new]];
        self.dataSource = [[RemoteListDataSource alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self insertRefreshControl];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.storeSubscription) {
        __weak __typeof__(self) weakSelf = self;
        self.storeSubscription = [self.store subscribe:^(RemoteListContent * _Nullable oldContent, RemoteListContent * _Nullable newContent)
        {
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            [strongSelf updateUIFromOldContent:oldContent];
        }];
        
        // First update
        [self updateUIFromOldContent:nil];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.store.content.items.count == 0) {
        [self.store dispatch:[RemoteListActionFactory requestItemsActionCreatorToLoadMore:NO]];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.storeSubscription) {
        [self.store unsubscribe:self.storeSubscription];
    }
}

#pragma mark - Private — Refresh Control

- (void)insertRefreshControl {
    MUKCirclePullToRefreshControl *const refreshControl = [[MUKCirclePullToRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:refreshControl];
    self.pullToRefreshControl = refreshControl;
}

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self.store dispatch:[RemoteListActionFactory requestItemsActionCreatorToLoadMore:NO]];
}

#pragma mark - Private — UI

- (void)updateUIFromOldContent:(nullable RemoteListContent *)oldContent {
    if (self.store.content.items > 0) {
        NSArray *const items = ({
            self.store.content.status == RemoteListContentStatusLoadingMore ? [self.store.content.items arrayByAddingObject:@YES] : [self.store.content.items arrayByAddingObject:@NO];
        });

        MUKDataSourceContentSection *const section = [[MUKDataSourceContentSection alloc] initWithIdentifier:@"unique" items:items];
        MUKDataSourceTableUpdate *const update = [self.dataSource setTableSections:@[section]];
        [update applyToTableView:self.tableView withAnimation:[MUKDataSourceTableUpdateAnimation defaultAnimation]];
        
        if (self.store.content.error && self.store.content.status == RemoteListContentStatusIdle && !self.presentedViewController)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:self.store.content.error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"Retry" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                [self.store dispatch:[RemoteListActionFactory requestItemsActionCreatorToLoadMore:oldContent.status == RemoteListContentStatusLoadingMore]];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else {
        // Empty
        
        self.dataSource.content = ({
            self.store.content.error ? [[MUKDataSourceContentPlaceholder alloc] initWithTitle:@"Error" subtitle:self.store.content.error.localizedDescription image:nil] : [[MUKDataSourceContentPlaceholder alloc] initWithTitle:@"No Items" subtitle:nil image:nil];
        });
        
        [self.tableView reloadData];
    }
    
    if (self.store.content.status == RemoteListContentStatusRefreshing) {
        [self.pullToRefreshControl revealAnimated:YES];
    }
    else {
        [self.pullToRefreshControl coverAnimated:YES];
    }
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id const item = [self.dataSource itemAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[NSNumber class]] && ![item boolValue]) {
        [self.store dispatch:[RemoteListActionFactory requestItemsActionCreatorToLoadMore:YES]];
    }
}

@end
