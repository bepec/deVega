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
    id<AttributeStateDelegate> _delegate;
}
-(void)setState:(BOOL)value;
@end

@implementation BoldfaceController

-(void)update:(NSDictionary*)attributes
{
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    self.state = [FontNameResolver isBold:font.fontName];
}

-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes
{
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    if ([FontNameResolver isBold:font.fontName] == value)
        return attributes;
    
    self.state = value;
    
    NSMutableDictionary *modifiedAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    NSString *newFontName = [FontNameResolver setBold:value from:font.fontName];
    [modifiedAttributes setObject:[UIFont fontWithName:newFontName size:font.pointSize]
                           forKey:NSFontAttributeName];
    
    return modifiedAttributes;
}

-(void)setState:(BOOL)value
{
    if (self->_state == value)
        return;
    self->_state = value;
    [self->_delegate update:self->_state];
}

-(BOOL)state
{
    return self->_state;
}

-(void)setStateDelegate:(id<AttributeStateDelegate>)delegate
{
    self->_delegate = delegate;
    [delegate update:self.state];
}

@end


