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
    iconView.padding = GridPaddingMake(0, 0, 0, 0);
    iconView.spacing = GridSpacingMake(0, 0);
    
    UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(moveActionGestureRecognizerStateChanged:)];
    gr.minimumPressDuration = 0.5;
    gr.delegate = self;
    [iconView addGestureRecognizer:gr];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"game_bg.png"]];
    navTitleBar.image = [UIImage imageWithName:@"sanguosha" tableName:@"btable 2"];
    navTitleBar.backgroundColor = [UIColor clearColor];
    
    menuContainer.image = [UIImage imageWithName:@"frame" tableName:@"table1 2"];
    menuContainer.backgroundColor = [UIColor clearColor];
    [begainButton setImage:[UIImage imageWithName:@"refresh" tableName:@"table_2"] forState:UIControlStateNormal];
    [begainButton setImage:[UIImage imageWithName:@"refresh_on" tableName:@"table_2"] forState:UIControlStateHighlighted];
    [dianjiangButton setImage:[UIImage imageWithName:@"finish" tableName:@"table_2"] forState:UIControlStateNormal];
    [dianjiangButton setImage:[UIImage imageWithName:@"finish_on" tableName:@"table_2"] forState:UIControlStateHighlighted];
    [backButton setImage:[UIImage imageWithName:@"back_on" tableName:@"btable 2"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageWithName:@"back" tableName:@"btable 2"] forState:UIControlStateHighlighted];
    [closeButton setImage:[UIImage imageWithName:@"close" tableName:@"table 2"] forState:UIControlStateNormal];
    [closeButton setImage:[UIImage imageWithName:@"close_on" tableName:@"table 2"] forState:UIControlStateHighlighted];
    [openButton setImage:[UIImage imageWithName:@"open" tableName:@"table 2"] forState:UIControlStateNormal];
    [openButton setImage:[UIImage imageWithName:@"open_on" tableName:@"table 2"] forState:UIControlStateHighlighted];
    [onOneOneButton setImage:[UIImage imageWithName:@"dantiao" tableName:@"table_2"] forState:UIControlStateNormal];
    [onOneOneButton setImage:[UIImage imageWithName:@"dantiao_on" tableName:@"table_2"] forState:UIControlStateHighlighted];
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

- (void)handleOpenRequest {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error finishWithGameID:self.currentGame.gameID withDelegate:self];
}

- (IBAction)openButtonClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(handleOpenRequest) withObject:nil afterDelay:0.5];
}

- (void)handleCloseRequest {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error closeWithGameID:self.currentGame.gameID withDelegate:self];
}

- (IBAction)closeButtonClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(handleCloseRequest) withObject:nil afterDelay:0.5];
}

- (void)handleOneOnOneRequest {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error onOnoneWithGameID:self.currentGame.gameID withDelegate:self];
}

- (void)handleFinishRequest {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error finishWithGameID:self.currentGame.gameID withDelegate:self];
}

- (IBAction)finishButtonClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(handleFinishRequest) withObject:nil afterDelay:0.5];
}

- (IBAction)oneOnoneButtonClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self performSelector:@selector(handleOneOnOneRequest) withObject:nil afterDelay:0.5];
}

#pragma mark - Instance Method
- (void)apiLibraryDidReceivedReopenResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)apiLibraryDidReceivedCloseResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)apiLibraryDidReceivedFinishResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)apiLibraryDidReceivedOneononeResult:(id)result {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

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

- (UIView *)role:(GameRoleInstance *)aRole viewAtIndex:(NSInteger)i {
    
    CGRect frame = CGRectMake(0, 0, 60, 62);
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
    
    UIImageView *portriatView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 42, 39)];
    portriatView.image = [UIImage imageWithName:@"female_face" tableName:@"utl 2"];
    portriatView.layer.cornerRadius = 5;
    portriatView.layer.masksToBounds = YES;
    portriatView.backgroundColor = [UIColor blackColor];
    portriatView.alpha = 0.5;
    [imageView addSubview:portriatView];
    
    UILabel *seatlabel = [[[UILabel alloc] initWithFrame:CGRectMake(2, 39, 58, 24)] autorelease];
    seatlabel.textColor = [UIColor yellowColor];
    seatlabel.font = [UIFont boldSystemFontOfSize:10];
    seatlabel.numberOfLines = 2;
    if (aRole.killedBy.length > 0 && ![aRole.killedBy isEqualToString:@"0"]) {
        seatlabel.text = [NSString stringWithFormat:@"%@ By:%@",aRole.userName,[self roleInstanceUserNameAtUserID:aRole.killedBy]];
    } else {
        seatlabel.text = aRole.userName;
    }
    
    seatlabel.textAlignment = UITextAlignmentCenter;
    
    seatlabel.backgroundColor = [UIColor clearColor];
    [imageView addSubview:seatlabel];
    
    
    UILabel *namelabel = [[[UILabel alloc] initWithFrame:CGRectMake(46, 4, 16, 45)] autorelease];
    namelabel.text = [NSString stringWithFormat:@"%@号位",aRole.seatNum];
    namelabel.textColor = [UIColor yellowColor];
    namelabel.font = [UIFont boldSystemFontOfSize:12];
    namelabel.numberOfLines = 4;
    namelabel.textAlignment = UITextAlignmentCenter;
    namelabel.backgroundColor = [UIColor clearColor];
    [imageView addSubview:namelabel];
    
    //        UIControl *control = [[[UIControl alloc] initWithFrame:frame] autorelease];
    //        control.tag = i;
    //        [control addSubview:imageView];
    //        [control addTarget:self action:@selector(thumbnailTapped:) forControlEvents:UIControlEventTouchUpInside];
    return imageView;
}

- (void)layoutRoles:(NSArray *)roles
{
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < roles.count; i++) {
        GameRoleInstance *aRole = [roles objectAtIndex:i];
        NSLog(@"index:%d,role:%@",i,aRole.userName);
        [views addObject:[self role:aRole viewAtIndex:i]];
    }
    iconView.icons = nil;
    [iconView addIcons:views];
    [self performSelector:@selector(handleAnimation) withObject:nil afterDelay:0.1];
}

#pragma mark - IconGridDelegate
- (void)thumbnailTapped:(id)sender
{
    UIControl *control = (UIControl *)sender;
    if (control.tag < self.feakAllRoles.count) {
        GameRoleInstance *aRole = [self.feakAllRoles objectAtIndex:control.tag];
        if (aRole.killedBy.length > 0 && ![aRole.killedBy isEqualToString:@"0"]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意" 
                                                                message:@"确定要复活角色吗？" 
                                                               delegate:self 
                                                      cancelButtonTitle:@"取消" 
                                                      otherButtonTitles:@"确定", nil];
            alertView.tag = control.tag;
            [alertView show];
            [alertView release];
        } else {
        }
    }
}

- (void)iconGridFrameDidChange:(AutoIconGrid *)iconGrid
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
    self.feakAllRoles = [NSMutableArray array];
    if (count > 0 ) {
        for (int i = 0; i < count; i++) {
            GameRoleInstance *aRole = [[GameRoleInstance alloc] init];
            aRole.userName = @"未入座";
            aRole.seatNum = [NSNumber numberWithInt:i+1];
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
#pragma mark - 

- (void)apiLibraryDidReceivedGameDetail:(id)detail {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSDictionary *role = (NSDictionary *)detail;
    GameRoleInstance *aRole = [[[GameRoleInstance alloc] init] autorelease];
    [aRole updateWithDictionary:role];
    self.currentRole = aRole;
    self.currentGame.name = [role forcedStringForKey:@"game_name"];
    self.currentGame.gameTypeID = [role forcedStringForKey:@"game_type_id"];
    [charactorButton setImage:[UIImage imageWithName:[[APILibrary sharedInstance] charactorKeyWithRoleID:self.currentRole.roleID] tableName:@"selcharacter"] forState:UIControlStateNormal];
    [charactorButton setImage:[UIImage imageWithName:[[APILibrary sharedInstance] charactorKeyWithRoleID:self.currentRole.roleID] tableName:@"selcharacter"] forState:UIControlStateHighlighted];
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

- (void)handleUnkilledRequestWithRole:(GameRoleInstance *)role {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status
                  metError:&error 
                    gameID:role.gameID 
                     whoID:role.userID 
      unkilledWithDelegate:self];
}

- (void)handleKilledByRequestWithRole:(GameRoleInstance *)role {
    BOOL status = NO;
    NSString *error = nil;
    GameRoleInstance *who = [self.feakAllRoles objectAtIndex:draggedIndex];
    [APILibrary apiLibrary:&status
                  metError:&error
                      game:self.currentGame
                       who:who
                  killedBy:role
              withDelegate:self];
}

- (void)apiLibraryDidReceivedUnKilledByResult:(id)result {
    [self observeGameRequest];
}

- (void)apiLibraryWithGameInstance:(GameInstance *)agameInstance roleInstance:(GameRoleInstance *)roleInstance didReceivedKilledByResult:(NSString *)gameID {
    [self observeGameRequest];
}

#pragma mark -
#pragma mark UIGestureRecognizer Delegate/Actions

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:iconView];
    if (self.currentGame.allRoles.count == self.currentGame.playerCount.integerValue){
        NSInteger index = [iconView indexForItemAtViewPoint:location];
        if (index < self.feakAllRoles.count) {
            GameRoleInstance *aRole = [self.feakAllRoles objectAtIndex:index];
            NSLog(@"dragged role:%@",aRole.userName);
            if (aRole) {
                if (aRole.killedBy.length > 0 && ![aRole.killedBy isEqualToString:@"0"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意"
                                                                        message:[NSString stringWithFormat:@"确定要复活%@吗?",aRole.userName]
                                                                       delegate:self
                                                              cancelButtonTitle:@"取消"
                                                              otherButtonTitles:@"确定", nil];
                    alertView.tag = index + 100;
                    [alertView show];
                    [alertView release];
                } else {
                    return YES;
                }
            }
        }
    }
    return NO;
}

- (void)moveActionGestureRecognizerStateChanged:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state)
    {
        default:
        case UIGestureRecognizerStateFailed:
            break;
        case UIGestureRecognizerStatePossible:
        case UIGestureRecognizerStateCancelled:
        {
            [UIView beginAnimations:@"SnapBack" context:NULL];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [UIView setAnimationDuration:0.5];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(finishedSnap:finished:context:)];
            CGRect f = draggedView.frame;
            f.origin = draggedOrigin;
            draggedView.frame = f;
            [UIView commitAnimations];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGPoint p = [recognizer locationInView:iconView];
            NSUInteger index = [iconView indexForItemAtViewPoint:p];
            if (index != NSNotFound)
            {
                [UIView beginAnimations:@"SnapToPlace" context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(finishedSnap:finished:context:)];
                
                CGRect f = [iconView iconFrameWithItemIndex:index];
                draggedView.frame = f;
                [UIView commitAnimations];
                
                GameRoleInstance *atRole = [self.feakAllRoles objectAtIndex:index];
                GameRoleInstance *draggedRole = [self.feakAllRoles objectAtIndex:draggedIndex];
                NSLog(@"dragged role:%@",draggedRole.userName);
                NSLog(@"at role:%@",atRole.userName);
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注意"
                                                                    message:[NSString stringWithFormat:@"%@将会被%@杀死",draggedRole.userName,atRole.userName]
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定",nil];
                alertView.tag = index;
                [alertView show];
                [alertView release];
            
            } else {
                [UIView beginAnimations:@"SnapToPlace" context:NULL];
                [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
                [UIView setAnimationDuration:0.5];
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(finishedSnap:finished:context:)];
                CGRect f = draggedView.frame;
                f.origin = draggedOrigin;
                draggedView.frame = f;
                [UIView commitAnimations];
            }
            break;
        }
            
        case UIGestureRecognizerStateBegan:
        {
            NSUInteger index = [iconView indexForItemAtViewPoint:[recognizer locationInView:iconView]];
            GameRoleInstance *role = [self.feakAllRoles objectAtIndex:index];
            draggedView = [self role:role viewAtIndex:index];
            [self.view addSubview:draggedView];
            CGRect frame = [self.view convertRect:[iconView iconFrameWithViewPoint:[recognizer locationInView:iconView]] fromView:iconView];
            draggedView.frame = frame;
            
//            // find the cell at the current point and copy it into our main view, applying some transforms
//            AQGridViewCell *sourceCell = [iconView cellForItemAtIndex:index];
//            CGRect frame = [self.view convertRect:sourceCell.frame fromView:iconView];
//            _draggingCell = [[SpringBoardCell alloc] initWithFrame:frame reuseIdentifier:@""];
//            GameRoleInstance *role = [self.currentGame.allRoles objectAtIndex:index];
//            _draggingCell.iconView.image = [UIImage imageWithName:@"female_face" tableName:@"utl 2"];
//            _draggingCell.nameLabel.text = role.userName;
//            if (![role.userID isEqualToString:self.currentRole.userID]) {
//                [_draggingCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithName:@"portriat_black" tableName:@"hall 2"]]];
//            } else {
//                [_draggingCell setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageWithName:@"portriat" tableName:@"hall 2"]]];
//            }
//            [self.view addSubview: _draggingCell];
            
            // grab some info about the origin of this cell
            draggedOrigin = frame.origin;
            draggedIndex = index;
            [UIView beginAnimations:@"" context: NULL];
            [UIView setAnimationDuration: 0.2];
            [UIView setAnimationCurve: UIViewAnimationCurveEaseOut];
            
            // transformation-- larger, slightly transparent
            draggedView.transform = CGAffineTransformMakeScale( 1.2, 1.2 );
            draggedView.alpha = 0.7;
            
            // also make it center on the touch point
            draggedView.center = [recognizer locationInView:self.view];
            [UIView commitAnimations];
            
//            // reload the grid underneath to get the empty cell in place
//            [iconView reloadItemsAtIndices: [NSIndexSet indexSetWithIndex: index]
//                             withAnimation: AQGridViewItemAnimationNone];
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            // update draging cell location
            draggedView.center = [recognizer locationInView:self.view];
            
//            // don't do anything with content if grid view is in the middle of an animation block
//            if (iconView.isAnimatingUpdates )
//                break;
            
            // update empty cell to follow, if necessary
            NSUInteger index = [iconView indexForItemAtViewPoint:[recognizer locationInView:iconView]];
			
			// don't do anything if it's over an unused grid cell
			if ( index == NSNotFound )
			{
//				// snap back to the last possible index
//				index = [self.currentGame.allRoles count] - 1;
			}
            break;
        }
    }
}

- (void) finishedSnap: (NSString *) animationID finished: (NSNumber *) finished context: (void *) context
{
    [draggedView removeFromSuperview];
    draggedView = nil;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (alertView.tag >= 100) {
            NSInteger index = alertView.tag - 100;
            if (index < self.feakAllRoles.count) {
                GameRoleInstance *role = [self.feakAllRoles objectAtIndex:index];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self performSelector:@selector(handleUnkilledRequestWithRole:) withObject:role afterDelay:0.5];
            }
        } else {
            NSInteger index = alertView.tag;
            if (index < self.feakAllRoles.count) {
                GameRoleInstance *role = [self.feakAllRoles objectAtIndex:index];
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self performSelector:@selector(handleKilledByRequestWithRole:) withObject:role afterDelay:0.5];
            }
        }
    }
}


@end
