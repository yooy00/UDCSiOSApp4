//
//  mainScreen.h
//  UDCSiOSApp4
//
//  Created by WL on 13-10-4.
//  Copyright (c) 2013年 WL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"

@interface mainScreen : UIViewController
{
    sqlite3* database_;
}
-(void)initDBAddress;
@end
