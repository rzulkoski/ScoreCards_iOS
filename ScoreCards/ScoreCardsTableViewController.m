//
//  ScoreCardsTableViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 9/3/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "ScoreCardsTableViewController.h"

@interface ScoreCardsTableViewController ()

@end

@implementation ScoreCardsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"BETA" style:UIBarButtonItemStylePlain target:self action:@selector(betaPressed)];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
