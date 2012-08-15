//
//  GameDetailViewController.m
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "GameDetailViewController.h"
#import "MBProgressHUD.h"
#import "Foundation+KGOAdditions.h"
#import "GameRoleInstance.h"
@interface GameDetailViewController ()

@end

@implementation GameDetailViewController
@synthesize currentGame;
@synthesize currentRole;
@synthesize listView;

- (void)dealloc {
    self.currentGame = nil;
    self.currentRole = nil;
    self.listView = nil;

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
    self.title = [NSString stringWithFormat:@"%@ #%@",NSLocalizedString(@"_Game_", @"game"),self.currentGame.gameID];
    BOOL status = NO;
    NSString *error = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APILibrary apiLibrary:&status metError:&error getMyRoleWithGameID:self.currentGame.gameID withDelegate:self];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - 

- (void)apiLibraryDidReceivedGameDetail:(id)detail {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *role = (NSDictionary *)detail;
    GameRoleInstance *aRole = [[GameRoleInstance alloc] init];
    aRole.credits = [role forcedNumberForKey:@"credits"];
    aRole.gameID = [role forcedStringForKey:@"game_id"];
    aRole.gameName = [role forcedStringForKey:@"game_name"];
    aRole.gameTypeID = [role forcedStringForKey:@"game_type_id"];
    aRole.killedBy = [role forcedStringForKey:@"killed_by"];
    aRole.roleName = [role forcedStringForKey:@"name"];
    aRole.roleID = [role forcedStringForKey:@"role_id"];
    aRole.seatNum = [role forcedNumberForKey:@"seat"];
    aRole.status = [NSNumber numberWithBool:[role boolForKey:@"status"]];
    aRole.userID = [role forcedStringForKey:@"user_id"];
    aRole.userName = [role forcedStringForKey:@"username"];
    self.currentRole = aRole;
    [self.listView reloadData];
}

- (void)apiLibraryDidReceivedError:(NSString *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [APILibrary alertWithException:error];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"gamescell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"游戏:%@",self.currentRole.gameName];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"身份:%@",self.currentRole.roleName];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"座位:%@",self.currentRole.seatNum];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"详细信息"];
    }
                  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    GameInstance *aGame = [self.games objectAtIndex:indexPath.row];
//    GameDetailViewController *gameDetailVC = [[GameDetailViewController alloc] initWithNibName:@"GameDetailViewController" bundle:nil];
//    gameDetailVC.currentGame = aGame;
//    [self.navigationController pushViewController:gameDetailVC animated:YES];
}


@end
