//
//  AttributeController.m
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "AttributeController.h"
#import "FontNameResolver.h"


@interface BoldfaceController ()
{
    BOOL _state;
    NSMutableDictionary *_attributes;
    id<AttributeControllerDelegate> _delegate;
    id<AttributeListController> _attributeListController;
}
@end

@implementation BoldfaceController

-(id)initWithAttributeListController:(id<AttributeListController>)attributeListController
{
    self = [super init];
    
    if (self)
    {
        self->_delegate = nil;
        self->_state = NO;
        self->_attributeListController = attributeListController;
        [attributeListController subscribe:self];
    }
    
    return self;
}

-(void)setAttributeState:(BOOL)value
{
    NSDictionary *attributes = [self->_attributeListController attributes];
    
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    if ([FontNameResolver isBold:font.fontName] == value)
        return;
    
    NSMutableDictionary *modifiedAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    NSString *newFontName = [FontNameResolver setBold:value from:font.fontName];
    [modifiedAttributes setObject:[UIFont fontWithName:newFontName size:font.pointSize]
                           forKey:NSFontAttributeName];

    [self->_attributeListController setAttributes:modifiedAttributes];
}

-(BOOL)state
{
    return self->_state;
}

-(void)setDelegate:(id<AttributeControllerDelegate>)delegate
{
    self->_delegate = delegate;
    [delegate update:self.state];
}

-(void)attributesChanged:(NSDictionary *)attributes
{
    if (attributes == nil)
        return;
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    BOOL newState = [FontNameResolver isBold:font.fontName];
    if (newState != self.state) {
        self->_state = newState;
        [self->_delegate update:self->_state];
    }
}

@end
