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
    
    ITFilterEditingBlock editingBlock = ^(UIImage* image){
        editImageView.image = image;
    };

    ITFilterSelectionBlock callbackBlock = ^(ITFilterEditorController* fdc){
        if(popoverController)
        {
            [popoverController dismissPopoverAnimated:NO];
            popoverController = nil;
        }
        
        // ADD apply and discard buttons buttons 
        fdc.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(discardFilter)];
        
        fdc.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(applyFilter)];
        
        
        fdc.inputImageSize = editImage.size;
        fdc.inputImage = editImage;
        
        UINavigationController* nvc = [[UINavigationController alloc] initWithRootViewController:fdc];
        
        popoverController= [[UIPopoverController alloc] initWithContentViewController:nvc];
        
        [popoverController presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    };
    
    //initialize image picker and add to popover controller
    ITFilterListController* fxController = [[ITFilterListController alloc] initWithFilters:[NSMutableArray arrayWithArray:[CIFilter filterNamesInCategory:kCICategoryBuiltIn]] filterSelectionBlock:callbackBlock filterEditingBlock:editingBlock];
    
    UINavigationController* rootController = [[UINavigationController alloc] initWithRootViewController:fxController];
	
    popoverController= [[UIPopoverController alloc] initWithContentViewController:rootController];
	
    [popoverController presentPopoverFromBarButtonItem:galleryButton permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
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
