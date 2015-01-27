//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by Bruce Ng on 1/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsViewController () <UIScrollViewDelegate>


@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [NSString stringWithString:self.movie[@"title"]];

    UIImageView *posterView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    posterView.contentMode = UIViewContentModeScaleAspectFit;
    NSString *posterUrl = [self.movie valueForKeyPath:@"posters.thumbnail"];
    [self.view addSubview:posterView];
    [posterView setImageWithURL:[NSURL URLWithString:posterUrl]];
    posterUrl = [posterUrl stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    [posterView setImageWithURL:[NSURL URLWithString:posterUrl]];
    
    UIScrollView *sv =  [[UIScrollView alloc] initWithFrame:self.view.bounds];

    UIView *contentHolder = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(sv.frame)* 2/3, CGRectGetWidth(sv.frame), CGRectGetHeight(sv.frame))];
    contentHolder.backgroundColor = [UIColor blackColor];
    contentHolder.alpha = 0.75;
    
    UILabel *synopsisLabel = [[UILabel alloc] initWithFrame:CGRectMake(12,12, CGRectGetWidth(contentHolder.frame) - 24, CGRectGetHeight(contentHolder.frame) - 24)];
    synopsisLabel.textAlignment = NSTextAlignmentLeft;
    synopsisLabel.textColor = [UIColor whiteColor];
    synopsisLabel.lineBreakMode = NSLineBreakByWordWrapping;
    synopsisLabel.numberOfLines = 0;
    synopsisLabel.text = self.movie[@"synopsis"];
    [synopsisLabel sizeToFit];

    float height = MAX(CGRectGetHeight(synopsisLabel.frame)+24, CGRectGetHeight(sv.frame)*1/3);
    [contentHolder setFrame:CGRectMake(0, CGRectGetHeight(sv.frame)*2/3, CGRectGetWidth(sv.frame), height)];
    NSLog(@"ContenHolder %f, %f", CGRectGetHeight(contentHolder.frame), CGRectGetWidth(contentHolder.frame));
    NSLog(@"synopsisLabel %f, %f", CGRectGetHeight(synopsisLabel.frame), CGRectGetWidth(synopsisLabel.frame));
    NSLog(@"scrollview %f, %f", CGRectGetHeight(sv.frame), CGRectGetWidth(sv.frame));
    
    [contentHolder addSubview:synopsisLabel];
    
    [sv addSubview:contentHolder];
    sv.contentSize = CGSizeMake(CGRectGetWidth(sv.frame), CGRectGetHeight(contentHolder.frame) + CGRectGetMinY(contentHolder.frame));
    sv.userInteractionEnabled = YES;
    [self.view addSubview:sv];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
