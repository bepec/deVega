//
//  AttributesAdapter.h
//  DeVega
//
//  Created by Admin on 6/30/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AttributeController.h"

@interface AttributeListControllerTextView : NSObject

-(id)initWithTextView:(UITextView*)textView;
-(void)notifySubscribers;
-(void)subscribe:(id<AttributeListSubscriber>)subscriber;
-(void)setAttributes:(NSDictionary*)attributes;
-(NSDictionary*)attributes;

@end
