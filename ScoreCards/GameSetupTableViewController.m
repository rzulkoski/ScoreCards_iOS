//
//  GameSetupTableViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/29/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "GameSetupTableViewController.h"
#import "GameSetupOptionsTableViewController.h"
#import "GameSetup1RowOptionTableViewCell.h"
#import "GameSetup2RowOptionTableViewCell.h"
#import "GameSetupTeamNameTableViewCell.h"
#import "PitchViewController.h"

@interface GameSetupTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataForTable;
@property (nonatomic) int numberOfOptions;

@end

@implementation GameSetupTableViewController

@synthesize dataForTable = _dataForTable;
@synthesize numberOfOptions = _numberOfOptions;

- (void)setChoice:(int)choice forOption:(int)option {
    NSLog(@"Option=%d Choice=%d selected.", option, choice);
    [[self.dataForTable objectAtIndex:option] setObject:[NSString stringWithFormat:@"%d", choice] forKey:@"OptionValueIndex"];
    [self validateChoices];
}

- (void)validateChoices {
    NSArray *validChoices;
    NSString *temp = @"Valid Choices for Option";
    for (int i = 0; i < self.numberOfOptions; i++) {
        int j = 0;
        validChoices = [self getValidChoicesForOption:i];
        if (j == 0) temp = [NSString stringWithFormat:@"Valid Choices for Option%d=", i];
        while (j < validChoices.count) {
            temp = [temp stringByAppendingFormat:@"%@,", [validChoices objectAtIndex:j]];
            j++;
        }
        if (![validChoices containsObject:[[self.dataForTable objectAtIndex:i] objectForKey:@"OptionValueIndex"]]) {
            NSLog(@"Defaulted. Their choice was=%d", [[[self.dataForTable objectAtIndex:i] objectForKey:@"OptionValueIndex"] intValue]);
            [[self.dataForTable objectAtIndex:i] setObject:[validChoices objectAtIndex:0] forKey:@"OptionValueIndex"];
        }
        NSLog(@"%@", temp);
    }
    [self.tableView reloadData];
}

- (NSArray *)getValidChoicesForOption:(int)option {
    NSMutableArray *validChoices = [[NSMutableArray alloc] init];
    //BOOL teamPlay = [[[self.dataForTable objectAtIndex:3] objectForKey:@"OptionValueIndex"] isEqualToString:@"0"] ? YES : NO;
    // TEMPORARILY DISABLED FOR FIRST BETA TEST
    // int optionValuesLengthForOption = [[[self.dataForTable objectAtIndex:option] objectForKey:@"OptionValues"] count];
    switch (option) {
        case 0: // For Number of Players
            [validChoices addObjectsFromArray:[[NSArray alloc] initWithObjects:@"0", @"1", @"2", @"4", nil]]; // TEMPORARY FOR FIRST BETA TEST
            //for (int i = 0; i < optionValuesLengthForOption; i++) [validChoices addObject:[NSString stringWithFormat:@"%d", i]]; // Return all choices
            break;
        case 1: // For Number of Points Per Hand
            switch ([[[self.dataForTable objectAtIndex:0] objectForKey:@"OptionValueIndex"] intValue]) { // Number of Players
                case 2: // 4 Players
                case 3: // 5 Players
                case 4: // 6 Players
                    //if (teamPlay) {
                        [validChoices addObject:@"2"]; // 10 Point
                        [validChoices addObject:@"3"]; // 13 Point
                        [validChoices addObject:@"4"]; // 14 Point
                    //    break;
                    //}
                case 0: // 2 Players
                case 1: // 3 Players
                    [validChoices addObject:@"0"]; // 4 Point
                    [validChoices addObject:@"1"]; // 5 Point
                    break;
                //case 3: // 5 Players
                //    for (int i = 0; i < optionValuesLengthForOption; i++) [validChoices addObject:[NSString stringWithFormat:@"%d", i]]; // Return all choices
                //    break;
            }
            break;
        case 2: // For Number of Points Per Game
            switch ([[[self.dataForTable objectAtIndex:1] objectForKey:@"OptionValueIndex"] intValue]) { // Number of Points Per Hand
                case 0: // 4 Point
                case 1: // 5 Point
                    [validChoices addObject:@"0"]; // 11 Points
                    [validChoices addObject:@"1"]; // 15 Points
                    [validChoices addObject:@"2"]; // 21 Points
                    break;
                case 2: // 10 Point
                case 3: // 13 Point
                case 4: // 14 Point
                    [validChoices addObject:@"3"]; // 52 Points
                    [validChoices addObject:@"4"]; // 104 Points
                    break;
            }
            break;
        case 3: // For Team Play
            switch ([[[self.dataForTable objectAtIndex:0] objectForKey:@"OptionValueIndex"] intValue]) { // Number of Players
                case 2: // 4 Players
                case 4: // 6 Players
                    [validChoices addObject:@"0"]; // Yes
                    //break;  // TEMPORARY FOR FIRST BETA TEST
                    // TEMPORARILY DISABLED FOR FIRST BETA TEST
                    // If playing 10/13/14 Point with 4/6 Players, force TeamPlay to Yes.
                    //if ([[[NSArray alloc] initWithObjects:@"2", @"3", @"4", nil] containsObject:[[self.dataForTable objectAtIndex:1] objectForKey:@"OptionValueIndex"]]) break;
                case 0: // 2 Players
                case 1: // 3 Players
                case 3: // 5 Players
                    [validChoices addObject:@"1"]; // No
                    break;
            }
            
    }
    return [[NSArray alloc] initWithArray:validChoices];
}

- (NSString *)displaySelectedValueForOption:(int)option {
    int optionValueIndex = [[[self.dataForTable objectAtIndex:option] objectForKey:@"OptionValueIndex"] intValue];
    return [self displayValueNumber:optionValueIndex forOption:option];
}

- (NSString *)displayValueNumber:(int)valueNum forOption:(int)option {
    NSString *optionValueDisplay;
    NSString *optionValue = [[[self.dataForTable objectAtIndex:option] objectForKey:@"OptionValues"] objectAtIndex:valueNum];
    switch (option) {
        case 0:
            optionValueDisplay = [NSString stringWithFormat:@"%@ Players", optionValue];
            break;
        case 1:
        case 2:
            optionValueDisplay = [NSString stringWithFormat:@"%@ Points", optionValue];
            break;
        case 3:
            optionValueDisplay = optionValue;
            break;
    }
    return optionValueDisplay;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *path = [self.tableView indexPathForSelectedRow];
    if ([segue.identifier isEqualToString:@"showPitch"]) {
        PitchViewController *vc = [segue destinationViewController];
        vc.numberOfPlayers = [[[[self.dataForTable objectAtIndex:0] objectForKey:@"OptionValues"] objectAtIndex:[[[self.dataForTable objectAtIndex:0] objectForKey:@"OptionValueIndex"] intValue]] intValue];
        vc.teamNames = [[self.dataForTable objectAtIndex:0] objectForKey:@"TeamNames"];
        vc.numberOfPointsPerHand = [[[[self.dataForTable objectAtIndex:1] objectForKey:@"OptionValues"] objectAtIndex:[[[self.dataForTable objectAtIndex:1] objectForKey:@"OptionValueIndex"] intValue]] intValue];
        vc.numberOfPointsPerGame = [[[[self. dataForTable objectAtIndex:2] objectForKey:@"OptionValues"] objectAtIndex:[[[self.dataForTable objectAtIndex:2] objectForKey:@"OptionValueIndex"] intValue]] intValue];
        switch (vc.numberOfPointsPerHand) {
            case 4:
            case 5:
                vc.minimumBid = 2;
                break;
            case 10:
                vc.minimumBid = 4;
                break;
            case 13:
            case 14:
                vc.minimumBid = 5;
                break;
        }
        vc.teamPlay = [[[[self.dataForTable objectAtIndex:3] objectForKey:@"OptionValues"] objectAtIndex:[[[self.dataForTable objectAtIndex:3] objectForKey:@"OptionValueIndex"] intValue]] isEqualToString:@"Yes"] ? YES : NO;
    } else if([segue.identifier isEqualToString:@"show1RowOptionChoices"] || [segue.identifier isEqualToString:@"show2RowOptionChoices"]) {
        GameSetupOptionsTableViewController *vc = [segue destinationViewController];
        vc.delegate = self;
        vc.optionSelected = path.row;
        vc.title = [[self.dataForTable objectAtIndex:path.row] objectForKey:@"OptionTitle"];
        if ([segue.identifier isEqualToString:@"show2RowOptionChoices"]) vc.title = [vc.title stringByAppendingFormat:@" %@", [[self.dataForTable objectAtIndex:path.row] objectForKey:@"OptionSubtitle"]];
        vc.choices = [[NSMutableArray alloc] init];
        vc.validChoices = [self getValidChoicesForOption:path.row];
        for (int i = 0; i < [[[self.dataForTable objectAtIndex:path.row] objectForKey:@"OptionValues"] count]; i++) [vc.choices addObject:[self displayValueNumber:i forOption:path.row]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Init Options for Pitch
    self.numberOfOptions = 4;
    self.title = @"Pitch Setup";
    self.dataForTable = [[NSMutableArray alloc] init];
    for (int row = 0; row < self.numberOfOptions; row++) {
        [self.dataForTable addObject:[[NSMutableDictionary alloc] init]];
        switch (row) {
            case 0:
                [[self.dataForTable objectAtIndex:row] setObject:@"Players" forKey:@"OptionTitle"];
                [[self.dataForTable objectAtIndex:row] setObject:[[NSArray alloc] initWithObjects:@"2", @"3", @"4", @"5", @"6", nil] forKey:@"OptionValues"];
                [[self.dataForTable objectAtIndex:row] setObject:[[NSArray alloc] initWithObjects:@"Team 1", @"Team 2", @"Team 3", @"Team 4", @"Team 5", @"Team 6", nil] forKey:@"TeamNames"];
                [[self.dataForTable objectAtIndex:row] setObject:@"2" forKey:@"OptionValueIndex"];
                [[self.dataForTable objectAtIndex:row] setObject:@"gameSetup1RowOptionTableCell" forKey:@"CellIdentifier"];
                break;
            case 1:
                [[self.dataForTable objectAtIndex:row] setObject:@"Points" forKey:@"OptionTitle"];
                [[self.dataForTable objectAtIndex:row] setObject:@"Per Hand" forKey:@"OptionSubtitle"];
                [[self.dataForTable objectAtIndex:row] setObject:[[NSArray alloc] initWithObjects:@"4", @"5", @"10", @"13", @"14", nil] forKey:@"OptionValues"];
                [[self.dataForTable objectAtIndex:row] setObject:@"2" forKey:@"OptionValueIndex"];
                [[self.dataForTable objectAtIndex:row] setObject:@"gameSetup2RowOptionTableCell" forKey:@"CellIdentifier"];
                break;
            case 2:
                [[self.dataForTable objectAtIndex:row] setObject:@"Points" forKey:@"OptionTitle"];
                [[self.dataForTable objectAtIndex:row] setObject:@"Per Game" forKey:@"OptionSubtitle"];
                [[self.dataForTable objectAtIndex:row] setObject:[[NSArray alloc] initWithObjects:@"11", @"15", @"21", @"52", @"104", nil] forKey:@"OptionValues"];
                [[self.dataForTable objectAtIndex:row] setObject:@"3" forKey:@"OptionValueIndex"];
                [[self.dataForTable objectAtIndex:row] setObject:@"gameSetup2RowOptionTableCell" forKey:@"CellIdentifier"];
                break;
            case 3:
                [[self.dataForTable objectAtIndex:row] setObject:@"Teams?" forKey:@"OptionTitle"];
                [[self.dataForTable objectAtIndex:row] setObject:[[NSArray alloc] initWithObjects:@"Yes", @"No", nil] forKey:@"OptionValues"];
                [[self.dataForTable objectAtIndex:row] setObject:@"0" forKey:@"OptionValueIndex"];
                [[self.dataForTable objectAtIndex:row] setObject:@"gameSetup1RowOptionTableCell" forKey:@"CellIdentifier"];
                break;
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// #pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    int numRows = 0;
    switch (section) {
        case 0: {
            numRows = self.dataForTable.count;
            
        }
        break;
        case 1: {
            // TEMPORARILY DISABLED FOR FIRST BETA TEST
            //int numPlayersIndex = [[[self.dataForTable objectAtIndex:0] objectForKey:@"OptionValueIndex"] intValue];
            //int numPlayers = [[[[self.dataForTable objectAtIndex:0] objectForKey:@"OptionValues"] objectAtIndex:numPlayersIndex] intValue];
            //BOOL teamPlay = [[[self.dataForTable objectAtIndex:3] objectForKey:@"OptionValueIndex"] isEqualToString:@"0"] ? YES : NO;
            //numRows = teamPlay ? numPlayers / 2 : numPlayers;
            numRows = 0; // TEMPORARY FOR FIRST BETA TEST
        }
        break;
        case 2: {
            numRows = 1;
        }
        break;
    }
    return numRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    switch (section) {
        case 0:
            title = @"Set the game rules.";
            break;
        case 1:
            // TEMPORARILY DISABLED FOR FIRST BETA TEST
            //title = [[[self.dataForTable objectAtIndex:3] objectForKey:@"OptionValueIndex"] isEqualToString:@"0"] ? @"Edit team names." : @"Edit player names.";
            title = @""; // TEMPORARY FOR FIRST BETA TEST
            break;
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    NSString *CellIdentifier = nil;
    switch (indexPath.section) {
        case 0: {
            CellIdentifier = [[self.dataForTable objectAtIndex:indexPath.row] objectForKey:@"CellIdentifier"];
            NSArray *validChoices = [self getValidChoicesForOption:indexPath.row];
            if ([CellIdentifier isEqualToString:@"gameSetup1RowOptionTableCell"]) {
                GameSetup1RowOptionTableViewCell *oneRowOptionCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                oneRowOptionCell.optionTitle.text = [[self.dataForTable objectAtIndex:indexPath.row] objectForKey:@"OptionTitle"];
                oneRowOptionCell.optionValue.text = [self displaySelectedValueForOption:indexPath.row];
                if (validChoices.count < 2) {
                    [oneRowOptionCell setUserInteractionEnabled:NO];
                    oneRowOptionCell.optionValue.textColor = [UIColor grayColor];
                    oneRowOptionCell.accessoryType = UITableViewCellAccessoryNone;
                } else {
                    [oneRowOptionCell setUserInteractionEnabled:YES];
                    oneRowOptionCell.optionValue.textColor = [[UIColor alloc] initWithRed:0.0 green:(128.0/255.0) blue:1.0 alpha:1.0];
                    oneRowOptionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell = oneRowOptionCell;
            } else if ([CellIdentifier isEqualToString:@"gameSetup2RowOptionTableCell"]) {
                GameSetup2RowOptionTableViewCell *twoRowOptionCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                twoRowOptionCell.optionTitle.text = [[self.dataForTable objectAtIndex:indexPath.row] objectForKey:@"OptionTitle"];
                twoRowOptionCell.optionSubtitle.text = [[self.dataForTable objectAtIndex:indexPath.row] objectForKey:@"OptionSubtitle"];
                twoRowOptionCell.optionValue.text = [self displaySelectedValueForOption:indexPath.row];
                if (validChoices.count < 2) {
                    [twoRowOptionCell setUserInteractionEnabled:NO];
                    twoRowOptionCell.optionValue.textColor = [UIColor grayColor];
                    twoRowOptionCell.accessoryType = UITableViewCellAccessoryNone;
                } else {
                    [twoRowOptionCell setUserInteractionEnabled:YES];
                    twoRowOptionCell.optionValue.textColor = [[UIColor alloc] initWithRed:0.0 green:(128.0/255.0) blue:1.0 alpha:1.0];
                    twoRowOptionCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell = twoRowOptionCell;
            }
        }
        break;
        case 1: {
            GameSetupTeamNameTableViewCell *teamNameCell = [tableView dequeueReusableCellWithIdentifier:@"teamNameCell"];
            teamNameCell.teamName.text = [[[self.dataForTable objectAtIndex:0] objectForKey:@"TeamNames"] objectAtIndex:indexPath.row];
            cell = teamNameCell;
        }
        break;
        case 2: {
            cell = [tableView dequeueReusableCellWithIdentifier:@"gameSetupStartButtonTableCell"];
        }
        break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

// #pragma mark - Table view delegate

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

@end
