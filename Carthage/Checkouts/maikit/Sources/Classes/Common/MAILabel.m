//
//  MAILabel.m
//  MAIKit
//
//  Created by Bonk, Thomas on 31.01.17.
//
//

#import "MAILabel.h"

@implementation MAILabel

- (MAIColor*)textColor {
    return (MAIColor*)super.textColor;
}

- (void)setTextColor:(MAIColor*)color {
#if TARGET_OS_IPHONE
    super.textColor = (UIColor*)color;
#else
    super.textColor = (NSColor*)color;
#endif
}

- (MAIColor*)backgroundColor {
    return (MAIColor*)super.backgroundColor;
}

- (void)setBackgroundColor:(MAIColor*)color {
#if TARGET_OS_IPHONE
    super.backgroundColor = (UIColor*)color;
#else
    super.backgroundColor = (NSColor*)color;
#endif
}

@end
