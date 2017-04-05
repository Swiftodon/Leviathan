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

@protocol MAILayoutManagerProtocol
-(instancetype)init;
-(nullable instancetype)initWithCoder:(NSCoder*)coder;
-(void)addTextContainer:(id<MAITextContainerProtocol>)container;
-(void)insertTextContainer:(id<MAITextContainerProtocol>)container atIndex:(NSUInteger)index;
-(void)removeTextContainerAtIndex:(NSUInteger)index;
-(void)textContainerChangedGeometry:(id<MAITextContainerProtocol>)container;
-(void)invalidateGlyphsForCharacterRange:(NSRange)charRange changeInLength:(NSInteger)delta actualCharacterRange:(nullable NSRangePointer)actualCharRange;
-(void)invalidateLayoutForCharacterRange:(NSRange)charRange actualCharacterRange:(nullable NSRangePointer)actualCharRange;
-(void)invalidateDisplayForCharacterRange:(NSRange)charRange;
-(void)invalidateDisplayForGlyphRange:(NSRange)glyphRange;
-(void)processEditingForTextStorage:(id<MAITextStorageProtocol>)textStorage edited:(MAITextStorageEditActions)editMask range:(NSRange)newCharRange changeInLength:(NSInteger)delta invalidatedRange:(NSRange)invalidatedCharRange;
-(void)ensureGlyphsForCharacterRange:(NSRange)charRange;
-(void)ensureGlyphsForGlyphRange:(NSRange)glyphRange;
-(void)ensureLayoutForCharacterRange:(NSRange)charRange;
-(void)ensureLayoutForGlyphRange:(NSRange)glyphRange;
-(void)ensureLayoutForTextContainer:(id<MAITextContainerProtocol>)container;
-(void)ensureLayoutForBoundingRect:(CGRect)bounds inTextContainer:(id<MAITextContainerProtocol>)container;
-(void)setGlyphs:(const CGGlyph*)glyphs properties:(const MAIGlyphProperty*)props characterIndexes:(const NSUInteger*)charIndexes font:(id<MAIFontProtocol>)aFont forGlyphRange:(NSRange)glyphRange;
-(CGGlyph)CGGlyphAtIndex:(NSUInteger)glyphIndex isValidIndex:(nullable BOOL*)isValidIndex;
-(CGGlyph)CGGlyphAtIndex:(NSUInteger)glyphIndex;
-(BOOL)isValidGlyphIndex:(NSUInteger)glyphIndex;
-(MAIGlyphProperty)propertyForGlyphAtIndex:(NSUInteger)glyphIndex;
-(NSUInteger)characterIndexForGlyphAtIndex:(NSUInteger)glyphIndex;
-(NSUInteger)glyphIndexForCharacterAtIndex:(NSUInteger)charIndex;
-(NSUInteger)getGlyphsInRange:(NSRange)glyphRange glyphs:(nullable CGGlyph*)glyphBuffer properties:(nullable MAIGlyphProperty*)props characterIndexes:(nullable NSUInteger*)charIndexBuffer bidiLevels:(nullable unsigned char*)bidiLevelBuffer;
-(void)setTextContainer:(id<MAITextContainerProtocol>)container forGlyphRange:(NSRange)glyphRange;
-(void)setLineFragmentRect:(CGRect)fragmentRect forGlyphRange:(NSRange)glyphRange usedRect:(CGRect)usedRect;
-(void)setExtraLineFragmentRect:(CGRect)fragmentRect usedRect:(CGRect)usedRect textContainer:(id<MAITextContainerProtocol>)container;
-(void)setLocation:(CGPoint)location forStartOfGlyphRange:(NSRange)glyphRange;
-(void)setNotShownAttribute:(BOOL)flag forGlyphAtIndex:(NSUInteger)glyphIndex;
-(void)setDrawsOutsideLineFragment:(BOOL)flag forGlyphAtIndex:(NSUInteger)glyphIndex;
-(void)getFirstUnlaidCharacterIndex:(nullable NSUInteger*)charIndex glyphIndex:(nullable NSUInteger*)glyphIndex;
-(nullable id<MAITextContainerProtocol>)textContainerForGlyphAtIndex:(NSUInteger)glyphIndex effectiveRange:(nullable NSRangePointer)effectiveGlyphRange;
-(nullable id<MAITextContainerProtocol>)textContainerForGlyphAtIndex:(NSUInteger)glyphIndex effectiveRange:(nullable NSRangePointer)effectiveGlyphRange withoutAdditionalLayout:(BOOL)flag;
-(CGRect)usedRectForTextContainer:(id<MAITextContainerProtocol>)container;
-(CGRect)lineFragmentRectForGlyphAtIndex:(NSUInteger)glyphIndex effectiveRange:(nullable NSRangePointer)effectiveGlyphRange;
-(CGRect)lineFragmentRectForGlyphAtIndex:(NSUInteger)glyphIndex effectiveRange:(nullable NSRangePointer)effectiveGlyphRange withoutAdditionalLayout:(BOOL)flag;
-(CGRect)lineFragmentUsedRectForGlyphAtIndex:(NSUInteger)glyphIndex effectiveRange:(nullable NSRangePointer)effectiveGlyphRange;
-(CGRect)lineFragmentUsedRectForGlyphAtIndex:(NSUInteger)glyphIndex effectiveRange:(nullable NSRangePointer)effectiveGlyphRange withoutAdditionalLayout:(BOOL)flag;
-(CGPoint)locationForGlyphAtIndex:(NSUInteger)glyphIndex;
-(BOOL)notShownAttributeForGlyphAtIndex:(NSUInteger)glyphIndex;
-(BOOL)drawsOutsideLineFragmentForGlyphAtIndex:(NSUInteger)glyphIndex;
-(NSRange)truncatedGlyphRangeInLineFragmentForGlyphAtIndex:(NSUInteger)glyphIndex;
-(NSRange)glyphRangeForCharacterRange:(NSRange)charRange actualCharacterRange:(nullable NSRangePointer)actualCharRange;
-(NSRange)characterRangeForGlyphRange:(NSRange)glyphRange actualGlyphRange:(nullable NSRangePointer)actualGlyphRange;
-(NSRange)glyphRangeForTextContainer:(id<MAITextContainerProtocol>)container;
-(NSRange)rangeOfNominallySpacedGlyphsContainingIndex:(NSUInteger)glyphIndex;
-(CGRect)boundingRectForGlyphRange:(NSRange)glyphRange inTextContainer:(id<MAITextContainerProtocol>)container;
-(NSRange)glyphRangeForBoundingRect:(CGRect)bounds inTextContainer:(id<MAITextContainerProtocol>)container;
-(NSRange)glyphRangeForBoundingRectWithoutAdditionalLayout:(CGRect)bounds inTextContainer:(id<MAITextContainerProtocol>)container;
-(NSUInteger)glyphIndexForPoint:(CGPoint)point inTextContainer:(id<MAITextContainerProtocol>)container fractionOfDistanceThroughGlyph:(nullable CGFloat*)partialFraction;
-(NSUInteger)glyphIndexForPoint:(CGPoint)point inTextContainer:(id<MAITextContainerProtocol>)container;
-(CGFloat)fractionOfDistanceThroughGlyphForPoint:(CGPoint)point inTextContainer:(id<MAITextContainerProtocol>)container;
-(NSUInteger)characterIndexForPoint:(CGPoint)point inTextContainer:(id<MAITextContainerProtocol>)container fractionOfDistanceBetweenInsertionPoints:(nullable CGFloat*)partialFraction;
-(NSUInteger)getLineFragmentInsertionPointsForCharacterAtIndex:(NSUInteger)charIndex alternatePositions:(BOOL)aFlag inDisplayOrder:(BOOL)dFlag positions:(nullable CGFloat*)positions characterIndexes:(nullable NSUInteger*)charIndexes;
-(void)enumerateLineFragmentsForGlyphRange:(NSRange)glyphRange usingBlock:(void (^)(CGRect rect, CGRect usedRect, MAITextContainer*textContainer, NSRange glyphRange, BOOL*stop))block;
-(void)enumerateEnclosingRectsForGlyphRange:(NSRange)glyphRange withinSelectedGlyphRange:(NSRange)selectedRange inTextContainer:(id<MAITextContainerProtocol>)textContainer usingBlock:(void (^)(CGRect rect, BOOL*stop))block;
-(void)drawBackgroundForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin;
-(void)drawGlyphsForGlyphRange:(NSRange)glyphsToShow atPoint:(CGPoint)origin;
-(void)fillBackgroundRectArray:(const CGRect*)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(id<MAIColorProtocol>)color;
-(void)drawUnderlineForGlyphRange:(NSRange)glyphRange underlineType:(MAIUnderlineStyle)underlineVal baselineOffset:(CGFloat)baselineOffset lineFragmentRect:(CGRect)lineRect lineFragmentGlyphRange:(NSRange)lineGlyphRange containerOrigin:(CGPoint)containerOrigin;
-(void)underlineGlyphRange:(NSRange)glyphRange underlineType:(MAIUnderlineStyle)underlineVal lineFragmentRect:(CGRect)lineRect lineFragmentGlyphRange:(NSRange)lineGlyphRange containerOrigin:(CGPoint)containerOrigin;
-(void)drawStrikethroughForGlyphRange:(NSRange)glyphRange strikethroughType:(MAIUnderlineStyle)strikethroughVal baselineOffset:(CGFloat)baselineOffset lineFragmentRect:(CGRect)lineRect lineFragmentGlyphRange:(NSRange)lineGlyphRange containerOrigin:(CGPoint)containerOrigin;
-(void)strikethroughGlyphRange:(NSRange)glyphRange strikethroughType:(MAIUnderlineStyle)strikethroughVal lineFragmentRect:(CGRect)lineRect lineFragmentGlyphRange:(NSRange)lineGlyphRange containerOrigin:(CGPoint)containerOrigin;
@property(nullable, setter=setTextStorage:, getter=textStorage) id<MAITextStorageProtocol> textStorage;
@property(readonly, getter=textContainers) NSArray<MAITextContainer*>* textContainers;
@property(nullable, setter=setDelegate:, getter=delegate) id <MAILayoutManagerDelegate> delegate;
@property(setter=setShowsInvisibleCharacters:, getter=showsInvisibleCharacters) BOOL showsInvisibleCharacters;
@property(setter=setShowsControlCharacters:, getter=showsControlCharacters) BOOL showsControlCharacters;
@property(setter=setUsesFontLeading:, getter=usesFontLeading) BOOL usesFontLeading;
@property(setter=setAllowsNonContiguousLayout:, getter=allowsNonContiguousLayout) BOOL allowsNonContiguousLayout;
@property(readonly, getter=hasNonContiguousLayout) BOOL hasNonContiguousLayout;
@property(readonly, getter=numberOfGlyphs) NSUInteger numberOfGlyphs;
@property(readonly, getter=extraLineFragmentRect) CGRect extraLineFragmentRect;
@property(readonly, getter=extraLineFragmentUsedRect) CGRect extraLineFragmentUsedRect;
@property(readonly, nullable, getter=extraLineFragmentTextContainer) id<MAITextContainerProtocol> extraLineFragmentTextContainer;

#if TARGET_OS_IPHONE
#else
#endif

@end

#if TARGET_OS_IPHONE
@interface MAILayoutManager : NSLayoutManager<MAILayoutManagerProtocol>
#else
@interface MAILayoutManager : NSLayoutManager<MAILayoutManagerProtocol>
#endif
@end

NS_ASSUME_NONNULL_END

#pragma clang diagnostic pop
