//
//  ITAlbumPickerController.m
//  ImageTools
//
//  Created by pramati on 9/4/12.
//
//

#import "ITAlbumPickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ITImagePickerController.h"

@interface ITAlbumPickerController ()
{
    NSMutableArray *assetGroups;
	ALAssetsLibrary *library;
}
@end

@implementation ITAlbumPickerController
@synthesize selectionBlock=_selectionBlock;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    assetGroups =  [[NSMutableArray alloc] init];
    
    library = [[ALAssetsLibrary alloc] init];
    
    // Load Albums into assetGroups
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       
                       // Group enumerator Block
                       void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                       {
                           if (group == nil)
                           {
                               return;
                           }
                           
                           [assetGroups addObject:group];
                           [self.tableView reloadData];
                           
                       };
                       
                       // Group Enumerator Failure Block
                       void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                           
                           UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                           [alert show];
                           
                           NSLog(@"A problem occured %@", [error description]);
                       };
                       
                       // Enumerate Albums
                       [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                              usingBlock:assetGroupEnumerator
                                            failureBlock:assetGroupEnumberatorFailure];
                   });
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [assetGroups count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%d)",[g valueForProperty:ALAssetsGroupPropertyName], gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ITImagePickerController* ipc = [[ITImagePickerController alloc] init];
    ipc.assetGroup = (ALAssetsGroup*)[assetGroups objectAtIndex:indexPath.row];
    ipc.selectionBlock = self.selectionBlock;
    [self.navigationController pushViewController:ipc animated:YES];
}

@end
