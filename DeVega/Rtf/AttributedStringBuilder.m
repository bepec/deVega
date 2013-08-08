//
//  AttributedStringBuilder.m
//  DeVega
//
//  Created by Admin on 8/3/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//


#import "AttributedStringBuilder.h"

@interface AttributedStringBuilder()
{
    RtfSyntaxParser *_parser;
    NSMutableAttributedString *_output;
    NSMutableArray *_attributesStack;
    NSMutableDictionary *_defaultAttributes;
    AttributeController *_boldfaceController;
    NSMutableArray *_subscribers;
}
@end


@implementation AttributedStringBuilder

- (id)init
{
    if (self = [super init]) {
        _output = [NSMutableAttributedString new];
        
        _defaultAttributes = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSFont fontWithName:@"Helvetica" size:12], NSFontAttributeName, nil];
        
        _attributesStack = [NSMutableArray new];

        _subscribers = [NSMutableArray new];

        _parser = [RtfSyntaxParser new];
        _parser.delegate = self;

        _boldfaceController = [AttributeController createBoldfaceController];
        _boldfaceController.attributeListController = self;
    }
    return self;
}

- (NSAttributedString *)feed:(NSData*)data
{
    _parser.inputStream = [NSInputStream inputStreamWithData: data];
    return _output;
}

// RtfDecoderDelegate methods
- (void)controlWord:(NSString*)word
{
    const unichar NSLineSeparatorCharacter = 0x2028;
    const unichar NSParagraphSeparatorCharacter = 0x2029;
    
    if ([word compare:@"par"] == NSOrderedSame) {
        [[_output mutableString] appendString:[NSString stringWithCharacters:&NSParagraphSeparatorCharacter length:1]];
    }
    else if ([word compare:@"line"] == NSOrderedSame) {
        [[_output mutableString] appendString:[NSString stringWithCharacters:&NSLineSeparatorCharacter length:1]];
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
    [_attributesStack addObject:[NSMutableDictionary dictionaryWithDictionary:self.attributes]];
}

- (void)groupEnd
{
    assert(_attributesStack.count > 0);
    
    [_attributesStack removeLastObject];
    [self notifySubscribers];
}

- (void)text:(NSString*)text
{
    NSAttributedString *stringToAppend = [[NSAttributedString alloc] initWithString:text attributes:self.attributes];
    [_output appendAttributedString:stringToAppend];
}

- (void)error
{
    
}

// AttributeStringController methods

-(void)notifySubscribers
{
    for (id<AttributeListSubscriber>subscriber in _subscribers) {
        [subscriber attributesChanged:self.attributes];
    }
}

-(void)subscribe:(id<AttributeListSubscriber>)subscriber
{
    [_subscribers addObject:subscriber];
}

-(void)setAttributes:(NSDictionary*)attributes
{
    assert(_attributesStack.count > 0);
    
    [_attributesStack removeLastObject];
    [_attributesStack addObject:[NSMutableDictionary dictionaryWithDictionary:attributes]];
    [self notifySubscribers];
}

-(NSDictionary*)attributes
{
    return _attributesStack.count == 0 ? _defaultAttributes : _attributesStack.lastObject;
}


@end
