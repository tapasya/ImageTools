//==============================================================================
//
//  ITAssetCell.h
//  ImageTools
//
//  Created by tapasya on 7/4/12.
//	Some rights reserved: http://opensource.org/licenses/MIT
//
//==============================================================================

#import <UIKit/UIKit.h>


@interface ITAssetCell : UITableViewCell
{
	NSArray *rowAssets;
}

-(id)initWithAssets:(NSArray*)_assets reuseIdentifier:(NSString*)_identifier;
-(void)setAssets:(NSArray*)_assets;

@property (nonatomic,strong) NSArray *rowAssets;

@end
