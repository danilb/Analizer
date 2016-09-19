//
//  Symbols.h
//  Analizer
//
//  Created by Danil on 18/09/16.
//  Copyright © 2016 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SymbolsBank : NSObject

@property (nonatomic, retain) NSArray *A_arr;
@property (nonatomic, retain) NSArray *B_arr;
@property (nonatomic, retain) NSArray *C_arr;
@property (nonatomic, retain) NSArray *D_arr;
@property (nonatomic, retain) NSArray *E_arr;
@property (nonatomic, retain) NSArray *F_arr;
@property (nonatomic, retain) NSArray *G_arr;
@property (nonatomic, retain) NSArray *H_arr;
@property (nonatomic, retain) NSArray *I_arr;
@property (nonatomic, retain) NSArray *J_arr;
@property (nonatomic, retain) NSArray *K_arr;
@property (nonatomic, retain) NSArray *L_arr;
@property (nonatomic, retain) NSArray *M_arr;
@property (nonatomic, retain) NSArray *N_arr;
@property (nonatomic, retain) NSArray *O_arr;
@property (nonatomic, retain) NSArray *P_arr;
@property (nonatomic, retain) NSArray *Q_arr;
@property (nonatomic, retain) NSArray *R_arr;
@property (nonatomic, retain) NSArray *S_arr;
@property (nonatomic, retain) NSArray *T_arr;
@property (nonatomic, retain) NSArray *U_arr;
@property (nonatomic, retain) NSArray *V_arr;
@property (nonatomic, retain) NSArray *W_arr;
@property (nonatomic, retain) NSArray *X_arr;
@property (nonatomic, retain) NSArray *Y_arr;
@property (nonatomic, retain) NSArray *Z_arr;

@property (nonatomic, retain) NSDictionary *symbolsDict;

+ (instancetype)sharedSymbolsBank;

@end
