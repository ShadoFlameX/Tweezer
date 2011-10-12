//
//  TWZSettingPicker.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "TWZSettingPicker.h"
#import "UIColor+BHExtensions.h"

@implementation TWZSettingPicker

@synthesize defaultsKey = _defaultsKey;
@synthesize settings = _settings;
@synthesize keyComparitor = _keyComparitor;

- (id)initWithUserDefaultsKey:(NSString *)defaultsKey settings:(NSDictionary *)settings comparitor:(NSComparator)comparitor
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.defaultsKey = defaultsKey;
        self.settings = settings;
        self.keyComparitor = comparitor;
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

- (void)viewWillAppear:(BOOL)animated
{
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.settings allKeys].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    id key = [[[self.settings allKeys] sortedArrayUsingComparator:self.keyComparitor] objectAtIndex:indexPath.row];
    cell.textLabel.text = [self.settings objectForKey:key];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:self.defaultsKey] isEqual:key]) {
        cell.textLabel.textColor = [UIColor selectedTextColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
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
    id key = [[[self.settings allKeys] sortedArrayUsingComparator:self.keyComparitor] objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults] setObject:key forKey:self.defaultsKey];
    
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark && ![[self.tableView indexPathForCell:cell] isEqual:indexPath]) {
            // only reload the old checked cell if its visible and its not the same as the new one
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[self.tableView indexPathForCell:cell]] withRowAnimation:UITableViewRowAnimationNone];
            break;
        }
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
