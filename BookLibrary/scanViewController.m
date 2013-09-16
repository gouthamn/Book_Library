//
//  scanViewController.m
//  SidebarDemo
//
//  Created by Goutham on 12/09/2013.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "scanViewController.h"
#import "SWRevealViewController.h"
#import "bookdetailsViewController.h"
@interface scanViewController ()

@end

@implementation scanViewController
@synthesize resultText,resultImage,camerabutton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    resultText.returnKeyType=UIReturnKeyDone;
    resultText.delegate=self;
    self.title = @"Scan Book";
      _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
	// Do any additional setup after loading the view.
    [self camera];
    
    
}
-(IBAction)camera
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    /* [scanner setSymbology: ZBAR_I25
     config: ZBAR_CFG_ENABLE
     to: 0];*/
    
    /*  if([ZBarReaderController isSourceTypeAvailable:
     UIImagePickerControllerSourceTypeCamera])
     reader.sourceType = UIImagePickerControllerSourceTypeCamera;
     [reader.scanner setSymbology: ZBAR_I25
     config: ZBAR_CFG_ENABLE
     to: 0]; */
    
    [scanner setSymbology: ZBAR_QRCODE
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    reader.readerView.zoom = 1.0;
    [self presentViewController:reader animated:YES completion:nil];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [resultText resignFirstResponder];
    return YES;
}
- (IBAction) scanButtonTapped
{
    // ADD: present a barcode reader that scans from the camera feed
       
}
-(IBAction)submit:(id)sender
{
    if (resultText.text.length==10 || resultText.text.length==13 || resultText.text.length==6) {
        UIActionSheet *action=[[UIActionSheet alloc] initWithTitle:@"Choose an Option"
                                                          delegate:self
                                                 cancelButtonTitle:@"cancel"
                                            destructiveButtonTitle:nil
                                                 otherButtonTitles:@"Register new book ",@"Lend Book",@"Borrow Book",@"Take back your book",nil];
        [action showInView:self.view];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Invalid ISBN Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }
    //search for the entered isbn in the database and display options based upon that
   
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==-1) {
        
    }
    else
    {
        if(buttonIndex==0)
        {
            
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        bookdetailsViewController *bookdetails=[storyboard instantiateViewControllerWithIdentifier:@"bookdetails"];
            bookdetails.borrow.enabled=false;
            bookdetails.ret.enabled=false;
        [self.navigationController pushViewController:bookdetails animated:YES];
            
        }
        else if (buttonIndex==1)
        {
            
        }
    }
}
- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    
    // EXAMPLE: do something useful with the barcode data
    resultText.text = symbol.data;
    
    // EXAMPLE: do something useful with the barcode image
    resultImage.image =
    [info objectForKey: UIImagePickerControllerOriginalImage];
    
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    //  [reader dismissModalViewControllerAnimated: YES];
    [reader dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [resultText becomeFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
