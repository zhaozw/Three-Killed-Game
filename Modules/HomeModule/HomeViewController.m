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
#import "MBProgressHUD.h"
#import "Foundation+KGOAdditions.h"
#import "UIKit+KGOAdditions.h"
#import <QuartzCore/QuartzCore.h>
#import "GameDetailViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize games;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)requestGames {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status
                  metError:&error
 getAvalibelGamesWithParam:nil
              withDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    
    navTitleImageView.image = [UIImage imageWithName:@"titlebar" tableName:@"hall 2"];
    infoContainer.image = [UIImage imageWithName:@"inforbkg" tableName:@"hall 2"];
    infoContainer.backgroundColor = [UIColor clearColor];
    
    leftholder.image = [UIImage imageWithCGImage:[UIImage imageWithName:@"sword" tableName:@"btable 2"].CGImage scale:1.0 orientation:UIImageOrientationRight];
    leftholder.backgroundColor = [UIColor clearColor];
    
    rightholder.image = [UIImage imageWithCGImage:[UIImage imageWithName:@"sword" tableName:@"btable 2"].CGImage scale:1.0 orientation:UIImageOrientationRight];
    rightholder.backgroundColor = [UIColor clearColor];
    
    [leftButton setImage:[UIImage imageWithName:@"previous" tableName:@"hall 2"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageWithName:@"previous_on" tableName:@"hall 2"] forState:UIControlStateHighlighted];
    [rightButton setImage:[UIImage imageWithName:@"next" tableName:@"hall 2"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageWithName:@"next_on" tableName:@"hall 2"] forState:UIControlStateHighlighted];
    
    [menuButton setImage:[UIImage imageWithName:@"menu" tableName:@"hall 2"] forState:UIControlStateNormal];
    [menuButton setImage:[UIImage imageWithName:@"menu_on" tableName:@"hall 2"] forState:UIControlStateHighlighted];
    
    [createButton setImage:[UIImage imageWithName:@"create" tableName:@"hall 2"] forState:UIControlStateNormal];
    [createButton setImage:[UIImage imageWithName:@"create_on" tableName:@"hall 2"] forState:UIControlStateHighlighted];
          
    infoTopView.image = [UIImage imageWithName:@"portriat" tableName:@"hall 2"];
    infoTopView.backgroundColor = [UIColor clearColor];
    
    portriatView.image = [UIImage imageWithName:@"female_face" tableName:@"utl 2"];
    portriatView.backgroundColor = [UIColor clearColor];
    
    bottomContainer.layer.cornerRadius = 5;
    bottomContainer.layer.masksToBounds = YES;
    bottomContainer.backgroundColor = [UIColor blackColor];
    bottomContainer.alpha = 0.5;
    
    listView.backgroundColor = [UIColor clearColor];
    
    nameLabel.text = [APILibrary sharedInstance].userData.usrName;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textAlignment = UITextAlignmentCenter;
    
    acLabel.text = @"君临天下";
    [acLabel setNumberOfLines:0];
    [acLabel sizeToFit];
    acLabel.backgroundColor = [UIColor clearColor];
    

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(requestGames) withObject:nil afterDelay:0.5];
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

- (void)apiLibraryDidReceivedJoinGameResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    GameInstance *currentGame = [[[GameInstance alloc] init] autorelease];
    currentGame.gameID = result;
    GameDetailViewController *gameDetailVC = [[GameDetailViewController alloc] initWithNibName:@"GameDetailViewController" bundle:nil];
    gameDetailVC.currentGame = currentGame;
    [self.navigationController pushViewController:gameDetailVC animated:YES];
}

- (void)handleJoinGameWithGameInstance:(GameInstance *)aGame {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error joinGameWithGameID:aGame.gameID withDelegate:self];
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"gamescell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.contentView.bounds];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"cellselectedbkg" tableName:@"hall 2"]];
    cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"cellbkg" tableName:@"hall 2"]];
    GameInstance *aGame = [self.games objectAtIndex:indexPath.row];
    cell.imageView.image = [aGame statusImage];
    cell.textLabel.text = [NSString stringWithFormat:@"#%@ %@",aGame.gameID,aGame.name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.games.count) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        GameInstance *aGame = [self.games objectAtIndex:indexPath.row];
        [self performSelector:@selector(handleJoinGameWithGameInstance:) withObject:aGame afterDelay:0.5];
    }
}

#pragma mark -APILibraryDelegate
- (void)apiLibraryDidReceivedResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSArray *results = (NSArray *)result;
    NSMutableArray *container = [NSMutableArray array];
    if (results) {
        for (NSDictionary *gameDictionary in results) {
            GameInstance *aGame = [[GameInstance alloc] init];
            aGame.gameID = [gameDictionary forcedStringForKey:@"id"];
            aGame.name = [gameDictionary forcedStringForKey:@"name"];
            [container addObject:aGame];
            [aGame release];
        }
    }
    self.games = container;
    [listView reloadData];
}

- (void)apiLibraryDidReceivedError:(NSString *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [APILibrary alertWithException:error];
}

@end
