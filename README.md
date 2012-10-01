# ImageTools
**Wrapper for iOS Core Image Filters**

> _This is still in early stages of development, so proceed with caution when using this in a production application.  
> Any bug reports, feature requests, or general feedback at this point would be greatly appreciated._

ImageTools is a simple framework which is built on top of iOS Core Image filters. ImageTools enables developers to quickly add image editing capabilities to their apps. 
Currently the framework doesn't support some of the complex filter attributes which can be modified. Following are the supported and unsupported attributes. 

### Supported Attributes
- `kCIAttributeTypeTime`
- `kCIAttributeTypeScalar` 
- `kCIAttributeTypeDistance`
- `kCIAttributeTypeAngle`
- `kCIAttributeTypeInteger`
- `kCIAttributeTypeCount`
- `kCIAttributeTypePosition`
- `kCIAttributeTypeOffset`
- `kCIAttributeTypeColor`
- `kCIAttributeTypeImage`

### Unsuppported Attributes
- `kCIAttributeTypePosition3`
- `kCIAttributeTypeRectangle`
- `kCIAttributeTypeBoolean`

## Getting Started

Check out the sample app that is included in the repository. Its a simple demonstration of an app that uses Core Image Filters with `ImageTools` to to apply filters to images.
You can either add the pre built framework to your application or create a workspace and add ImageTools as child project or just drag and drop all the files. If you want to compile then open ImageTools.xcodeproj and build ImageTools-Framework target to build the framework.

## Usage

The initial component is `ITFilterListController` class. Initiate this class with the required filters and callback blocks. Sample app shows all the built in filters. The filterSelection block will get a callback with `ITFilterEditorController`  which can be used to show the filter editing interface. 
filterEditingBlock will get the callback when ever some attribute is changed with an processed image as an argument.  Refer to the `ITViewController.m`  `-(void) openFXGallery:(id)sender` method for sample implementation

``` objective-c
ITFilterListController* fxController = [[ITFilterListController alloc] initWithFilters:[NSMutableArray arrayWithArray:
											[CIFilter filterNamesInCategory:kCICategoryBuiltIn]] filterSelectionBlock:callbackBlock
											 filterEditingBlock:editingBlock];

// Register a filter editing callback block. Update the UI with the processed image											 
ITFilterEditingBlock editingBlock = ^(UIImage* image){
        editImageView.image = image;
    };											 
    
```


## Requirements

ImageTools requires Xcode 4.4 with either the [iOS 5.0](http://developer.apple.com/library/ios/#releasenotes/General/WhatsNewIniPhoneOS/Articles/iOS5.html) 

## Next Steps

This project is just getting started. Next up for `ImageTools` are the following:

- Support for other editing attributes
- iPhone example project

## Credits

ImageTools was created by [Tapasya](https://github.com/tapasya/).

 [InfColorPicker] (https://github.com/InfinitApps/InfColorPicker/) is being used for the color selection interface.


### Creators

[Tapasya](http://github.com/tapasya)  


## License

ImageTools is available under the MIT license. See the LICENSE file for more info.
