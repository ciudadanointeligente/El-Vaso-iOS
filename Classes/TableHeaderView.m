//
//  TableHeaderView.m
//  ARSSReader
//
//  Created by Marin Todorov on 6/2/10.
//  Copyright 2010 Marin Todorov. All rights reserved.
//

#import "TableHeaderView.h"


@implementation TableHeaderView

- (id)initWithText:(NSString*)text 
{
	UIImage* img = [UIImage imageNamed:@"_table_header_320x75.png"];
    if ((self = [super initWithImage:img])) {
        // Initialization code
		label = [[UILabel alloc] initWithFrame:CGRectMake(20,10,200,70)];
		label.textColor = [UIColor whiteColor];
		label.shadowColor = [UIColor grayColor];
		label.shadowOffset = CGSizeMake(1, 1);
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont systemFontOfSize:16];
		label.text = text;
		label.numberOfLines = 2;
		[self addSubview:label];
		[label release];
    }
    return self;
}

- (void)setText:(NSString*)text
{
	label.text = text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
    [super dealloc];
}


@end
