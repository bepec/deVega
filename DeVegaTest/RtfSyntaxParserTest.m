//
//  RtfSyntaxParserTest.m
//  DeVega
//
//  Created by Admin on 8/3/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "RtfSyntaxParserTest.h"
#import "RtfSyntaxParser.h"


@interface RtfDebugSyntaxProcessor : NSObject<RtfSyntaxParserDelegate>
{
    NSMutableString *output;
}

- (void)controlWord:(NSString*)word;
- (void)groupStart;
- (void)groupEnd;
- (void)text:(NSString*)text;
- (NSString*)result;

@end


@implementation RtfDebugSyntaxProcessor

- (id)init
{
    self = [super init];
    output = [NSMutableString new];
    return self;
}

- (void)controlWord:(NSString*)word
{
    if (output.length > 0) [output appendString:@"\n"];
    [output appendFormat:@"control word: %@", word];
}

- (void)groupStart
{
    if (output.length > 0) [output appendString:@"\n"];
    [output appendString:@"group open"];
}

- (void)groupEnd
{
    if (output.length > 0) [output appendString:@"\n"];
    [output appendString:@"group close"];
}

- (void)text:(NSString*)text
{
    if (output.length > 0) [output appendString:@"\n"];
    [output appendString:text];
}

- (NSString*)result
{
    return output;
}

@end


@implementation RtfSyntaxParserTest

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testEmptyFile
{
    RtfSyntaxParser *parser = [RtfSyntaxParser new];
    NSString *rtf = @"";
    NSInputStream *in = [NSInputStream inputStreamWithData:[rtf dataUsingEncoding:NSASCIIStringEncoding]];
    RtfDebugSyntaxProcessor *processor = [RtfDebugSyntaxProcessor new];
    parser.delegate = processor;
    parser.inputStream = in;
    STAssertEqualObjects(processor.result, @"", @"Bad result");
}

- (void)testSingleGroup
{
    RtfSyntaxParser *parser = [RtfSyntaxParser new];
    NSString *rtf = @"{}";
    NSInputStream *in = [NSInputStream inputStreamWithData:[rtf dataUsingEncoding:NSASCIIStringEncoding]];
    RtfDebugSyntaxProcessor *processor = [RtfDebugSyntaxProcessor new];
    parser.delegate = processor;
    parser.inputStream = in;
    STAssertEqualObjects(processor.result, @"group open\ngroup close", @"Bad result");
}

- (void)testControlWordSingleChar
{
    RtfSyntaxParser *parser = [RtfSyntaxParser new];
    NSString *rtf = @"{\\b}";
    NSInputStream *in = [NSInputStream inputStreamWithData:[rtf dataUsingEncoding:NSASCIIStringEncoding]];
    RtfDebugSyntaxProcessor *processor = [RtfDebugSyntaxProcessor new];
    parser.delegate = processor;
    parser.inputStream = in;
    STAssertEqualObjects(processor.result, @"group open\ncontrol word: b\ngroup close", @"Bad result");
}

- (void)testControlWordWithParameter
{
    RtfSyntaxParser *parser = [RtfSyntaxParser new];
    NSString *rtf = @"{\\rtf1}";
    NSInputStream *in = [NSInputStream inputStreamWithData:[rtf dataUsingEncoding:NSASCIIStringEncoding]];
    RtfDebugSyntaxProcessor *processor = [RtfDebugSyntaxProcessor new];
    parser.delegate = processor;
    parser.inputStream = in;
    STAssertEqualObjects(processor.result, @"group open\ncontrol word: rtf1\ngroup close", @"Bad result");
}

- (void)testTwoControlWords
{
    RtfSyntaxParser *parser = [RtfSyntaxParser new];
    RtfDebugSyntaxProcessor *processor = [RtfDebugSyntaxProcessor new];
    parser.delegate = processor;
    
    NSString *rtf = @"{\\rtf1\\ascii}";
    NSInputStream *in = [NSInputStream inputStreamWithData:[rtf dataUsingEncoding:NSASCIIStringEncoding]];
    parser.inputStream = in;
    STAssertEqualObjects(processor.result, @"group open\ncontrol word: rtf1\ncontrol word: ascii\ngroup close", @"Bad result");
}

- (void)testTwoControlWordsWithSpace
{
    RtfSyntaxParser *parser = [RtfSyntaxParser new];
    RtfDebugSyntaxProcessor *processor = [RtfDebugSyntaxProcessor new];
    parser.delegate = processor;
    
    NSString *rtf = @"{\\rtf1 \\ascii }";
    NSInputStream *in = [NSInputStream inputStreamWithData:[rtf dataUsingEncoding:NSASCIIStringEncoding]];
    parser.inputStream = in;
    
    STAssertEqualObjects(processor.result, @"group open\ncontrol word: rtf1\ncontrol word: ascii\ngroup close", @"Bad result");
}

- (void)testGroupWithText
{
    RtfSyntaxParser *parser = [RtfSyntaxParser new];
    NSString *rtf = @"{\\rtf1 Simple text}";
    NSInputStream *in = [NSInputStream inputStreamWithData:[rtf dataUsingEncoding:NSASCIIStringEncoding]];
    RtfDebugSyntaxProcessor *processor = [RtfDebugSyntaxProcessor new];
    parser.delegate = processor;
    parser.inputStream = in;
    STAssertEqualObjects(processor.result, @"group open\ncontrol word: rtf1\nSimple text\ngroup close", @"Bad result");
}

@end
