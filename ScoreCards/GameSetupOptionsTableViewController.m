//
//  GameSetupOptionsTableViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/29/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "GameSetupOptionsTableViewController.h"
#import "GameSetupOptionChoicesTableViewCell.h"
#import "ScoreCardsNavigationViewController.h"

@interface GameSetupOptionsTableViewController ()

@end

@implementation GameSetupOptionsTableViewController

@synthesize delegate = _delegate;
@synthesize optionSelected = _optionSelected;
@synthesize choices = _choices;
@synthesize validChoices = _validChoices;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// #pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.choices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"optionCell";
    GameSetupOptionChoicesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell.optionChoice.text = [self.choices objectAtIndex:indexPath.row];
    if (![self.validChoices containsObject:[NSString stringWithFormat:@"%d", indexPath.row]]) {
        [cell setUserInteractionEnabled:NO];
        cell.optionChoice.textColor = [UIColor grayColor];
    } else {
        [cell setUserInteractionEnabled:YES];
        cell.optionChoice.textColor = [[UIColor alloc] initWithRed:0.0 green:(128.0/255.0) blue:1.0 alpha:1.0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate setChoice:indexPath.row forOption:self.optionSelected];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
