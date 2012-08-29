//
//  PitchHandTableViewCell.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/27/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "PitchHandTableViewCell.h"

@implementation PitchHandTableViewCell

@synthesize team1Score = _team1Score;
@synthesize team1ScoreChange = _team1ScoreChange;
@synthesize team2Score = _team2Score;
@synthesize team2ScoreChange = _team2ScoreChange;
@synthesize team3Score = _team3Score;
@synthesize team3ScoreChange = _team3ScoreChange;
@synthesize team4Score = _team4Score;
@synthesize team4ScoreChange = _team4ScoreChange;
@synthesize team5Score = _team5Score;
@synthesize team5ScoreChange = _team5ScoreChange;
@synthesize team6Score = _team6Score;
@synthesize team6ScoreChange = _team6ScoreChange;
@synthesize bid = _bid;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
