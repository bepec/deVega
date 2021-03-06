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
    NSDictionary *_defaultAttributes;
    AttributeController *_boldfaceController;
    AttributeController *_italicsController;
    NSMutableArray *_subscribers;
    NSDictionary *_controlWordHandlers;
    int _skipGroupCounter;
    NSSet *_skipGroupWords;
}
- (void)initControlWordHandlers;
- (void)appendString:(NSString*)string;
@end


@implementation AttributedStringBuilder

- (id)init
{
    NSDictionary *defaultAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Helvetica" size:12], NSFontAttributeName, nil];
    RtfSyntaxParser *parser = [RtfSyntaxParser new];
    return [self initWithParser:parser andAttributes:defaultAttributes];
}

- (id)initWithParser:(RtfSyntaxParser*)parser andAttributes:(NSDictionary*)defaultAttributes
{
    if (self = [super init]) {
        _output = [NSMutableAttributedString new];
        
        _attributesStack = [NSMutableArray new];
        
        _subscribers = [NSMutableArray new];
        
        _boldfaceController = [AttributeController createBoldfaceController];
        _boldfaceController.attributeListController = self;
        
        _italicsController = [AttributeController createItalicsController];
        _italicsController.attributeListController = self;
        
        _skipGroupCounter = 0;
        _skipGroupWords = [NSSet setWithObjects:@"*", @"generator", @"fonttbl", @"colortbl", @"styletbl", nil];
        
        _defaultAttributes = defaultAttributes;
        _parser = parser;
        _parser.delegate = self;

        [self initControlWordHandlers];
    }
    return self;
}

- (NSAttributedString *)feed:(NSData*)data
{
    _parser.inputStream = [NSInputStream inputStreamWithData: data];
    return _output;
}

- (NSAttributedString *)output
{
    return _output;
}

// RtfDecoderDelegate methods
- (void)controlWord:(NSString*)word
{
    assert(word.length > 0);
    
    if (_skipGroupCounter > 0)
        return;
    
    if ([_skipGroupWords containsObject:word]) {
        _skipGroupCounter++;
        return;
    }
    
    void (^handler)() = [_controlWordHandlers objectForKey:word];
    if (handler == nil)
        return;

    handler();
}

- (void)groupStart
{
    if (_skipGroupCounter) {
        _skipGroupCounter++;
        return;
    }
    
    [_attributesStack addObject:[NSMutableDictionary dictionaryWithDictionary:self.attributes]];
}

- (void)groupEnd
{
    if (_skipGroupCounter) {
        _skipGroupCounter--;
        return;
    }
    
    assert(_attributesStack.count > 0);
    
    [_attributesStack removeLastObject];
    [self notifySubscribers];
}

- (void)text:(NSString*)text
{
    if (_skipGroupCounter) return;
    
    [self appendString:text];
}

// AttributeStringController methods

- (void)notifySubscribers
{
    for (id<AttributeListSubscriber>subscriber in _subscribers) {
        [subscriber attributesChanged:self.attributes];
    }
}

- (void)subscribe:(id<AttributeListSubscriber>)subscriber
{
    [_subscribers addObject:subscriber];
}

- (void)setAttributes:(NSDictionary*)attributes
{
    assert(_attributesStack.count > 0);
    
    [_attributesStack removeLastObject];
    [_attributesStack addObject:[NSMutableDictionary dictionaryWithDictionary:attributes]];
    [self notifySubscribers];
}

- (NSDictionary*)attributes
{
    return _attributesStack.count == 0 ? _defaultAttributes : _attributesStack.lastObject;
}

- (void)initControlWordHandlers
{
    assert(_controlWordHandlers == nil);
    
    static const unichar NSLineSeparatorCharacter = 0x2028;
    static const unichar NSParagraphSeparatorCharacter = 0x2029;
    
    void (^par)()  = ^{ [self appendString:[NSString stringWithCharacters:&NSParagraphSeparatorCharacter length:1]]; };
    void (^line)() = ^{ [self appendString:[NSString stringWithCharacters:&NSLineSeparatorCharacter length:1]]; };
    void (^b)()    = ^{ _boldfaceController.attributeState = YES; };
    void (^b0)()   = ^{ _boldfaceController.attributeState = NO; };
    void (^i)()    = ^{ _italicsController.attributeState = YES; };
    void (^i0)()   = ^{ _italicsController.attributeState = NO; };

    _controlWordHandlers = [NSDictionary dictionaryWithObjectsAndKeys: par,  @"par",
                                                                       line, @"line",
                                                                       b,    @"b",
                                                                       b0,   @"b0",
                                                                       i,    @"i",
                                                                       i0,   @"i0",
                                                                       nil];
}

- (void)appendString:(NSString *)string
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:string attributes:self.attributes];
    [_output appendAttributedString:attributedString];
}

@end
