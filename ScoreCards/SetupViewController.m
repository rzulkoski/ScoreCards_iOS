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

- (IBAction)numPointsSelected:(UISegmentedControl *)sender {
    self.numPoints = [[sender titleForSegmentAtIndex:sender.selectedSegmentIndex] intValue];
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
