//==============================================================================
//
//  ITImageEffectsController.m
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "ITFilterListController.h"
#import "ITImageFilterUtils.h"
#import "ITFilterEditorController.h"
#import "ITFilter.h"

@interface ITFilterListController() {
@private
    UITableView* categoriesTableView;
    NSMutableDictionary* categories;
}

@property (nonatomic , copy) ITFilterSelectionBlock filterSelectionCallbackBlock;

@property (nonatomic, copy) ITFilterEditingBlock editingCallbackBlock;

@end

@implementation ITFilterListController
@synthesize filterSelectionCallbackBlock;
@synthesize editingCallbackBlock = _editingCallbackBlock;

- (id)initWithFilters:(NSArray*) filtersArray filterSelectionBlock:(ITFilterSelectionBlock)callbackBlock filterEditingBlock:(ITFilterEditingBlock)editingCallbackBlock
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.filterSelectionCallbackBlock = callbackBlock;
        
        self.editingCallbackBlock = editingCallbackBlock;
        
        categories = [[NSMutableDictionary alloc] init];
        [categories setObject: [ITImageFilterUtils FilterDictionaryForFilters:filtersArray] forKey: @"Filters"];
        
        /*
        array = [NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:kCICategoryColorEffect]];
        [categories setObject: [PGImageFilterUtils FilterDictionaryForFilters:array] forKey: @"Color Effect"];
       
        array = [NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:kCICategoryDistortionEffect]];
        [categories setObject: [PGImageFilterUtils FilterDictionaryForFilters:array] forKey: @"Distortion"];
        
        array = [NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:kCICategoryHalftoneEffect]];
        [categories setObject: [PGImageFilterUtils FilterDictionaryForFilters:array] forKey: @"Halftone"];
        
        array = [NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:kCICategorySharpen]];
        [categories setObject: [PGImageFilterUtils FilterDictionaryForFilters:array] forKey: @"Shanrpen"];
        
        array = [NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:kCICategoryStylize]];
        [categories setObject: [PGImageFilterUtils FilterDictionaryForFilters:array] forKey: @"Stylize"];
        
        array = [NSMutableArray arrayWithArray: [CIFilter filterNamesInCategory: kCICategoryColorAdjustment]];
        [array addObjectsFromArray:[CIFilter filterNamesInCategory: kCICategoryBlur]];
        [categories setObject:[PGImageFilterUtils FilterDictionaryForFilters:array] forKey:@"Focus"];
         */
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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    categoriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    categoriesTableView.delegate = self;
    categoriesTableView.dataSource = self;
    [self.view addSubview:categoriesTableView];
    [categoriesTableView reloadData];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* category = [[categories allKeys] objectAtIndex:section];
    return category;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [categories count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* category = [[categories allKeys] objectAtIndex:section];
    return [[categories objectForKey:category] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    NSString* category = [[categories allKeys] objectAtIndex:indexPath.section];
    NSArray* catDict = [categories objectForKey:category];
    ITFilter* filter = [catDict objectAtIndex:indexPath.row];
    cell.textLabel.text = filter.displayName ;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    // Navigation logic may go here. Create and push another view controller.  
    if(self.filterSelectionCallbackBlock) {
        NSString* category = [[categories allKeys] objectAtIndex:indexPath.section];
        NSArray* catDict = [categories objectForKey:category];
        ITFilter* filter = [catDict objectAtIndex:indexPath.row];
        
        ITFilterEditorController* fdc = [[ITFilterEditorController alloc] initWithFilter:filter editingBlock:self.editingCallbackBlock];
        self.filterSelectionCallbackBlock(fdc);
    }

}


@end
