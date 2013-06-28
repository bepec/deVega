//
//  AttributeController.m
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "AttributeController.h"
#import "FontNameResolver.h"


@implementation BoldfaceController

-(BOOL)updateValue:(NSDictionary*)attributes
{
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    return [FontNameResolver isBold:font.fontName];
}

-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes
{
    if ([self updateValue:attributes] == value)
        return attributes;
    
    NSMutableDictionary *modifiedAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];
    UIFont *font = (UIFont*)[attributes objectForKey:NSFontAttributeName];
    
    NSString *newFontName = [FontNameResolver setBold:value from:font.fontName];
    [modifiedAttributes setObject:[UIFont fontWithName:newFontName size:font.pointSize]
                           forKey:NSFontAttributeName];
    
    return modifiedAttributes;
}

@end


