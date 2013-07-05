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

//@protocol AttributeController
//
//-(void)update:(NSDictionary*)attributes;
//-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes;
//
//@end

@interface AttributeController : NSObject <AttributeListSubscriber>

+(id)createBoldfaceController;
+(id)createItalicsController;

-(void)setAttributeListController:(id<AttributeListController>)attributeListController;
-(void)setDelegate:(id<AttributeControllerDelegate>)delegate;
-(void)setAttributeState:(BOOL)value;
-(BOOL)state;
-(void)attributesChanged:(NSDictionary *)attributes;

@end