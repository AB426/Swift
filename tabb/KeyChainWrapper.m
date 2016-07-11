//
//  KeyChainWrapper.m
//  KeyChainTest
//
//  Created by lhh3520 on 2015. 3. 31..
//  Copyright (c) 2015년 lhh3520. All rights reserved.
//
#import "KeyChainWrapper.h"

@implementation KeyChainWrapper

+ (NSData *)ItemCopyMatching: (NSDictionary *)dict {
    
    CFTypeRef searchResultRef = NULL;
    OSStatus err = SecItemCopyMatching((__bridge CFDictionaryRef)dict, &searchResultRef);
    
    NSData *result = nil;
    if(err == noErr) {
        // transfer ownership so ARC will take care of releasing underlying CF object
        result = (__bridge_transfer id)searchResultRef;
    }
    
    return result;
}
@end