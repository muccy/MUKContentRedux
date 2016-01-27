//
//  RemoteListDataSource.m
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import "RemoteListDataSource.h"
#import "RemoteListLoadMoreTableViewCell.h"

@implementation RemoteListDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    __kindof UITableViewCell *cell;
    
    id const item = [self itemAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[NSDictionary class]]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
        
        NSDictionary *const dict = item;
        cell.textLabel.text = dict[@"name"];
        cell.detailTextLabel.text = dict[@"email"];
    }
    else if ([item isKindOfClass:[NSNumber class]]) {
        RemoteListLoadMoreTableViewCell *const loadMoreCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RemoteListLoadMoreTableViewCell class]) forIndexPath:indexPath];;
        
        NSNumber *const n = item;
        loadMoreCell.titleLabel.text = n.boolValue ? @"Loading..." : @"Load More";
        n.boolValue ? [loadMoreCell.activityIndicator startAnimating] : [loadMoreCell.activityIndicator stopAnimating];
        
        cell = loadMoreCell;
    }
    else {
        cell = nil;
    }
    
    return cell;
}

@end
