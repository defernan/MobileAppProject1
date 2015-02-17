//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Dezmon Fernandez on 1/14/15.
//  Copyright (c) 2015 edu.mines.csci448.dezmon. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain

@synthesize operandStack = _operandStack;

-(NSMutableArray *)operandStack{
    if(!_operandStack){
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}
- (id)program
{
    return [self.operandStack copy];
}
+ (NSString *)descriptionOfProgram:(id)program
{
    // TODO: write however you would like to display the sequence of operands, variables, operations on stack
    //NSString *topOfStack = [operandStack las
    //test
    NSMutableArray *stack= [program mutableCopy];
    //strings
    NSString *descr = @"";
    NSString *one =@"";
    NSString *two =@"";
    //NSSet
    NSSet *twoOperations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    NSSet *oneOperation = [NSSet setWithObjects:@"sin", @"cos", @"sqrt", nil];

    id stackObj;
    // For each item in the program
    if ( [stack count] == 0 )return descr;
    if ( [stack count] == 1){
        stackObj = [stack objectAtIndex:0];
        descr = [self getStringValue:stackObj];
        if( [self isOperation:descr]){
            descr = @"";
        }
        
    }else{
        //assign one
        stackObj = [stack objectAtIndex:0];

        one = [self getStringValue:stackObj];
        //handle where first object is operation
        if( [self isOperation:one]){
            descr = @"";
        } else{
            descr = one;
        }
        
        for (int i=1; i < [stack count]; i++) {
            stackObj = [stack objectAtIndex:i];
            two = [self getStringValue:stackObj];
            if ( [twoOperations containsObject:two] ){
                //split comma seperated string
                NSArray *stackItems = [descr componentsSeparatedByString:@", "];
                if([stackItems count] < 2){
                    //clear description if * or / else ignore
                    if([two isEqualToString:@"*"] || [two isEqualToString:@"/"]){
                        descr=@"";
                        
                    }
                    continue;
                }
                NSString *operand1 = [stackItems objectAtIndex:([stackItems count] - 1)];
                NSString *operand2 = [stackItems objectAtIndex:([stackItems count] - 2)];
                NSString *results = [[[[@"(" stringByAppendingString:operand2]stringByAppendingString:two]
                    stringByAppendingString:operand1]
                    stringByAppendingString:@")"];
                // remove the las comma seperated parts
                descr = @"";
                for( int j = 0; j < [stackItems count] - 2; j++){
                    descr = [[descr stringByAppendingString:[self getStringValue:[stackItems objectAtIndex:j]]] stringByAppendingString:@", "];
                }
                descr = [descr stringByAppendingString:results];
            } else if ( [oneOperation containsObject:two]){
                //surround right most expression by operation
                NSArray *stackItem = [descr componentsSeparatedByString:@", "];
                NSString *operand = [stackItem objectAtIndex:([stackItem count] - 1)];
                NSString *result = [[[two stringByAppendingString:@"("]
                                      stringByAppendingString:operand] stringByAppendingString:@")"];
                // remove the las comma seperated parts
                descr = @"";
                for( int j = 0; j < [stackItem count] - 1; j++){
                    descr = [[descr stringByAppendingString:[self getStringValue:[stackItem objectAtIndex:j]]] stringByAppendingString:@", "];
                }
                descr = [descr stringByAppendingString:result];//*/

            } else{
                if(![descr isEqualToString:@""]){
                descr = [[descr stringByAppendingString:@", "] stringByAppendingString:two];
                }else{
                    descr = two;
                }
            }

        }
        
    }
    
    //return @"implement this";
    return descr;
}
//HELPER FUNCTIONS FOR DESCRIPTION OF PROGRAM
+(NSString *)getStringValue:(id)stackObj {
    NSString *string = @"";
    if ([stackObj isKindOfClass:[NSString class]]) {
        string = stackObj;
    } else {
        string = [stackObj stringValue];
    }
    return string;
}
-(NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack{
    
    return @"temp";
}

+ (BOOL)isOperation:(NSString *)operation {
    //need logic for is operation
    NSSet *twoOperations = [NSSet setWithObjects:@"+", @"-", @"*", @"/", nil];
    NSSet *oneOperation = [NSSet setWithObjects:@"sin", @"cos", @"sqrt", nil];
    if ([twoOperations containsObject:operation] || [oneOperation containsObject:operation] || [operation  isEqual: @"pi"]){
        return YES;
    }
    
    return NO;
}
- (BOOL) isVariable:(NSString *)variable {
    
    return NO;
}

-(void)pushOperand:(double)operand{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
    
}
- (void)pushOperation:(NSString *) operation {
    [self.operandStack addObject:operation];
}
- (void)pushVariable:(NSString *)variable {
    [self.operandStack addObject:variable];
}

- (id)performOperation:(NSString *)operation
{
    [self.operandStack addObject:operation];
    return [[self class] runProgram:self.program];
}
+ (id)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]]) return topOfStack;
    
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
       
        
        if ([operation isEqualToString:@"+"]) {
            id operand1 = [self popOperandOffProgramStack:stack];
            id operand2 = [self popOperandOffProgramStack:stack];
            result = [operand1 doubleValue] + [operand2 doubleValue];
        } else if ([@"*" isEqualToString:operation]) {
            result = [[self popOperandOffProgramStack:stack] doubleValue] *
            [[self popOperandOffProgramStack:stack] doubleValue];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [[self popOperandOffProgramStack:stack] doubleValue];
            result = [[self popOperandOffProgramStack:stack] doubleValue] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [[self popOperandOffProgramStack:stack] doubleValue];
            if (divisor) result = [[self popOperandOffProgramStack:stack] doubleValue] / divisor;
        } else if([operation isEqualToString:@"cos"]) {
            result = cos ( [[self popOperandOffProgramStack:stack] doubleValue] );
        } else if([operation isEqualToString:@"sin"]) {
            result = sin ( [[self popOperandOffProgramStack:stack] doubleValue] );
        } else if([operation isEqualToString:@"pi"]) {
            result = M_PI;
        } else if([operation isEqualToString:@"sqrt"]) {
            double number = [[self popOperandOffProgramStack:stack] doubleValue];
            if ( number < 0 ){
                result = 0;
            } else {
                result = sqrt( number );
            }
        }
    }
    
    return [NSNumber numberWithDouble:result];
}

-(void) clearStack{
    [self.operandStack removeAllObjects];
}

+ (id)runProgram:(id)program {
    // Call the new runProgram method with a nil dictionary
    return [self runProgram:program usingVariableValues:nil];
}

+ (id)runProgram:(id)program
usingVariableValues:(NSDictionary *)variableValues {
    
    
    NSMutableArray *stack= [program mutableCopy];
    
    // For each item in the program
    for (int i=0; i < [stack count]; i++) {
        id obj = [stack objectAtIndex:i];
        
        // See whether we think the item is a variable
        if ([obj isKindOfClass:[NSString class]] && ![self isOperation:obj]) {
            id value = [variableValues objectForKey:obj];
            // If value is not an instance of NSNumber, set it to zero
            if (![value isKindOfClass:[NSNumber class]]) {
                value = [NSNumber numberWithInt:0];
            }
            // Replace program variable with value.
            [stack replaceObjectAtIndex:i withObject:value];
        }
    }	
    // Starting popping off the stack
    return [self popOperandOffProgramStack:stack];
}


@end

