//
//  SearchViewController.m
//  MusicBrainz
//
//  Created by Hendrik Bruinsma on 04-03-13.
//  Copyright (c) 2013 xs4some. All rights reserved.
//

#import "SearchViewController.h"
#import "Artist.h"
#import "ArtistDetailViewController.h"
#import "BarcodeScanViewController.h"
#import "Label.h"
#import "Recording.h"
#import "Release.h"
#import "ReleaseGroup.h"
#import "Work.h"

@interface SearchViewController ()

-(void)performSearchQuery;
-(IBAction)searchWithBarcode:(id)sender;
-(void)displayErrorWithMessage:(NSString *)message;

@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.title = NSLocalizedString(@"SEARCH_TITLE", @"Search");
        self.tabBarItem.image = [UIImage imageNamed:@"magnifier"];
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.results = [NSArray array];

    UIBarButtonItem *scanButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"SEARCH_SCAN", @"Scan barcode")
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(searchWithBarcode:)];

    self.navigationItem.rightBarButtonItem = scanButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView Delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 2;
    } else
    {
        return [self.results count];
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return NSLocalizedString(@"SEARCH_DESCRIPTION", @"Enter search criteria");
    } else
    {
        if (!self.results || [self.results count] == 0 )
        {
            return NSLocalizedString(@"SEARCH_RESULTS_NONE", @"Nothing found (yet)");
        } else
        {
            return NSLocalizedString(@"SEARCH_RESULTS_FOUND", @"Search results");
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSString *CellIdentifier = @"SearchQueryTypeCell";
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
            }
            cell.textLabel.text = NSLocalizedString(@"SEARCH_QUERY_TYPE", @"Query type");

            switch (self.searchType)
            {
                case SearchTypeArtist:
                    cell.detailTextLabel.text = @"Artist";
                    break;

                case SearchTypeLabel:
                    cell.detailTextLabel.text = @"Label";
                    break;

                case SearchTypeRecording:
                    cell.detailTextLabel.text = @"Recording";
                    break;

                case SearchTypeRelease:
                    cell.detailTextLabel.text = @"Release";
                    break;

                case SearchTypeReleaseGroup:
                    cell.detailTextLabel.text = @"Release-Group";
                    break;

                case SearchTypeWork:
                    cell.detailTextLabel.text = @"Work";
                    break;

                default:
                    cell.detailTextLabel.text = @"";
            }

            return cell;
            
        } else
        {
            NSString *CellIdentifier = @"SearchQueryTextCell";

            SearchQueryTextCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SearchQueryTextCell" owner:nil options:nil];
                
                for (id object in topLevelObjects)
                {
                    if ([object isKindOfClass:[SearchQueryTextCell class]])
                    {
                        cell = (SearchQueryTextCell *) object;
                        break;
                    }
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textField.placeholder = NSLocalizedString(@"SEARCH_QUERY_PLACEHOLDER", @"Search query placeholder text");
            
            cell.textField.delegate = self;
            
            return cell;
        }
        
    } else
    {
        NSString *CellIdentifier = @"SearchResultsCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }

        if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Artist class]])
        {
            Artist *artist = [self.results objectAtIndex:indexPath.row];
            cell.textLabel.text = artist.name;
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Label class]])
        {
            Label *label = [self.results objectAtIndex:indexPath.row];
            cell.textLabel.text = label.name;
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Recording class]])
        {
            Recording *recording = [self.results objectAtIndex:indexPath.row];
            cell.textLabel.text = recording.title;
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Release class]])
        {
            Release *release = [self.results objectAtIndex:indexPath.row];
            cell.textLabel.text = release.title;
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[ReleaseGroup class]])
        {
            ReleaseGroup *releaseGroup = [self.results objectAtIndex:indexPath.row];
            cell.textLabel.text = releaseGroup.title;
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Work class]])
        {
            Work *work = [self.results objectAtIndex:indexPath.row];
            cell.textLabel.text = work.title;
        } else
        {
            cell.textLabel.text = @"";
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if ((indexPath.section == 0) && (indexPath.row == 0))
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select search type"
                                                                 delegate:self
                                                        cancelButtonTitle:nil
                                                   destructiveButtonTitle:NSLocalizedString(@"CANCEL", @"Cancel")
                                                        otherButtonTitles:NSLocalizedString(@"SEARCH_ARTIST", @"Artist"),
                        NSLocalizedString(@"SEARCH_LABEL", @"Label"),
                        NSLocalizedString(@"SEARCH_RECORDING", @"Recording"),
                        NSLocalizedString(@"SEARCH_RELEASE", @"Release"),
                        NSLocalizedString(@"SEARCH_RELEASEGROUP", @"Release-Group"),
                        NSLocalizedString(@"SEARCH_WORK", @"Work"), nil ];

        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    }
    
    if (indexPath.section == 1)
    {
        ArtistDetailViewController *artistDetailViewController = [[ArtistDetailViewController alloc] initWithNibName:@"ArtistDetailViewController" bundle:nil];

        if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Artist class]])
        {
            Artist *artist = [self.results objectAtIndex:indexPath.row];
            [artistDetailViewController setTitle:artist.name];
            [artistDetailViewController setArtist:artist];

            [self.navigationController pushViewController:artistDetailViewController animated:YES];
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Label class]])
        {
            Label *label = [self.results objectAtIndex:indexPath.row];
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Recording class]])
        {
            Recording *recording = [self.results objectAtIndex:indexPath.row];
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Release class]])
        {
            Release *release = [self.results objectAtIndex:indexPath.row];
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[ReleaseGroup class]])
        {
            ReleaseGroup *releaseGroup = [self.results objectAtIndex:indexPath.row];
        } else if ([[self.results objectAtIndex:indexPath.row] isKindOfClass:[Work class]])
        {
            Work *work = [self.results objectAtIndex:indexPath.row];
        } else
        {
            // Don't know the search type, so can't show the detail view...
        }

    }
}

#pragma mark - SearchQueryTextCell Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	SearchQueryTextCell *searchQueryTextCell = (SearchQueryTextCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
	[searchQueryTextCell resignFirstResponder];
	
    [self performSearchQuery];
	
    return YES;
}

#pragma mark - Action Sheet Delegate methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    UITableViewCell *selectedQueryTypeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    switch (buttonIndex)
    {
        case 0:
            [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
            break;

        default:
            self.searchType = (SearchType) buttonIndex;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

#pragma mark - class methods

-(void)performSearchQuery
{
    UITableViewCell *searchTypeCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    SearchQueryTextCell *searchQueryTextCell = (SearchQueryTextCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    
    if ([searchTypeCell.detailTextLabel.text isEqualToString:@""] || [searchQueryTextCell.textField.text isEqualToString:@""])
    {
        if ([searchTypeCell.detailTextLabel.text isEqualToString:@""])
        {
            [self displayErrorWithMessage:@"Please select a search type"];
        } else
        {
            [self displayErrorWithMessage:@"Please enter a search string"];
        }
        // Show alert
    } else
    {
        NSDictionary *query = nil;

        switch (self.searchType)
        {
            case SearchTypeArtist:
                query = @{ @"searchType": @(self.searchType),
                            @"params" :@{
                                @"query": [NSString stringWithFormat:@"artist:%@", searchQueryTextCell.textField.text]
                            }
                        };
                break;

            case SearchTypeLabel:
                query = @{ @"searchType": @(self.searchType),
                        @"params" :@{
                                @"query": [NSString stringWithFormat:@"label:%@", searchQueryTextCell.textField.text]
                        }
                };
                break;

            case SearchTypeRecording:
                query = @{ @"searchType": @(self.searchType),
                        @"params" :@{
                                @"query": [NSString stringWithFormat:@"recording:%@", searchQueryTextCell.textField.text]
                        }
                };
                break;

            case SearchTypeRelease:
                query = @{ @"searchType": @(self.searchType),
                            @"params" :@{
                                @"query": [NSString stringWithFormat:@"release:%@", searchQueryTextCell.textField.text]
                            }
                        };
                break;

            case SearchTypeReleaseGroup:
                query = @{ @"searchType": @(self.searchType),
                            @"params" :@{
                                @"query": [NSString stringWithFormat:@"release:%@", searchQueryTextCell.textField.text]
                            }
                        };
                break;

            case SearchTypeWork:
                query = @{ @"searchType": @(self.searchType),
                            @"params" :@{
                                @"query": [NSString stringWithFormat:@"work:%@", searchQueryTextCell.textField.text]
                            }
                        };
                break;

            default:
                break;
        }

        SearchService *searchService = [[SearchService alloc] initServiceWithQuery:query];

        [searchService getResultsOnCompletion:^(NSArray *results)
         {
             self.results = results;
             [self.tableView reloadData];
         } onError:^(NSError *error)
         {
             switch (error.code)
             {
                 case kCFURLErrorNotConnectedToInternet:
                     [self displayErrorWithMessage:NSLocalizedString(@"NO_CONNECTION", @"No connection available")];

                     break;

                 case HTTPBADREQUEST:
                 case HTTPPRECONDITIONFAILED:
                     [self displayErrorWithMessage:NSLocalizedString(@"HTTP_BADREQUEST", @"Communication error")];

                     break;

                 default:
                     [self displayErrorWithMessage:NSLocalizedString(@"UNKNOWN_ERROR", @"Unknown connection error")];

                     break;
             }
         }];
    }
}

-(IBAction)searchWithBarcode:(id)sender
{
    BarcodeScanViewController *barcodeScanViewController = [[BarcodeScanViewController alloc] init];
    barcodeScanViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:barcodeScanViewController];

    [self presentModalViewController:navigationController animated:YES];
}

-(void)displayErrorWithMessage:(NSString *)message
{
    UIAlertView *alertView;
    alertView = [[UIAlertView alloc] initWithTitle:nil
                                           message:message
                                          delegate:nil
                                 cancelButtonTitle:nil
                                 otherButtonTitles:NSLocalizedString(@"OK", @"Ok"), nil];
    [alertView show];
}

@end
