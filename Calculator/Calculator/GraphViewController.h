//
//  CalculatorBrain.h
//  Calculator
//
//  Created by CS193p Instructor.
//  Copyright (c) 2011 Stanford University.
//  All rights reserved.
//
#import <UIKit/UIKit.h>



@interface GraphViewController : UIViewController <UISplitViewControllerDelegate>

@property (nonatomic, strong) id program;

- (void)refreshView;

@end
