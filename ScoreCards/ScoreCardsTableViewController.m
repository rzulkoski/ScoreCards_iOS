//
//  ScoreCardsTableViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 9/3/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "ScoreCardsTableViewController.h"
#import "UIViewController+WithScoreCardsBetaButton.h"

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureScoreCardsBetaButton];

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
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
