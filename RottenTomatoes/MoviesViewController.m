//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Bruce Ng on 1/24/15.
//  Copyright (c) 2015 com.yahoo. All rights reserved.
//

#import "MoviesViewController.h"
#import "ErrorCell.h"
#import "MovieTableViewCell.h"
#import "MovieDetailsViewController.h"
#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"

#define BOX_OFFICE_TAB 0
#define DVD_TAB 1

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (nonatomic, strong) NSArray *movies;
@property (nonatomic) NSInteger currentTabBarItemTag;



-(void) getRottenTomatoesMovies;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Movies";
    
    self.tabBar.delegate = self;
    UITabBarItem *boxOfficeTab = [[UITabBarItem alloc] initWithTitle:@"Box Office" image:[UIImage imageNamed:@"boxoffice"] tag:BOX_OFFICE_TAB];
    UITabBarItem *dvdTab = [[UITabBarItem alloc] initWithTitle:@"DVD" image:[UIImage imageNamed:@"dvd"] tag:DVD_TAB];
    [self.tabBar setItems:@[boxOfficeTab, dvdTab]];
    [self.tabBar setSelectedItem:boxOfficeTab];
    self.currentTabBarItemTag = BOX_OFFICE_TAB;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 120;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ErrorCell" bundle:nil] forCellReuseIdentifier:@"ErrorCell"];
    
    [SVProgressHUD show];
    [self getRottenTomatoesMovies];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getRottenTomatoesMovies {
    
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=aqq8dpbxw2skrmqwpp9ty4rc";
    if (self.currentTabBarItemTag == DVD_TAB) {
        url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/new_releases.json?apikey=aqq8dpbxw2skrmqwpp9ty4rc";
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError != nil) {
            [self displayError];
            
        } else {
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = responseDictionary[@"movies"];
            if (self.movies.count == 0) {
                [self displayError ];
            } else {
                [self.tableView reloadData];
            }
        }

        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
    }];
}

- (void)onRefresh {
    [self getRottenTomatoesMovies];
}

- (void)displayError {
    ErrorCell *cell  = [self.tableView dequeueReusableCellWithIdentifier:@"ErrorCell"];
    cell.errorImage.image = [UIImage imageNamed:@"warning"];
    cell.errorLabel.text = @"Network Error";
    cell.transform = CGAffineTransformMakeTranslation(0, -120);
    cell.alpha = 0;
    [self.tableView addSubview:cell];
    [UIView animateWithDuration:0.4 animations:^{
        cell.transform = CGAffineTransformMakeTranslation(0, 0);
        cell.alpha = 1;
    } completion:^(BOOL finished) {
        sleep(2);
        [UIView animateWithDuration:0.4 animations:^{
            cell.transform = CGAffineTransformMakeTranslation(0, -120);
            cell.alpha = 0;
        } completion:^(BOOL finished) {
        }];
    }];
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
    cell.posterView.alpha = 0.25;
    [UIView animateWithDuration:0.9 animations:^{
        cell.posterView.alpha = 1;
    } completion:^(BOOL finished) {
    }];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieDetailsViewController *vc = [[MovieDetailsViewController alloc] init];
    vc.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    if (item.tag != self.currentTabBarItemTag) {
        self.currentTabBarItemTag = item.tag;
        [self getRottenTomatoesMovies];
        NSLog(@"clicked %s",  [tabBar.selectedItem.title cStringUsingEncoding:NSUTF8StringEncoding]);
    }
//    if (item != self.tabBar.selectedItem)
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
