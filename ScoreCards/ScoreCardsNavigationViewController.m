//
//  ScoreCardsNavigationViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/29/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "ScoreCardsNavigationViewController.h"
#import "PitchViewController.h"

#define LEAVE_GAME_ALERT 0

@interface ScoreCardsNavigationViewController ()

@end

@implementation ScoreCardsNavigationViewController

@synthesize leaveGameSelected = _leaveGameSelected;
@synthesize regularPop = _regularPop;

// Overrides the "Back" button displayed in the Navigation Bar to ask for confirmation when in the middle of a game.
- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if (self.regularPop) {                  // Regular Pop? If so, Pop.
        self.regularPop = NO;
        return YES;
    } else if (self.leaveGameSelected) {    // Leave game chosen? If so, Pop.
        self.leaveGameSelected = NO;
        return YES;
    } else if ([self.topViewController isMemberOfClass:[PitchViewController class]]) {  // Current VC is PitchVC? Ask for confirmation to leave current game by displaying AlertView.
        UIAlertView *leaveGameAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to leave the current game? All scores will be lost." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Leave Game", nil];
        leaveGameAlert.tag = LEAVE_GAME_ALERT;
        [leaveGameAlert show];
        
        return NO;
    } else {                                // Default case, just Pop.
        self.regularPop = YES;
        [self popViewControllerAnimated:YES];
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == LEAVE_GAME_ALERT) {
        switch (buttonIndex) {
            case 0: // Cancel Button
                break;
            case 1: // Leave Game Button
                self.leaveGameSelected = YES;
                [self popViewControllerAnimated:YES];
                break;
        }
    }    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if([[self.viewControllers lastObject] class] == [PitchViewController class]) {  // Is top VC PitchVC? If so, use the Curl up animation.
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: 1.00];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
        
        UIViewController *vc = [super popViewControllerAnimated:NO];
        
        [UIView commitAnimations];
        
        return vc;
    } else {    // Default case, just use the default popping animation.
        self.regularPop = YES;
        return [super popViewControllerAnimated:animated];
    }
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
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
