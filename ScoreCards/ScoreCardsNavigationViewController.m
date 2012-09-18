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

@synthesize alertViewClicked = _alertViewClicked;
@synthesize regularPop = _regularPop;

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item {
    if (self.regularPop) {
        self.regularPop = NO;
        return YES;
    } else if (self.alertViewClicked) {
        self.alertViewClicked = NO;
        return YES;
    } else if ([self.topViewController isMemberOfClass:[PitchViewController class]]) {
        UIAlertView *leaveGameAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to leave the current game? All scores will be lost." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Leave Game", nil];
        leaveGameAlert.tag = LEAVE_GAME_ALERT;
        [leaveGameAlert show];
        
        return NO;
    } else {
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
                self.alertViewClicked = YES;
                [self popViewControllerAnimated:YES];
                break;
        }
    }    
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if([[self.viewControllers lastObject] class] == [PitchViewController class]) {
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration: 1.00];
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:NO];
        
        UIViewController *vc = [super popViewControllerAnimated:NO];
        
        [UIView commitAnimations];
        
        return vc;
    } else {
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
