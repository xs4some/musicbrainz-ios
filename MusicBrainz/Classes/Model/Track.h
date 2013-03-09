//
//  Track
//  MusicBrainz
//
//  Created by bruinshe on 09-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Recording.h"

@interface Track : NSObject

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSNumber *number;
@property (nonatomic, retain) NSNumber *length;
@property (nonatomic, retain) Recording *recording;
@property (nonatomic, retain) NSArray *artists;

@end