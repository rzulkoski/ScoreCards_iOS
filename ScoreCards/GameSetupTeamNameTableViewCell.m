//
//  GameSetupTeamNameTableViewCell.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/30/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "GameSetupTeamNameTableViewCell.h"

@implementation GameSetupTeamNameTableViewCell

@synthesize teamName;

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
