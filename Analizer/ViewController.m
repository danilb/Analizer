//
//  ViewController.m
//  Analizer
//
//  Created by Danil on 16/09/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import "ViewController.h"
#import "Detector.h"

@interface ViewController () {
    
    CGPoint lastPoint;
    CGFloat brushSize;
    
    BOOL isDrawing;
    
    Detector *detector;
    
    NSMutableArray *weights;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    brushSize = 5.0;
    detector = [Detector sharedDetector];
    
    weights = [[NSMutableArray alloc] init];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    isDrawing = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self->tempImage];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    isDrawing = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self->tempImage];
    
    UIGraphicsBeginImageContext(self->tempImage.frame.size);
    [self->tempImage.image drawInRect:CGRectMake(0, 0, self->tempImage.frame.size.width, self->tempImage.frame.size.height)];
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brushSize );
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self->tempImage.image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    lastPoint = currentPoint;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(!isDrawing) {
        UIGraphicsBeginImageContext(self->tempImage.frame.size);
        [self->tempImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brushSize);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 0.0, 0.0, 0.0, 1.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self->tempImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    UIGraphicsBeginImageContext(self->mainImage.frame.size);
    [self->mainImage.image drawInRect:CGRectMake(0, 0, self->mainImage.frame.size.width, self->mainImage.frame.size.height)];
    [self->tempImage.image drawInRect:CGRectMake(0, 0, self->tempImage.frame.size.width, self->tempImage.frame.size.height)];
    self->mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self->tempImage.image = nil;
    UIGraphicsEndImageContext();
}

- (IBAction)clear:(UIButton *)sender {
    self->mainImage.image = nil;
}

- (IBAction)detect:(UIButton *)sender {
    [recognizedLetter setText:[detector detect:mainImage.image]];
}


//Utility method which prints weights of letter

- (IBAction)printWeights:(id)sender {
    
    [weights addObject:[detector getPixelArrayOfImage:[detector getScaledImageFrom:mainImage.image]]];
    
    NSMutableArray *avgArray = [[NSMutableArray alloc] initWithCapacity:32*32];
    
    for (int i = 0; i<weights.count; i++) {
        NSArray *arr = (NSArray*)[weights objectAtIndex:i];
        
        for (int j=0; j<arr.count; j++) {
            NSNumber *prevVal;
            NSNumber *newVal = [arr objectAtIndex:j];
            
            if (avgArray.count == 0) {
                [avgArray addObjectsFromArray:arr];
                break;
            } else {
                prevVal = [avgArray objectAtIndex:j];
                NSNumber* sum = @([prevVal doubleValue]+[newVal doubleValue]);
                [avgArray setObject:sum atIndexedSubscript:j];
            }
        }
    }
    
    for (int i=0; i<avgArray.count; i++) {
        
        NSNumber *curVal = (NSNumber*)[avgArray objectAtIndex:i];
        NSNumber *avgVal = @([curVal doubleValue]/[weights count]);
        
        [avgArray setObject:avgVal atIndexedSubscript:i];
    }
    
    int z = 0;
    
    printf("[[NSMutableArray alloc] initWithObjects: ");
    
    for (int j = 0; j < 32; j++) {
        for (int i = 0; i < 32; i++) {
            NSNumber *num = (NSNumber *)[avgArray objectAtIndex:z];
            printf("@(%f),", [num doubleValue]);
            z++;
        }
    }
    
    printf(" nil]; \n\n\n");
    
}


@end
