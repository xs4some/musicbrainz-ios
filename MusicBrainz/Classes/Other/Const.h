//
//  Const.h
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 04-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#ifndef MusicBrainz_Const_h
#define MusicBrainz_Const_h

#define kBuildVersion @"1.0"
#define kBuildDate 20130304
#define kUserAgent @"[musicbrainz]:[iPhone]:[%@]:[%d]"
#define kClientId @"musicbrainz.ios-1.0"

#define kNavigationBarColour 0x666633
#define kNavigationBarTextColour 0xFFFFFF

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define iPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define Retina ([UIScreen mainScreen].scale == 2.0f)

#endif
