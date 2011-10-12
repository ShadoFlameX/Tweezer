//
//  TWZSettingsViewController.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "TWZSettingsViewController.h"
#import "TWZSettingPicker.h"
#import "TWZSourceEditorViewController.h"
#import "TWZSourcePreset.h"
#import "TWZConstants.h"
#import "UIColor+TweezerExtensions.h"

enum {
    TWZSettingsTableSectionSourcePresets,
    TWZSettingsTableSectionRandomMode,
    TWZSettingsTableSectionDisplay,
    TWZSettingsTableSectionCount
};

@implementation TWZSettingsViewController


#pragma mark - UserDefaults info

+ (NSDictionary *)dictionaryForUserDefaultsKey:(NSString *)key
{
    if ([key isEqualToString:TWZUserDefaultShuffleMode]) {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                NSLocalizedString(@"Off", @"shuffle setting name"),[NSNumber numberWithInt:0],
                NSLocalizedString(@"5 Minutes", @"shuffle setting name"),[NSNumber numberWithInt:5],
                NSLocalizedString(@"15 Minutes", @"shuffle setting name"),[NSNumber numberWithInt:15],
                NSLocalizedString(@"30 Minutes", @"shuffle setting name"),[NSNumber numberWithInt:30],
                NSLocalizedString(@"1 Hour", @"shuffle setting name"),[NSNumber numberWithInt:60],
                NSLocalizedString(@"4 Hours", @"shuffle setting name"),[NSNumber numberWithInt:240],
                NSLocalizedString(@"1 Day", @"shuffle setting name"),[NSNumber numberWithInt:1440],
                nil];
    }
    if ([key isEqualToString:TWZUserDefaultQuoteDuration]) {
        return [NSDictionary dictionaryWithObjectsAndKeys:
                NSLocalizedString(@"3 Seconds", @"quote duration setting name"),[NSNumber numberWithInt:3],
                NSLocalizedString(@"5 Seconds", @"quote duration setting name"),[NSNumber numberWithInt:5],
                NSLocalizedString(@"10 Seconds", @"quote duration setting name"),[NSNumber numberWithInt:10],
                NSLocalizedString(@"30 Seconds", @"quote duration setting name"),[NSNumber numberWithInt:30],
                NSLocalizedString(@"1 Minute", @"quote duration setting name"),[NSNumber numberWithInt:60],
                NSLocalizedString(@"5 Minutes", @"quote duration setting name"),[NSNumber numberWithInt:300],
                nil];
    }
    return nil;
}


#pragma mark - init

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"Settings", @"view title");

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    if (selectedIndexPath) {
        [self.tableView reloadData];
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
    
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - API

- (void)close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TWZSettingsTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TWZSettingsTableSectionSourcePresets) {
        return [TWZSourcePreset allPresets].count + 1;
    }
    if (section == TWZSettingsTableSectionRandomMode) {
        return 1;
    }
    if (section == TWZSettingsTableSectionDisplay) {
        return 1;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == TWZSettingsTableSectionSourcePresets) {
        return NSLocalizedString(@"Source Presets", @"Settings table header title");
    }
    if (section == TWZSettingsTableSectionDisplay) {
        return NSLocalizedString(@"Presentation", @"Settings table header title");
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TWZSettingsTableSectionSourcePresets) {
        if (indexPath.row < [TWZSourcePreset allPresets].count) {
            static NSString *CellIdentifier = @"SourcePresetCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                cell.textLabel.adjustsFontSizeToFitWidth = YES;
                cell.textLabel.minimumFontSize = 12.0f;
            }
            
            cell.textLabel.text = ((TWZSourcePreset *)[[TWZSourcePreset allPresets] objectAtIndex:indexPath.row]).name;
            cell.imageView.image = (indexPath.row == 0) ? [UIImage imageNamed:@"checkmark"] : nil; 
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
            
            return cell;
        }
        else {
            static NSString *CellIdentifier = @"SourcePresetAddCell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                cell.textLabel.textAlignment = UITextAlignmentCenter;
            }
            
            cell.textLabel.text = NSLocalizedString(@"Add Preset", @"settings cell title");
            cell.textLabel.textColor = [UIColor addSourcePresetTextColor];
            
            return cell;
        }
    }
    if (indexPath.section == TWZSettingsTableSectionRandomMode) {
        static NSString *CellIdentifier = @"RandomModeCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = NSLocalizedString(@"Shuffle Preset", @"Settings cell title");
        
        NSDictionary *shuffleSettings = [TWZSettingsViewController dictionaryForUserDefaultsKey:TWZUserDefaultShuffleMode];
        cell.detailTextLabel.text = [shuffleSettings objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:TWZUserDefaultShuffleMode]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    if (indexPath.section == TWZSettingsTableSectionDisplay) {
        static NSString *CellIdentifier = @"DisplayCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = NSLocalizedString(@"Duration", @"Settings cell title");
        NSDictionary *durationSettings = [TWZSettingsViewController dictionaryForUserDefaultsKey:TWZUserDefaultQuoteDuration];
        cell.detailTextLabel.text = [durationSettings objectForKey:[[NSUserDefaults standardUserDefaults] objectForKey:TWZUserDefaultQuoteDuration]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    
    return nil;
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    if (indexPath.section == TWZSettingsTableSectionSourcePresets)
    {
        if (indexPath.row < [TWZSourcePreset allPresets].count) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else {
            TWZSourceEditorViewController *sourceEditorVC = [[TWZSourceEditorViewController alloc] initWithNibName:@"TWZSourceEditorViewController" bundle:nil];
            [self.navigationController pushViewController:sourceEditorVC animated:YES];
            [sourceEditorVC release];
        }
    }
    if (indexPath.section == TWZSettingsTableSectionRandomMode)
    {
        TWZSettingPicker *settingPicker = [[TWZSettingPicker alloc] initWithUserDefaultsKey:TWZUserDefaultShuffleMode settings:[TWZSettingsViewController dictionaryForUserDefaultsKey:TWZUserDefaultShuffleMode] comparitor:^(NSNumber *num1, NSNumber *num2) {return [num1 compare:num2];}];
        settingPicker.title = NSLocalizedString(@"Shuffle Frequency", @"settings view title");
        [self.navigationController pushViewController:settingPicker animated:YES];
        [settingPicker release];
    }
    if (indexPath.section == TWZSettingsTableSectionDisplay)
    {
        TWZSettingPicker *settingPicker = [[TWZSettingPicker alloc] initWithUserDefaultsKey:TWZUserDefaultQuoteDuration settings:[TWZSettingsViewController dictionaryForUserDefaultsKey:TWZUserDefaultQuoteDuration] comparitor:^(NSNumber *num1, NSNumber *num2) {return [num1 compare:num2];}];
        settingPicker.title = NSLocalizedString(@"Quote Duration", @"settings view title");
        [self.navigationController pushViewController:settingPicker animated:YES];
        [settingPicker release];
    }
}

@end
