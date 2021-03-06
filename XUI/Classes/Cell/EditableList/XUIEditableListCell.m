//
//  XUIEditableListCell.m
//  XUI
//
//  Created by Zheng on 15/10/2017.
//

#import "XUIEditableListCell.h"

@implementation XUIEditableListCell

+ (BOOL)layoutNeedsTextLabel {
    return YES;
}

+ (BOOL)layoutNeedsImageView {
    return YES;
}

+ (BOOL)layoutRequiresDynamicRowHeight {
    return NO;
}

+ (NSDictionary <NSString *, Class> *)entryValueTypes {
    return
    @{
      @"maxCount": [NSNumber class],
      @"footerText": [NSString class],
      @"value": [NSArray class],
      };
}

- (void)setupCell {
    [super setupCell];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

@end
