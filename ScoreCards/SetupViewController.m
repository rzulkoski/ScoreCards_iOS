//
//  SetupViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/26/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "SetupViewController.h"
#import "PitchViewController.h"

@interface SetupViewController ()
@property (nonatomic) int numPlayers;
@property (nonatomic) int numPoints;
@property (nonatomic) BOOL teamPlay;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numPlayersControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *numPointsControl;
@property (weak, nonatomic) IBOutlet UISwitch *teamPlaySwitch;
@property (weak, nonatomic) IBOutlet UIButton *startGameButton;
@end

@implementation SetupViewController

@synthesize numPlayers = _numPlayers;
@synthesize numPoints = _numPoints;
@synthesize teamPlay = _teamPlay;
@synthesize numPlayersControl = _numPlayersControl;
@synthesize numPointsControl = _numPointsControl;
@synthesize teamPlaySwitch = _teamPlaySwitch;
@synthesize startGameButton = _startGameButton;

- (int)numPlayers {
    if (!_numPlayers) _numPlayers = 2;
    return _numPlayers;
}

- (IBAction)numPlayersSelected:(UISegmentedControl *)sender {
    self.numPlayers = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] intValue];
    [self updateSetupControls];
}

- (IBAction)numPointsSelected:(UISegmentedControl *)sender {
    self.numPoints = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] intValue];
    [self updateSetupControls];
}

- (IBAction)teamPlaySelected:(UISwitch *)sender {
    self.teamPlay = sender.on;
}

- (void)loadDefaults {
    self.numPlayers = 4;
    self.numPoints = 13;
    self.teamPlay = YES;
    self.teamPlaySwitch.enabled = NO;
    [self updateSetupControls];
}

- (void)updateSetupControls {
    switch (self.numPlayers) {
        case 2:
        case 3:
            [self.numPointsControl setEnabled:YES forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"4"]];
            [self.numPointsControl setEnabled:YES forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"5"]];
            [self.numPointsControl setEnabled:NO forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"10"]];
            [self.numPointsControl setEnabled:NO forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"13"]];
            [self.numPointsControl setEnabled:NO forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"14"]];
            self.numPoints = self.numPoints <= 5 ? self.numPoints : -1;
            self.teamPlaySwitch.enabled = NO;
            self.teamPlay = NO;
            break;
        case 4:
        case 6:
            [self.numPointsControl setEnabled:YES forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"4"]];
            [self.numPointsControl setEnabled:YES forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"5"]];
            [self.numPointsControl setEnabled:YES forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"10"]];
            [self.numPointsControl setEnabled:YES forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"13"]];
            [self.numPointsControl setEnabled:YES forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"14"]];
            self.teamPlaySwitch.enabled = self.numPoints > 5 ? NO : YES;
            self.teamPlay = self.numPoints > 5 ? YES : self.teamPlay;
            break;
        case 5:
            [self.numPointsControl setEnabled:YES forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"4"]];
            [self.numPointsControl setEnabled:YES forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"5"]];
            [self.numPointsControl setEnabled:NO forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"10"]];
            [self.numPointsControl setEnabled:NO forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"13"]];
            [self.numPointsControl setEnabled:NO forSegmentAtIndex:[self indexForSegmentedControl:self.numPointsControl withTitle:@"14"]];
            self.numPoints = self.numPoints <= 5 ? self.numPoints : -1;
            self.teamPlaySwitch.enabled = NO;
            self.teamPlay = NO;
            break;
    }
    self.numPlayersControl.selectedSegmentIndex = [self indexForSegmentedControl:self.numPlayersControl withTitle:[NSString stringWithFormat:@"%i", self.numPlayers]];
    self.numPointsControl.selectedSegmentIndex = [self indexForSegmentedControl:self.numPointsControl withTitle:[NSString stringWithFormat:@"%i", self.numPoints]];
    self.teamPlaySwitch.on = self.teamPlay;
    self.startGameButton.enabled = self.numPoints > 0 ? YES : NO;
    self.startGameButton.alpha = self.numPoints > 0 ? 1.0 : 0.5;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showPitch"]) {
        PitchViewController *vc = [segue destinationViewController];
        vc.numberOfPlayers = self.numPlayers;
        vc.numberOfPointsPerHand = self.numPoints;
        switch (self.numPoints) {
            case 4:
            case 5:
                vc.minimumBid = 2;
                break;
            case 10:
                vc.minimumBid = 4;
                break;
            case 13:
            case 14:
                vc.minimumBid = 5;
                break;
        }
        vc.teamPlay = self.teamPlay;
    }
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
    [self setStartGameButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
