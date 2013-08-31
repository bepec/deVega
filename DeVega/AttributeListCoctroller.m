//
//  AttributesAdapter.m
//  DeVega
//
//  Created by Admin on 6/30/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "AttributeListController.h"

@interface AttributeListControllerTextView ()
{
    UITextView *_textView;
    NSMutableSet *_subscribers;
}
@end

@implementation AttributeListControllerTextView

-(id)initWithTextView:(UITextView*)textView
{
    self = [super init];
    if (self) {
        self->_subscribers = [NSMutableSet new];
        self->_textView = textView;
    }
    return self;
}

-(void)subscribe:(id<AttributeListSubscriber>)subscriber
{
    [_subscribers addObject:subscriber];
}

-(void)setAttributes:(NSDictionary*)attributes
{
    NSRange range = _textView.selectedRange;
    if (range.length == 0) {
        _textView.typingAttributes = attributes;
    }
    else {
        NSMutableAttributedString *modifiedString = [[NSMutableAttributedString alloc] initWithAttributedString:_textView.attributedText];
        [modifiedString setAttributes:attributes range:range];
        _textView.attributedText = modifiedString;
        _textView.selectedRange = range;
    }
    [self notifySubscribers];
}

-(NSDictionary*)attributes
{
    NSRange range = _textView.selectedRange;
    if (range.location == NSNotFound) {
        return nil;
    }
    else if (range.length == 0) {
        return _textView.typingAttributes;
    }
    else {
        return [_textView.attributedText attributesAtIndex:range.location
                                           effectiveRange:nil];
    }
}

-(void)notifySubscribers
{
    for (id<AttributeListSubscriber> subscriber in _subscribers) {
        [subscriber attributesChanged:self.attributes];
    }
}

@end
