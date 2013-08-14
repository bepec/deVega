//
//  FontNameResolver.m
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "FontNameResolver.h"

@implementation FontNameResolver

NSString *const FONTNAME_REGULAR = @"Helvetica";
NSString *const FONTNAME_BOLD = @"Helvetica-Bold";
NSString *const FONTNAME_ITALIC = @"Helvetica-Oblique";
NSString *const FONTNAME_BOLDITALIC = @"Helvetica-BoldOblique";


+(BOOL)isBold:(NSString*)fontName
{
    return ([fontName isEqualToString:FONTNAME_BOLD] ||
            [fontName isEqualToString:FONTNAME_BOLDITALIC]);
}

+(BOOL)isItalic:(NSString*)fontName
{
    return ([fontName isEqualToString:FONTNAME_ITALIC] ||
            [fontName isEqualToString:FONTNAME_BOLDITALIC]);
}

+(NSString*)setBold:(BOOL)value from:(NSString*)fontName
{
    if (value == TRUE) {
        if ([fontName isEqualToString:FONTNAME_REGULAR]) {
            return FONTNAME_BOLD;
        }
        else if ([fontName isEqualToString:FONTNAME_ITALIC]) {
            return FONTNAME_BOLDITALIC;
        }
    }
    else {
        if ([fontName isEqualToString:FONTNAME_BOLD]) {
            return FONTNAME_REGULAR;
        }
        else if ([fontName isEqualToString:FONTNAME_BOLDITALIC]) {
            return FONTNAME_ITALIC;
        }
    }
    return fontName;
}

+(NSString*)setItalic:(BOOL)value from:(NSString*)fontName
{
    if (value == TRUE) {
        if ([fontName isEqualToString:FONTNAME_REGULAR]) {
            return FONTNAME_ITALIC;
        }
        else if ([fontName isEqualToString:FONTNAME_BOLD]) {
            return FONTNAME_BOLDITALIC;
        }
    }
    else {
        if ([fontName isEqualToString:FONTNAME_ITALIC]) {
            return FONTNAME_REGULAR;
        }
        else if ([fontName isEqualToString:FONTNAME_BOLDITALIC]) {
            return FONTNAME_BOLD;
        }
    }
    return fontName;
}

@end

