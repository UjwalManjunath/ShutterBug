//
//  ImageViewController.m
//  ShutterBug
//
//  Created by Ujwal Manjunath on 3/2/13.
//  Copyright (c) 2013 Ujwal Manjunath. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(strong,nonatomic) UIImageView *imageView;

@end

@implementation ImageViewController

-(void)setImageURL:(NSURL *)imageURL
{
    _imageURL = imageURL;
    [self resetImage];
}

-(UIImageView *)imageView
{
    if(!_imageView ) _imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        return _imageView;
}
-(void) resetImage
{
    if(self.scrollView){
        self.scrollView.contentSize = CGSizeZero;
        self.imageView.image=nil;
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:self.imageURL];
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        if(image)
        {
            self.scrollView.contentSize = image.size;
            self.imageView.image = image;
            self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    [self resetImage];
    
	// Do any additional setup after loading the view.
}



@end
