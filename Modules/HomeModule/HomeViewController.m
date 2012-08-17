//
//  HomeViewController.m
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "NewGameViewController.h"
#import "RangkingsViewController.h"
#import "GamesViewController.h"
#import "APILibrary.h"
#import <QuartzCore/QuartzCore.h>
@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    navTitleImageView.image = [UIImage imageNamed:@"home_title_bar_reverse.png"];
    infoContainer.image = [UIImage imageNamed:@"home_right_infobar.png"];
    
    [leftButton setImage:[[UIImage imageNamed:@"home_prexious_page_disable.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [leftButton setImage:[[UIImage imageNamed:@"home_prexious_page.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    [rightButton setImage:[[UIImage imageNamed:@"home_next_page_disable.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateNormal];
    [rightButton setImage:[[UIImage imageNamed:@"home_next_page.png"] stretchableImageWithLeftCapWidth:5 topCapHeight:5] forState:UIControlStateHighlighted];
    
    bottomContainer.layer.cornerRadius = 5;
    bottomContainer.layer.masksToBounds = YES;
    bottomContainer.backgroundColor = [UIColor blackColor];
    bottomContainer.alpha = 0.5;
    
    portriatView.image = [UIImage imageNamed:@"defaultface.png"];
    
    listView.backgroundColor = [UIColor clearColor];
    
    //    UIImage *masthead = [[UIImage imageNamed:@"home_title_bar.png"] resizableImageWithCapInsets:(UIEdgeInsets)];
    //    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:masthead] autorelease];
    //    self.title = [NSString stringWithFormat:@"欢迎您:%@ %@",[APILibrary sharedInstance].userData.firstName,[APILibrary sharedInstance].userData.lastName];
    //    GamesViewController *gamesVC = [[[GamesViewController alloc] initWithNibName:@"GamesViewController" bundle:nil] autorelease];
    //    gamesVC.title = @"Games";
    //    NewGameViewController *newgameVC = [[[NewGameViewController alloc] initWithNibName:@"NewGameViewController" bundle:nil] autorelease];
    //    newgameVC.title = @"New Game";
    //    RangkingsViewController *rangkingsVC = [[[RangkingsViewController alloc] initWithNibName:@"RangkingsViewController" bundle:nil] autorelease];
    //    rangkingsVC.title = @"Rankings";
    //    self.viewControllers = [NSArray arrayWithObjects:gamesVC,newgameVC,rangkingsVC, nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    CGAffineTransform t = self.view.transform;
    if (UIInterfaceOrientationIsPortrait(toInterfaceOrientation) && t.b && t.c) {
        [self.view setTransform:CGAffineTransformMakeRotation(0)];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"gamescell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.textLabel.text = @"123";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
