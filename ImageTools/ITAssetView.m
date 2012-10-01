//==============================================================================
//  ITAssetView.m
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================


#import "ITAssetView.h"

@implementation ITAssetView

@synthesize asset;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

-(id)initWithAsset:(ALAsset*)_asset {
	CGRect viewFrames = CGRectMake(0, 0, 75, 75);    
	if (self = [super initWithFrame:viewFrames])
    {		
		self.asset = _asset;
        [self setImage:[UIImage imageWithCGImage:[self.asset thumbnail]] forState:UIControlStateNormal];
		[self setContentMode:UIViewContentModeScaleToFill];
    }    
	return self;	
}

- (void)dealloc 
{    
    self.asset = nil;
}

@end

