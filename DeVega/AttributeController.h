//
//  AttributeController.h
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeListController.h"
#import "AttributeControllerDelegate.h"

@protocol AttributeController

-(void)update:(NSDictionary*)attributes;
-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes;

@end

@interface BoldfaceController : NSObject <AttributeListSubscriber>//<AttributeController>

-(id)initWithAttributeListController:(id<AttributeListController>)attributeListController;
-(void)setAttributeState:(BOOL)value;
-(BOOL)state;
-(void)setDelegate:(id<AttributeControllerDelegate>)delegate;
-(void)attributesChanged:(NSDictionary *)attributes;

@end