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
#import "Foundation+KGOAdditions.h"
#import "UIKit+KGOAdditions.h"
#import "AppDelegate+TKAdditions.h"
#import <QuartzCore/QuartzCore.h>

@interface ObserveViewController ()

@end

@implementation ObserveViewController
@synthesize allRoles;
@synthesize allUsers;
@synthesize currentGame;
@synthesize currentRole;

- (void)dealloc {
    self.allRoles = nil;
    self.allUsers = nil;
    self.currentGame = nil;
    self.currentRole = nil;

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
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    navTitleBar.image = [UIImage imageWithName:@"titlebar" tableName:@"btable1 2"];
    navTitleBar.backgroundColor = [UIColor clearColor];
    
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveActionGestureRecognizerStateChanged:)];
    gr.minimumPressDuration = 0.5;
    gr.delegate = self;
    [iconView addGestureRecognizer:gr];
    
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

#pragma mark - Navigation
- (IBAction)navBackButtonClicked:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

- (IBAction)refreshButtonClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(observeGameRequest) withObject:nil afterDelay:0.5];
}

#pragma mark - Instance methods
- (void)observeGameRequest {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status 
                  metError:&error 
     observeGameWithGameID:self.currentGame.gameID 
              withDelegate:self];
}

#pragma mark -
#pragma mark UIGestureRecognizer Delegate/Actions

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView: iconView];
    if ((self.currentGame.allRoles.count == self.currentGame.playerCount.integerValue) &&  [iconView indexForItemAtPoint: location] < self.currentGame.allRoles.count ){
        GameRoleInstance *role = [self.currentGame.allRoles objectAtIndex:[iconView indexForItemAtPoint: location]];
        if ([role.userID isEqualToString:self.currentRole.userID]) {
            return YES;
        }
    }
    return NO;
}

- (void)moveActionGestureRecognizerStateChanged:(UIGestureRecognizer *)recognizer
{
    switch ( recognizer.state )
    {
        default:
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateCancelled:
        {
            [iconView beginUpdates];
            if ( _emptyCellIndex != _dragOriginIndex )
            {
                [iconView moveItemAtIndex: _emptyCellIndex toIndex: _dragOriginIndex withAnimation: AQGridViewItemAnimationFade];
            }
            _emptyCellIndex = _dragOriginIndex;
            // move the cell back to its origin
            [UIView beginAnimations: @"SnapBack" context: NULL];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration: 0.5];
            [UIView setAnimationDelegate: self];
            [UIView setAnimationDidStopSelector: @selector(finishedSnap:finished:context:)];
            CGRect f = _draggingCell.frame;
            f.origin = _dragOriginCellOrigin;
            _draggingCell.frame = f;
            [UIView commitAnimations];
            [iconView endUpdates];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGPoint p = [recognizer locationInView:iconView];
            NSUInteger index = [iconView indexForItemAtPoint:p];
            if (index != NSNotFound)
            {
                GameRoleInstance *role = [self.currentGame.allRoles objectAtIndex:index];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意"
                                           message:[NSString stringWithFormat:@"%@将会被%@杀死",self.currentRole.userName,role.userName]
                                          delegate:self
                                 cancelButtonTitle:@"取消"
                                 otherButtonTitles:@"确定",nil];
                alertView.tag = index;
                [alertView show];
                [alertView release];
                
            } else {
                // move the real cell into place
                [UIView beginAnimations: @"SnapToPlace" context: NULL];
                [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
                [UIView setAnimationDuration: 0.5];
                [UIView setAnimationDelegate: self];
                [UIView setAnimationDidStopSelector: @selector(finishedSnap:finished:context:)];
                
                CGRect r = [iconView rectForItemAtIndex: _emptyCellIndex];
                CGRect f = _draggingCell.frame;
                f.origin.x = r.origin.x + floorf((r.size.width - f.size.width) * 0.5);
                f.origin.y = r.origin.y + floorf((r.size.height - f.size.height) * 0.5) - iconView.contentOffset.y;
                NSLog( @"Gesture ended-- moving to %@", NSStringFromCGRect(f) );
                _draggingCell.frame = f;
                
                _draggingCell.transform = CGAffineTransformIdentity;
                _draggingCell.alpha = 1.0;
                
                [UIView commitAnimations];
            }
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            NSUInteger index = [iconView indexForItemAtPoint:[recognizer locationInView: iconView]];
            _emptyCellIndex = index;    // we'll put an empty cell here now
            
            // find the cell at the current point and copy it into our main view, applying some transforms
            AQGridViewCell *sourceCell = [iconView cellForItemAtIndex:index];
            CGRect frame = [self.view convertRect:sourceCell.frame fromView:iconView];
            _draggingCell = [[SpringBoardCell alloc] initWithFrame:frame reuseIdentifier:@""];
            GameRoleInstance *role = [self.currentGame.allRoles objectAtIndex:index];
            _draggingCell.iconView.image = [UIImage imageWithName:@"female_face" tableName:@"utl 2"];
            _draggingCell.nameLabel.text = role.userName;
            if (![role.userID isEqualToString:self.currentRole.userID]) {
                [_draggingCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithName:@"portriat_black" tableName:@"hall 2"]]];
            } else {
                [_draggingCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithName:@"portriat" tableName:@"hall 2"]]];
            }
            [self.view addSubview: _draggingCell];
            
            // grab some info about the origin of this cell
            _dragOriginCellOrigin = frame.origin;
            _dragOriginIndex = index;
            
            [UIView beginAnimations: @"" context: NULL];
            [UIView setAnimationDuration: 0.2];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            
            // transformation-- larger, slightly transparent
            _draggingCell.transform = CGAffineTransformMakeScale( 1.2, 1.2 );
            _draggingCell.alpha = 0.7;
            
            // also make it center on the touch point
            _draggingCell.center = [recognizer locationInView: self.view];
            
            [UIView commitAnimations];
            
            // reload the grid underneath to get the empty cell in place
            [iconView reloadItemsAtIndices: [NSIndexSet indexSetWithIndex: index]
                              withAnimation: AQGridViewItemAnimationNone];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            // update draging cell location
            _draggingCell.center = [recognizer locationInView:self.view];
            
            // don't do anything with content if grid view is in the middle of an animation block
            if ( iconView.isAnimatingUpdates )
                break;
            
            // update empty cell to follow, if necessary
            NSUInteger index = [iconView indexForItemAtPoint: [recognizer locationInView: iconView]];
			
			// don't do anything if it's over an unused grid cell
			if ( index == NSNotFound )
			{
				// snap back to the last possible index
				index = [self.currentGame.allRoles count] - 1;
			}
            break;
        }
    }
}

- (void) finishedSnap: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context
{
    NSIndexSet * indices = [[NSIndexSet alloc] initWithIndex: _emptyCellIndex];
    _emptyCellIndex = NSNotFound;
    
    // load the moved cell into the grid view
    [iconView reloadItemsAtIndices: indices withAnimation: AQGridViewItemAnimationNone];
    
    // dismiss our copy of the cell
    [_draggingCell removeFromSuperview];
    _draggingCell = nil;
    
}

#pragma mark -AQGridViewDataSource
- (NSUInteger) numberOfItemsInGridView: (AQGridView *) gridView {
    return self.currentGame.allRoles.count;
}

- (AQGridViewCell *) gridView: (AQGridView *) gridView cellForItemAtIndex: (NSUInteger) index {
    AQGridViewCell *cell = nil;
    static NSString *identifier = @"aqgrid";
    cell = [gridView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[SpringBoardCell alloc] initWithFrame:CGRectMake(0, 0, 80, 72) reuseIdentifier:identifier] autorelease];
    }
    GameRoleInstance *role = [self.currentGame.allRoles objectAtIndex:index];
    UIColor *backgroundColor = nil;
    if (![role.userID isEqualToString:self.currentRole.userID]) {
        backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"portriat_black" tableName:@"hall 2"]];
    } else {
        backgroundColor = [UIColor colorWithPatternImage:[UIImage imageWithName:@"portriat" tableName:@"hall 2"]];
    }
    cell.backgroundColor = backgroundColor;
    [(SpringBoardCell *)cell iconView].image = [UIImage imageWithName:@"female_face" tableName:@"utl 2"];
    [(SpringBoardCell *)cell nameLabel].text = role.userName;
    return cell;
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

- (void)updateCurrentRole {
    for (GameRoleInstance *role in self.currentGame.allRoles) {
        if ([self.currentRole.userID isEqualToString:role.userID]) {
            self.currentRole = role;
        }
    }
}

- (void)apiLibraryDidReceivedObserveResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.currentGame.gameID = [result forcedStringForKey:@"id"];
    self.currentGame.playerCount = [result forcedNumberForKey:@"playerCount"];
    NSDictionary *aResult = (NSDictionary *)result;
    NSArray *players = [aResult arrayForKey:@"players"];
    NSMutableArray *playerContainer = [NSMutableArray array];
    for (NSDictionary *role in players) {
        GameRoleInstance *aRole = [[GameRoleInstance alloc] init];
        [aRole updateWithDictionary:role];
        [playerContainer addObject:aRole];
        [aRole release];
    }
    self.currentGame.allRoles = playerContainer;
    [self updateCurrentRole];
    [iconView reloadData];
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
    [(NSMutableArray *)self.currentGame.allRoles removeObjectAtIndex:_emptyCellIndex];
    [iconView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_draggingCell removeFromSuperview];
    _draggingCell = nil;
    if (buttonIndex == 0) {
        NSIndexSet * indices = [[NSIndexSet alloc] initWithIndex: _emptyCellIndex];
        _emptyCellIndex = NSNotFound;
        [iconView reloadItemsAtIndices: indices withAnimation: AQGridViewItemAnimationNone];
    } else {
        NSInteger index = alertView.tag;
        if (index < self.currentGame.allRoles.count) {
            GameRoleInstance *role = [self.currentGame.allRoles objectAtIndex:index];
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self performSelector:@selector(handleKilledByRequestWithRole:) withObject:role afterDelay:0.5];
        }
    }
}

- (void)handleKilledByRequestWithRole:(GameRoleInstance *)role {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status
                  metError:&error
                      game:self.currentGame
                       who:self.currentRole
                  killedBy:role
              withDelegate:self];
}


@end
