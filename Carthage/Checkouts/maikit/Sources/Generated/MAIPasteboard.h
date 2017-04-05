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

@protocol MAIPasteboardProtocol
+(id<MAIPasteboardProtocol>)pasteboardWithUniqueName;
@property(readonly, getter=changeCount) NSInteger changeCount;

#if TARGET_OS_IPHONE
+(id<MAIPasteboardProtocol>)generalPasteboard NS_UNAVAILABLE;
+(nullable id<MAIPasteboardProtocol>)pasteboardWithName:(UIPasteboardName)pasteboardName create:(BOOL)create NS_UNAVAILABLE;
+(void)removePasteboardWithName:(UIPasteboardName)pasteboardName NS_UNAVAILABLE;
#else
+(id<MAIPasteboardProtocol>)pasteboardWithName:(NSString*)name NS_UNAVAILABLE;
+(id<MAIPasteboardProtocol>)pasteboardByFilteringFile:(NSString*)filename NS_UNAVAILABLE;
+(id<MAIPasteboardProtocol>)pasteboardByFilteringData:(NSData*)data ofType:(NSString*)type NS_UNAVAILABLE;
+(id<MAIPasteboardProtocol>)pasteboardByFilteringTypesInPasteboard:(id<MAIPasteboardProtocol>)pboard NS_UNAVAILABLE;
#endif

@end

#if TARGET_OS_IPHONE
@interface MAIPasteboard : UIPasteboard<MAIPasteboardProtocol>
#else
@interface MAIPasteboard : NSPasteboard<MAIPasteboardProtocol>
#endif
@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
