//
//  PitchViewController.h
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/26/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreCardsViewController.h"

@interface PitchViewController : ScoreCardsViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>
//@interface PitchViewController : ScoreCardsTableViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *pitchHandsTableView;
@property (nonatomic) int numberOfPlayers;
@property (nonatomic) NSArray *teamNames;
@property (nonatomic) int numberOfPointsPerHand;
@property (nonatomic) int numberOfPointsPerGame;
@property (nonatomic) int minimumBid;
@property (nonatomic) BOOL teamPlay;

@end