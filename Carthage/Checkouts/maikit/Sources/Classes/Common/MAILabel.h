//
//  MAILabel.h
//  MAIKit
//
//  Created by Bonk, Thomas on 31.01.17.
//
//

#import <TargetConditionals.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-no-attribute"

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import AppKit;

#import "NSLabel.h"
#endif

#import "MAIEnums.h"
#import "MAIDeclarations.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MAILabelProtocol

@property(nonatomic, copy)   IBInspectable NSString*           text;
@property(nonatomic, copy)                 NSAttributedString* attributedText;
@property(nonatomic, retain) IBInspectable MAIFont*            font;
@property(nonatomic, retain) IBInspectable MAIColor*           textColor;
@property(nonatomic, retain) IBInspectable MAIColor*           backgroundColor;
@property(nonatomic, assign) IBInspectable NSInteger           numberOfLines;
@property(nonatomic, assign)               NSTextAlignment     textAlignment;
@property(nonatomic, assign)               NSLineBreakMode     lineBreakMode;
@property(nonatomic, assign) IBInspectable CGFloat             preferredMaxLayoutWidth;

@end


#if TARGET_OS_IPHONE
IB_DESIGNABLE
@interface MAILabel : UILabel<MAILabelProtocol>
#else
IB_DESIGNABLE
@interface MAILabel : NSLabel<MAILabelProtocol>
#endif
@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
