//
//  AttributeControllerDelegate.h
//  DeVega
//
//  Created by Admin on 6/30/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AttributeControllerDelegate

-(void)update:(BOOL)state;

@end

@interface AttributeControllerDelegateFactory : NSObject

+(id<AttributeControllerDelegate>)delegateWithButton:(UIButton*)button andBlock:(void(^)())eventBlock;

@end
