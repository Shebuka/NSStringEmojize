//
//  NSString+Emojize.m
//  NSStringEmojize
//
//  Modified by Anton Shebukov on 30/01/15
//  to support Facebook emoticons.
//  Copyright (c) 2015-2016 Feedback Italia S.r.l. All rights reserved.
//
//  Created by Jonathan Beilin on 11/05/12.
//  Copyright (c) 2012-2014 DIY. All rights reserved.
//
//  Inspired by https://github.com/larsschwegmann/Emoticonizer

#import "NSString+Emojize.h"
#import "emojis.h"

@implementation NSString (Emojize)

- (NSString *)emojizedString {
    return [NSString emojizedStringWithString:self];
}

+ (NSString *)emojizedStringWithString:(NSString *)text {
    static dispatch_once_t onceToken;
    static NSRegularExpression *regex = nil;
    dispatch_once(&onceToken, ^{
        regex = [[NSRegularExpression alloc] initWithPattern:@"(:[a-z0-9-+_]+:)" options:NSRegularExpressionCaseInsensitive error:NULL];
    });
    
    __block NSString *resultText = text;
    NSRange matchingRange = NSMakeRange(0, [resultText length]);
    [regex enumerateMatchesInString:resultText options:NSMatchingReportCompletion range:matchingRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
         if (result && ([result resultType] == NSTextCheckingTypeRegularExpression) && !(flags & NSMatchingInternalError)) {
             NSRange range = result.range;
             if (range.location != NSNotFound) {
                 NSString *code = [text substringWithRange:range];
                 NSString *unicode = self.emojiAliases[code];
                 if (unicode) {
                     resultText = [resultText stringByReplacingOccurrencesOfString:code withString:unicode];
                 }
             }
         }
     }];
    
    NSError *error = nil;
    for (NSString *key in self.emojiEmoticons) {
        NSString *pattern = [NSString stringWithFormat:@"(?<=^|\\s)(%@)(?=\\s|[^\"-(*+\\-/->@-~]|$)", [NSRegularExpression escapedPatternForString:key]];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
        
        resultText = [regex stringByReplacingMatchesInString:resultText options:0 range:NSMakeRange(0, [resultText length]) withTemplate:(NSString *)[self.emojiEmoticons objectForKey:key]];
        
//        NSArray *matches = [regex matchesInString:resultText options:0 range:NSMakeRange(0, [resultText length])];
//        for (NSTextCheckingResult *match in matches) {
//            NSRange matchRange = match.range;
//            resultText = [resultText stringByReplacingOccurrencesOfString:key withString:(NSString *)[self.emojiEmoticons objectForKey:key] options:0 range:matchRange];
//        }
    }
    
    return resultText;
}

+ (NSDictionary *)emojiAliases {
    static NSDictionary *_emojiAliases;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emojiAliases = EMOJI_HASH;
    });
    return _emojiAliases;
}

+ (NSDictionary *)emojiEmoticons {
    static NSDictionary *_emojiEmoticons;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _emojiEmoticons = EMOJI_EMOTICONS_HASH;
    });
    return _emojiEmoticons;
}

@end
