//
//  FontNameResolver.m
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "FontNameResolver.h"

@implementation FontNameResolver

NSString *const FONTNAME_GENERAL = @"Helvetica";
NSString *const FONTNAME_BOLD = @"Helvetica-Bold";
NSString *const FONTNAME_ITALIC = @"Helvetica-Italic";
NSString *const FONTNAME_BOLDITALIC = @"Helvetica-BoldItalic";


+(BOOL)isBold:(NSString*)fontName
{
    return ([fontName compare:FONTNAME_BOLD] || [fontName compare:FONTNAME_BOLDITALIC]);
}

+(BOOL)isItalic:(NSString*)fontName
{
    return ([fontName compare:FONTNAME_ITALIC] || [fontName compare:FONTNAME_BOLDITALIC]);
}

+(NSString*)setBold:(BOOL)value from:(NSString*)fontName
{
    if (value == TRUE) {
        if ([fontName compare:FONTNAME_GENERAL]) {
            return FONTNAME_BOLD;
        }
        else if ([fontName compare:FONTNAME_ITALIC]) {
            return FONTNAME_BOLDITALIC;
        }
    }
    else {
        if ([fontName compare:FONTNAME_BOLD]) {
            return FONTNAME_GENERAL;
        }
        else if ([fontName compare:FONTNAME_BOLDITALIC]) {
            return FONTNAME_ITALIC;
        }
    }
    return fontName;
}

+(NSString*)setItalic:(BOOL)value from:(NSString*)fontName
{
    if (value == TRUE) {
        if ([fontName compare:FONTNAME_GENERAL]) {
            return FONTNAME_ITALIC;
        }
        else if ([fontName compare:FONTNAME_BOLD]) {
            return FONTNAME_BOLDITALIC;
        }
    }
    else {
        if ([fontName compare:FONTNAME_ITALIC]) {
            return FONTNAME_GENERAL;
        }
        else if ([fontName compare:FONTNAME_BOLDITALIC]) {
            return FONTNAME_BOLD;
        }
    }
    return fontName;
}

@end

