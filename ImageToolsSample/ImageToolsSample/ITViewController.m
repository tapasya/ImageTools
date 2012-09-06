//
//  ITViewController.m
//  ImageToolsSample
//
//  Created by pramati on 9/3/12.
//
//

#import "ITViewController.h"
#import <CoreImage/CoreImage.h>

@interface ITViewController ()
{
    UIPopoverController* popoverController;
    UIImageView* editImageView;
    UIImage* editImage;
    CIContext* context;
}

@end

@implementation ITViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    editImage = [UIImage imageNamed:@"image.jpeg"];
    editImageView = [[UIImageView alloc] initWithImage:editImage];
    editImageView.contentMode = UIViewContentModeScaleAspectFit;
    editImageView.frame = CGRectMake(30, (self.view.frame.size.width-editImageView.frame.size.height)/2, editImageView.frame.size.width, editImageView.frame.size.height);
    //editImageView.center = self.view.center;
    [self.view addSubview:editImageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleDone target:self action:@selector(openFXGallery:)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Gallery" style:UIBarButtonItemStyleDone target:self action:@selector(openGallery:)];
    
	// Do any additional setup after loading the view, typically from a nib.
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

-(void) openGallery:(id)sender
{
    if(popoverController)
    {
        [popoverController dismissPopoverAnimated:NO];
        popoverController = nil;
    }
    
    //initialize image picker and add to popover controller
	UIImagePickerController* imagePickerController= [[UIImagePickerController alloc] init];
	imagePickerController.delegate=self;
	imagePickerController.sourceType= UIImagePickerControllerSourceTypePhotoLibrary;
	popoverController= [[UIPopoverController alloc] initWithContentViewController:imagePickerController];
    [popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
	editImage= image;
	[editImageView setImage:editImage];
}

-(void) openFXGallery:(id)sender
{
    UIBarButtonItem* galleryButton = (UIBarButtonItem*)sender;
    if(popoverController)
    {
        [popoverController dismissPopoverAnimated:NO];
        popoverController = nil;
    }
    
    //initialize image picker and add to popover controller
    ITFilterListController* fxController = [[ITFilterListController alloc] initWithFilters:[NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:kCICategoryBuiltIn]]];
    fxController.delegate = self;
    UINavigationController* rootController = [[UINavigationController alloc] initWithRootViewController:fxController];
	popoverController= [[UIPopoverController alloc] initWithContentViewController:rootController];
	[popoverController presentPopoverFromBarButtonItem:galleryButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void) filterSelected:(ITFilter*)filter
{
    if(popoverController)
    {
        [popoverController dismissPopoverAnimated:NO];
        popoverController = nil;
    }
    
    ITFilterEditorController* fdc = [[ITFilterEditorController alloc] initWithFilter:filter];
    fdc.delegate = self;
    fdc.inputImageSize = editImage.size;
    UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:fdc];
    popoverController= [[UIPopoverController alloc] initWithContentViewController:nvc];
    popoverController.popoverContentSize = CGSizeMake(320, 480);
	[popoverController presentPopoverFromRect:CGRectMake(self.view.frame.size.width, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:NO];
}

-(void) filterValueChanged:(ITFilter *) pgFilter forKey:(NSString *)key
{
    CIFilter* filter = pgFilter.ciFilter;
    CIImage* beginImage = [[CIImage alloc] initWithImage:editImage];
    [filter setValue:beginImage forKey:kCIInputImageKey];
    //[filter setValue:value forKey:key];
    
    if(!context)
        context = [CIContext contextWithOptions:nil];
    
    CIImage *outputImage = [filter outputImage];
    CGImageRef cgimg = [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *newImg = [UIImage imageWithCGImage:cgimg];
    
    //editImage = newImg;
    [editImageView setImage:newImg];
    
    CGImageRelease(cgimg);
    [filter setValue:nil forKey:kCIInputImageKey];
}

-(void) applyFilter
{
    editImage = editImageView.image;
    [popoverController dismissPopoverAnimated:YES];
}

-(void) discardFilter
{
    [editImageView setImage:editImage];
}
@end
