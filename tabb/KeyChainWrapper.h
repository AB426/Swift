//
//  KeyChainWrapper.h
//  KeyChainTest
//
//  Created by lhh3520 on 2015. 3. 31..
//  Copyright (c) 2015년 lhh3520. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef KeyChainTest_KeyChainWrapper_h
#define KeyChainTest_KeyChainWrapper_h

@interface KeyChainWrapper : NSObject

+ (NSData *)ItemCopyMatching: (NSDictionary *)dict;

@end

#endif
