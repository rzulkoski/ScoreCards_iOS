//
//  GameSetupTableViewController.h
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/29/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameSetupOptionsTableViewController.h"

@interface GameSetupTableViewController : UITableViewController <GameSetupChoicesDelegate>

- (void)setChoice:(int)choice forOption:(int)option;

@end
