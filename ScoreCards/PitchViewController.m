//
//  PitchViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/26/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "PitchViewController.h"

@interface PitchViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *pointTargetControl;
@property (weak, nonatomic) IBOutlet UILabel *team1Score;
@property (weak, nonatomic) IBOutlet UILabel *team2Score;
@property (weak, nonatomic) IBOutlet UILabel *bid;
@property (weak, nonatomic) IBOutlet UISlider *pointSlider;
@property (weak, nonatomic) IBOutlet UISegmentedControl *suitControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *biddingTeam;
@property (nonatomic) int currentBid;

@end

@implementation PitchViewController
@synthesize pointTargetControl;
@synthesize team1Score;
@synthesize team2Score;
@synthesize bid;
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
                    self.team1Score.text = [NSString stringWithFormat:@"%d", (int)self.pointSlider.value];
                    self.team2Score.text = [NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value];
                } else {
                    self.team1Score.text = [NSString stringWithFormat:@"%d", 0 - self.currentBid];
                    self.team2Score.text = [NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value];
                }
            } else {
                if (13 - (int)self.pointSlider.value >= self.currentBid) {
                    self.team1Score.text = [NSString stringWithFormat:@"%d", (int)self.pointSlider.value];
                    self.team2Score.text = [NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value];
                } else {
                    self.team1Score.text = [NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value];
                    self.team2Score.text = [NSString stringWithFormat:@"%d", 0 - self.currentBid];
                }
            }
            break;                                    
        case 1:
            if ([[self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex] isEqualToString:@"2"]) {
                if ((int)self.pointSlider.value >= self.currentBid) {
                    self.team2Score.text = [NSString stringWithFormat:@"%d", (int)self.pointSlider.value];
                    self.team1Score.text = [NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value];
                } else {
                    self.team2Score.text = [NSString stringWithFormat:@"%d", 0 - self.currentBid];
                    self.team1Score.text = [NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value];
                }
            } else {
                if (13 - (int)self.pointSlider.value >= self.currentBid) {
                    self.team2Score.text = [NSString stringWithFormat:@"%d", (int)self.pointSlider.value];
                    self.team1Score.text = [NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value];
                } else {
                    self.team2Score.text = [NSString stringWithFormat:@"%d", 13 - (int)self.pointSlider.value];
                    self.team1Score.text = [NSString stringWithFormat:@"%d", 0 - self.currentBid];
                }
            }
            break;
        case 2:
            self.currentBid = (int)self.pointSlider.value;
            self.bid.text = [NSString stringWithFormat:@"%d%@ (%@)", self.currentBid, [self.suitControl titleForSegmentAtIndex:self.suitControl.selectedSegmentIndex], [self.biddingTeam titleForSegmentAtIndex:self.biddingTeam.selectedSegmentIndex]];
            break;
    }
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
    self.pointTargetControl.enabled = NO;
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setTeam1Score:nil];
    [self setTeam2Score:nil];
    [self setBid:nil];
    [self setPointTargetControl:nil];
    [self setPointSlider:nil];
    [self setSuitControl:nil];
    [self setBiddingTeam:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
