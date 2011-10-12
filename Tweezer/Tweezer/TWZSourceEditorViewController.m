//
//  TWZSourceEditorViewController.m
//  Tweezer
//
//  Created by Bryan Hansen on 10/10/11.
//  Copyright (c) 2011 Übermind, Inc. All rights reserved.
//

#import "TWZSourceEditorViewController.h"
#import "TWZSourceHeaderView.h"
#import "BHTextFieldCell.h"

enum {
    TWZSourceTableSectionBasics,
    TWZSourceTableSectionPeople,
    TWZSourceTableSectionKeywords,
    TWZSourceTableSectionCount
};

enum {
    TWZSourceTableSectionBasicsRowName,
    TWZSourceTableSectionBasicsRowCount
};

enum {
    TWZSourceTableSectionKeywordsRowMatching,
    TWZSourceTableSectionKeywordsRowAdd,
    TWZSourceTableSectionKeywordsRowCount
};

enum {
    TWZSourceTableSectionPeopleRowSource,
    TWZSourceTableSectionPeopleRowResponses,
    TWZSourceTableSectionPeopleRowRetweets,
    TWZSourceTableSectionPeopleRowCount
};

@interface TWZSourceEditorViewController ()
{
    TWZSourcePreset *_tempSourcePreset;
}
- (void)close:(id)sender;
- (void)save:(id)sender;

@property (nonatomic,retain) TWZSourcePreset *tempSourcePreset;

@end

@implementation TWZSourceEditorViewController

@synthesize sourcePreset = _sourcePreset;
@synthesize tempSourcePreset = _tempSourcePreset;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

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
    
    self.title = NSLocalizedString(@"New Preset", @"view controller title");
 
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(close:)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save:)];
    
    UIView *headerContainer = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.bounds.size.width, 96.0f)];
    TWZSourceHeaderView *headerView = [[TWZSourceHeaderView alloc] initWithFrame:CGRectMake(0.0f, -480.0f, self.view.bounds.size.width, 96.0f + 480.0f)];
    [headerContainer addSubview:headerView];
    self.tableView.tableHeaderView = headerContainer;
    [headerContainer release];
    [headerView release];
    
    self.sourcePreset = [[[TWZSourcePreset alloc] initWithName:nil] autorelease];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidUpdate:) name:UITextFieldTextDidChangeNotification object:nil];
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


#pragma mark - API

- (void)toggleIncludesRetweets:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    self.tempSourcePreset.includesRetweets = switchView.on;
}

- (void)toggleIncludesResponses:(id)sender {
    UISwitch *switchView = (UISwitch *)sender;
    self.tempSourcePreset.includesResponses = switchView.on;
}

- (void)close:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    BHTextFieldCell *nameCell = (BHTextFieldCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:TWZSourceTableSectionBasicsRowName inSection:TWZSourceTableSectionBasics]];
    
    if (![nameCell.textField.text length]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Name Required", @"alert title") message:NSLocalizedString(@"Please enter a name for this preset.", @"alert message") delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil];
        [alert show];
        [alert release];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:TWZSourceTableSectionBasicsRowName inSection:TWZSourceTableSectionBasics] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [nameCell.textField becomeFirstResponder];
        return;
    }
    
    self.sourcePreset.name = nameCell.textField.text;
    [self close:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return TWZSourceTableSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == TWZSourceTableSectionBasics)
    {
        return TWZSourceTableSectionBasicsRowCount;
    }
    if (section == TWZSourceTableSectionKeywords)
    {
        return self.tempSourcePreset.keywords.count + TWZSourceTableSectionKeywordsRowCount;
    }
    if (section == TWZSourceTableSectionPeople)
    {
        return TWZSourceTableSectionPeopleRowCount;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == TWZSourceTableSectionBasics)
    {
        if (indexPath.row == TWZSourceTableSectionBasicsRowName)
        {
            static NSString *CellIdentifier = @"BHTextFieldCell";
            
            BHTextFieldCell *cell = (BHTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[BHTextFieldCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.titleWidth = 0.0f;
            cell.textField.text = self.tempSourcePreset.name;
            cell.textField.placeholder = NSLocalizedString(@"Name", @"");
            cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            
            return cell;
        }
    }
    if (indexPath.section == TWZSourceTableSectionKeywords)
    {
        if (indexPath.row == TWZSourceTableSectionKeywordsRowMatching)
        {
            static NSString *CellIdentifier = @"BooleanCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.textLabel.text = NSLocalizedString(@"Keywords", @"");
            cell.detailTextLabel.text = [TWZSourcePreset nameForMatching:self.tempSourcePreset.matching];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
        if (self.tempSourcePreset.keywords.count && indexPath.row < self.tempSourcePreset.keywords.count + TWZSourceTableSectionKeywordsRowAdd)
        {
            static NSString *CellIdentifier = @"BHTextFieldCell";
            
            BHTextFieldCell *cell = (BHTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[BHTextFieldCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.titleWidth = 0.0f;
            cell.textField.text = [self.tempSourcePreset.keywords objectAtIndex:indexPath.row - 1];
            cell.textField.placeholder = NSLocalizedString(@"Add Keyword", @"");
            cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            cell.textField.delegate = self;
            
            return cell;
        }
        if (indexPath.row == self.tempSourcePreset.keywords.count + TWZSourceTableSectionKeywordsRowAdd)
        {
            static NSString *CellIdentifier = @"BHTextFieldCell";
            
            BHTextFieldCell *cell = (BHTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[BHTextFieldCell alloc] initWithReuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.titleWidth = 0.0f;
            cell.textField.placeholder = NSLocalizedString(@"Add Keyword", @"");
            cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
            cell.textField.delegate = self;
            
            return cell;
        }
    }
    if (indexPath.section == TWZSourceTableSectionPeople)
    {
        if (indexPath.row == TWZSourceTableSectionPeopleRowSource)
        {
            static NSString *CellIdentifier = @"SourceCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
            }
            
            cell.textLabel.text = NSLocalizedString(@"List", @"source editor cell title");
            cell.detailTextLabel.text = NSLocalizedString(@"Required", @"source editor cell placeholder value");
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            return cell;
        }
        if (indexPath.row == TWZSourceTableSectionPeopleRowRetweets)
        {
            static NSString *CellIdentifier = @"RecycleCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = NSLocalizedString(@"Include Retweets", @"source editor cell title");
            UISwitch *switchView = [[[UISwitch alloc] init] autorelease];
            [switchView addTarget:self action:@selector(toggleIncludesRetweets:) forControlEvents:UIControlEventValueChanged];
            switchView.on = self.tempSourcePreset.includesRetweets;
            cell.accessoryView = switchView;
            
            return cell;
        }
        if (indexPath.row == TWZSourceTableSectionPeopleRowResponses)
        {
            static NSString *CellIdentifier = @"RecycleCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.textLabel.text = NSLocalizedString(@"Include Responses", @"source editor cell title");
            UISwitch *switchView = [[[UISwitch alloc] init] autorelease];
            [switchView addTarget:self action:@selector(toggleIncludesResponses:) forControlEvents:UIControlEventValueChanged];
            switchView.on = self.tempSourcePreset.includesResponses;
            cell.accessoryView = switchView;
            
            return cell;
        }
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
    
}


#pragma mark - UITextField delegate & notifications

- (void)textFieldDidUpdate:(NSNotification *)notification {
    NSUInteger rowCount = [self.tableView numberOfRowsInSection:TWZSourceTableSectionKeywords];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rowCount - 1 inSection:TWZSourceTableSectionKeywords];
    BHTextFieldCell *cell = (BHTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textField isEqual:[notification object]] && [cell.textField.text length])
    {
        // this is the "new keyword" cell
        [self.tableView beginUpdates];
        [self.tempSourcePreset.keywords addObject:@""];
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSUInteger rowCount = [self.tableView numberOfRowsInSection:TWZSourceTableSectionKeywords];
    NSUInteger index;
    // skip first cell, its not a keyword cell
    for (index=1; index<rowCount; index++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:TWZSourceTableSectionKeywords];
        BHTextFieldCell *cell = (BHTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textField isEqual:textField])
        {
            if (index < rowCount - 1)
            {
                NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:index + 1 inSection:TWZSourceTableSectionKeywords];
                BHTextFieldCell *cell = (BHTextFieldCell *)[self.tableView cellForRowAtIndexPath:newIndexPath];
                [cell.textField becomeFirstResponder];
                [self.tableView selectRowAtIndexPath:newIndexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            }
        }
    }
    return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSUInteger rowCount = [self.tableView numberOfRowsInSection:TWZSourceTableSectionKeywords];
    NSUInteger index;
    // skip first cell, its not a keyword cell
    for (index=1; index<rowCount; index++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:TWZSourceTableSectionKeywords];
        BHTextFieldCell *cell = (BHTextFieldCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        if ([cell.textField isEqual:textField])
        {
            if (index < rowCount - 1)
            {
                // this is an actual keyword cell
                if (cell.textField.text.length)
                {
                    [self.tempSourcePreset.keywords replaceObjectAtIndex:indexPath.row - 1 withObject:cell.textField.text];
                }
                else 
                {
                    [self.tableView beginUpdates];
                    [self.tempSourcePreset.keywords removeObjectAtIndex:indexPath.row - 1];
                    [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
                    [self.tableView endUpdates];
                }
            }
        }
    }
}


#pragma mark - getter/setter

- (void)setSourcePreset:(TWZSourcePreset *)sourcePreset {
    [sourcePreset retain];
    [_sourcePreset release];
    _sourcePreset = sourcePreset;
    
    self.tempSourcePreset = [sourcePreset copy];
}

@end
