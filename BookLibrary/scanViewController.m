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
#import "lendViewController.h"
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
- (UIImage *)GetRawImage:(NSString *)imageUrlPath
{
    NSURL *imageURL = [NSURL URLWithString:imageUrlPath];
    NSData *data = [NSData dataWithContentsOfURL:imageURL];
    UIImage *image = [[UIImage alloc] initWithData:data];
    return image;
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
    
     NSInteger i=[[DBManager getSharedInstance] searchISBN:resultText.text];
    
    //[DBManager finalize];
   // int i=0;
    if (buttonIndex==4) {
        
    }
    else
    {
        if(buttonIndex==0)
        {
           
            if(i==0)
            {
            NSString *str=[NSString stringWithFormat:@"https://www.googleapis.com/books/v1/volumes?q=isbn:%@",resultText.text];
                //0735619670
            NSURL* jsonURL = [NSURL URLWithString:str];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData* data = [NSData dataWithContentsOfURL:
                                jsonURL];
                [self performSelectorOnMainThread:@selector(fetchedData:)
                                       withObject:data waitUntilDone:YES];
            
            });
            
            }
            else
            {
                UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Book already exists" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
                [alertview show];
            }
        }
        else if (buttonIndex==1)
        {
            if(i==1)
            {
                NSInteger copies=[[DBManager getSharedInstance] searchcopies:resultText.text];
                if (copies>0) {
                    
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            lendViewController *lend=[storyboard instantiateViewControllerWithIdentifier:@"lend"];
                lend.pagetitle=@"Lend Book";
                lend.isbn=resultText.text;
            [self.navigationController pushViewController:lend animated:YES];
                }
                else
                {
                    UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Number of copies available:0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
                    [alertview show];

                }
            }
            else
            {
                UIAlertView *alertview=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"This Book doesn't exist.Please register the book." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil ];
                [alertview show];
            }
        }
        else if (buttonIndex == 2)
        {
            UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            lendViewController *lend=[storyboard instantiateViewControllerWithIdentifier:@"lend"];
            lend.pagetitle=@"Borrow Book";
            lend.isbn=resultText.text;
          [self.navigationController pushViewController:lend animated:YES];
        }
        else
        {
               NSMutableArray *arr= [[DBManager getSharedInstance]finddetailsbyisbn:resultText.text];
            if (arr!=nil) {
                    UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    bookdetailsViewController *bookdetails=[storyboard instantiateViewControllerWithIdentifier:@"bookdetails"];
                    bookdetails.tabledatasource=arr;
                    bookdetails.flag=4;
                    [self.navigationController pushViewController:bookdetails animated:YES];
               }
            else
            {
                UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Info!!" message:@"Book Not registered" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }
        

    }
}
- (void)fetchedData:(NSData *)responseData{
    //parse out the json data
    
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData //1
                          
                          options:kNilOptions
                          error:&error];
    if (json != nil &&
        error == nil)
    {
        //extracting data from json object
        NSLog(@"Successfully deserialized...");
       
        NSDictionary* items = [json objectForKey:@"items"];
        for(NSDictionary *dict in items)
        {
            title= [[  dict objectForKey:@"volumeInfo"] objectForKey:@"title"] ;
            publisher  = [[  dict objectForKey:@"volumeInfo"] objectForKey:@"publisher"] ;
            author     = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"authors"]objectAtIndex:0];
            category   = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"categories"]objectAtIndex:0];
            description= [[  dict objectForKey:@"volumeInfo"] objectForKey:@"description"];
            rating     = [[  dict objectForKey:@"volumeInfo"] objectForKey:@"averageRating"];
            imgURL     = [[[ dict objectForKey:@"volumeInfo"] objectForKey:@"imageLinks"] objectForKey:@"thumbnail"];
        }
        
        imgdata=[NSData dataWithContentsOfURL:[NSURL URLWithString:imgURL]];
        //UIImage *img=[[UIImage alloc] initWithData:imgdata];
        
        
      
      /*  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        //  Append the filename and get the full image path
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",resultText.text]];
        
        //  Now convert the image to PNG/JPEG and write it to the image path
        NSData *imageData = UIImagePNGRepresentation(img);
        [imageData writeToFile:savedImagePath atomically:NO];*/
        
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        [defaults setObject:imgdata forKey:resultText.text];
        
        [[DBManager getSharedInstance] saveData:resultText.text title:title author:author publisher:publisher category:category description:description rating:rating copies:1 archive:0];
       
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        bookdetailsViewController *bookdetails=[storyboard instantiateViewControllerWithIdentifier:@"bookdetails"];
        bookdetails.flag=1;
        bookdetails.tabledatasource=[[NSMutableArray alloc] initWithObjects:resultText.text,title,author,publisher,category,description,rating,[NSNumber numberWithInt:1],nil];
        [self.navigationController pushViewController:bookdetails animated:YES];
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Alert!!" message:@"Invalid ISBN Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
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
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"register"]) {
        
        bookdetailsViewController *bookdetails=[segue destinationViewController];
         bookdetails.tabledatasource=[[NSMutableArray alloc] initWithObjects:resultText.text,title,author,publisher,category,description,rating,imgdata,@"1",nil];
        bookdetails.flag=1;
    }
}
@end
