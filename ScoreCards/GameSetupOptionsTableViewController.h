//
//  GameSetupOptionsTableViewController.h
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/29/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreCardsTableViewController.h"

@protocol GameSetupChoicesDelegate <NSObject>
- (void)setChoice:(int)choice forOption:(int)option;
@end

@interface GameSetupOptionsTableViewController : ScoreCardsTableViewController

@property (nonatomic, strong) id <GameSetupChoicesDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *choices;
@property (nonatomic, strong) NSArray *validChoices;
@property (nonatomic) int optionSelected;

@end
