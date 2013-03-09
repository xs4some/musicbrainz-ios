//
//  LabelService
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "BasicService.h"
#import "Label.h"

@interface LabelService : BasicService


+(NSArray *)parseLabelsWithArray:(NSArray *)array;
+(Label *)parseLabelWithDictionary:(NSDictionary *)dictionary;

@end