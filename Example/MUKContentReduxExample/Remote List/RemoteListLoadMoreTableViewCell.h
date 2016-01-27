//
//  RemoteListLoadMoreTableViewCell.h
//  MUKContentReduxExample
//
//  Created by Marco on 27/01/16.
//  Copyright © 2016 MeLive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoteListLoadMoreTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
