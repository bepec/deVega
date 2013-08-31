//
//  AttributeController.m
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "AttributeController.h"
#import "FontNameResolver.h"

#import <TargetConditionals.h>
#ifdef TARGET_OS_MAC
//typedef NSFont UIFont;
#endif

@interface AttributeController ()
{
    BOOL _state;
    NSMutableDictionary *_attributes;
    id<AttributeControllerDelegate> _delegate;
    id<AttributeListController> _attributeListController;
    
    BOOL (^_getStateFromFont)(UIFont *font);
    UIFont* (^_makeFontForState)(UIFont *font, BOOL state);
}
- (id)init;
@end

@implementation AttributeController

+ (id)createBoldfaceController
{
    AttributeController *controller = [AttributeController new];
    
    controller->_getStateFromFont = ^BOOL(UIFont *font) {
        return [FontNameResolver isBold:font.fontName];
    };
    
    controller->_makeFontForState = ^UIFont*(UIFont *font, BOOL state) {
        return [UIFont fontWithName:[FontNameResolver setBold:state from:font.fontName] size:font.pointSize];
    };
    
    return controller;
}

+ (id)createItalicsController
{
    AttributeController *controller = [AttributeController new];
    
    controller->_getStateFromFont = ^BOOL(UIFont *font) {
        return [FontNameResolver isItalic:font.fontName];
    };
    
    controller->_makeFontForState = ^UIFont*(UIFont *font, BOOL state) {
        return [UIFont fontWithName:[FontNameResolver setItalic:state from:font.fontName] size:font.pointSize];
    };
    
    return controller;
}

- (id)init
{
    _state = NO;
    return self;
}

- (void)setAttributeListController:(id<AttributeListController>)attributeListController
{
    _attributeListController = attributeListController;
    [attributeListController subscribe:self];
}

- (void)setAttributeState:(BOOL)value
{
    NSDictionary *attributes = [_attributeListController attributes];
    
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    if (self->_getStateFromFont(font) == value)
        return;
    
    UIFont *newFont = _makeFontForState(font, value);

    NSMutableDictionary *modifiedAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    [modifiedAttributes setObject:newFont forKey:NSFontAttributeName];
    [_attributeListController setAttributes:modifiedAttributes];
}

- (BOOL)state
{
    return _state;
}

- (void)setDelegate:(id<AttributeControllerDelegate>)delegate
{
    _delegate = delegate;
    [delegate update:self.state];
}

- (void)attributesChanged:(NSDictionary *)attributes
{
    if (attributes == nil)
        return;
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    BOOL newState = _getStateFromFont(font);
    if (newState != _state) {
        _state = newState;
        [_delegate update:_state];
    }
}

@end
