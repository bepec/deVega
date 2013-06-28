//
//  AttributeController.h
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AttributeController

-(BOOL)updateValue:(NSDictionary*)attributes;
-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes;

@end


@interface BoldfaceController : NSObject <AttributeController>

-(BOOL)updateValue:(NSDictionary*)attributes;
-(NSDictionary*)set:(BOOL)value in:(NSDictionary*)attributes;

@end