//
//  PitchHandTableViewCell.h
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/27/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PitchHandTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *team1Score;
@property (strong, nonatomic) IBOutlet UILabel *team1ScoreChange;
@property (strong, nonatomic) IBOutlet UILabel *team2Score;
@property (strong, nonatomic) IBOutlet UILabel *team2ScoreChange;
@property (strong, nonatomic) IBOutlet UILabel *bid;

@end
