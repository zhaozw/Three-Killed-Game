//
//  HomeViewController.m
//  Sanguosha
//
//  Created by tynewstar on 8/12/12.
//  Copyright (c) 2012 Symbio Inc. All rights reserved.
//

#import "HomeViewController.h"
#import "NewGameViewController.h"
#import "RangkingsViewController.h"
#import "GamesViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

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
    GamesViewController *gamesVC = [[[GamesViewController alloc] initWithNibName:@"GamesViewController" bundle:nil] autorelease];
    gamesVC.title = @"Games";
    NewGameViewController *newgameVC = [[[NewGameViewController alloc] initWithNibName:@"NewGameViewController" bundle:nil] autorelease];
    newgameVC.title = @"New Game";
    RangkingsViewController *rangkingsVC = [[[RangkingsViewController alloc] initWithNibName:@"RangkingsViewController" bundle:nil] autorelease];
    rangkingsVC.title = @"Rankings";
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:newgameVC,rangkingsVC,gamesVC, nil];
    NSLog(@"%@",self.navigationController);
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

@end
