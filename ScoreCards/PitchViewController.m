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
@property (strong, nonatomic) IBOutlet UIStepper *pointStepper;
@property (strong, nonatomic) IBOutlet UILabel *pointStepperDisplay;
@property (weak, nonatomic) IBOutlet UILabel *biddingTeamControlLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *biddingTeamControl;
@property (weak, nonatomic) IBOutlet UILabel *suitControlLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *suitControl;
@property (strong, nonatomic) IBOutlet UIButton *nextHandButton;
@property (strong, nonatomic) IBOutlet UIButton *removeHandButton;
@property (strong, nonatomic) NSMutableArray *hands;
@property (nonatomic) int numberOfTeams;
@property (nonatomic) int biddingTeam;
@property (nonatomic) int currentBid;
@property (nonatomic) int currentPointValue;
 
@end

@implementation PitchViewController

@synthesize pitchHandsTableView = _pitchHandsTableView;
@synthesize numberOfPlayers = _numberOfPlayers;
@synthesize numberOfPointsPerHand = _numberOfPointsPerHand;
@synthesize teamPlay = _teamPlay;
@synthesize pointTargetControl = _pointTargetControl;
@synthesize pointStepper = _pointStepper;
@synthesize pointStepperDisplay = _pointStepperDisplay;
@synthesize biddingTeamControlLabel = _biddingTeamControlLabel;
@synthesize biddingTeamControl = _biddingTeamControl;
@synthesize suitControlLabel = _suitControlLabel;
@synthesize suitControl = _suitControl;
@synthesize nextHandButton = _nextHandButton;
@synthesize removeHandButton = _removeHandButton;
@synthesize hands = _hands;
@synthesize numberOfTeams = _numberOfTeams;
@synthesize biddingTeam = _biddingTeam;
@synthesize minimumBid = _minimumBid;
@synthesize currentBid = _currentBid;
@synthesize currentPointValue = _currentPointValue;

- (IBAction)pointTargetSelected:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex < sender.numberOfSegments - 1) {
        [self updateTeamControls];
        self.pointStepper.minimumValue = 0;
        self.pointStepper.value = [[[self.hands objectAtIndex:self.hands.count-1] objectForKey:[NSString stringWithFormat:@"Team%dScoreChange", self.pointTargetControl.selectedSegmentIndex+1]] intValue] >= 0 ? [[[self.hands objectAtIndex:self.hands.count-1] objectForKey:[NSString stringWithFormat:@"Team%dScoreChange", self.pointTargetControl.selectedSegmentIndex+1]] intValue] : 0;
        [self updateCurrentPointValue];
    } else {
        [self updateBidControls];

    }
}

- (void)updateCurrentPointValue {
    self.currentPointValue = (int)self.pointStepper.value;
    self.pointStepperDisplay.text = [NSString stringWithFormat:@"%d", self.currentPointValue];
}

- (IBAction)nextHandPressed {
    [self addHand];
    [self.pitchHandsTableView reloadData];
    [self.pitchHandsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.hands.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (IBAction)removeHandPressed {
    UIActionSheet *removeLastHandConfirmation = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to remove the current hand? This action cannot be undone." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Hand" otherButtonTitles:nil];
    [removeLastHandConfirmation setActionSheetStyle:UIActionSheetStyleDefault];
    [removeLastHandConfirmation showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self removeLastHand];
            [self.pitchHandsTableView reloadData];
            [self updateTeamControls];
            break;
        case 1:
            NSLog(@"Cancelled");
            break;
    }
}

- (IBAction)pointsChanged {
    [self updateCurrentPointValue];
    if (self.biddingTeamControl.selectedSegmentIndex >=0 && self.suitControl.selectedSegmentIndex >= 0) [self updateCurrentRow];
    if (self.pointTargetControl.selectedSegmentIndex != self.pointTargetControl.numberOfSegments-1) [self updateTeamControls];
}

- (IBAction)suitSelected:(UISegmentedControl *)sender {
    if (self.biddingTeamControl.selectedSegmentIndex >= 0) [self updateCurrentRow];
}

- (IBAction)biddingTeamSelected:(UISegmentedControl *)sender {
    self.biddingTeam = self.biddingTeamControl.selectedSegmentIndex+1;
    if (self.suitControl.selectedSegmentIndex >= 0) [self updateCurrentRow];
}

- (void)updateTeamControls {
    BOOL pointsScoredYet = NO;
    for (int i = 1; i <= self.numberOfTeams; i++) {
        if (![[[self.hands objectAtIndex:self.hands.count-1] objectForKey:[NSString stringWithFormat:@"Team%dScoreChange", i]] isEqualToString:@""]) {
            pointsScoredYet = YES;
        }
    }
    self.nextHandButton.hidden = NO;
    self.nextHandButton.alpha =  pointsScoredYet ? 1.0 : 0.5;
    self.removeHandButton.hidden = NO;
    self.removeHandButton.alpha = self.hands.count > 1 ? 1.0 : 0.5;
    self.biddingTeamControlLabel.hidden = YES;
    self.biddingTeamControl.hidden = YES;
    self.suitControlLabel.hidden = YES;
    self.suitControl.hidden = YES;
}

- (void)updateBidControls {
    self.nextHandButton.hidden = YES;
    self.removeHandButton.hidden = YES;
    self.biddingTeamControlLabel.hidden = NO;
    self.biddingTeamControl.hidden = NO;
    self.suitControlLabel.hidden = NO;
    self.suitControl.hidden = NO;
    self.pointStepper.minimumValue = self.minimumBid;
    self.pointStepper.value = self.currentBid;
}

- (void)updateCurrentRow {
    self.pointTargetControl.enabled = YES;
    
    if (self.pointTargetControl.selectedSegmentIndex < self.pointTargetControl.numberOfSegments - 1){
        for (int i = 1; i <= self.numberOfTeams; i++) {
            [self handleScoringForTeam:i selectedTeam:self.pointTargetControl.selectedSegmentIndex+1];
        }
    } else {
        self.currentBid = (int)self.pointStepper.value;
        [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d%@ (%d)", self.currentBid, [self.suitControl titleForSegmentAtIndex:self.suitControl.selectedSegmentIndex], self.biddingTeam] forKey:@"Bid"];
    }
    [self.pitchHandsTableView reloadData];
}

- (void)handleScoringForTeam:(int)team
                selectedTeam:(int)selectedTeam {
    
    NSString *teamScore = [NSString stringWithFormat:@"Team%dScore", team];
    NSString *teamScoreChange = [NSString stringWithFormat:@"Team%dScoreChange", team];
    
    int previousScore = self.hands.count > 1 ? [[[self.hands objectAtIndex:self.hands.count-2] objectForKey:teamScore] intValue] : 0;
    
    if (team != self.biddingTeam || (team == selectedTeam && self.currentPointValue >= self.currentBid) || (team != selectedTeam && self.numberOfPointsPerHand - self.currentPointValue >= self.currentBid)) {
        [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", previousScore + (team == selectedTeam ? self.currentPointValue : self.numberOfPointsPerHand - self.currentPointValue)] forKey:teamScore];
        [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"+%d", team == selectedTeam ? self.currentPointValue : self.numberOfPointsPerHand - self.currentPointValue] forKey:teamScoreChange];
    } else {
        [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", previousScore - self.currentBid] forKey:teamScore];
        [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", 0 - self.currentBid] forKey:teamScoreChange];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.hands.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"pitch2TeamTableCell";
    
    PitchHandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PitchHandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.team1Score.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team1Score"];
    cell.team1ScoreChange.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team1ScoreChange"];
    cell.team2Score.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team2Score"];
    cell.team2ScoreChange.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team2ScoreChange"];
    cell.bid.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Bid"];
    
    return cell;
}

- (void)addHand {
    self.currentBid = self.minimumBid;
    [self updateBidControls];
    self.pointTargetControl.selectedSegmentIndex = self.pointTargetControl.numberOfSegments - 1;
    self.pointTargetControl.enabled = NO;
    self.biddingTeamControl.selectedSegmentIndex = -1;
    self.suitControl.selectedSegmentIndex = -1;
    [self updateCurrentPointValue];
    
    [self.hands addObject:[[NSMutableDictionary alloc] init]];
    
    for (int i = 1; i <= self.numberOfTeams; i++) {
        if (self.hands.count == 1) [[self.hands objectAtIndex:self.hands.count-1] setObject:@"0" forKey:[NSString stringWithFormat:@"Team%dScore", i]];
        else [[self.hands objectAtIndex:self.hands.count-1] setObject:[[self.hands objectAtIndex:self.hands.count-2] objectForKey:[NSString stringWithFormat:@"Team%dScore", i]] forKey:[NSString stringWithFormat:@"Team%dScore", i]];
        [[self.hands objectAtIndex:self.hands.count-1] setObject:@"" forKey:[NSString stringWithFormat:@"Team%dScoreChange", i]];
    }
    [[self.hands objectAtIndex:self.hands.count-1] setObject:@"No bid" forKey:@"Bid"];
}

- (void)removeLastHand {
    if (self.hands.count > 1) [self.hands removeLastObject];
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
    self.numberOfTeams = self.teamPlay ? self.numberOfPlayers / 2 : self.numberOfPlayers;
    self.pointStepper.maximumValue = self.numberOfPointsPerHand;
    self.biddingTeam = 1;
    self.hands = [[NSMutableArray alloc] init];
    [self addHand];
    [self updateCurrentPointValue];
    [self.pitchHandsTableView setDataSource:self];
    [self.pitchHandsTableView setDelegate:self];
}

- (void)viewDidUnload
{
    [self setPointTargetControl:nil];
    [self setSuitControl:nil];
    [self setBiddingTeamControl:nil];
    [self setPitchHandsTableView:nil];
    [self setPitchHandsTableView:nil];
    [self setPointStepperDisplay:nil];
    [self setPointStepper:nil];
    [self setNextHandButton:nil];
    [self setSuitControlLabel:nil];
    [self setBiddingTeamControlLabel:nil];
    [self setRemoveHandButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
