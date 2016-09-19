//
//  Detector.h
//  Analizer
//
//  Created by Danil on 17/09/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Detector : NSObject

-(UIImage*) getScaledImageFrom:(UIImage*)image;
-(NSArray*) getPixelArrayOfImage:(UIImage*)image;
-(NSString*) detect: (UIImage*) image;

+ (instancetype)sharedDetector;

@end
