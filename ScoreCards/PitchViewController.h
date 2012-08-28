//
//  PitchViewController.h
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/26/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PitchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UITableView *pitchHandsTableView;
@property (nonatomic) int numberOfPlayers;
@property (nonatomic) int numberOfPointsPerHand;
@property (nonatomic) int minimumBid;
@property (nonatomic) BOOL teamPlay;

@end