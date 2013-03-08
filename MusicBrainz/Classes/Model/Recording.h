//
//  Recording
//  MusicBrainz
//
//  Created by bruinshe on 08-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface Recording : NSObject

@property (nonatomic, retain) NSString *recordingId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSNumber *length;
@property (nonatomic, retain) NSArray *releases;
@property (nonatomic, retain) NSNumber *score;

@end