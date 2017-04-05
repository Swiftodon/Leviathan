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

@protocol MAIFontDescriptorProtocol
-(nullable id)objectForKey:(NSString*)anAttribute;
+(id<MAIFontDescriptorProtocol>)fontDescriptorWithName:(NSString*)fontName size:(CGFloat)size;
-(id<MAIFontDescriptorProtocol>)fontDescriptorByAddingAttributes:(NSDictionary<NSString*, id>*)attributes;
-(id<MAIFontDescriptorProtocol>)fontDescriptorWithSize:(CGFloat)newPointSize;
-(id<MAIFontDescriptorProtocol>)fontDescriptorWithFace:(NSString*)newFace;
-(id<MAIFontDescriptorProtocol>)fontDescriptorWithFamily:(NSString*)newFamily;
@property(readonly, getter=pointSize) CGFloat pointSize;
@property(readonly, getter=fontAttributes) NSDictionary<NSString*, id>* fontAttributes;

#if TARGET_OS_IPHONE
-(instancetype)init NS_UNAVAILABLE;
-(nullable instancetype)initWithCoder:(NSCoder*)aDecoder NS_UNAVAILABLE;
+(id<MAIFontDescriptorProtocol>)preferredFontDescriptorWithTextStyle:(UIFontTextStyle)style NS_UNAVAILABLE;
+(id<MAIFontDescriptorProtocol>)preferredFontDescriptorWithTextStyle:(UIFontTextStyle)style compatibleWithTraitCollection:(nullable UITraitCollection*)traitCollection NS_UNAVAILABLE;
#else
#endif

@end

#if TARGET_OS_IPHONE
@interface MAIFontDescriptor : UIFontDescriptor<MAIFontDescriptorProtocol>
#else
@interface MAIFontDescriptor : NSFontDescriptor<MAIFontDescriptorProtocol>
#endif
@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
