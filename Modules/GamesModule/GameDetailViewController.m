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
#import "Foundation+KGOAdditions.h"
#import "UIKit+KGOAdditions.h"
#import <QuartzCore/QuartzCore.h>
@interface GameDetailViewController ()

@end

@implementation GameDetailViewController
@synthesize currentGame;
@synthesize currentRole;
@synthesize feakAllRoles;

- (void)dealloc {
    self.currentGame = nil;
    self.currentRole = nil;
    self.feakAllRoles = nil;

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
    iconView.backgroundColor = [UIColor clearColor];
    iconView.delegate = self;
    iconView.padding = GridPaddingMake(17, 17, 17, 17);
    iconView.spacing = GridSpacingMake(16, 16);
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    navTitleBar.image = [UIImage imageWithName:@"titlebar" tableName:@"btable1 2"];
    navTitleBar.backgroundColor = [UIColor clearColor];
    
    menuContainer.image = [UIImage imageWithName:@"frame" tableName:@"table1 2"];
    menuContainer.backgroundColor = [UIColor clearColor];
    [begainButton setImage:[UIImage imageWithName:@"kaishi" tableName:@"table 2"] forState:UIControlStateNormal];
    [begainButton setImage:[UIImage imageWithName:@"kaishi_on" tableName:@"table 2"] forState:UIControlStateHighlighted];
    [dianjiangButton setImage:[UIImage imageWithName:@"dianjiang" tableName:@"table 2"] forState:UIControlStateNormal];
    [dianjiangButton setImage:[UIImage imageWithName:@"dianjiang_on" tableName:@"table 2"] forState:UIControlStateHighlighted];
    [backButton setImage:[UIImage imageWithName:@"back_on" tableName:@"btable 2"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageWithName:@"back" tableName:@"btable 2"] forState:UIControlStateHighlighted];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(observeGameRequest) withObject:nil afterDelay:0.5];
}

#pragma mark - Instance Method

- (void)observeGameRequest {
    BOOL status = NO;
    NSString *error = nil;
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

- (void)layoutRoles:(NSArray *)roles
{
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < roles.count; i++) {
        GameRoleInstance *aRole = [roles objectAtIndex:i];
        CGRect frame = CGRectMake(0, 0, 90, 80);
        UIImageView *imageView = [[[UIImageView alloc] initWithFrame:frame] autorelease];
        UIImage *backgroundImage = nil;
        if (aRole.killedBy.length > 0 && ![aRole.killedBy isEqualToString:@"0"]) {
            backgroundImage = [UIImage imageWithName:[[APILibrary sharedInstance] roleDeadKeyWithRoleID:aRole.roleID] tableName:@"gameIcon 2"];
        } else {
            backgroundImage = [UIImage imageWithName:@"portriat" tableName:@"hall 2"];
        }
        imageView.image = backgroundImage;
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.alpha = 0.5;
        
        UIImageView *portriatView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 70, 60)];
        portriatView.image = [UIImage imageWithName:@"female_face" tableName:@"utl 2"];
        portriatView.layer.cornerRadius = 2;
        portriatView.layer.masksToBounds = YES;
        portriatView.backgroundColor = [UIColor blackColor];
        portriatView.alpha = 0.5;
        [imageView addSubview:portriatView];
        
        UILabel *seatlabel = [[[UILabel alloc] initWithFrame:CGRectMake(2, 60, 69, 18)] autorelease];
        seatlabel.text = aRole.userName;
        seatlabel.textColor = [UIColor yellowColor];
        seatlabel.font = [UIFont boldSystemFontOfSize:12];
        [seatlabel sizeToFit];
        seatlabel.backgroundColor = [UIColor clearColor];
        [imageView addSubview:seatlabel];
        
        UILabel *namelabel = [[[UILabel alloc] initWithFrame:CGRectMake(73, 7, 13, 60)] autorelease];
        namelabel.text = [NSString stringWithFormat:@"%@号位",aRole.seatNum];
        namelabel.textColor = [UIColor yellowColor];
        namelabel.font = [UIFont boldSystemFontOfSize:12];
        namelabel.numberOfLines = 4;
        namelabel.backgroundColor = [UIColor clearColor];
        [imageView addSubview:namelabel];
        
        UIControl *control = [[[UIControl alloc] initWithFrame:frame] autorelease];
        control.tag = i;
        [control addSubview:imageView];
        [control addTarget:self action:@selector(thumbnailTapped:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:control];
    }
    [iconView addIcons:views];
    [self performSelector:@selector(handleAnimation) withObject:nil afterDelay:0.1];
}

#pragma mark - IconGridDelegate
- (void)iconGridFrameDidChange:(IconGrid *)iconGrid
{
    CGFloat expectedHeight = CGRectGetMaxY(iconGrid.frame) ;
    if ([tableContentView contentSize].height != expectedHeight) {
        [tableContentView setContentSize:CGSizeMake(CGRectGetWidth(tableContentView.bounds), expectedHeight)];
    }
}

- (void)handleAnimation {
    [iconView animationWithRect:CGRectMake(105, 85, 90, 80)];
}

//- (void)viewWillAppear:(BOOL)animated {
//    BOOL status = NO;
//    NSString *error = nil;
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    [APILibrary apiLibrary:&status 
//                  metError:&error 
//     observeGameWithGameID:self.currentGame.gameID 
//              withDelegate:self];
//    if (!self.currentRole) {
//        BOOL status = NO;
//        NSString *error = nil;
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [APILibrary apiLibrary:&status metError:&error getMyRoleWithGameID:self.currentGame.gameID withDelegate:self];
//    }
//}

- (void)updateFeakRolesWithPlayerCount:(NSInteger)count {
    if (!self.feakAllRoles) self.feakAllRoles = [NSMutableArray array];
    if (count > 0 ) {
        for (int i = 0; i < count; i++) {
            GameRoleInstance *aRole = [[GameRoleInstance alloc] init];
            aRole.userName = @"未入座";
            [self.feakAllRoles addObject:aRole];
        }
    }
}

- (void)apiLibraryDidReceivedObserveResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    GameInstance *game = [[[GameInstance alloc] init] autorelease];
    game.gameID = [result forcedStringForKey:@"id"];
    game.playerCount = [result forcedNumberForKey:@"playerCount"];
    [self updateFeakRolesWithPlayerCount:game.playerCount.integerValue];
    NSDictionary *aResult = (NSDictionary *)result;
    NSArray *players = [aResult arrayForKey:@"players"];
    NSMutableArray *playerContainer = [NSMutableArray array];
    for (NSDictionary *role in players) {
        GameRoleInstance *aRole = [[GameRoleInstance alloc] init];
        [aRole updateWithDictionary:role];
        [playerContainer addObject:aRole];
        [self.feakAllRoles replaceObjectAtIndex:(aRole.seatNum.integerValue - 1) withObject:aRole];
        [aRole release];
    }
    game.allRoles = playerContainer;
    self.currentGame = game;
    [self layoutRoles:self.feakAllRoles];
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
