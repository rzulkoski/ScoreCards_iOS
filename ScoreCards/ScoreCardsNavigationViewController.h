//
//  ScoreCardsNavigationViewController.h
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/29/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreCardsNavigationViewController : UINavigationController <UIAlertViewDelegate, UINavigationBarDelegate>

@property (nonatomic) BOOL alertViewClicked;
@property (nonatomic) BOOL regularPop;

@end
