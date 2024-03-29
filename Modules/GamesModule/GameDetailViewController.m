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
#import "ObserveViewController.h"
#import "UnKilledViewController.h"
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
}

- (void)viewWillAppear:(BOOL)animated {
    BOOL status = NO;
    NSString *error = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APILibrary apiLibrary:&status 
                  metError:&error 
     observeGameWithGameID:self.currentGame.gameID 
              withDelegate:self];
    if (!self.currentRole) {
        BOOL status = NO;
        NSString *error = nil;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [APILibrary apiLibrary:&status metError:&error getMyRoleWithGameID:self.currentGame.gameID withDelegate:self];
    }
}

- (void)apiLibraryDidReceivedObserveResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    GameInstance *game = [[[GameInstance alloc] init] autorelease];
    game.gameID = [result forcedStringForKey:@"id"];
    NSDictionary *aResult = (NSDictionary *)result;
    NSArray *players = [aResult arrayForKey:@"players"];
    NSMutableArray *playerContainer = [NSMutableArray array];
    for (NSDictionary *role in players) {
        GameRoleInstance *aRole = [[GameRoleInstance alloc] init];
        [aRole updateWithDictionary:role];
        [playerContainer addObject:aRole];
        [aRole release];
    }
    game.allRoles = playerContainer;
    self.currentGame = game;
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
    GameRoleInstance *aRole = [[[GameRoleInstance alloc] init] autorelease];
    [aRole updateWithDictionary:role];
    self.currentRole = aRole;
    self.currentGame.name = [role forcedStringForKey:@"game_name"];
    self.currentGame.gameTypeID = [role forcedStringForKey:@"game_type_id"];
    [self.listView reloadData];
}

- (void)apiLibraryDidReceivedError:(NSString *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [APILibrary alertWithException:error];
}

- (NSString  *)roleInstanceUserNameAtUserID:(NSString *)roleID {
    if ([roleID isEqualToString:@"0"]) {
        return @"God";
    } else {
        if (self.currentGame.allRoles) {
            for (GameRoleInstance *aRole in self.currentGame.allRoles) {
                if ([aRole.userID isEqualToString:roleID]) {
                    return aRole.userName;
                }
            }
        }
    }
    return nil;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"gamescell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"玩家:%@",self.currentRole.userName];
    } else if (indexPath.row == 1) {
        cell.textLabel.text = [NSString stringWithFormat:@"游戏:%@",self.currentRole.gameName];
    } else if (indexPath.row == 2) {
        cell.textLabel.text = [NSString stringWithFormat:@"身份:%@",self.currentRole.roleName];
        cell.textLabel.textColor = [UIColor whiteColor];
    } else if (indexPath.row == 3) {
        cell.textLabel.text = [NSString stringWithFormat:@"座位:%@",self.currentRole.seatNum];
    } else if (indexPath.row == 4){
        if (self.currentRole.killedBy.length > 0 && ![self.currentRole.killedBy isEqualToString:@"0"]) {
            cell.textLabel.text = [NSString stringWithFormat:@"Killed By:%@",[self roleInstanceUserNameAtUserID:self.currentRole.killedBy]];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        } else {
            cell.textLabel.text = @"恭喜您还活在场上!";
        }
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"详细信息->"];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
                  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 5) {
        ObserveViewController *observeVC = [[[ObserveViewController alloc] initWithNibName:@"ObserveViewController" bundle:nil] autorelease];
        observeVC.currentGame = self.currentGame;
        [self.navigationController pushViewController:observeVC animated:YES];
    } else if (indexPath.row == 4) {
        if (self.currentRole.killedBy.length > 0) {
            UnKilledViewController *unkilledVC = [[[UnKilledViewController alloc] initWithNibName:@"UnKilledViewController" bundle:nil] autorelease];
            unkilledVC.currentGame = self.currentGame;
            unkilledVC.currentRole = self.currentRole;
            [self.navigationController pushViewController:unkilledVC animated:YES];
        }
    }
}


@end
