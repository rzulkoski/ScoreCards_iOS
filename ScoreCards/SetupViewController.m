//
//  SetupViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/26/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "SetupViewController.h"

@interface SetupViewController ()
@property (nonatomic) int numPlayers;
@property (nonatomic) int numPoints;
@property (nonatomic) BOOL teamPlay;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numPlayersControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numPointsControl;
@property (weak, nonatomic) IBOutlet UISwitch *teamPlaySwitch;
@end

@implementation SetupViewController

@synthesize numPlayers = _numPlayers;
@synthesize numPoints = _numPoints;
@synthesize teamPlay = _teamPlay;
@synthesize numPlayersControl = _numPlayersControl;
@synthesize numPointsControl = _numPointsControl;
@synthesize teamPlaySwitch = _teamPlaySwitch;

- (int)numPlayers {
    if (!_numPlayers) _numPlayers = 2;
    return _numPlayers;
}

- (IBAction)numPlayersSelected:(UISegmentedControl *)sender {
    self.numPlayers = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] intValue];
    NSLog(@"numPlayers = %i", self.numPlayers);
}

- (void)loadDefaults {
    self.numPlayers = 4;
    self.numPoints = 13;
    self.teamPlay = YES;
    [self updateSetupControls];
}

- (void)updateSetupControls {
    self.numPlayersControl.selectedSegmentIndex = [self indexForSegmentedControl:self.numPlayersControl withTitle:[NSString stringWithFormat:@"%i", self.numPlayers]];
    self.numPointsControl.selectedSegmentIndex = [self indexForSegmentedControl:self.numPointsControl withTitle:[NSString stringWithFormat:@"%i", self.numPoints]];
    self.teamPlaySwitch.on = self.teamPlay;
}

- (int)indexForSegmentedControl:(UISegmentedControl *)segment withTitle:(NSString *)title {
    int index = -1;
    for (int i = 0; i < segment.numberOfSegments; i++) {
        if ([[segment titleForSegmentAtIndex:i] isEqualToString:title]) index = i;
    }
    return index;
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
	[self loadDefaults];
}

- (void)viewDidUnload
{
    [self setNumPlayersControl:nil];
    [self setNumPointsControl:nil];
    [self setTeamPlaySwitch:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
