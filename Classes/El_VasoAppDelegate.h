//
//  El_VasoAppDelegate.h
//  El Vaso
//
//  Created by Baltierra on 13-02-12.
//  Copyright 2012 Berith Apps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface El_VasoAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

