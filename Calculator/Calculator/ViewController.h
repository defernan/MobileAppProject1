//
//  ViewController.h
//  Calculator
//
//  Created by Dezmon Fernandez on 1/13/15.
//  Copyright (c) 2015 edu.mines.csci448.dezmon. All rights reserved.
//

#import <UIKit/UIKit.h>

//DONT KNOW WHAT IM DOING
@protocol ControllerDelegate

@property (weak, nonatomic) id delegateController;

@end

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *stackDisplay;
//TODO: add another property (of type outlet) that displays the o/p from descriptionOfProgram
@property (weak, nonatomic) IBOutlet UILabel *funcDisplay;

@property (weak, nonatomic) id <ControllerDelegate> popoverDelegate;


@end

