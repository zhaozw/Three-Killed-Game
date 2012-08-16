//
//  UnKilledViewController.m
//  ThreeKilled
//
//  Created by Liu Mingxing on 8/16/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "UnKilledViewController.h"
#import "MBProgressHUD.h"
@interface UnKilledViewController ()

@end

@implementation UnKilledViewController
@synthesize currentRole;
@synthesize listView;
@synthesize currentGame;


- (void)dealloc {
    self.currentRole = nil;
    self.listView = nil;
    self.currentGame = nil;

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
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"gamescell";
    UITableViewCell *cell = nil;
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
    }
    if (indexPath.row == 1){
        if (self.currentRole.killedBy.length > 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"Killed By:%@",[self roleInstanceUserNameAtUserID:self.currentRole.killedBy]];
        } else {
            cell.textLabel.text = @"Alive";
        }
    } else if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:@"玩家:%@",self.currentRole.userName];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"Clicked to unkill"];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 2) {
        BOOL status = NO;
        NSString *error = nil;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [APILibrary apiLibrary:&status
                      metError:&error 
                        gameID:self.currentRole.gameID 
                         whoID:self.currentRole.userID 
          unkilledWithDelegate:self];
    } 
}

- (void)apiLibraryDidReceivedUnKilledByResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)apiLibraryDidReceivedError:(NSString *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [APILibrary alertWithException:error];
}

@end
