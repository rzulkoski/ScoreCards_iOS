//
//  ScoreCardsViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 9/4/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "ScoreCardsViewController.h"
#import "UIViewController+WithScoreCardsBetaButton.h"

@interface ScoreCardsViewController ()

@end

@implementation ScoreCardsViewController

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
    [self configureScoreCardsBetaButton];

	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
