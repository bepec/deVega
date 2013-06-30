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

@interface BoldfaceController : NSObject //<AttributeController>

//-(void)initWithCallback:(SEL)selector target:(id)object;
-(void)update:(NSDictionary*)attributes callback:(void(^)(BoldfaceController*))block;
-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes;
-(BOOL)state;

@end

