//
//  RootViewController.h
//  El Vaso
//
//  Created by Baltierra on 13-02-12.
//  Copyright 2012 Berith Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSSLoader.h"
#import "DetailsViewController.h"
#import "TableHeaderView.h"

@interface RootViewController : UITableViewController<RSSLoaderDelegate>
{
	RSSLoader* rss;
	NSMutableArray* rssItems;
}

@end