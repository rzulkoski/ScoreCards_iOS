//
//  UIViewController+WithScoreCardsBetaButton.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 9/5/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "UIViewController+WithScoreCardsBetaButton.h"

@implementation UIViewController (WithScoreCardsBetaButton)

- (void)configureScoreCardsBetaButton {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"BETA" style:UIBarButtonItemStylePlain target:self action:@selector(betaPressed)];
}

- (void)betaPressed {
    NSLog(@"BETA Pressed!");
    UIAlertView *betaAlert = [[UIAlertView alloc] initWithTitle:@"Choose an action:" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Check for Updates", @"Submit a Bug Report", @"Request a Feature", @"Make a Suggestion", nil];
    [betaAlert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            NSLog(@"Cancel Pressed");
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.rzgamer.com/scorecardsbetadownloads"]];
            break;
        case 2:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.rzgamer.com/mobile/forum/newthread/m/7667863/id/1680082"]];
            break;
        case 3:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.rzgamer.com/mobile/forum/newthread/m/7667863/id/1680085"]];
            break;
        case 4:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.rzgamer.com/mobile/forum/newthread/m/7667863/id/1680086"]];
            break;
    }
}

@end
