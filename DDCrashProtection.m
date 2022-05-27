//
//  DDCrashProtection.m
//  DDCrashProtection
//
//  Created by dengjinlong on 2019/5/20.
//

#import "DDCrashProtection.h"
#import <UIKit/UIKit.h>
#import <BlockKit.h>

@implementation DDCrashProtection

+ (void)ddCrash_logCrashWithException:(NSException *)exception {
}

+ (void)showErrorMessageWithException:(NSException *)exception {
    UIAlertView *alertViewTemp = [[UIAlertView alloc] bk_initWithTitle:@"This is a Crash" message:exception.reason];
    [alertViewTemp bk_addButtonWithTitle:@"Copy Crash to Clipboard" handler:^{
        UIPasteboard *paste = [UIPasteboard generalPasteboard];
        paste.string = [[self getSymbolInfoWithCallStackSymbolArray:exception.callStackSymbols]  componentsJoinedByString:@"\n"];
    }];
    [alertViewTemp show];
}

+ (NSArray *)getSymbolInfoWithCallStackSymbolArray:(NSArray *)callStackSymbolArray {
    NSString *regularExpStr = @"[-\\+]\\[.+\\]";
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpStr options:NSRegularExpressionCaseInsensitive error:nil];
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 0; i < callStackSymbolArray.count; i++) {
        NSString *symbolString = callStackSymbolArray[i];
        [regularExp enumerateMatchesInString:symbolString options:NSMatchingReportProgress range:NSMakeRange(0, symbolString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            if (result) {
                [array addObject:[symbolString substringFromIndex:result.range.location]];
                *stop = YES;
            }
        }];
    }
    return [array copy];
}

@end
