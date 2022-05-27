//
//  NSMutableArray+DDCrashProtection.m
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import "NSMutableArray+DDCrashProtection.h"
#import "NSObject+DDCrashProtection.h"

@implementation NSMutableArray (DDCrashProtection)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class dClass = NSClassFromString(@"__NSArrayM");
        
        // - (void)addObject:(ObjectType)anObject(实际调用insertObject:)
        [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(insertObject:atIndex:) swizzledSel:@selector(ddCrash_insertObject:atIndex:)];
        [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(removeObjectAtIndex:) swizzledSel:@selector(ddCrash_removeObjectAtIndex:)];
        [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(removeObjectsInRange:) swizzledSel:@selector(ddCrash_removeObjectsInRange:)];
        
        [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(objectAtIndex:) swizzledSel:@selector(ddCrash_objectAtIndexM:)];
        [self ddCrash_swizzleInstanceMethodWithClass:dClass originalSel:@selector(objectAtIndexedSubscript:) swizzledSel:@selector(ddCrash_objectAtIndexedSubscriptM:)];
    });
}

- (void)ddCrash_insertObject:(id)anObject atIndex:(NSUInteger)index {
    @try {
        [self ddCrash_insertObject:anObject atIndex:index];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
        
    }
}

- (void)ddCrash_removeObjectAtIndex:(NSUInteger)index {
    @try {
        [self ddCrash_removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
        
    }
}

-(void)ddCrash_removeObjectsInRange:(NSRange)range {
    @try {
        [self ddCrash_removeObjectsInRange:range];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
        
    }
}

- (id)ddCrash_objectAtIndexedSubscriptM:(NSUInteger)idx {
    id object = nil;
    @try {
        object = [self ddCrash_objectAtIndexedSubscriptM:idx];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
        return object;
    }
}

- (id)ddCrash_objectAtIndexM:(NSUInteger)index {
    id object = nil;
    @try {
        object = [self ddCrash_objectAtIndexM:index];
    }
    @catch (NSException *exception) {
        [DDCrashProtection ddCrash_logCrashWithException:exception];
    }
    @finally {
        return object;
    }
}

@end
