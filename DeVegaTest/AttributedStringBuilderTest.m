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

@end
