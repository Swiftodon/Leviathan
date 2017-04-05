#import <TargetConditionals.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-property-no-attribute"

#if TARGET_OS_IPHONE
@import UIKit;
#else
@import AppKit;
#endif

#import "MAIEnums.h"
#import "MAIDeclarations.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MAIColorProtocol
+(id<MAIColorProtocol>)colorWithWhite:(CGFloat)white alpha:(CGFloat)alpha;
+(id<MAIColorProtocol>)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha;
+(id<MAIColorProtocol>)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+(id<MAIColorProtocol>)colorWithDisplayP3Red:(CGFloat)displayP3Red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+(id<MAIColorProtocol>)colorWithCGColor:(CGColorRef)cgColor;
+(id<MAIColorProtocol>)colorWithPatternImage:(id<MAIImageProtocol>)image;
+(id<MAIColorProtocol>)colorWithCIColor:(CIColor*)ciColor;
-(void)set;
-(void)setFill;
-(void)setStroke;
-(id<MAIColorProtocol>)colorWithAlphaComponent:(CGFloat)alpha;
@property(readonly, getter=blackColor) id<MAIColorProtocol> blackColor;
@property(readonly, getter=darkGrayColor) id<MAIColorProtocol> darkGrayColor;
@property(readonly, getter=lightGrayColor) id<MAIColorProtocol> lightGrayColor;
@property(readonly, getter=whiteColor) id<MAIColorProtocol> whiteColor;
@property(readonly, getter=grayColor) id<MAIColorProtocol> grayColor;
@property(readonly, getter=redColor) id<MAIColorProtocol> redColor;
@property(readonly, getter=greenColor) id<MAIColorProtocol> greenColor;
@property(readonly, getter=blueColor) id<MAIColorProtocol> blueColor;
@property(readonly, getter=cyanColor) id<MAIColorProtocol> cyanColor;
@property(readonly, getter=yellowColor) id<MAIColorProtocol> yellowColor;
@property(readonly, getter=magentaColor) id<MAIColorProtocol> magentaColor;
@property(readonly, getter=orangeColor) id<MAIColorProtocol> orangeColor;
@property(readonly, getter=purpleColor) id<MAIColorProtocol> purpleColor;
@property(readonly, getter=brownColor) id<MAIColorProtocol> brownColor;
@property(readonly, getter=clearColor) id<MAIColorProtocol> clearColor;
@property(readonly, getter=CGColor) CGColorRef CGColor;
@property(readonly, getter=underPageBackgroundColor) id<MAIColorProtocol> underPageBackgroundColor;

#if TARGET_OS_IPHONE
-(id<MAIColorProtocol>)initWithWhite:(CGFloat)white alpha:(CGFloat)alpha NS_UNAVAILABLE;
-(id<MAIColorProtocol>)initWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha NS_UNAVAILABLE;
-(id<MAIColorProtocol>)initWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha NS_UNAVAILABLE;
-(id<MAIColorProtocol>)initWithDisplayP3Red:(CGFloat)displayP3Red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha NS_UNAVAILABLE;
-(id<MAIColorProtocol>)initWithCGColor:(CGColorRef)cgColor NS_UNAVAILABLE;
-(id<MAIColorProtocol>)initWithPatternImage:(id<MAIImageProtocol>)image NS_UNAVAILABLE;
-(id<MAIColorProtocol>)initWithCIColor:(CIColor*)ciColor NS_UNAVAILABLE;
+(id<MAIColorProtocol>)lightTextColor NS_UNAVAILABLE;
+(id<MAIColorProtocol>)darkTextColor NS_UNAVAILABLE;
+(id<MAIColorProtocol>)groupTableViewBackgroundColor NS_UNAVAILABLE;
#else
-(instancetype)init NS_UNAVAILABLE;
-(nullable instancetype)initWithCoder:(NSCoder*)coder NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithColorSpace:(NSColorSpace*)space components:(const CGFloat*)components count:(NSInteger)numberOfComponents NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithSRGBRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithGenericGamma22White:(CGFloat)white alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithColorSpace:(NSColorSpace*)space hue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithCalibratedWhite:(CGFloat)white alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithCalibratedRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithCalibratedHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithDeviceWhite:(CGFloat)white alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithDeviceRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithDeviceHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorWithDeviceCyan:(CGFloat)cyan magenta:(CGFloat)magenta yellow:(CGFloat)yellow black:(CGFloat)black alpha:(CGFloat)alpha NS_UNAVAILABLE;
+(nullable id<MAIColorProtocol>)colorWithCatalogName:(NSString*)listName colorName:(NSString*)colorName NS_UNAVAILABLE;
+(id<MAIColorProtocol>)colorForControlTint:(NSControlTint)controlTint NS_UNAVAILABLE;
+(nullable id<MAIColorProtocol>)colorFromPasteboard:(id<MAIPasteboardProtocol>)pasteBoard NS_UNAVAILABLE;
#endif

@end

#if TARGET_OS_IPHONE
@interface MAIColor : UIColor<MAIColorProtocol>
#else
@interface MAIColor : NSColor<MAIColorProtocol>
#endif
@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
