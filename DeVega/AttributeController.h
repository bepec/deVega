//
//  AttributeController.h
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AttributeControllerDelegate

-(void)update:(BOOL)state;

@end

@protocol AttributeListSubscriber

-(void)attributesChanged:(NSDictionary*)attributes;

@end

@protocol AttributeListController

-(void)notifySubscribers;
-(void)subscribe:(id<AttributeListSubscriber>)subscriber;
-(void)setAttributes:(NSDictionary*)attributes;
-(NSDictionary*)attributes;

@end

@interface AttributeController : NSObject <AttributeListSubscriber>

+(id)createBoldfaceController;
+(id)createItalicsController;

-(void)setAttributeListController:(id<AttributeListController>)attributeListController;
-(void)setDelegate:(id<AttributeControllerDelegate>)delegate;
-(void)setAttributeState:(BOOL)value;
-(BOOL)state;
-(void)attributesChanged:(NSDictionary *)attributes;

@end