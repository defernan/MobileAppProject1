//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Dezmon Fernandez on 1/14/15.
//  Copyright (c) 2015 edu.mines.csci448.dezmon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

@property (nonatomic, readonly) id program;

-(void)pushOperand:(double)operand;
-(void)pushVariable:(NSString *) variable;
-(void)pushOperation:(NSString *)operation;
//+(id)popOperandOffProgramStack:(NSMutableArray *) stack;
-(id)performOperation:(NSString *)operation;

+ (NSString *)descriptionOfProgram:(id)program;

+ (id)runProgram:(id)program;
+ (id)runProgram:(id)program
usingVariableValues:(NSDictionary *)variableValue;


//MAY OR MAY NOT NEED from here down
-(void)clearStack;

//new
-(NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack;
+(BOOL) isOperation:(NSString *) operation;
@end

