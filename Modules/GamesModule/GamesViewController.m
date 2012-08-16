//
//  GamesViewController.m
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "GamesViewController.h"
#import "MBProgressHUD.h"
#import "GameInstance.h"
#import "Foundation+KGOAdditions.h"
#import "GameDetailViewController.h"
#import "GameUserData.h"
@interface GamesViewController ()

@end

@implementation GamesViewController
@synthesize gamesTableView;
@synthesize games;

- (void)dealloc {
    self.games = nil;

    [super dealloc];
}

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
    BOOL status = NO;
    NSString *error = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APILibrary apiLibrary:&status metError:&error getAvalibelGamesWithParam:nil withDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - APILibraryDelegate
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
    [self.gamesTableView reloadData];
}

- (void)apiLibraryDidReceivedError:(NSString *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [APILibrary alertWithException:error];
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
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    GameInstance *aGame = [self.games objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"#%@ %@",aGame.gameID,aGame.name];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GameInstance *aGame = [self.games objectAtIndex:indexPath.row];
    [self handleJoinGameWithGameInstance:aGame];
}

@end
