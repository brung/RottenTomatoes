//
//  MovieTableViewCell.h
//  RottenTomatoes
//
//  Created by Bruce Ng on 1/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;

@end
