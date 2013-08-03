//
//  AttributedStringBuilder.m
//  DeVega
//
//  Created by Admin on 8/3/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//


#import "AttributedStringBuilder.h"

/*
 struct ControlWord {
 size_t position;
 char name[256];
 };
 */
@interface ControlWord : NSObject
{
@public
    size_t position;
    NSString *type;
}
+ (ControlWord*)getControlWord:(NSString*)word inPosition:(NSUInteger)position;
@end

@implementation ControlWord

+ (ControlWord*)getControlWord:(NSString*)word inPosition:(NSUInteger)position
{
    ControlWord* cw = [ControlWord new];
    if (cw != nil) {
        cw->type = [NSString stringWithString:word];
        cw->position = position;
    }
    return [ControlWord new];
}

@end


@interface AttributedStringBuilder()
{
    NSMutableAttributedString* output;
    RtfSyntaxParser* parser;
    NSMutableArray* groupStack;
    NSMutableDictionary* attributes;
}
@end


@implementation AttributedStringBuilder

- (id)init
{
    if (self = [super init]) {
        output = [NSMutableAttributedString new];
        attributes = [NSMutableDictionary new];
        groupStack = [NSMutableArray new];
        parser = [RtfSyntaxParser new];
        parser.delegate = self;
    }
    return self;
}

- (NSAttributedString *)feed:(NSData*)data
{
    parser.inputStream = [NSInputStream inputStreamWithData: data];
    return output;
}

// RtfDecoderDelegate methods
- (void)controlWord:(NSString*)word
{
    const unichar NSLineSeparatorCharacter = 0x2028;
    const unichar NSParagraphSeparatorCharacter = 0x2029;
    
    if ([word compare:@"par"] == NSOrderedSame) {
        [[output mutableString] appendString:[NSString stringWithCharacters:&NSParagraphSeparatorCharacter length:1]];
    }
    else if ([word compare:@"line"] == NSOrderedSame) {
        [[output mutableString] appendString:[NSString stringWithCharacters:&NSLineSeparatorCharacter length:1]];
    }
}

- (void)groupStart
{
    [groupStack addObject:[NSMutableArray new]];
}

- (void)groupEnd
{
    // process all opened control words
    [groupStack removeLastObject];
}

- (void)text:(NSString*)text
{
    [[output mutableString] appendString:text];
}

- (void)error
{
    
}

@end
