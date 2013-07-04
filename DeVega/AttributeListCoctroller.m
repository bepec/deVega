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
    [self->_subscribers addObject:subscriber];
}

-(void)setAttributes:(NSDictionary*)attributes
{
    NSRange range = self->_textView.selectedRange;
    if (range.length == 0) {
        self->_textView.typingAttributes = attributes;
    }
    else {
        NSMutableAttributedString *modifiedString = [[NSMutableAttributedString alloc] initWithAttributedString:self->_textView.attributedText];
        [modifiedString setAttributes:attributes range:range];
        self->_textView.attributedText = modifiedString;
        self->_textView.selectedRange = range;
    }
    [self notifySubscribers];
}

-(NSDictionary*)attributes
{
    NSRange range = self->_textView.selectedRange;
    if (range.location == NSNotFound) {
        return nil;
    }
    else if (range.length == 0) {
        return self->_textView.typingAttributes;
    }
    else {
        return [self->_textView.attributedText attributesAtIndex:range.location
                                           effectiveRange:nil];
    }
}

-(void)notifySubscribers
{
    for (id<AttributeListSubscriber> subscriber in self->_subscribers) {
        [subscriber attributesChanged:self.attributes];
    }
}

@end
