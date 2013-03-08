//
//  Work
//  MusicBrainz
//
//  Created by bruinshe on 08-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Work : NSObject

@property (nonatomic, retain) NSString *workId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *language;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSNumber *score;
@property (nonatomic, retain) NSArray *composers;
@property (nonatomic, retain) NSArray *lyricists;
@property (nonatomic, retain) NSArray *performers;

@end