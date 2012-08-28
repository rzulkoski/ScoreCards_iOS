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
@property (strong, nonatomic) NSMutableArray *hands;
@property (strong, nonatomic) IBOutlet UIStepper *pointStepper;
@property (strong, nonatomic) IBOutlet UILabel *pointStepperDisplay;
@property (weak, nonatomic) IBOutlet UISegmentedControl *suitControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *biddingTeam;
@property (strong, nonatomic) IBOutlet UIButton *nextHandButton;
@property (nonatomic) int currentBid;
@property (nonatomic) int numberOfTeams;
 

@end

@implementation PitchViewController

@synthesize pitchHandsTableView;
@synthesize hands = _hands;
@synthesize pointStepper;
@synthesize pointStepperDisplay;
@synthesize pointTargetControl;
@synthesize suitControl;
@synthesize biddingTeam;
@synthesize nextHandButton = _nextHandButton;
@synthesize currentBid = _currentBid;
@synthesize numberOfPlayers = _numberOfPlayers;
@synthesize teamPlay = _teamPlay;
@synthesize numberOfTeams = _numberOfTeams;

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
    [self addHand];
    [pitchHandsTableView reloadData];
    [pitchHandsTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.hands.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
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
    NSString *selectedTeam = [NSString stringWithFormat:@"%d", pointTargetControl.selectedSegmentIndex + 1];
    switch (pointTargetControl.selectedSegmentIndex) {
        case 0:
        case 1:
            [self handleScoringForTeam:@"1" selectedTeam:selectedTeam];
            [self handleScoringForTeam:@"2" selectedTeam:selectedTeam];
            break;
        case 2:
            self.currentBid = (int)self.pointStepper.value;
            [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d%@ (%@)", self.currentBid, [self.suitControl titleForSegmentAtIndex:self.suitControl.selectedSegmentIndex], [self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex]] forKey:@"Bid"];
            break;
    }
    [pitchHandsTableView reloadData];
}

- (void)handleScoringForTeam:(NSString *)team
                selectedTeam:(NSString *)selectedTeam {
    
    NSString *teamScore = [NSString stringWithFormat:@"Team%@Score", team];
    NSString *teamScoreChange = [NSString stringWithFormat:@"Team%@ScoreChange", team];
    
    int previousScore = 0;
    if (self.hands.count > 1) previousScore = [[[self.hands objectAtIndex:self.hands.count-2] objectForKey:teamScore] intValue];
    
    if ([team isEqualToString:[self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex]]) {
        if ([team isEqualToString:selectedTeam]) {
            if ((int)self.pointStepper.value >= self.currentBid) {
                [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", previousScore + (int)self.pointStepper.value] forKey:teamScore];
                [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"+%d", (int)self.pointStepper.value] forKey:teamScoreChange];
            } else {
                [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", previousScore - self.currentBid] forKey:teamScore];
                [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", 0 - self.currentBid] forKey:teamScoreChange];
            }
        } else {
            if (13 - (int)self.pointStepper.value >= self.currentBid) {
                [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", previousScore + 13 - (int)self.pointStepper.value] forKey:teamScore];
                [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"+%d", 13 - (int)self.pointStepper.value] forKey:teamScoreChange];
            } else {
                [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", previousScore - self.currentBid] forKey:teamScore];
                [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", 0 - self.currentBid] forKey:teamScoreChange];
            }
        }
    } else {
        if ([team isEqualToString:selectedTeam]) {
            [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", previousScore + (int)self.pointStepper.value] forKey:teamScore];
            [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"+%d", (int)self.pointStepper.value] forKey:teamScoreChange];
        } else {
            [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"%d", previousScore + 13 - (int)self.pointStepper.value] forKey:teamScore];
            [[self.hands objectAtIndex:self.hands.count-1] setObject:[NSString stringWithFormat:@"+%d", 13 - (int)self.pointStepper.value] forKey:teamScoreChange];
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
    [self.hands addObject:[[NSMutableDictionary alloc] init]];
    
    for (int i = 1; i <= self.numberOfTeams; i++) {
        if (self.hands.count == 1) [[self.hands objectAtIndex:self.hands.count-1] setObject:@"0" forKey:[NSString stringWithFormat:@"Team%dScore", i]];
        else [[self.hands objectAtIndex:self.hands.count-1] setObject:[[self.hands objectAtIndex:self.hands.count-2] objectForKey:[NSString stringWithFormat:@"Team%dScore", i]] forKey:[NSString stringWithFormat:@"Team%dScore", i]];
        [[self.hands objectAtIndex:self.hands.count-1] setObject:@"" forKey:[NSString stringWithFormat:@"Team%dScoreChange", i]];
    }
    [[self.hands objectAtIndex:self.hands.count-1] setObject:@"No bid" forKey:@"Bid"];
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
    self.hands = [[NSMutableArray alloc] init];
    [self addHand];
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
