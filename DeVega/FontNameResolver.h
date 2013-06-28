//
//  FontNameResolver.h
//  DeVega
//
//  Created by Admin on 6/28/13.
//  Copyright (c) 2013 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FontNameResolver : NSObject

+(BOOL)isBold:(NSString*)fontName;
+(BOOL)isItalic:(NSString*)fontName;
+(NSString*)setBold:(BOOL)value from:(NSString*)fontName;
+(NSString*)setItalic:(BOOL)value from:(NSString*)fontName;

@end
