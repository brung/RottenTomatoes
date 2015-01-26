//
//  ErrorCell.h
//  RottenTomatoes
//
//  Created by Bruce Ng on 1/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrorCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

@end
