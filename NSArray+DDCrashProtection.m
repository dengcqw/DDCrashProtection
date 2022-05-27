//
//  NSArray+DDCrashProtection.m
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import "NSArray+DDCrashProtection.h"
#import "NSObject+DDCrashProtection.h"

@implementation NSArray (DDCrashProtection)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // designated init
        [self ddCrash_swizzleInstanceMethodWithClass:objc_getClass("__NSPlaceholderArray") originalSel:@selector(initWithObjects:count:) swizzledSel:@selector(ddCrash_initWithObjects:count:)];
        
        // __NSArrayI 有 objectAtIndex:   objectAtIndexedSubscript:
        [self ddCrash_swizzleInstanceMethodWithClass:objc_getClass("__NSArrayI") originalSel:@selector(objectAtIndex:) swizzledSel:@selector(ddCrash_objectAtIndexI:)];
        [self ddCrash_swizzleInstanceMethodWithClass:objc_getClass("__NSArrayI") originalSel:@selector(objectAtIndexedSubscript:) swizzledSel:@selector(ddCrash_objectAtIndexedSubscriptI:)];
        
        // __NSArray0 和 __NSSingleObjectArrayI  只有objectAtIndex:
        [self ddCrash_swizzleInstanceMethodWithClass:objc_getClass("__NSArray0") originalSel:@selector(objectAtIndex:) swizzledSel:@selector(ddCrash_objectAtIndex0:)];
        [self ddCrash_swizzleInstanceMethodWithClass:objc_getClass("__NSSingleObjectArrayI") originalSel:@selector(objectAtIndex:) swizzledSel:@selector(ddCrash_objectAtIndexSingleI:)];
    });
}

- (instancetype)ddCrash_initWithObjects:(id  _Nonnull const [])objects count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self ddCrash_initWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        
        [DDCrashProtection ddCrash_logCrashWithException:exception];
        
        NSInteger newObjsIndex = 0;
        id newObjects[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] != nil) {
                newObjects[newObjsIndex] = objects[i];
                newObjsIndex++;
            }
        }
        instance = [self ddCrash_initWithObjects:newObjects count:newObjsIndex];
    }
    @finally {
        return instance;
    }
}

- (id)ddCrash_objectAtIndexedSubscriptI:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self ddCrash_objectAtIndexedSubscriptI:idx];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
        return object;
    }
}

- (id)ddCrash_objectAtIndexI:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self ddCrash_objectAtIndexI:index];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
        return object;
    }
}

- (id)ddCrash_objectAtIndex0:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self ddCrash_objectAtIndex0:index];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
        return object;
    }
}

- (id)ddCrash_objectAtIndexSingleI:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self ddCrash_objectAtIndexSingleI:index];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
        return object;
    }
}

@end
