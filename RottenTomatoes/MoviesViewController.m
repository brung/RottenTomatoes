//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Bruce Ng on 1/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTableViewCell.h"
#import "MovieDetailsViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *movies;

-(void) getRottenTomatoesMovies;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Movies";
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 120;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTableViewCell"];
    
    [SVProgressHUD show];
    [self getRottenTomatoesMovies];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getRottenTomatoesMovies {
    NSLog(@"calling getRottenTomatoesMovies");
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=aqq8dpbxw2skrmqwpp9ty4rc";

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            
        } else {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = responseDictionary[@"movies"];
            [self.tableView reloadData];
        }

        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
    }];
}

- (void)onRefresh {
    [self getRottenTomatoesMovies];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *movie = self.movies[indexPath.row];
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    [cell.posterView setImageWithURL:[NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]]];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailsViewController *vc = [[MovieDetailsViewController alloc] init];
    vc.movie = self.movies[indexPath.row];
    
    [self.navigationController pushViewController:vc animated:YES];
    
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
