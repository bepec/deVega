//
//  AttributedStringBuilder.m
//  DeVega
//
//  Created by Admin on 8/3/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//


#import "AttributedStringBuilder.h"
#import "FontNameResolver.h"

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
        [attributes setObject:[NSFont fontWithName:@"Helvetica" size:12] forKey:NSFontAttributeName];
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
    else if ([word compare:@"b"] == NSOrderedSame) {
        NSFont *font = (NSFont *)[attributes objectForKey:NSFontAttributeName];
        if (![FontNameResolver isBold:font.fontName]) {
            NSFont *newFont = [NSFont fontWithName:[FontNameResolver setBold:YES from:font.fontName] size:font.pointSize];
            [attributes setObject:newFont forKey:NSFontAttributeName];
        }
    }
    else if ([word compare:@"b0"] == NSOrderedSame) {
        NSFont *font = (NSFont *)[attributes objectForKey:NSFontAttributeName];
        if ([FontNameResolver isBold:font.fontName]) {
            NSFont *newFont = [NSFont fontWithName:[FontNameResolver setBold:NO from:font.fontName] size:font.pointSize];
            [attributes setObject:newFont forKey:NSFontAttributeName];
        }
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
    NSAttributedString *stringToAppend = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    [output appendAttributedString:stringToAppend];
}

- (void)error
{
    
}

@end
