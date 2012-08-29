//
//  GameSetupTableViewController.m
//  ScoreCards
//
//  Created by Ryan Zulkoski on 8/29/12.
//  Copyright (c) 2012 RZGamer. All rights reserved.
//

#import "GameSetupTableViewController.h"
#import "GameSetup1RowOptionTableViewCell.h"
#import "GameSetup2RowOptionTableViewCell.h"

@interface GameSetupTableViewController ()

@property (nonatomic, strong) NSMutableArray *dataForTable;

@end

@implementation GameSetupTableViewController

@synthesize dataForTable = _dataForTable;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSString *)displayOptionValue:(int)row {
    NSString *optionValueDisplay = @"";
    NSString *optionValue = [[self.dataForTable objectAtIndex:row] objectForKey:@"OptionValue"];
    
    switch (row) {
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Init Options for Pitch
    self.dataForTable = [[NSMutableArray alloc] init];
    for (int row = 0; row < 4; row++) {
        [self.dataForTable addObject:[[NSMutableDictionary alloc] init]];
        switch (row) {
            case 0:
                [[self.dataForTable objectAtIndex:row] setObject:@"Players" forKey:@"OptionTitle"];
                [[self.dataForTable objectAtIndex:row] setObject:@"4" forKey:@"OptionValue"];
                [[self.dataForTable objectAtIndex:row] setObject:@"gameSetup1RowOptionTableCell" forKey:@"CellIdentifier"];
                break;
            case 1:
                [[self.dataForTable objectAtIndex:row] setObject:@"Points" forKey:@"OptionTitle"];
                [[self.dataForTable objectAtIndex:row] setObject:@"Per Hand" forKey:@"OptionSubtitle"];
                [[self.dataForTable objectAtIndex:row] setObject:@"13" forKey:@"OptionValue"];
                [[self.dataForTable objectAtIndex:row] setObject:@"gameSetup2RowOptionTableCell" forKey:@"CellIdentifier"];
                break;
            case 2:
                [[self.dataForTable objectAtIndex:row] setObject:@"Points" forKey:@"OptionTitle"];
                [[self.dataForTable objectAtIndex:row] setObject:@"Per Game" forKey:@"OptionSubtitle"];
                [[self.dataForTable objectAtIndex:row] setObject:@"104" forKey:@"OptionValue"];
                [[self.dataForTable objectAtIndex:row] setObject:@"gameSetup2RowOptionTableCell" forKey:@"CellIdentifier"];
                break;
            case 3:
                [[self.dataForTable objectAtIndex:row] setObject:@"Teams?" forKey:@"OptionTitle"];
                [[self.dataForTable objectAtIndex:row] setObject:@"Yes" forKey:@"OptionValue"];
                [[self.dataForTable objectAtIndex:row] setObject:@"gameSetup1RowOptionTableCell" forKey:@"CellIdentifier"];
                break;
        }
    }
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    int numRows = 0;
    switch (section) {
        case 0:
            numRows = self.dataForTable.count;
            break;
        case 1:
            numRows = 1;
            break;
    }
    return numRows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    if (section == 0) {
        title = @"Set the game rules.";
    }
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id cell = [tableView dequeueReusableCellWithIdentifier:@"gameSetupStartButtonTableCell"];
    if (indexPath.section == 0) {
        NSString *CellIdentifier = [[self.dataForTable objectAtIndex:indexPath.row] objectForKey:@"CellIdentifier"];
        if ([CellIdentifier isEqualToString:@"gameSetup1RowOptionTableCell"]) {
            GameSetup1RowOptionTableViewCell *oneRowOptionCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            oneRowOptionCell.optionTitle.text = [[self.dataForTable objectAtIndex:indexPath.row] objectForKey:@"OptionTitle"];
            oneRowOptionCell.optionValue.text = [self displayOptionValue:indexPath.row];
            cell = oneRowOptionCell;
        } else if ([CellIdentifier isEqualToString:@"gameSetup2RowOptionTableCell"]) {
            GameSetup2RowOptionTableViewCell *twoRowOptionCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            twoRowOptionCell.optionTitle.text = [[self.dataForTable objectAtIndex:indexPath.row] objectForKey:@"OptionTitle"];
            twoRowOptionCell.optionSubtitle.text = [[self.dataForTable objectAtIndex:indexPath.row] objectForKey:@"OptionSubtitle"];
            twoRowOptionCell.optionValue.text = [self displayOptionValue:indexPath.row];
            cell = twoRowOptionCell;
        }
    }
    
    return cell;
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
