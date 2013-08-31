//
//  AttributeControllerDelegate.m
//  DeVega
//
//  Created by Admin on 6/30/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import "AttributeControllerDelegate.h"

@interface AttributeStateDelegateButton : NSObject<AttributeControllerDelegate>
{
    UIButton *_button;
    void (^_buttonEventBlock)();
}
- (id)initWithButton:(UIButton*)button andBlock:(void(^)())eventBlock;
- (void)update:(BOOL)state;

@end


@implementation AttributeStateDelegateButton

- (id)initWithButton:(UIButton*)button andBlock:(void(^)())eventBlock
{
    self->_button = button;
    self->_buttonEventBlock = eventBlock;
    [self->_button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)update:(BOOL)state
{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        _button.highlighted = state;
    }];
}

- (void)buttonEvent:(id)sender
{
    _buttonEventBlock();
}

@end

@implementation AttributeControllerDelegateFactory

+ (id<AttributeControllerDelegate>)delegateWithButton:(UIButton*)button andBlock:(void(^)())eventBlock
{
    return [[AttributeStateDelegateButton alloc] initWithButton:button andBlock:eventBlock];
}

@end

