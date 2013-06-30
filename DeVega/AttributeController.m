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
    BOOL state;
    NSMutableDictionary *_attributes;
    SEL notify;
}
@end

@implementation BoldfaceController

-(void)update:(NSDictionary*)attributes callback:(void(^)(BoldfaceController*))block
{
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    self->state = [FontNameResolver isBold:font.fontName];
//    self->_attributes = [NSMutableDictionary  ]
    if (block != nil) {
        block(self);
    }
}

-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes
{
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    if ([FontNameResolver isBold:font.fontName] == value)
        return attributes;
    
    NSMutableDictionary *modifiedAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    
    NSString *newFontName = [FontNameResolver setBold:value from:font.fontName];
    [modifiedAttributes setObject:[UIFont fontWithName:newFontName size:font.pointSize]
                           forKey:NSFontAttributeName];
    
    return modifiedAttributes;
}

-(BOOL)state
{
    return self->state;
}

@end


