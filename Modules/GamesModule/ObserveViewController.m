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
@interface ObserveViewController ()

@end

@implementation ObserveViewController
@synthesize allRoles;
@synthesize allUsers;
@synthesize currentGame;
@synthesize listView;
@synthesize tableFooterView;

- (void)dealloc {
    self.allRoles = nil;
    self.allUsers = nil;
    self.currentGame = nil;
    self.listView = nil;
    self.tableFooterView = nil;

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
    
}

- (IBAction)finish:(id)sender {
    
}

- (IBAction)oneOnone:(id)sender {
    
}

- (IBAction)myRole:(id)sender {
    
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
        [self.listView reloadData];
        self.listView.tableFooterView = self.tableFooterView;
    }];
}

- (void)apiLibraryDidReceivedKilledByResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
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
    return self.allRoles.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"gamescell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    if (indexPath.section == indexPath.row) {
        cell.textLabel.text = [NSString stringWithFormat:@"Killed by god"];
    } else {
        GameRoleInstance *otherRole = [self.allRoles objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"Killed by %@",otherRole.userName];
    }
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    GameRoleInstance *aRole = [self.allRoles objectAtIndex:indexPath.section];
    if (indexPath.section == indexPath.row) {
        BOOL status = NO;
        NSString *error = nil;
        [APILibrary apiLibrary:&status 
                      metError:&error 
                        gameID:self.currentGame.gameID 
                         whoID:aRole.userID 
                    killedByID:aRole.userID 
                  withDelegate:self];
    } else {
        GameRoleInstance *otherRole = [self.allRoles objectAtIndex:indexPath.row];
        BOOL status = NO;
        NSString *error = nil;
        [APILibrary apiLibrary:&status 
                      metError:&error 
                        gameID:self.currentGame.gameID 
                         whoID:aRole.userID 
                    killedByID:otherRole.userID 
                  withDelegate:self];
    }
}


@end
