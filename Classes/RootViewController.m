//
//  RootViewController.m
//  El Vaso
//
//  Created by Baltierra on 13-02-12.
//  Copyright 2012 Berith Apps. All rights reserved.
//

#import "RootViewController.h"

//Para poner una imagen de fondo en la barra de navegación
@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"_table_header_320x75.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end

/*//Para poner una imagen de fondo en el tab bar
@implementation UITabBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"_table_header_320x75.png"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}
@end*/

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	//Título del NavBar, pero sólo aparece en el botón de navegación
	self.navigationItem.title = @"Volver";
	rssItems = nil;
	rss = nil;

//Para no mostrar el título de barra de navegación
	UILabel *label = [[[UILabel alloc] init] autorelease];
	self.navigationItem.titleView = label;
	label.text = @"";

	self.tableView.backgroundColor = [UIColor clearColor];
	[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[self.tableView setIndicatorStyle:UIScrollViewIndicatorStyleWhite];
	
	//self.tableView.tableHeaderView = [[TableHeaderView alloc] initWithText:@"fetching rss feed"];
	
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	 /*
	 	[super viewWillAppear:animated];
	NSString * mediaUrl = [[[self appDelegate]currentlySelectedBlogItem]mediaUrl];
	[[self image]setImage:[UIImage imageNamed:@"unknown.jpg"]];
	if(nil != mediaUrl){
		NSData* imageData;
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
		@try {
			imageData = [[NSData alloc]initWithContentsOfURL:[NSURL URLWithString:mediaUrl]];
		}
		@catch (NSException * e) {
			//Some error while downloading data
		}
		@finally {
			UIImage * imageFromImageData = [[UIImage alloc] initWithData:imageData];
			[[self image]setImage:imageFromImageData];
			[imageData release];
			[imageFromImageData release];
		}
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	}
	self.titleTextView.text = [[[self appDelegate] currentlySelectedBlogItem]title];
	self.descriptionTextView.text = [[[self appDelegate] currentlySelectedBlogItem]description]; 
	 */

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	
	if (rss==nil) {
		rss = [[RSSLoader alloc] init];
		rss.delegate = self;
		[rss load];
	}
}
 


#pragma mark -
#pragma mark Table view data source

// Establecemos el número de secciones en la Table View.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Establecemos el número de filas en el Table View
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (rss.loaded == YES) {
		return [rssItems count]*2;
	} else {
		return 1;
	}
}

- (UITableViewCell *)getLoadingTableCellWithTableView:(UITableView *)tableView 
{
    static NSString *LoadingCellIdentifier = @"LoadingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier];
    
	if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:LoadingCellIdentifier] autorelease];
    }
	
	cell.textLabel.text = @"Cargando...";
	
	UIActivityIndicatorView* activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activity startAnimating];
	[cell setAccessoryView: activity];
	[activity release];
	
    return cell;
}

- (UITableViewCell *)getTextCellWithTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	static NSString *TextCellIdentifier = @"TextCell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TextCellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TextCellIdentifier] autorelease];
    }
    
	NSDictionary* item = [rssItems objectAtIndex: (indexPath.row-1)/2];
	
	// Preview del artículo
	cell.textLabel.font = [UIFont systemFontOfSize:11];
	cell.textLabel.numberOfLines = 4;
	cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
	cell.backgroundColor = [UIColor clearColor];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	// Dibujamos una imagen que acompañe la descripción del artículo
	cell.imageView.image = [UIImage imageNamed:@"_icon_57x57.png"];

	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	backView.backgroundColor = [UIColor clearColor];
	cell.backgroundView = backView;
	
	CGRect f = cell.textLabel.frame;
	[cell.textLabel setFrame: CGRectMake(f.origin.x+15, f.origin.y, f.size.width-15, f.size.height)];
	cell.textLabel.text = [item objectForKey:@"description"];
	
	return cell;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (rss.loaded == NO) {
		return [self getLoadingTableCellWithTableView:tableView];
	}
	
	if (indexPath.row % 2 == 1) {
		return [self getTextCellWithTableView:tableView atIndexPath:indexPath];
	}
	
    static NSString *CellIdentifier = @"TitleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

	UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
	backView.backgroundColor = [UIColor clearColor];
	cell.backgroundView = backView;
    
	NSDictionary* item = [rssItems objectAtIndex: indexPath.row/2];
	
	cell.textLabel.text = [item objectForKey:@"title"];
	//cell.textLabel.font = [UIFont systemFontOfSize:20];
	//cell.textLabel.numberOfLines = 2;

    return cell;
}



#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
	
	DetailsViewController *detailViewController = [[DetailsViewController alloc] initWithNibName:@"DetailsViewController" bundle:nil];
	detailViewController.item = [rssItems objectAtIndex:floor(indexPath.row/2)];
	[self.navigationController pushViewController:detailViewController animated:YES];
	[detailViewController release];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[rssItems release];
	rssItems = nil;
	
	[rss release];
	rss = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark RSSLoaderDelegate
-(void)updatedFeedWithRSS:(NSMutableArray*)items
{
	rssItems = [items retain];
	[self.tableView reloadData];
}

-(void)failedFeedUpdateWithError:(NSError *)error
{
	//
}

-(void)updatedFeedTitle:(NSString*)rssTitle
{
	//[(TableHeaderView*)self.tableView.tableHeaderView setText:rssTitle];
}

@end