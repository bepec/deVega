//
//  AttributeController.h
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AttributeController

//-(BOOL)
-(void)update:(NSDictionary*)attributes;
-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes;

@end

//@interface AttributeCOntroller

@protocol AttributeStateDelegate

-(void)update:(BOOL)state;

@end


@interface BoldfaceController : NSObject //<AttributeController>

-(void)update:(NSDictionary*)attributes;
-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes;
-(BOOL)state;
-(void)setStateDelegate:(id<AttributeStateDelegate>)delegate;

@end

