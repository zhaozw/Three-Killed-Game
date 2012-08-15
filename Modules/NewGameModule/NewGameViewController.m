//
//  NewGameViewController.m
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "NewGameViewController.h"
#import "MBProgressHUD.h"
#import "GameInstance.h"
#import "GameDetailViewController.h"
#import "Foundation+KGOAdditions.h"
@interface NewGameViewController ()

@end

@implementation NewGameViewController
@synthesize allKindsGames;
@synthesize listView;

- (void)dealloc {
    self.allKindsGames = nil;
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
    BOOL status = NO;
    NSString *error = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APILibrary apiLibrary:&status metError:&error getTypesWithDelegate:self];
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

#pragma mark - APILibaryDelegate
- (void)apiLibraryDidReceivedResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([result isKindOfClass:[NSArray class]]) {
        NSArray *kinds = (NSArray *)result;
        NSMutableArray *container = [NSMutableArray array];
        for (NSDictionary *kind in kinds) {
            GameInstance *gi = [[[GameInstance alloc] init] autorelease];
            gi.gameTypeID = [kind forcedStringForKey:@"id"];
            gi.name = [kind forcedStringForKey:@"name"];
            [container addObject:gi];
        }
        self.allKindsGames = container;
    }
    [self.listView reloadData];
}

- (void)apiLibraryDidReceivedError:(NSString *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [APILibrary alertWithException:error];
}

- (void)apiLibraryDidReceivedCreateGameResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    GameDetailViewController *gameDetailVC = [[GameDetailViewController alloc] initWithNibName:@"GameDetailViewController" bundle:nil];
    GameInstance *gi = [[[GameInstance alloc] init] autorelease];
    gi.gameID = (NSString *)result;
    gameDetailVC.currentGame = gi;
    [self.navigationController pushViewController:gameDetailVC animated:YES];
}

- (void)handleCreateGameWithGameTypeID:(NSString *)gameID {
    BOOL status = NO;
    NSString *error = nil;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [APILibrary apiLibrary:&status metError:&error createWithGameTypeID:gameID withDelegate:self];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.allKindsGames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"asdfgh";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    GameInstance *aGame = [self.allKindsGames objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",aGame.name];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GameInstance *aGame = [self.allKindsGames objectAtIndex:indexPath.row];
    [self handleCreateGameWithGameTypeID:aGame.gameTypeID];
}



@end
