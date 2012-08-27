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
@property (strong, nonatomic) NSMutableArray *team2Scores;
@property (strong, nonatomic) NSMutableArray *bids;
@property (weak, nonatomic) IBOutlet UISlider *pointSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *suitControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *biddingTeam;
@property (nonatomic) int currentBid;
 

@end

@implementation PitchViewController

@synthesize pitchHandsTableView;
@synthesize team1Scores = _team1Scores;
@synthesize team2Scores = _team2Scores;
@synthesize bids = _bids;
@synthesize pointTargetControl;
@synthesize pointSlider;
@synthesize suitControl;
@synthesize biddingTeam;
@synthesize currentBid = _currentBid;

- (IBAction)pointTargetSelected:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
        case 1:
            self.biddingTeam.enabled = NO;
            self.suitControl.enabled = NO;
            self.pointSlider.minimumValue = 0;
            break;
        case 2:
            self.biddingTeam.enabled = YES;
            self.suitControl.enabled = YES;
            self.pointSlider.minimumValue = 5;
            break;
    }
    
}

- (IBAction)pointsSelected:(UISlider *)sender {
    [self updateCurrentRow];
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
            if ([[self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex] isEqualToString:@"1"]) {
                if ((int)self.pointSlider.value >= self.currentBid) {
                    [self.team1Scores replaceObjectAtIndex:self.team1Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", (int)self.pointSlider.value]];
                    [self.team2Scores replaceObjectAtIndex:self.team2Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value]];
                } else {
                    [self.team1Scores replaceObjectAtIndex:self.team1Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 0 - self.currentBid]];
                    [self.team2Scores replaceObjectAtIndex:self.team2Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value]];
                }
            } else {
                if (13 - (int)self.pointSlider.value >= self.currentBid) {
                    [self.team1Scores replaceObjectAtIndex:self.team1Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", (int)self.pointSlider.value]];
                    [self.team2Scores replaceObjectAtIndex:self.team2Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value]];
                } else {
                    [self.team1Scores replaceObjectAtIndex:self.team1Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value]];
                    [self.team2Scores replaceObjectAtIndex:self.team2Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 0 - self.currentBid]];
                }
            }
            break;
        case 1:
            if ([[self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex] isEqualToString:@"2"]) {
                if ((int)self.pointSlider.value >= self.currentBid) {
                    [self.team2Scores replaceObjectAtIndex:self.team2Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", (int)self.pointSlider.value]];
                    [self.team1Scores replaceObjectAtIndex:self.team1Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value]];
                } else {
                    [self.team2Scores replaceObjectAtIndex:self.team2Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 0 - self.currentBid]];
                    [self.team1Scores replaceObjectAtIndex:self.team1Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value]];
                }
            } else {
                if (13 - (int)self.pointSlider.value >= self.currentBid) {
                    [self.team2Scores replaceObjectAtIndex:self.team2Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", (int)self.pointSlider.value]];
                    [self.team1Scores replaceObjectAtIndex:self.team1Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value]];
                } else {
                    [self.team2Scores replaceObjectAtIndex:self.team2Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value]];
                    [self.team1Scores replaceObjectAtIndex:self.team1Scores.count - 1 withObject:[NSString stringWithFormat:@"%d", 0 - self.currentBid]];
                }
            }
            break;
        case 2:
            self.currentBid = (int)self.pointSlider.value;
            [self.bids replaceObjectAtIndex:self.bids.count - 1 withObject:[NSString stringWithFormat:@"%d%@ (%@)", self.currentBid, [self.suitControl titleForSegmentAtIndex:self.suitControl.selectedSegmentIndex], [self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex]]];
            //self.bid.text = [NSString stringWithFormat:@"%d%@ (%@)", self.currentBid, [self.suitControl titleForSegmentAtIndex:self.suitControl.selectedSegmentIndex], [self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex]];
            break;
    }
    [pitchHandsTableView reloadData];
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
    cell.team2Score.text = [self.team2Scores objectAtIndex:[indexPath row]];
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
    self.team2Scores = [[NSMutableArray alloc] initWithObjects:@"0", nil];
    self.bids = [[NSMutableArray alloc] initWithObjects:@"No bids", nil];
    [pitchHandsTableView setDataSource:self];
    [pitchHandsTableView setDelegate:self];
    self.pointTargetControl.enabled = NO;
}

- (void)viewDidUnload
{
    [self setPointTargetControl:nil];
    [self setPointSlider:nil];
    [self setSuitControl:nil];
    [self setBiddingTeam:nil];
    [self setPitchHandsTableView:nil];
    [self setPitchHandsTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
