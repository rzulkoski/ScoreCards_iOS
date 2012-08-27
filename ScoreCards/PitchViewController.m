//
//  PitchViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/26/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "PitchViewController.h"
#import "PitchHandTableViewCell.h"

@interface PitchViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *pointTargetControl;
@property (strong, nonatomic) NSMutableArray *team1Scores;
@property (strong, nonatomic) NSMutableArray *team1ScoreChanges;
@property (strong, nonatomic) NSMutableArray *team2Scores;
@property (strong, nonatomic) NSMutableArray *team2ScoreChanges;
@property (strong, nonatomic) NSMutableArray *bids;
@property (strong, nonatomic) IBOutlet UIStepper *pointStepper;
@property (strong, nonatomic) IBOutlet UILabel *pointStepperDisplay;
@property (weak, nonatomic) IBOutlet UISegmentedControl *suitControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *biddingTeam;
@property (strong, nonatomic) IBOutlet UIButton *nextHandButton;
@property (nonatomic) int currentBid;
 

@end

@implementation PitchViewController

@synthesize pitchHandsTableView;
@synthesize team1Scores = _team1Scores;
@synthesize team1ScoreChanges = _team1ScoreChanges;
@synthesize team2Scores = _team2Scores;
@synthesize team2ScoreChanges = _team2ScoreChanges;
@synthesize bids = _bids;
@synthesize pointStepper;
@synthesize pointStepperDisplay;
@synthesize pointTargetControl;
@synthesize suitControl;
@synthesize biddingTeam;
@synthesize nextHandButton = _nextHandButton;
@synthesize currentBid = _currentBid;
@synthesize numberOfPlayers = _numberOfPlayers;

- (IBAction)pointTargetSelected:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        case 1:
            self.biddingTeam.enabled = NO;
            self.suitControl.enabled = NO;
            self.pointStepper.minimumValue = 0;
            break;
        case 2:
            self.biddingTeam.enabled = YES;
            self.suitControl.enabled = YES;
            self.pointStepper.minimumValue = 5;
            break;
    }
}

- (IBAction)nextHandPressed {
    [self.team1Scores addObject:[self.team1Scores objectAtIndex:self.team1Scores.count - 1]];
    [self.team1ScoreChanges addObject:@""];
    [self.team2Scores addObject:[self.team2Scores objectAtIndex:self.team2Scores.count - 1]];
    [self.team2ScoreChanges addObject:@""];
    [self.bids addObject:@"No bid"];
    [pitchHandsTableView reloadData];
    [pitchHandsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.team1Scores.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)pointsChanged {
    [self updateCurrentRow];
    self.pointStepperDisplay.text = [NSString stringWithFormat:@"%d", (int)self.pointStepper.value];
}

- (IBAction)suitSelected:(UISegmentedControl *)sender {
    [self updateCurrentRow];
}

- (IBAction)biddingTeamSelected:(UISegmentedControl *)sender {
    [self updateCurrentRow];
}

- (void)updateCurrentRow {
    self.pointTargetControl.enabled = YES;
    switch (pointTargetControl.selectedSegmentIndex) {
        case 0:
        case 1:
            [self handleScoringForTeam:@"1" teamScores:self.team1Scores teamScoreChanges:self.team1ScoreChanges selectedTeam:[NSString stringWithFormat:@"%d", pointTargetControl.selectedSegmentIndex + 1]];
            [self handleScoringForTeam:@"2" teamScores:self.team2Scores teamScoreChanges:self.team2ScoreChanges selectedTeam:[NSString stringWithFormat:@"%d", pointTargetControl.selectedSegmentIndex + 1]];
            break;
        case 2:
            self.currentBid = (int)self.pointStepper.value;
            [self.bids replaceObjectAtIndex:self.bids.count - 1 withObject:[NSString stringWithFormat:@"%d%@ (%@)", self.currentBid, [self.suitControl titleForSegmentAtIndex:self.suitControl.selectedSegmentIndex], [self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex]]];
            break;
    }
    [pitchHandsTableView reloadData];
}

- (void)handleScoringForTeam:(NSString *)team
                  teamScores:(NSMutableArray *)teamScores
            teamScoreChanges:(NSMutableArray *)teamScoreChanges
                selectedTeam:(NSString *)selectedTeam {
    
    int previousScore = 0;
    if (teamScores.count > 1) previousScore = [[teamScores objectAtIndex:teamScores.count - 2] intValue];
    if ([team isEqualToString:[self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex]]) {
        if ([team isEqualToString:selectedTeam]) {
            if ((int)self.pointStepper.value >= self.currentBid) {
                [teamScores replaceObjectAtIndex:teamScores.count - 1 withObject:[NSString stringWithFormat:@"%d", previousScore + (int)self.pointStepper.value]];
                [teamScoreChanges replaceObjectAtIndex:teamScoreChanges.count - 1 withObject:[NSString stringWithFormat:@"+%d", (int)self.pointStepper.value]];
            } else {
                [teamScores replaceObjectAtIndex:teamScores.count - 1 withObject:[NSString stringWithFormat:@"%d", previousScore - self.currentBid]];
                [teamScoreChanges replaceObjectAtIndex:teamScoreChanges.count - 1 withObject:[NSString stringWithFormat:@"%d", 0 - self.currentBid]];
            }
        } else {
            if (13 - (int)self.pointStepper.value >= self.currentBid) {
                [teamScores replaceObjectAtIndex:teamScores.count - 1 withObject:[NSString stringWithFormat:@"%d", previousScore + 13 - (int)self.pointStepper.value]];
                [teamScoreChanges replaceObjectAtIndex:teamScoreChanges.count - 1 withObject:[NSString stringWithFormat:@"+%d", 13 - (int)self.pointStepper.value]];
            } else {
                [teamScores replaceObjectAtIndex:teamScores.count - 1 withObject:[NSString stringWithFormat:@"%d", previousScore - self.currentBid]];
                [teamScoreChanges replaceObjectAtIndex:teamScoreChanges.count - 1 withObject:[NSString stringWithFormat:@"%d", 0 - self.currentBid]];
            }
        }
    } else {
        if ([team isEqualToString:selectedTeam]) {
            [teamScores replaceObjectAtIndex:teamScores.count - 1 withObject:[NSString stringWithFormat:@"%d", previousScore + (int)self.pointStepper.value]];
            [teamScoreChanges replaceObjectAtIndex:teamScoreChanges.count - 1 withObject:[NSString stringWithFormat:@"+%d", (int)self.pointStepper.value]];
        } else {
            [teamScores replaceObjectAtIndex:teamScores.count - 1 withObject:[NSString stringWithFormat:@"%d", previousScore + 13 - (int)self.pointStepper.value]];
            [teamScoreChanges replaceObjectAtIndex:teamScoreChanges.count - 1 withObject:[NSString stringWithFormat:@"+%d", 13 - (int)self.pointStepper.value]];
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.team1Scores.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"pitch2TeamTableCell";
    
    PitchHandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PitchHandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.team1Score.text = [self.team1Scores objectAtIndex:[indexPath row]];
    cell.team1ScoreChange.text = [self.team1ScoreChanges objectAtIndex:[indexPath row]];
    cell.team2Score.text = [self.team2Scores objectAtIndex:[indexPath row]];
    cell.team2ScoreChange.text = [self.team2ScoreChanges objectAtIndex:[indexPath row]];
    cell.bid.text = [self.bids objectAtIndex:[indexPath row]];
    
    return cell;
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
    self.team1Scores = [[NSMutableArray alloc] initWithObjects:@"0", nil];
    self.team1ScoreChanges = [[NSMutableArray alloc] initWithObjects:@"", nil];
    self.team2Scores = [[NSMutableArray alloc] initWithObjects:@"0", nil];
    self.team2ScoreChanges = [[NSMutableArray alloc] initWithObjects:@"", nil];
    self.bids = [[NSMutableArray alloc] initWithObjects:@"No bid", nil];
    [pitchHandsTableView setDataSource:self];
    [pitchHandsTableView setDelegate:self];
    self.pointTargetControl.enabled = NO;
    //self.nextHandButton.enabled = NO;
}

- (void)viewDidUnload
{
    [self setPointTargetControl:nil];
    [self setSuitControl:nil];
    [self setBiddingTeam:nil];
    [self setPitchHandsTableView:nil];
    [self setPitchHandsTableView:nil];
    [self setPointStepperDisplay:nil];
    [self setPointStepper:nil];
    [self setNextHandButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
