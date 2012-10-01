//==============================================================================
//
//  ITFilterEditorController.m
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import "ITFilterEditorController.h"
#import "ITFilter.h"
#import "ITFilterInputAttribute.h"
#import "ITFilterSlider.h"
#import "ITFilterAttributeCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ITAlbumPickerController.h"

@interface ITFilterEditorController() {
@private
    NSIndexPath* selectedIndexPath;
    CIContext* context;
    
    dispatch_queue_t backgroundQueue;
    
}
@property (nonatomic,strong) ITFilter* filter;

- (void) filterValueChanged:(ITFilter*) itFilter forKey:(NSString *)key;

@end
@implementation ITFilterEditorController

@synthesize filter=_filter;

@synthesize filterEditingBlock =_filterEditingBlock;

@synthesize inputImageSize=_inputImageSize;

@synthesize inputImage = _inputImage;


-(id) initWithFilter:(ITFilter *)filter editingBlock:(ITFilterEditingBlock)callbackBlock
{
    self = [self init];
    if (self) {
        self.filter = filter;
        self.filterEditingBlock = callbackBlock;
        backgroundQueue = dispatch_queue_create("com.iamgetools.itfilters", NULL);
        dispatch_async(backgroundQueue, ^(void) {
            context = [CIContext contextWithOptions:nil];
        });
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

    UITableView* categoriesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 300, 400) style:UITableViewStyleGrouped];
    categoriesTableView.delegate = self;
    categoriesTableView.dataSource = self;
    [self.view addSubview:categoriesTableView];
    [categoriesTableView reloadData];
}


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
{
    [super viewDidLoad];
        
}
 
- (void)viewWillAppear:(BOOL)animated {
    
    CGSize size = CGSizeMake(320, 400); // size of view in popover
    self.contentSizeForViewInPopover = size;
    
    [super viewWillAppear:animated];
    
}

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

#pragma mark -  cell delegates

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
    
    ITFilterAttributeCell *cell = [tableView dequeueReusableCellWithIdentifier:inputAttr.type];
    
    if (cell == nil)
    {
        cell = [[ITFilterAttributeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:inputAttr.type filterAttribute:inputAttr];
        cell.sliderActionBlock = ^(id sender){
            [self sliderValueChanged:sender];
        };
    }
    
    [ITFilterAttributeCell configureCell:cell indexPath:indexPath];
 
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
        picker.delegate = self;
        picker.navigationItem.title = inputAttr.displayName;
        picker.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:picker action:@selector(done:)];
        
        [self.navigationController pushViewController:picker animated:YES];
    }
    else if([inputAttr.type isEqualToString:kCIAttributeTypeImage])
    {
        ITAlbumPickerController* apc = [[ITAlbumPickerController alloc] init];
        apc.selectionBlock = ^(ALAsset* asset){
            [self assetSelected:asset];
        };
        [self.navigationController pushViewController:apc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - attribute edit actions

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    NSString* key = [[[self.filter editableProperties] allKeys] objectAtIndex:selectedIndexPath.section];
    ITFilterInputAttribute* inputAttr = [[self.filter editableProperties] objectForKey:key];
    
    if([inputAttr.type isEqualToString:kCIAttributeTypeImage])
    {
        inputAttr.value = image;
        [self.filter updateAttributeValue:inputAttr];
        [self filterValueChanged:self.filter forKey:inputAttr.key];
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
    [self filterValueChanged:self.filter forKey:inputAttr.key];
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
    [self filterValueChanged:self.filter forKey:inputAttr.key];
}

-(void) sliderValueChanged:(id) sender
{
    ITFilterSlider* slider = (ITFilterSlider*) sender;
    
    if(self.filterEditingBlock)
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
        [self filterValueChanged:self.filter forKey:inputAttr.key]; 
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
    [self filterValueChanged:self.filter forKey:inputAttr.key];
}

- (void) filterValueChanged:(ITFilter *)itFilter forKey:(NSString *)key
{
    dispatch_async(backgroundQueue, ^(void) {
        CIFilter* filter = itFilter.ciFilter;
        CIImage* beginImage = [[CIImage alloc] initWithImage:self.inputImage];
        [filter setValue:beginImage forKey:kCIInputImageKey];
        //[filter setValue:value forKey:key];
        
        if(!context)
            context = [CIContext contextWithOptions:nil];
        
        CIImage *outputImage = [filter outputImage];
        CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *newImg = [UIImage imageWithCGImage:cgimg];
        
        CGImageRelease(cgimg);
        [filter setValue:nil forKey:kCIInputImageKey];
        
        if(self.filterEditingBlock){
            dispatch_async(dispatch_get_main_queue(), ^(void){
                self.filterEditingBlock(newImg);
            });
        }
    });
    
}
@end
