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
@synthesize team2Score = _team2Score;
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
