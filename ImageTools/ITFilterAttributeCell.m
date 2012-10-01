//
//  ITFilterAttributeCell.m
//  ImageTools
//
//  Created by pramati on 9/6/12.
//
//

#import "ITFilterAttributeCell.h"
#import "ITFilterSlider.h"

@interface ITFilterAttributeCell()

@end

@implementation ITFilterAttributeCell
@synthesize attribute=_attribute;
@synthesize sliderActionBlock =_sliderActionBlock;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier filterAttribute:(ITFilterInputAttribute*) inputAttr
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.attribute = inputAttr;
        if([inputAttr.type isEqualToString:kCIAttributeTypeColor])
        {
            self.textLabel.text = @"Pick Color" ;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if([inputAttr.type isEqualToString:kCIAttributeTypeImage])
        {
            self.textLabel.text = @"Pick Image" ;
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else
        {
            ITFilterSlider* slider = [[ITFilterSlider alloc] init];
            slider.tag = 1001;
            [self.contentView addSubview:(slider)];
            slider.bounds = CGRectMake(0, 0, self.contentView.bounds.size.width - 10, slider.bounds.size.height);
            slider.center = CGPointMake(CGRectGetMidX(self.contentView.bounds), CGRectGetMidY(self.contentView.bounds));
            slider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
            [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            
        }
    }
    return self;
}

- (IBAction) sliderValueChanged:(id)sender
{
    if (self.sliderActionBlock) {
        self.sliderActionBlock(sender);
    }
}

+(void) configureCell:(ITFilterAttributeCell*) cell indexPath:(NSIndexPath*) indexPath
{
    if([cell.attribute.type isEqualToString:kCIAttributeTypeColor])
    {
        //TODO should fix the crash        
        //CIColor* color = inputAttr.value;
        //cell.textLabel.textColor = [[UIColor alloc] initWithCIColor:color];
    }
    else
    {
        ITFilterSlider* slider = (ITFilterSlider*) [cell.contentView viewWithTag:1001];
        slider.attributeInputKey = cell.attribute.key;
        slider.type = cell.attribute.type;
        
        slider.maximumValue = [cell.attribute.maxSliderValue floatValue];
        slider.minimumValue = [cell.attribute.minSliderValue floatValue];
        if([cell.attribute.type isEqualToString:kCIAttributeTypePosition]  || [slider.type isEqualToString:kCIAttributeTypeOffset])
        {
            slider.componentKey = indexPath.section ==0 ? kXPositionTag : kYPositionTag;
            slider.minimumValue = 0;
            slider.maximumValue = 100;
        }
    }
}
@end
