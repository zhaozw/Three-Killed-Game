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
#import "UIKit+KGOAdditions.h"
#import "AppDelegate+TKAdditions.h"
#import <QuartzCore/QuartzCore.h>
@interface NewGameViewController ()

@end

@implementation NewGameViewController
@synthesize allKindsGames;

- (void)dealloc {
    self.allKindsGames = nil;

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

- (void)requestGameTypes {
    BOOL status = NO;
    NSString *error = nil;
    [APILibrary apiLibrary:&status metError:&error getTypesWithDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    iconView.backgroundColor = [UIColor clearColor];
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
    [self performSelector:@selector(requestGameTypes) withObject:nil afterDelay:0.5];
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

#pragma mark - Navigation
- (IBAction)navBackButtonClicked:(id)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}

#pragma mark - Instance methods

- (void)thumbnailTapped:(id)sender
{
    UIControl *control = (UIControl *)sender;
    if (control.tag < self.allKindsGames.count) {
        GameInstance *aGame = [self.allKindsGames objectAtIndex:control.tag];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self performSelector:@selector(handleCreateGameWithGameTypeID:) withObject:aGame.gameTypeID afterDelay:0.5];
    };
}

- (void)handleAnimation {
    [iconView animationWithRect:CGRectMake(0, 0, 80, 40)];
}

- (void)layoutGames:(NSArray *)games
{
    NSMutableArray *views = [NSMutableArray array];
    for (NSInteger i = 0; i < games.count; i++) {
        GameInstance *aGame = [games objectAtIndex:i];
        CGRect frame = CGRectMake(0, 0, 80, 40);
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = [UIImage imageWithName:@"yinzhang" tableName:@"gameIcon"];
        imageView.layer.cornerRadius = 5;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = [UIColor blackColor];
        imageView.alpha = 0.5;
        
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(30, 12, 20, 16)] autorelease];
        label.text = aGame.name;
        label.textColor = [UIColor yellowColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.numberOfLines = 2;
        [label sizeToFit];
        label.backgroundColor = [UIColor clearColor];
        [imageView addSubview:label];
        
        UIControl *control = [[[UIControl alloc] initWithFrame:frame] autorelease];
        control.tag = i;
        [control addSubview:imageView];
        [control addTarget:self action:@selector(thumbnailTapped:) forControlEvents:UIControlEventTouchUpInside];
        [views addObject:control];
    }
    [iconView addIcons:views];
    [self performSelector:@selector(handleAnimation) withObject:nil afterDelay:0.1];
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
    [self layoutGames:self.allKindsGames];
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
    [APILibrary apiLibrary:&status metError:&error createWithGameTypeID:gameID withDelegate:self];
}

@end
