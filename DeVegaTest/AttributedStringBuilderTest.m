//
//  AttributedStringBuilderTest.m
//  DeVega
//
//  Created by Admin on 8/3/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "AttributedStringBuilderTest.h"
#import "AttributedStringBuilder.h"


@implementation AttributedStringBuilderTest

- (void)testEmptyData
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];
    NSString* input = @"";
    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEquals(result.length, input.length, @"Bad output");
}

- (void)testPlainText
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];
    NSString* input = @"plain text";
    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEqualObjects(result.string, input, @"Bad output");
}

- (void)testRtfWithSimpleHeader
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];
    NSString* input = @"{\\rtf1 plain text}";
    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEqualObjects(result.string, @"plain text", @"Bad output");
}

- (void)testRtfWithParagraph
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];
    NSString* input = @"{\\rtf1 first par\\par second par}";
    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEqualObjects(result.string, @"first par\u2029second par", @"Bad output");
}

- (void)testRtfWithNewline
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];
    NSString* input = @"{\\rtf1 first line\\line second line}";
    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEqualObjects(result.string, @"first line\u2028second line", @"Bad output");
}

- (void)testRtfWithBold
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];
    NSString* input = @"{\\rtf1 regular \\b bold \\b0 regular}";
    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEqualObjects(result.string, @"regular bold regular", @"Bad output");
    NSFont* font = (NSFont*)[[result attributesAtIndex:5 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:10 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica-Bold", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:15 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica", @"Bad font");
}

- (void)testRtfWithBoldInsideGroup
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];

    NSString* input = @"{\\rtf1 {regular \\b bold} regular}";
    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEqualObjects(result.string, @"regular bold regular", @"Bad output");
    NSFont* font = (NSFont*)[[result attributesAtIndex:5 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:10 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica-Bold", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:15 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica", @"Bad font");
}

- (void)testRtfWithItalics
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];
    
    NSString* input = @"{\\rtf1 regular \\i italic \\i0 regular}";
    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEqualObjects(result.string, @"regular italic regular", @"Bad output");
    NSFont* font = (NSFont*)[[result attributesAtIndex:5 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:10 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica-Oblique", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:16 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica", @"Bad font");
}

- (void)testRtfWithBoldItalics
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];
    
    NSString* input = @"{\\rtf1 regular \\b bold {\\i bold-italic} bold \\b0 regular}";
    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEqualObjects(result.string, @"regular bold bold-italic bold regular", @"Bad output");
    NSFont* font = (NSFont*)[[result attributesAtIndex:5 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:10 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica-Bold", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:16 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica-BoldOblique", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:26 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica-Bold", @"Bad font");
    font = (NSFont*)[[result attributesAtIndex:32 effectiveRange:nil] objectForKey:NSFontAttributeName];
    STAssertEqualObjects(font.fontName, @"Helvetica", @"Bad font");
}

- (void)testRtfIgnoreHeaderGroups
{
    AttributedStringBuilder *converter = [AttributedStringBuilder new];
    
    NSString* input = @"{\\rtf1\\ansi\\ansicpg1251\\deff0\\deflang1058{\\fonttbl{\\f0\\fnil\\fcharset0 Calibri;}}\r\n{\\*\\generator Msftedit 5.41.21.2510;}\\viewkind4\\uc1\\pard\\sa200\\sl276\\slmult1\\lang9\\f0\\fs22 Plain text\\par\r\n}";

    NSAttributedString* result = [converter feed:[input dataUsingEncoding:NSASCIIStringEncoding]];
    STAssertEqualObjects(result.string, @"Plain text", @"Bad output");
}

@end
