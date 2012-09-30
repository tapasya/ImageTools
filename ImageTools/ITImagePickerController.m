//
//  ITImagePickerController.m
//  ImageTools
//
//  Created by pramati on 9/4/12.
//
//

#import "ITImagePickerController.h"
#import "ITAssetCell.h"
#import "ITAssetView.h"

@interface ITImagePickerController ()
@property (nonatomic, strong) NSMutableArray *assetViews;
-(void) assetTapped:(ITAssetView*) sender;
@end

@implementation ITImagePickerController
@synthesize assetGroup=_assetGroup;
@synthesize assetViews=_assets;
@synthesize selectionBlock =_selectionBlock;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.assetViews = [[NSMutableArray alloc] init];
        [self.tableView setAllowsSelection:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
    
    // Show partial while full list loads
	[self.tableView performSelector:@selector(reloadData) withObject:nil afterDelay:.5];
}

-(void)preparePhotos {
    
    NSLog(@"enumerating photos");
    [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop)
     {
         if(result == nil)
         {
             return;
         }
         ITAssetView* view = [[ITAssetView alloc] initWithAsset:(ALAsset*) result];
         [view addTarget:self action:@selector(assetTapped:) forControlEvents:UIControlEventTouchDown];
         [self.assetViews addObject:view];
     }];
    NSLog(@"done enumerating photos");
	
	[self.tableView reloadData];
	[self.navigationItem setTitle:@"Pick Photo"];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSArray*)assetsForIndexPath:(NSIndexPath*)_indexPath {
    
	int index = (_indexPath.row*4);
	int maxIndex = (_indexPath.row*4+3);
    
	// NSLog(@"Getting assets for %d to %d with array count %d", index, maxIndex, [assets count]);
    
	if(maxIndex < [self.assetViews count]) {
        
		return [NSArray arrayWithObjects:[self.assetViews objectAtIndex:index],
				[self.assetViews objectAtIndex:index+1],
				[self.assetViews objectAtIndex:index+2],
				[self.assetViews objectAtIndex:index+3],
				nil];
	}
    
	else if(maxIndex-1 < [self.assetViews count]) {
        
		return [NSArray arrayWithObjects:[self.assetViews objectAtIndex:index],
				[self.assetViews objectAtIndex:index+1],
				[self.assetViews objectAtIndex:index+2],
				nil];
	}
    
	else if(maxIndex-2 < [self.assetViews count]) {
        
		return [NSArray arrayWithObjects:[self.assetViews objectAtIndex:index],
				[self.assetViews objectAtIndex:index+1],
				nil];
	}
    
	else if(maxIndex-3 < [self.assetViews count]) {
        
		return [NSArray arrayWithObject:[self.assetViews objectAtIndex:index]];
	}
    
	return nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return ceil([self.assetViews count] / 4.0);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    ITAssetCell *cell = (ITAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ITAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier];
    }
	else
    {
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	return 79;
}


-(void) assetTapped:(ITAssetView *)sender
{
    if(self.selectionBlock)
    {
        self.selectionBlock(sender.asset);
    }
}

@end
