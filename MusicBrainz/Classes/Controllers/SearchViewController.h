//
//  SearchViewController.h
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 04-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchQueryTextCell.h"
#import "SearchService.h"

@interface SearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, SearchQueryTextCellDelegate, UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *results;
@property (nonatomic, assign) SearchType searchType;

@end
