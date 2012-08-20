//
//  ViewController.h
//  TestBarcode
//
//  Created by  on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"

@interface ViewController : UIViewController
<ZBarReaderDelegate,UITableViewDataSource,UITableViewDelegate, UINavigationControllerDelegate>
{
    ZBarReaderViewController *imagePickerController;
    NSMutableArray* _scanHistory;
    UITableView* _tableview;
    UILabel*    _lblerr;
}
@property (nonatomic,retain) ZBarReaderViewController *imagePickerController;
@property (nonatomic,retain) IBOutlet UITableView* tableview;
@property (nonatomic,retain) IBOutlet UILabel* lblerr;
-(IBAction)onClickCamera:(id)sender;
@end
