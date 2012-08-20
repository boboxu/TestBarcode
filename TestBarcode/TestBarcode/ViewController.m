//
//  ViewController.m
//  TestBarcode
//
//  Created by  on 12-8-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"

#define DATAFILE_NAME @"history.dat"
@implementation ViewController
@synthesize imagePickerController;
@synthesize tableview = _tableview;
@synthesize lblerr = _lblerr;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    _scanHistory = [[NSMutableArray alloc] initWithContentsOfFile:[Utils getDataPath:DATAFILE_NAME]];
    if (_scanHistory == nil) {
        _scanHistory = [[NSMutableArray alloc] init];
    }
    NSLog(@"%d",[_scanHistory count]);
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [_scanHistory release];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

-(void)takePicture:(UIImagePickerControllerSourceType)sourceType
{
    
	NSArray* availabeMediaTypes = nil;
	BOOL isAvailable = [UIImagePickerController isSourceTypeAvailable:sourceType];
	if(isAvailable==FALSE)
	{
		NSLog(@"sorry ,you dont support the device");
		return;
	}else {
		
		availabeMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
	}
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
	ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    self.imagePickerController = reader;
	[self presentModalViewController:reader animated:TRUE];
	[reader release];
    self.lblerr.text = @"";
}


-(IBAction)onClickCamera:(id)sender
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]==FALSE)
    {
        //没有摄像头
        UIImagePickerControllerSourceType type =UIImagePickerControllerSourceTypePhotoLibrary;
        [self takePicture:type];
        return;
    }
    [self takePicture:UIImagePickerControllerSourceTypeCamera];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController*)picker
{
	NSLog(@"User cancel pick");
	[picker dismissModalViewControllerAnimated:TRUE];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];  
    ZBarSymbol *symbol = nil;  
    for(symbol in results)  
        // EXAMPLE: just grab the first barcode  
        break;  
    
    // EXAMPLE: do something useful with the barcode data  
    
    if (symbol) 
    {
        //有扫描结果
        NSLog(@"%@",symbol.data); 
        [_scanHistory addObject:symbol.data];
        [_scanHistory writeToFile:[Utils getDataPath:DATAFILE_NAME] atomically:YES];
        [self.tableview reloadData];
        
    }
    else
    {
        //没有结果
        self.lblerr.text = @"扫描失败，请重试";
    }
    [self.imagePickerController dismissModalViewControllerAnimated:TRUE];
    self.imagePickerController = nil;
}

- (void) readerControllerDidFailToRead: (ZBarReaderController*) reader
                             withRetry: (BOOL) retry
{
    NSLog(@"readerControllerDidFailToRead");
}
-(void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        NSLog(@"保存原图失败");
    }
    else
    {
        NSLog(@"已保存到手机相册");
    }
}

#pragma mark -tabledatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_scanHistory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* dequeueIdentifer = @"UITableViewCell";
    UITableViewCell* cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:dequeueIdentifer];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:dequeueIdentifer] autorelease];
    }
    cell.textLabel.text = [_scanHistory objectAtIndex:indexPath.row];
    return cell;
}


@end
