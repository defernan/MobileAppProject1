//
//  ViewController.m
//  Calculator
//
//  Created by Dezmon Fernandez on 1/13/15.
//  Copyright (c) 2015 edu.mines.csci448.dezmon. All rights reserved.
//

#import "ViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface ViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) NSDictionary *variableValue;
@property (nonatomic, strong)CalculatorBrain *brain;
@end

@implementation ViewController

@synthesize display;
@synthesize stackDisplay;
@synthesize funcDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
//think i need
@synthesize variableValue = _variableValue;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return self.splitViewController ?
    YES : UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}


- (GraphViewController *)graphViewController {
    // TODO: declare the delegate protocol in viewcontroller.h to be able to use this functionality
    return self.popoverDelegate ?
    self.popoverDelegate :[self.splitViewController.viewControllers lastObject];
}

-(CalculatorBrain *)brain{
    // TODO: Ditto from above. Declare the delegate protocol in viewcontroller.h to be able to use this functionality
    if (self.popoverDelegate) _brain = [[self.popoverDelegate delegateController] brain];
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}
- (void)setBrain:(CalculatorBrain *)brain {
    _brain = brain;
}

- (NSDictionary *)variableValues {
    
    if(!_variableValue){
        _variableValue = [[NSDictionary alloc] init];
    }
    
    // create a dictionary which holds the value of variable. Can be easily extended to keep more than one variable.
    //_variableValue[@"x"] = @(2);//[NSNumber numberWithInt:2];
    return _variableValue;
}


-(void)updateView {
    

    // Find the result by running the program passing in the test variable values
    id result = [CalculatorBrain runProgram:self.brain.program
                        usingVariableValues:self.variableValue];
    
    // update display property based on the type of the result. If string, display as is. if number, convert to string format.
    if ( [result isKindOfClass:[NSString class]] ) {
        self.display.text = result;
    } else if ( [result isKindOfClass:[NSNumber class]] ){
        self.display.text = [result stringValue];
    }

    // update the label with description of program
    self.funcDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    
    
    // And the user isn't in the middle of entering a number
    //self.userInMiddleOfEnteringNumber = NO;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.display.text = digit;
    }
}
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    //kept stack display
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:@" "];
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:self.display.text];
    //update other views
    [self updateView];
}
- (IBAction)decimalPressed:(UIButton *)sender {
    NSString *decimal = [sender currentTitle];
    if ( [self.display.text rangeOfString:decimal].location == NSNotFound && self.userIsInTheMiddleOfEnteringANumber) {
        self.userIsInTheMiddleOfEnteringANumber = YES;
        self.display.text = [self.display.text stringByAppendingString:decimal];
    } else if ( !self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = decimal;
        self.userIsInTheMiddleOfEnteringANumber = YES;
        
    }

}
- (IBAction)clearPressed:(UIButton *)sender {
    //NSString *clear = [sender currentTitle];
    [self.brain clearStack];
    self.stackDisplay.text = @"";
    self.display.text = @"0";
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateView];
}
//guide says "You should statically type this to UIButton *
- (IBAction)operationPressed:(id)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    
    // don't perform the operation; instead, push it onto the stack and updateView.
    
    [self.brain pushOperation:[sender currentTitle]];
    //used for stack
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:@" "];
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:[sender currentTitle]];
    //update view
    [self updateView];
}

- (IBAction)variablePressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    // push variable and updateView
    [self.brain pushVariable:sender.currentTitle];
    //used for stack
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:@" "];
    self.stackDisplay.text = [self.stackDisplay.text stringByAppendingString:[sender currentTitle]];
    //update view
    [self updateView];
}

- (IBAction)drawGraphPressed {
    
    if ([self graphViewController]) {
        [[self graphViewController] setProgram:self.brain.program];
        [[self graphViewController] refreshView ];
    } else {
        [self performSegueWithIdentifier:@"DisplayGraphView" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [segue.destinationViewController setProgram:self.brain.program];
}


- (void)viewDidAppear:(BOOL)animated {
    [self updateView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
