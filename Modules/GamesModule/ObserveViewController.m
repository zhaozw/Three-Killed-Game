//
//  ObserveViewController.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/15/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "ObserveViewController.h"
#import "Foundation+KGOAdditions.h"
#import "MBProgressHUD.h"
#import "GameRoleInstance.h"
#import "GameUserData.h"
#import "GameDetailViewController.h"
#import "UnKilledViewController.h"
@interface ObserveViewController ()

@end

@implementation ObserveViewController
@synthesize allRoles;
@synthesize allUsers;
@synthesize currentGame;
@synthesize listView;
@synthesize tableFooterView;
@synthesize openButton;
@synthesize myRoleButton;
@synthesize finishButton;
@synthesize closeButton;
@synthesize oneOnOneButton;

- (void)dealloc {
    self.allRoles = nil;
    self.allUsers = nil;
    self.currentGame = nil;
    self.listView = nil;
    self.tableFooterView = nil;
    self.openButton = nil;
    self.myRoleButton = nil;
    self.finishButton = nil;
    self.closeButton = nil;
    self.oneOnOneButton = nil;


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
}

- (void)viewWillAppear:(BOOL)animated {
    BOOL status = NO;
    NSString *error = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APILibrary apiLibrary:&status 
                  metError:&error 
     observeGameWithGameID:self.currentGame.gameID 
              withDelegate:self];
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

- (IBAction)open:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error reopenWithGameID:self.currentGame.gameID withDelegate:self];
}

- (IBAction)finish:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error finishWithGameID:self.currentGame.gameID withDelegate:self];
}

- (IBAction)oneOnone:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error onOnoneWithGameID:self.currentGame.gameID withDelegate:self];
}

- (IBAction)close:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error closeWithGameID:self.currentGame.gameID withDelegate:self];
}

- (IBAction)myRole:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error getMyRoleWithGameID:self.currentGame.gameID withDelegate:self];
}

- (void)apiLibraryDidReceivedObserveResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *aResult = (NSDictionary *)result;
    NSArray *players = [aResult arrayForKey:@"players"];
    NSMutableArray *playerContainer = [NSMutableArray array];
    for (NSDictionary *role in players) {
        GameRoleInstance *aRole = [[GameRoleInstance alloc] init];
        [aRole updateWithDictionary:role];
        [playerContainer addObject:aRole];
        [aRole release];
    }
    self.allRoles = playerContainer;
    self.currentGame.allRoles = playerContainer;
    if (self.allRoles.count != [result forcedNumberForKey:@"playerCount"].integerValue) {
        self.finishButton.enabled = NO;
        self.oneOnOneButton.enabled = NO;
    } else {
        self.finishButton.enabled = YES;
        self.oneOnOneButton.enabled = YES;
    }
    NSDictionary *users = [aResult dictionaryForKey:@"users"];
    [users enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        NSMutableArray *usersContainer = [NSMutableArray array];
        GameUserData *anUser = [[GameUserData alloc] init];
        anUser.userDataKey = key;
        anUser.userDataID = [obj forcedStringForKey:@"id"];
        anUser.userDataName = [obj forcedStringForKey:@"username"];
        [usersContainer addObject:anUser];
        [anUser release];
        self.allUsers = usersContainer;
        self.currentGame.allUsers = usersContainer;
        [self.listView reloadData];
        self.listView.tableFooterView = self.tableFooterView;
    }];
}

- (void)apiLibraryDidReceivedFinishResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)apiLibraryDidReceivedReopenResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)apiLibraryDidReceivedCloseResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)apiLibraryDidReceivedOneononeResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)apiLibraryWithGameInstance:(GameInstance *)agameInstance roleInstance:(GameRoleInstance *)roleInstance didReceivedKilledByResult:(NSString *)gameID {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status 
                  metError:&error 
     observeGameWithGameID:self.currentGame.gameID 
              withDelegate:self];
}

- (void)apiLibraryDidReceivedError:(NSString *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [APILibrary alertWithException:error];
}

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.allRoles.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    GameRoleInstance *aRole = [self.allRoles objectAtIndex:section];
    return aRole.userName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    GameRoleInstance *aRole = [self.allRoles objectAtIndex:section];
    if (aRole.killedBy.length > 0 && ![aRole.killedBy isEqualToString:@"0"]) {
        return 1;
    }
    return self.allRoles.count;
}

- (NSString  *)roleInstanceUserNameAtUserID:(NSString *)roleID {
    if ([roleID isEqualToString:@"0"]) {
        return @"God";
    } else {
        if (self.allRoles) {
            for (GameRoleInstance *aRole in self.allRoles) {
                if ([aRole.userID isEqualToString:roleID]) {
                    return aRole.userName;
                }
            }
        }
    }
    return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"gamescell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    GameRoleInstance *aRole = [self.allRoles objectAtIndex:indexPath.section];
    if (aRole.killedBy.length > 0 && ![aRole.killedBy isEqualToString:@"0"]) {
        cell.textLabel.text = [NSString stringWithFormat:@"Killed by :%@ --->%@",[self roleInstanceUserNameAtUserID:aRole.killedBy],aRole.roleName];
    } else {
        if (indexPath.section == indexPath.row) {
            cell.textLabel.text = [NSString stringWithFormat:@"Killed by god"];
        } else {
            GameRoleInstance *otherRole = [self.allRoles objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"Killed by %@",otherRole.userName];
        }
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GameRoleInstance *aRole = [self.allRoles objectAtIndex:indexPath.section];
    if (aRole.killedBy.length > 0 && ![aRole.killedBy isEqualToString:@"0"]) {
        UnKilledViewController *unkilledVC = [[UnKilledViewController alloc] initWithNibName:@"UnKilledViewController" bundle:nil];
        unkilledVC.currentRole = aRole;
        unkilledVC.currentGame = self.currentGame;
        [self.navigationController pushViewController:unkilledVC animated:YES];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if (indexPath.section == indexPath.row) {
            BOOL status = NO;
            NSString *error = nil;
            [APILibrary apiLibrary:&status 
                          metError:&error 
                              game:self.currentGame 
                               who:aRole 
                          killedBy:aRole 
                      withDelegate:self];
        } else {
            GameRoleInstance *otherRole = [self.allRoles objectAtIndex:indexPath.row];
            BOOL status = NO;
            NSString *error = nil;
            [APILibrary apiLibrary:&status 
                          metError:&error 
                              game:self.currentGame 
                               who:aRole 
                          killedBy:otherRole 
                      withDelegate:self];
        }
    }
}


@end
