//
//  Detector.m
//  Analizer
//
//  Created by Danil on 17/09/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import "Detector.h"
#import "SymbolsBank.h"

@interface Detector (){
    SymbolsBank *symbols;
}
@end

@implementation Detector

+ (instancetype)sharedDetector {
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

-(id) init{
    if ( self = [super init] ) {
        symbols = [SymbolsBank sharedSymbolsBank];
    }
    return self;
}


-(UIImage*) getScaledImageFrom:(UIImage*)image {
    
    UIGraphicsBeginImageContext(CGSizeMake(32, 32));
    
    [image drawInRect:CGRectMake(0, 0, 32 ,32)];
    UIImage *scaled = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaled;
}

-(NSArray*) getPixelArrayOfImage:(UIImage*)image {
    
    CGImageRef inputCGImage = [image CGImage];
    NSUInteger width = CGImageGetWidth(inputCGImage);
    NSUInteger height = CGImageGetHeight(inputCGImage);
    
    NSMutableArray *bits = [NSMutableArray arrayWithCapacity: width * height];
    
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    
    UInt32 * pixels;
    pixels = (UInt32 *) calloc(height * width, sizeof(UInt32));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixels, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast|kCGBitmapByteOrder32Big);
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), inputCGImage);
    
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    
#define Mask8(x) ( (x) & 0xFF )
#define ALPHA(x) ( Mask8(x >> 24) )
    
    UInt32 * currentPixel = pixels;
    for (NSUInteger i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            UInt32 color = *currentPixel;
            ALPHA(color) > 0 ? [bits addObject:@(1.0)] : [bits addObject:@(0.0)];
            currentPixel++;
        }
    }
    
    free(pixels);

#undef Mask8
#undef ALPHA
    
    return bits;
}

-(NSNumber *) calculateDistanceBetweenPoint:(NSArray*) one and: (NSArray*) two {
    
    if (one.count != two.count) {
        return nil;
    }
    
    NSNumber *squareSum = @(0.0);
    
    for (int i = 0; i<one.count; i++) {
        
        NSNumber *coordOne = (NSNumber*)[one objectAtIndex:i];
        NSNumber *coordTwo = (NSNumber*)[two objectAtIndex:i];
        
        squareSum = @([squareSum doubleValue] + pow(([coordTwo doubleValue] - [coordOne doubleValue]), 2));
    }
    
    NSNumber *root = @(pow([squareSum doubleValue], 1.0/2.0));
    
    return root;
}

-(NSString *) detect: (UIImage*) image {
    
    NSArray* arrOne = [self getPixelArrayOfImage:[self getScaledImageFrom:image]];
    NSArray* symArr = [[symbols symbolsDict] allValues];
    NSMutableDictionary* distancies = [[NSMutableDictionary alloc] init];
    
    for (NSArray* arrTwo in symArr) {
        
        NSNumber* distance  = [self calculateDistanceBetweenPoint:arrTwo and:arrOne];
        NSString* symLetter = (NSString *)[[[symbols symbolsDict] allKeysForObject:arrTwo] lastObject];
        
        [distancies setObject:distance forKey:symLetter];
    
    }
    
    NSString *recognizedLetter = nil;
    double shortestDistance = 0.0;
    
    for (NSString *key in distancies)
    {
        int value = [distancies[key] doubleValue];
        if (!recognizedLetter || value < shortestDistance)
        {
            recognizedLetter = key;
            shortestDistance = value;
        }
    }
    
    return recognizedLetter;
    
}


@end
