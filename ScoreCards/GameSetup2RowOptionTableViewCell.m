//
//  GameSetup2RowOptionTableViewCell.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/29/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "GameSetup2RowOptionTableViewCell.h"

@implementation GameSetup2RowOptionTableViewCell

@synthesize optionTitle = _optionTitle;
@synthesize optionSubtitle = _optionSubtitle;
@synthesize optionValue = _optionValue;

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
