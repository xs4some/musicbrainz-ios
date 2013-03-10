//
//  LabelService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import "LabelService.h"


@implementation LabelService

+(NSArray *)labelsWithArray:(NSArray *)array
{
    NSMutableArray *results = [[NSMutableArray alloc] init];

    for (NSDictionary *dictionary in array)
    {
        Label *label = [LabelService labelWithDictionary:dictionary];

        if (label)
        {
            [results addObject:label];
        }
    }

    return results;
}

+(Label *)labelWithDictionary:(NSDictionary *)dictionary
{
    if (![dictionary objectForKey:@"id"] || ![dictionary objectForKey:@"name"])
    {
#if DEBUG
        NSLog(@"label: Missing elements in response\n%@", dictionary);
#endif
        return nil;
    }

    Label *label = [[Label alloc] init];

    label.labelId = [dictionary objectForKey:@"id"];
    label.name = [dictionary objectForKey:@"name"];

    if ([dictionary objectForKey:@"life-span"])
    {
        NSDictionary *lifeSpan = [dictionary objectForKey:@"life-span"];

        if ([lifeSpan objectForKey:@"begin"])
        {
            label.lifeSpanBegin = [lifeSpan objectForKey:@"begin"];
        }
        if ([lifeSpan objectForKey:@"end"])
        {
            label.lifeSpanEnd = [lifeSpan objectForKey:@"end"];
        }
        if ([lifeSpan objectForKey:@"ended"])
        {
            NSNumber *lifeSpanEnded = [lifeSpan objectForKey:@"ended"];

            label.lifeSpanEnded = lifeSpanEnded.boolValue;
        }
    }

    if ([dictionary objectForKey:@"score"])
    {
        label.score = [dictionary objectForKey:@"score"];
    }

    if ([dictionary objectForKey:@"country"])
    {
        label.country = [dictionary objectForKey:@"country"];
    }

    return label;
}

@end