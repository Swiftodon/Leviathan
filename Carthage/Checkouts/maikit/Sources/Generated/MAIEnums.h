typedef NS_ENUM(NSInteger, MAIUnderlineStyle) {
MAIUnderlineStyleNone = 0x00,
MAIUnderlineStyleSingle = 0x01,
MAIUnderlineStyleThick = 0x02,
MAIUnderlineStyleDouble = 0x09,
MAIUnderlinePatternSolid = 0x0000,
MAIUnderlinePatternDot = 0x0100,
MAIUnderlinePatternDash = 0x0200,
MAIUnderlinePatternDashDot = 0x0300,
MAIUnderlinePatternDashDotDot = 0x0400,
MAIUnderlineByWord = 0x8000
};

typedef NS_ENUM(NSInteger, MAIWritingDirectionFormatType) {
MAIWritingDirectionEmbedding = (0 << 1),
MAIWritingDirectionOverride = (1 << 1)
};

typedef NS_ENUM(NSInteger, MAILayoutRelation) {
MAILayoutRelationLessThanOrEqual = -1,
MAILayoutRelationEqual = 0,
MAILayoutRelationGreaterThanOrEqual = 1
};

typedef NS_ENUM(NSInteger, MAILayoutAttribute) {
MAILayoutAttributeLeft = 1,
MAILayoutAttributeRight,
MAILayoutAttributeTop,
MAILayoutAttributeBottom,
MAILayoutAttributeLeading,
MAILayoutAttributeTrailing,
MAILayoutAttributeWidth,
MAILayoutAttributeHeight,
MAILayoutAttributeCenterX,
MAILayoutAttributeCenterY,
MAILayoutAttributeLastBaseline,
MAILayoutAttributeBaseline = MAILayoutAttributeLastBaseline,
MAILayoutAttributeFirstBaseline,
MAILayoutAttributeNotAnAttribute = 0
};

typedef NS_ENUM(NSInteger, MAITextLayoutOrientation) {
MAITextLayoutOrientationHorizontal = 0,
MAITextLayoutOrientationVertical = 1
};

typedef NS_ENUM(NSInteger, MAIGlyphProperty) {
MAIGlyphPropertyNull = (1 << 0),
MAIGlyphPropertyControlCharacter = (1 << 1),
MAIGlyphPropertyElastic = (1 << 2),
MAIGlyphPropertyNonBaseCharacter = (1 << 3)
};

typedef NS_ENUM(NSInteger, MAIControlCharacterAction) {
MAIControlCharacterActionZeroAdvancement = (1 << 0),
MAIControlCharacterActionWhitespace = (1 << 1),
MAIControlCharacterActionHorizontalTab = (1 << 2),
MAIControlCharacterActionLineBreak = (1 << 3),
MAIControlCharacterActionParagraphBreak = (1 << 4),
MAIControlCharacterActionContainerBreak = (1 << 5)
};

typedef NS_OPTIONS(NSInteger, MAIStringDrawingOptions) {
MAIStringDrawingUsesLineFragmentOrigin = 1 << 0,
MAIStringDrawingUsesFontLeading = 1 << 1,
MAIStringDrawingUsesDeviceMetrics = 1 << 3,
MAIStringDrawingTruncatesLastVisibleLine = 1 << 5
};

typedef NS_ENUM(NSInteger, MAIWritingDirection) {
MAIWritingDirectionNatural = -1,
MAIWritingDirectionLeftToRight = 0,
MAIWritingDirectionRightToLeft = 1
};

typedef NS_OPTIONS(NSUInteger, MAITextStorageEditActions) {
MAITextStorageEditedAttributes = (1 << 0),
MAITextStorageEditedCharacters = (1 << 1)
};

typedef NS_OPTIONS(NSUInteger, MAIRemoteNotificationType) {
MAIRemoteNotificationTypeNone = 0,
MAIRemoteNotificationTypeBadge = 1 << 0,
MAIRemoteNotificationTypeSound = 1 << 1,
MAIRemoteNotificationTypeAlert = 1 << 2
};

typedef NS_OPTIONS(NSUInteger, MAICollectionViewScrollPosition) {
MAICollectionViewScrollPositionNone = 0,
MAICollectionViewScrollPositionTop = 1 << 0,
MAICollectionViewScrollPositionCenteredVertically = 1 << 1,
MAICollectionViewScrollPositionBottom = 1 << 2,
MAICollectionViewScrollPositionLeft = 1 << 3,
MAICollectionViewScrollPositionCenteredHorizontally = 1 << 4,
MAICollectionViewScrollPositionRight = 1 << 5
};

typedef NS_ENUM(NSInteger, MAICollectionViewScrollDirection) {
MAICollectionViewScrollDirectionVertical,
MAICollectionViewScrollDirectionHorizontal
};

typedef NS_ENUM(NSInteger, MAICollectionUpdateAction) {
MAICollectionUpdateActionInsert,
MAICollectionUpdateActionDelete,
MAICollectionUpdateActionReload,
MAICollectionUpdateActionMove,
MAICollectionUpdateActionNone
};

typedef NS_ENUM(NSInteger, MAIGestureRecognizerState) {
MAIGestureRecognizerStatePossible,
MAIGestureRecognizerStateBegan,
MAIGestureRecognizerStateChanged,
MAIGestureRecognizerStateEnded,
MAIGestureRecognizerStateCancelled,
MAIGestureRecognizerStateFailed,
MAIGestureRecognizerStateRecognized = MAIGestureRecognizerStateEnded
};

typedef NS_ENUM(NSInteger, MAIUserInterfaceLayoutDirection) {
MAIUserInterfaceLayoutDirectionLeftToRight,
MAIUserInterfaceLayoutDirectionRightToLeft
};

typedef NS_ENUM(NSInteger, MAIDisplayGamut) {
MAIDisplayGamutSRGB,
MAIDisplayGamutP3
};

typedef NS_ENUM(NSInteger, MAIStackViewDistribution) {
MAIStackViewDistributionFill = 0,
MAIStackViewDistributionFillEqually,
MAIStackViewDistributionFillProportionally,
MAIStackViewDistributionEqualSpacing,
MAIStackViewDistributionEqualCentering
};

typedef NS_ENUM(NSInteger, MAITouchType) {
MAITouchTypeDirect,
MAITouchTypeIndirect
};

