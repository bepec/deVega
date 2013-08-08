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
    NSMutableDictionary* _attributes;
    
    AttributeController *_boldfaceController;
    NSMutableArray *_subscribers;
}
@end


@implementation AttributedStringBuilder

- (id)init
{
    if (self = [super init]) {
        output = [NSMutableAttributedString new];
        _attributes = [NSMutableDictionary new];
        [_attributes setObject:[NSFont fontWithName:@"Helvetica" size:12] forKey:NSFontAttributeName];
        
        groupStack = [NSMutableArray new];
        _subscribers = [NSMutableArray new];

        parser = [RtfSyntaxParser new];
        parser.delegate = self;

        _boldfaceController = [AttributeController createBoldfaceController];
        _boldfaceController.attributeListController = self;
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
        if (![_boldfaceController state]) {
            _boldfaceController.attributeState = YES;
        }
    }
    else if ([word compare:@"b0"] == NSOrderedSame) {
        if ([_boldfaceController state]) {
            _boldfaceController.attributeState = NO;
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
    NSAttributedString *stringToAppend = [[NSAttributedString alloc] initWithString:text attributes:_attributes];
    [output appendAttributedString:stringToAppend];
}

- (void)error
{
    
}

// AttributeStringController methods

-(void)notifySubscribers
{
    for (id<AttributeListSubscriber>subscriber in _subscribers) {
        [subscriber attributesChanged:_attributes];
    }
}

-(void)subscribe:(id<AttributeListSubscriber>)subscriber
{
    [_subscribers addObject:subscriber];
}

-(void)setAttributes:(NSDictionary*)attributes
{
    _attributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [self notifySubscribers];
}

-(NSDictionary*)attributes
{
    return _attributes;
}


@end
