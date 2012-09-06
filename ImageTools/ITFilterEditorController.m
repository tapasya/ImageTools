//
//  PGFilterEditorController.m
//  PhotoGrid
//
//  Created by pramati on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ITFilterEditorController.h"
#import "ITFilter.h"
#import "ITFilterInputAttribute.h"
#import "ITFilterSlider.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ITAlbumPickerController.h"

@interface ITFilterEditorController()  {
@private
    NSIndexPath* selectedIndexPath;
}
@property (nonatomic,strong) ITFilter* filter;
@end
@implementation ITFilterEditorController
@synthesize filter=_filter;
@synthesize delegate=_delegate;
@synthesize inputImageSize=_inputImageSize;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(id) initWithFilter:(ITFilter *)filter
{
    self = [self init];
    if (self) {
        self.filter = filter;
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
    [self.navigationItem setTitle:self.filter.displayName];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(discardFilter)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(applyFilter)];
    
    UITableView* categoriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300,400) style:UITableViewStyleGrouped];
    categoriesTableView.delegate = self;
    categoriesTableView.dataSource = self;
    [self.view addSubview:categoriesTableView];
    [categoriesTableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    CGSize size = CGSizeMake(320, 480); // size of view in popover
    self.contentSizeForViewInPopover = size;
    
    [super viewWillAppear:animated];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString* key = [[[self.filter editableProperties] allKeys] objectAtIndex:section];
    ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:key];
    return inputAttr.displayName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [[self.filter editableProperties] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString* key = [[[self.filter editableProperties] allKeys] objectAtIndex:section];
    ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:key];
    return inputAttr.components;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //static NSString *CellIdentifier = @"Cell";
    NSString* key = [[[self.filter editableProperties] allKeys] objectAtIndex:indexPath.section];
    ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:key];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:inputAttr.type];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inputAttr.type];
        if([inputAttr.type isEqualToString:kCIAttributeTypeColor])
        {
            cell.textLabel.text = @"Pick Color" ;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if([inputAttr.type isEqualToString:kCIAttributeTypeImage])
        {
            cell.textLabel.text = @"Pick Image" ;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            ITFilterSlider* slider = [[ITFilterSlider alloc] init];
            slider.tag = 1001;
            [cell.contentView addSubview:(slider)];
            slider.bounds = CGRectMake(0, 0, cell.contentView.bounds.size.width - 10, slider.bounds.size.height);
            slider.center = CGPointMake(CGRectGetMidX(cell.contentView.bounds), CGRectGetMidY(cell.contentView.bounds));
            slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        }
            
    }
    
    if([inputAttr.type isEqualToString:kCIAttributeTypeColor])
    {
        //TODO should fix the crash
        
        //CIColor* color = inputAttr.value;
        //cell.textLabel.textColor = [[UIColor alloc] initWithCIColor:color];
    }
    else
    {
        ITFilterSlider* slider = (ITFilterSlider*) [cell.contentView viewWithTag:1001];
        slider.attributeInputKey = inputAttr.key;
        slider.type = inputAttr.type;
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        slider.maximumValue = [inputAttr.maxSliderValue floatValue];
        slider.minimumValue = [inputAttr.minSliderValue floatValue];
        if([inputAttr.type isEqualToString:kCIAttributeTypePosition]  || [slider.type isEqualToString:kCIAttributeTypeOffset])
        {
            slider.componentKey = indexPath.section ==0 ? kXPositionTag : kYPositionTag;
            slider.minimumValue = 0;
            slider.maximumValue = 100;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    // Navigation logic may go here. Create and push another view controller.
    NSString* key = [[[self.filter editableProperties] allKeys] objectAtIndex:indexPath.section];
    ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:key];
    selectedIndexPath = indexPath;
    if([inputAttr.type isEqualToString:kCIAttributeTypeColor])
    {
        InfColorPickerController* picker = [ InfColorPickerController colorPickerViewController ];
        //picker.sourceColor = colors[ pickingColorIndex ];
        picker.delegate = self;
        picker.navigationItem.title = inputAttr.displayName;
        picker.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:picker action:@selector(done:)];
        //[picker presentModallyOverViewController:self];
        [self.navigationController pushViewController:picker animated:YES];
    }
    else if([inputAttr.type isEqualToString:kCIAttributeTypeImage])
    {
        ITAlbumPickerController* apc = [[ITAlbumPickerController alloc] init];
        apc.delegate = self;
        [self.navigationController pushViewController:apc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSString* key = [[[self.filter editableProperties] allKeys] objectAtIndex:selectedIndexPath.section];
    ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:key];
    if([inputAttr.type isEqualToString:kCIAttributeTypeImage])
    {
        inputAttr.value = image;
        [self.filter updateAttributeValue:inputAttr];
        [self.delegate filterValueChanged:self.filter forKey:key];
    }
}

- (void) colorPickerControllerDidFinish: (InfColorPickerController*) picker
{
    NSString* key = [[[self.filter editableProperties] allKeys] objectAtIndex:selectedIndexPath.section];
    ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:key];
    if([inputAttr.type isEqualToString:kCIAttributeTypeColor])
    {
        id ciColor = [[CIColor alloc] initWithColor:picker.resultColor];
        inputAttr.value = ciColor;
    }
    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.filter updateAttributeValue:inputAttr];
    [self.delegate filterValueChanged:self.filter forKey:key];
}

-(void) colorPickerControllerDidChangeColor:(InfColorPickerController *)controller
{
    NSString* key = [[[self.filter editableProperties] allKeys] objectAtIndex:selectedIndexPath.section];
    ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:key];
    if([inputAttr.type isEqualToString:kCIAttributeTypeColor])
    {
        id ciColor = [[CIColor alloc] initWithColor:controller.resultColor];
        inputAttr.value = ciColor;
    }
    //[self.navigationController popToViewController:self animated:YES];
    [self.filter updateAttributeValue:inputAttr];
    [self.delegate filterValueChanged:self.filter forKey:key];
}

-(void) sliderValueChanged:(id) sender
{
    ITFilterSlider* slider = (ITFilterSlider*) sender;
    if(self.delegate)
    {
        ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:slider.attributeInputKey];
        if([inputAttr.type isEqualToString:kCIAttributeTypePosition] || [slider.type isEqualToString:kCIAttributeTypeOffset])
        {
            [inputAttr updatePositionValue:slider.value forComponent:slider.componentKey]; 
        }
        else if( [inputAttr.className isEqualToString:@"NSNumber"]) 
        {
            id value =  [NSNumber numberWithFloat:slider.value];
            inputAttr.value = value;
        }
        else
        {
            NSLog(@"Input attrubute of %@ type and %@ class is not supported", inputAttr.type, inputAttr.className);
        }
        [self.filter updateAttributeValue:inputAttr];
        [self.delegate filterValueChanged:self.filter forKey:slider.attributeInputKey];
    }
    
}

-(void) assetSelected:(ALAsset *)asset
{
    NSString* key = [[[self.filter editableProperties] allKeys] objectAtIndex:selectedIndexPath.section];
    ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:key];
    if([inputAttr.type isEqualToString:kCIAttributeTypeImage])
    {
        CIImage* ciImage = [CIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
        CGRect extent = ciImage.extent;
        CIImage *finalImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(self.inputImageSize.width/extent.size.width,self.inputImageSize.height/extent.size.height)];
        inputAttr.value = finalImage;
    }
    //[self.navigationController popToViewController:self animated:YES];
    [self.filter updateAttributeValue:inputAttr];
    [self.delegate filterValueChanged:self.filter forKey:key];
}


-(void) discardFilter
{
    if(self.delegate)
    {
        [self.delegate discardFilter];
    }
}

-(void) applyFilter
{
    if(self.delegate)
    {
        [self.delegate applyFilter];
    }
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

@end
