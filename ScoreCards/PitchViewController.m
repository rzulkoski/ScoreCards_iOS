//
//  PitchViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/26/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "PitchViewController.h"
#import "PitchHandTableViewCell.h"
#import "ScoreCardsNavigationViewController.h"
#import "UIViewController+WithScoreCardsBetaButton.h"
#include "Globals.h"

#define END_GAME_ALERT 0
#define GAME_OVER_ALERT 1

#define REMOVE_LAST_HAND_ACTIONSHEET 0

@interface PitchViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *pointTargetControl;
@property (strong, nonatomic) IBOutlet UIStepper *pointStepper;
@property (strong, nonatomic) IBOutlet UILabel *pointStepperDisplay;
@property (strong, nonatomic) IBOutlet UILabel *pointStepperLabel;
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
 
@end

@implementation PitchViewController

@synthesize pitchHandsTableView = _pitchHandsTableView;
@synthesize numberOfPlayers = _numberOfPlayers;
@synthesize teamNames = _teamNames;
@synthesize numberOfPointsPerHand = _numberOfPointsPerHand;
@synthesize numberOfPointsPerGame = _numberOfPointsPerGame;
@synthesize teamPlay = _teamPlay;
@synthesize pointTargetControl = _pointTargetControl;
@synthesize pointStepper = _pointStepper;
@synthesize pointStepperDisplay = _pointStepperDisplay;
@synthesize pointStepperLabel = _pointStepperLabel;
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

- (IBAction)pointTargetSelected:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == sender.numberOfSegments-1) {
        [self showBidControls];
    } else {
        [self showTeamControls];
        self.pointStepper.minimumValue = 0;
        self.pointStepper.value = [[[self.hands objectAtIndex:self.hands.count-1] objectForKey:[NSString stringWithFormat:@"Team%dPointsTaken", sender.selectedSegmentIndex+1]] intValue];
        [self updatePointStepperDisplay];
        [self adjustMaxPointsIfNeeded];
    }
}

- (void)adjustMaxPointsIfNeeded {
    if (self.numberOfTeams > 2 && self.pointTargetControl.selectedSegmentIndex != self.pointTargetControl.numberOfSegments-1) self.pointStepper.maximumValue = self.numberOfPointsPerHand - [self pointsScoredSoFar] + self.pointStepper.value;
}

- (void)updatePointStepperDisplay {
    self.pointStepperDisplay.text = [NSString stringWithFormat:@"%d", (int)self.pointStepper.value];
}

- (IBAction)nextHandPressed {
    if ([self.nextHandButton.currentTitle isEqualToString:@"Next Hand"]) { // Button is next hand
        [self addHand];
        [self.pitchHandsTableView reloadData];
        [self.pitchHandsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.hands.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    } else { // Button is end game
        UIAlertView *endGameAlert = [[UIAlertView alloc] initWithTitle:@"Are you sure you want to end the current game?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End Game", nil];
        endGameAlert.tag = END_GAME_ALERT;
        [endGameAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Entered PVC alertView clickedButtonAtIndex");
    if (alertView.tag == END_GAME_ALERT) {
        switch (buttonIndex) {
            case 0: // Cancel
                break;
            case 1: // End Game
                [self showGameOver];
                break;
        }
    } else if (alertView.tag == GAME_OVER_ALERT) {
        switch (buttonIndex) {
            case 0: { // OK
                ScoreCardsNavigationViewController *nvc = (ScoreCardsNavigationViewController *)self.navigationController;
                nvc.regularPop = YES;
                [self.navigationController popViewControllerAnimated:YES];
                break;
            }
        }
    } else if (alertView.tag == BETA_BUTTON_ALERT) {
        [super clickedBetaButtonAtIndex:buttonIndex];
    }
}

- (void)showGameOver {
    int highestScore = 0;
    int winningTeam = -1;
    for (int i = 1; i <= self.numberOfTeams; i++) {
        int currentTeamScore = [[[self.hands objectAtIndex:self.hands.count-1] objectForKey:[NSString stringWithFormat:@"Team%dScore", i]] intValue];
        if (currentTeamScore > highestScore) {
            winningTeam = i;
            highestScore = currentTeamScore;
        }
    }
    UIAlertView *gameOverAlert = [[UIAlertView alloc] initWithTitle:@"Game Over" message:[NSString stringWithFormat:@"Team %d Wins!!!", winningTeam] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    gameOverAlert.tag = GAME_OVER_ALERT;
    [gameOverAlert show];
}

- (IBAction)removeHandPressed {
    UIActionSheet *removeLastHandConfirmation = [[UIActionSheet alloc] initWithTitle:@"Are you sure you want to remove the current hand? This action cannot be undone." delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Hand" otherButtonTitles:nil];
    removeLastHandConfirmation.tag = REMOVE_LAST_HAND_ACTIONSHEET;
    [removeLastHandConfirmation setActionSheetStyle:UIActionSheetStyleDefault];
    [removeLastHandConfirmation showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == REMOVE_LAST_HAND_ACTIONSHEET) {
        switch (buttonIndex) {
            case 0: // Remove Hand
                [self removeLastHand];
                [self.pitchHandsTableView reloadData];
                [self showTeamControls];
                break;
            case 1: // Cancel
                break;
        }
    }
}

- (IBAction)pointsChanged {
    [self updatePointStepperDisplay];
    if (self.pointTargetControl.selectedSegmentIndex != self.pointTargetControl.numberOfSegments-1) { // If bidding not selected
        [self updateCurrentRow];
        [self adjustMaxPointsIfNeeded];
        [self showTeamControls]; 
    } else {  // Bidding control is selected
        if (self.biddingTeamControl.selectedSegmentIndex >= 0 && self.suitControl.selectedSegmentIndex >= 0) [self updateCurrentRow];
        if([self pointsScoredSoFar] > 0) {
            for (int i = 1; i <= self.numberOfTeams; i++) [self handleScoringForTeam:i];
        }
    }
}

- (IBAction)biddingTeamSelected:(UISegmentedControl *)sender {
    self.biddingTeam = self.biddingTeamControl.selectedSegmentIndex+1;
    [[self.hands objectAtIndex:self.hands.count-1] setObject:[UIImage imageNamed:[NSString stringWithFormat:@"team%d.png", self.biddingTeam]] forKey:@"BidTeam1"];
    if (self.suitControl.selectedSegmentIndex >= 0) [self updateCurrentRow];
}

- (void)updateCurrentRow {
    self.pointTargetControl.enabled = YES;
    
    if (self.pointTargetControl.selectedSegmentIndex == self.pointTargetControl.numberOfSegments - 1){ // If bidding control selected
        self.currentBid = (int)self.pointStepper.value;
        [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d   %@", self.currentBid, [self.teamNames objectAtIndex:self.biddingTeam-1]] forKey:@"Bid"];
    } else { // If team control selected
        for (int i = 1; i <= self.numberOfTeams; i++) [self handleScoringForTeam:i];
        [self checkIfGameOver];
    }
    [self.pitchHandsTableView reloadData];
}

- (void)checkIfGameOver {
    BOOL gameIsOver = NO;
    for (int i = 1; i <= self.numberOfTeams; i++) {
        if ([[[self.hands objectAtIndex:self.hands.count-1] objectForKey:[NSString stringWithFormat:@"Team%dScore", i]] intValue] >= self.numberOfPointsPerGame) gameIsOver = YES;
    }
    [self setNextHandButtonToGameOver:gameIsOver ? YES : NO];
}

- (void)setNextHandButtonToGameOver:(BOOL)gameIsOver {
    if (gameIsOver) {
        [self.nextHandButton setTitle:@"End Game" forState:UIControlStateNormal];
        [self.nextHandButton setTitle:@"End Game" forState:UIControlStateHighlighted];
        [self.nextHandButton setTitle:@"End Game" forState:UIControlStateDisabled];
        [self.nextHandButton setTitle:@"End Game" forState:UIControlStateSelected];
    } else {
        [self.nextHandButton setTitle:@"Next Hand" forState:UIControlStateNormal];
        [self.nextHandButton setTitle:@"Next Hand" forState:UIControlStateHighlighted];
        [self.nextHandButton setTitle:@"Next Hand" forState:UIControlStateDisabled];
        [self.nextHandButton setTitle:@"Next Hand" forState:UIControlStateSelected];
    }
}

- (void)handleScoringForTeam:(int)team {
    int selectedTeam = self.pointTargetControl.selectedSegmentIndex+1;
    int currentValue = (int)self.pointStepper.value;
    int currentHand = self.hands.count-1;
    NSString *teamScore = [NSString stringWithFormat:@"Team%dScore", team];
    NSStream *teamPointsTaken = [NSString stringWithFormat:@"Team%dPointsTaken", team];
    NSString *teamScoreChange = [NSString stringWithFormat:@"Team%dScoreChange", team];
    int previousScore = self.hands.count > 1 ? [[[self.hands objectAtIndex:self.hands.count-2] objectForKey:teamScore] intValue] : 0;
    NSString *currentScoreChange = [[self.hands objectAtIndex:currentHand] objectForKey:teamScoreChange];
    NSString *prevScorePlusCurScore = [NSString stringWithFormat:@"%d", previousScore + currentValue];
    NSString *prevScorePlusPointsTaken = [NSString stringWithFormat:@"%d", previousScore + [[[self.hands objectAtIndex:currentHand] objectForKey:teamPointsTaken] intValue]];
    NSString *prevScoreMinusBid = [NSString stringWithFormat:@"%d", previousScore - self.currentBid];
    NSString *prevScorePlusInvCurScore = [NSString stringWithFormat:@"%d", previousScore + self.numberOfPointsPerHand - currentValue];
    NSString *curValue = [NSString stringWithFormat:@"%d", currentValue];
    NSString *curValuePlus = [NSString stringWithFormat:@"+%d", currentValue];
    NSString *pointsTakenPlus = [NSString stringWithFormat:@"+%d", [[[self.hands objectAtIndex:currentHand] objectForKey:teamPointsTaken] intValue]];
    NSString *minusCurBid = [NSString stringWithFormat:@"%d", 0 - self.currentBid];
    NSString *invCurValue = [NSString stringWithFormat:@"%d", self.numberOfPointsPerHand - currentValue];
    NSString *invCurValuePlus = [NSString stringWithFormat:@"+%d", self.numberOfPointsPerHand - currentValue];
    
    if (self.pointTargetControl.selectedSegmentIndex == self.pointTargetControl.numberOfSegments-1) { // If bidding control selected
        if (team == self.biddingTeam) {
            if ([[[self.hands objectAtIndex:currentHand] objectForKey:teamPointsTaken] intValue] < self.currentBid) { // If team went set
                [[self.hands objectAtIndex:currentHand] setObject:prevScoreMinusBid forKey:teamScore];
                [[self.hands objectAtIndex:currentHand] setObject:minusCurBid forKey:teamScoreChange];
            } else {
                [[self.hands objectAtIndex:currentHand] setObject:prevScorePlusPointsTaken forKey:teamScore];
                [[self.hands objectAtIndex:currentHand] setObject:pointsTakenPlus forKey:teamScoreChange];
            }
        }
    }
    else { // If team control selected
        if (team == selectedTeam) {
            if (team == self.biddingTeam) {
                [[self.hands objectAtIndex:currentHand] setObject:currentValue >= self.currentBid ? prevScorePlusCurScore : prevScoreMinusBid forKey:teamScore];
                [[self.hands objectAtIndex:currentHand] setObject:currentValue >= self.currentBid ? curValuePlus : minusCurBid forKey:teamScoreChange];
            } else {
                [[self.hands objectAtIndex:currentHand] setObject:prevScorePlusCurScore forKey:teamScore];
                [[self.hands objectAtIndex:currentHand] setObject:curValuePlus forKey:teamScoreChange];
            }
            [[self.hands objectAtIndex:currentHand] setObject:curValue forKey:teamPointsTaken];
        } else if (self.numberOfTeams == 2 && self.numberOfPointsPerHand >=10) {
            if (team == self.biddingTeam) {
                [[self.hands objectAtIndex:currentHand] setObject:self.numberOfPointsPerHand - currentValue >= self.currentBid ? prevScorePlusInvCurScore : prevScoreMinusBid forKey:teamScore];
                [[self.hands objectAtIndex:currentHand] setObject:self.numberOfPointsPerHand - currentValue >= self.currentBid ? invCurValuePlus : minusCurBid forKey:teamScoreChange];
            } else {
                [[self.hands objectAtIndex:currentHand] setObject:prevScorePlusInvCurScore forKey:teamScore];
                [[self.hands objectAtIndex:currentHand] setObject:invCurValuePlus forKey:teamScoreChange];
            }
            [[self.hands objectAtIndex:currentHand] setObject:invCurValue forKey:teamPointsTaken];
        } else {
            if (team == self.biddingTeam && [[[self.hands objectAtIndex:currentHand] objectForKey:teamPointsTaken] intValue] < self.currentBid) [[self.hands objectAtIndex:currentHand] setObject:minusCurBid forKey:teamScoreChange];
            else [[self.hands objectAtIndex:currentHand] setObject:[currentScoreChange isEqualToString:@""] ? @"+0" : currentScoreChange forKey:teamScoreChange];
        }
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
    NSString *CellIdentifier = [NSString stringWithFormat:@"pitch%dTeamTableCell", self.numberOfTeams];
    
    PitchHandTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[PitchHandTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.team1Score.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team1Score"];
    cell.team1ScoreChange.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team1ScoreChange"];
    cell.team2Score.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team2Score"];
    cell.team2ScoreChange.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team2ScoreChange"];
    switch (self.numberOfTeams) {
        case 6:
            cell.team6Score.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team6Score"];
            cell.team6ScoreChange.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team6ScoreChange"];
        case 5:
            cell.team5Score.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team5Score"];
            cell.team5ScoreChange.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team5ScoreChange"];
        case 4:
            cell.team4Score.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team4Score"];
            cell.team4ScoreChange.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team4ScoreChange"];
        case 3:
            cell.team3Score.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team3Score"];
            cell.team3ScoreChange.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Team3ScoreChange"];
            break;
    }
    cell.bid.text = [[self.hands objectAtIndex:[indexPath row]] objectForKey:@"Bid"];
    
    return cell;
}

- (void)addHand {
    self.currentBid = self.minimumBid;
    [self showBidControls];
    self.pointTargetControl.selectedSegmentIndex = self.pointTargetControl.numberOfSegments - 1;
    self.pointTargetControl.enabled = NO;
    self.biddingTeamControl.selectedSegmentIndex = -1;
    self.suitControl.selectedSegmentIndex = -1;
    [self updatePointStepperDisplay];
    
    [self.hands addObject:[[NSMutableDictionary alloc] init]];
    
    for (int i = 1; i <= self.numberOfTeams; i++) {
        if (self.hands.count == 1) [[self.hands objectAtIndex:self.hands.count-1] setObject:@"0" forKey:[NSString stringWithFormat:@"Team%dScore", i]];
        else [[self.hands objectAtIndex:self.hands.count-1] setObject:[[self.hands objectAtIndex:self.hands.count-2] objectForKey:[NSString stringWithFormat:@"Team%dScore", i]] forKey:[NSString stringWithFormat:@"Team%dScore", i]];
        [[self.hands objectAtIndex:self.hands.count-1] setObject:@"0" forKey:[NSString stringWithFormat:@"Team%dPointsTaken", i]];
        [[self.hands objectAtIndex:self.hands.count-1] setObject:@"" forKey:[NSString stringWithFormat:@"Team%dScoreChange", i]];
    }
    [[self.hands objectAtIndex:self.hands.count-1] setObject:@"No bid" forKey:@"Bid"];
} // NEEDS A CHECKUP

- (void)removeLastHand {
    if (self.hands.count > 1) [self.hands removeLastObject];
}

- (int)pointsScoredSoFar {
    int pointsScoredSoFar = 0;
    for (int i = 1; i <= self.numberOfTeams; i++) {
        pointsScoredSoFar += [[[self.hands objectAtIndex:self.hands.count-1] objectForKey:[NSString stringWithFormat:@"Team%dPointsTaken", i]] intValue];
    }
    return pointsScoredSoFar;
}

- (void)showTeamControls {
    self.nextHandButton.hidden = NO;
    if ([self pointsScoredSoFar] > 0 && (self.numberOfTeams == 2 || [self pointsScoredSoFar] >= 3)) {
        self.nextHandButton.alpha = 1.0;
        self.nextHandButton.enabled = YES;
    } else {
        self.nextHandButton.alpha = 0.5;
        self.nextHandButton.enabled = NO;
    }
    self.removeHandButton.hidden = NO;
    self.removeHandButton.alpha = self.hands.count > 1 ? 1.0 : 0.5;
    self.removeHandButton.enabled = self.hands.count > 1 ? YES : NO;
    self.pointStepperLabel.text = @"Points scored:";
    self.biddingTeamControlLabel.hidden = YES;
    self.biddingTeamControl.hidden = YES;
    self.suitControlLabel.hidden = YES;
    self.suitControl.hidden = YES;
}

- (void)showBidControls {  
    self.nextHandButton.hidden = YES;
    self.removeHandButton.hidden = YES;
    self.biddingTeamControlLabel.hidden = NO;
    self.biddingTeamControl.hidden = NO;
    self.suitControlLabel.hidden = NO;
    self.suitControl.hidden = NO;
    self.pointStepperLabel.text = @"Bid:";
    self.pointStepper.minimumValue = self.minimumBid;
    self.pointStepper.maximumValue = self.numberOfPointsPerHand;
    self.pointStepper.value = self.currentBid;
    [self updatePointStepperDisplay];
}

- (void)startNewGame {
    self.pointStepper.maximumValue = self.numberOfPointsPerHand;
    if (!self.hands) self.hands = [[NSMutableArray alloc] init];
    else [self.hands removeAllObjects];
    [self addHand];
    if (self.numberOfTeams > 2) {
        for (int i = 0; i < self.numberOfTeams; i++) {
            if (i > 1) {
                [self.pointTargetControl insertSegmentWithTitle:[NSString stringWithFormat:@"P%d", i+1] atIndex:i animated:NO];
                [self.biddingTeamControl insertSegmentWithTitle:[NSString stringWithFormat:@"%d", i+1] atIndex:i animated:NO];
            }
            else [self.pointTargetControl setTitle:[NSString stringWithFormat:@"P%d", i+1] forSegmentAtIndex:i];
        }
    }
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureScoreCardsBetaButton];
    if (!self.teamPlay) self.teamNames = [[NSArray alloc] initWithObjects:@"P1", @"P2", @"P3", @"P4", @"P5", @"P6", nil]; // TEMPORARY FOR FIRST BETA TEST
    self.numberOfTeams = self.teamPlay ? self.numberOfPlayers / 2 : self.numberOfPlayers;
    [self startNewGame];
    for (int i = 0; i < self.numberOfTeams; i++) {
        [self.pointTargetControl setTitle:[self.teamNames objectAtIndex:i] forSegmentAtIndex:i];
        [self.biddingTeamControl setTitle:[self.teamNames objectAtIndex:i] forSegmentAtIndex:i];
    }
    [self.suitControl setImage:[UIImage imageNamed:@"spade.png"] forSegmentAtIndex:0];
    [self.suitControl setImage:[UIImage imageNamed:@"diamond.png"] forSegmentAtIndex:1];
    [self.suitControl setImage:[UIImage imageNamed:@"club.png"] forSegmentAtIndex:2];
    [self.suitControl setImage:[UIImage imageNamed:@"heart.png"] forSegmentAtIndex:3];
    [self.pitchHandsTableView setDataSource:self];
    [self.pitchHandsTableView setDelegate:self];
}

- (void)viewDidUnload {
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
    [self setPointStepperLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
