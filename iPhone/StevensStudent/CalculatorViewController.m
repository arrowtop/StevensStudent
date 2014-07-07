//
//  CalculatorViewController.m
//  StevensStudent
//
//  Created by toby on 5/2/14.
//  Copyright (c) 2014 arrowtop. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CalculatorViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BOOL isStart;
@property (nonatomic) BOOL isStartUpdated;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CalculatorViewController
{
    BOOL isDotPressed;
    BOOL isNextOperation;
    NSMutableArray *numberStack;
    NSMutableArray *operatorStack;
    NSMutableArray *numberTVStack;
    NSMutableArray *operatorTVStack;
    NSMutableString *trackInput;
    double result;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initCalculator];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
}

- (void) scrollToBottom
{
    long cells_count = [operatorTVStack count]-1;
    NSIndexPath *ipath = [NSIndexPath indexPathForRow: cells_count inSection: 0];
    [self.tableView scrollToRowAtIndexPath: ipath atScrollPosition: UITableViewScrollPositionBottom animated: YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [operatorTVStack count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Calculator Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CalculatorCell *calCell = (CalculatorCell *)cell;
    
    if (calCell == nil) {
        calCell = [[CalculatorCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    if(([numberTVStack count] != [operatorTVStack count]) && indexPath.row == [operatorTVStack count]-1) calCell.number.text = @"";
    else if([[operatorTVStack objectAtIndex:indexPath.row] isEqualToString:@"="]){
        NSString *s = [numberTVStack objectAtIndex:indexPath.row];
        double number = [s doubleValue];
        long length = [s length];
        bool signal = true;
        for (int i = 0; i < [s length]; i++) {
            if (signal == false) {
                if ([s characterAtIndex:i] == '0') signal = true;
                else {
                    signal = false;
                    break;
                }
            }
            if ([s characterAtIndex:i] == '.')
                signal = false;
        }
        if (signal == true) {
            long number2 = [s intValue];
            NSMutableString *ms = [NSMutableString stringWithFormat:@"%ld",number2];
            length = [ms length];
            if (length >= 10) {
                int n = log10(number);
                double num = number /pow(10, n);
                ms = [NSMutableString stringWithFormat:@"%.3f",num];
                if (n > 0) [ms appendString:[NSString stringWithFormat:@"e+%d", n]];
                else [ms appendString:[NSString stringWithFormat:@"e%d", n]];
            }
            calCell.number.text = ms;
        } else {
            long length2 = 0;
            for (int i = 0; i < [s length]; i++) {
                if (i == 0 && [s characterAtIndex:i] == '0') length2 = 2;
                if (i >=2 && length >= 2 && [s characterAtIndex:i] == '0') {
                    length2++;
                }
            }
            if (length2 >= 10) {
                int n = log10(number);
                double num = number /pow(10, n);
                NSMutableString *ms = [NSMutableString stringWithFormat:@"%.3f",num];
                if (n > 0) [ms appendString:[NSString stringWithFormat:@"e-%d", n]];
                else [ms appendString:[NSString stringWithFormat:@"e%d", n]];
                 calCell.number.text = ms;
            } else calCell.number.text  = [s substringToIndex:11];
        }
    } else {
        calCell.number.text  = [NSString stringWithFormat:@"%@", [numberTVStack objectAtIndex:indexPath.row]];
    }
    
    calCell.op.text = [operatorTVStack objectAtIndex:indexPath.row];
    
    return calCell;
    
}

- (void)initCalculator
{
    isDotPressed = false;
    isNextOperation = false;
    numberStack = [[NSMutableArray alloc] init];
    operatorStack = [[NSMutableArray alloc] init];
    numberTVStack = [[NSMutableArray alloc] init];
    operatorTVStack = [[NSMutableArray alloc] init];
    [operatorTVStack addObject:@""];
    trackInput = [[NSMutableString alloc] init];
    [self.tableView reloadData];

}

- (IBAction)clearAll:(id)sender {
    [self initCalculator];
}

- (BOOL) isStart
{
    if ([numberStack count] == 0 && [operatorStack count] == 0) {
        return YES;
    }
    return NO;
}

- (BOOL) isStartUpdated
{
    if (isNextOperation) {
        if ([numberStack count] == 1 && [operatorStack count] == 0) {
            return YES;
        }
    } else {
        if ([numberStack count] == 0 && [operatorStack count] == 0) {
            return YES;
        }
    }
    return NO;
}

- (IBAction)number:(UIButton *)sender {
    //[[sender layer] setBorderWidth:2.0f];
    //[[sender layer] setBorderColor:[UIColor blackColor].CGColor];

    NSMutableString *s;
    if ([numberStack count] == 0 || [trackInput characterAtIndex:[trackInput length]-1] == '0') {
        s = [[NSMutableString alloc] init];
        [numberStack addObject:s];
        [numberTVStack addObject:s];
    } else {
        s = [numberStack lastObject];
    }
    if(s.length < 9) {
        [s appendString: sender.titleLabel.text];
        [trackInput appendString:@"1"];
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}



- (IBAction)dot:(UIButton *)sender {
    if (!isDotPressed){
        NSMutableString *s;
        if ([numberStack count] == 0) {
            s = [[NSMutableString alloc] init];
            [numberStack addObject:s];
            [numberTVStack addObject:s];
            [s appendString: @"0."];
            [trackInput appendString:@"1"];
        } else {
            s = [numberStack lastObject];
            [s appendString: @"."];
        }
        [trackInput appendString:@"1"];
    }
    [self.tableView reloadData];
    [self scrollToBottom];

}

- (IBAction)delete:(UIButton *)sender {
    if (!self.isStartUpdated) {
        if ([trackInput characterAtIndex:[trackInput length]-1] == '1') {
            NSMutableString *s = [numberStack lastObject];
            if ([s length] == 1) {
                [numberStack removeLastObject];
                [numberTVStack removeLastObject];
            }
            else [s deleteCharactersInRange:NSMakeRange([s length]-1, 1)];
        } else {
            [operatorStack removeLastObject];
            [operatorTVStack removeLastObject];
        }
        [trackInput deleteCharactersInRange:NSMakeRange([trackInput length]-1, 1)];

    }
    [self.tableView reloadData];
    [self scrollToBottom];

}

- (IBAction)operator:(UIButton *)sender {
    if ([trackInput length] != 0 && [trackInput characterAtIndex:[trackInput length]-1] == '1') {
        if (self.isStart) {
            [numberStack addObject:@"0"];
            [numberTVStack addObject:@"0"];
        }
        isDotPressed = false;
        [operatorStack addObject:sender.titleLabel.text];
        [operatorTVStack addObject:sender.titleLabel.text];
        [trackInput appendString:@"0"];
        [self.tableView reloadData];
        [self scrollToBottom];

    }
}

- (IBAction)result:(id)sender {
    if ([trackInput characterAtIndex:[trackInput length]-1] != '0') {
        if (self.isStart) result = 0;
        else if ([operatorStack count] == 0) {
            result = [[numberStack lastObject] doubleValue];
            isNextOperation = true;
        }
        else {
            [self calculate];
            isNextOperation = true;
        }
        numberStack = [[NSMutableArray alloc] init];
        operatorStack = [[NSMutableArray alloc] init];
        NSMutableString *number = [NSMutableString stringWithFormat:@"%.9f", result];
        [numberStack addObject:number];
        [operatorTVStack addObject:@"="];
        [numberTVStack addObject:number];
        [self.tableView reloadData];
        [self scrollToBottom];

    }
}

- (void) calculate
{
    NSMutableArray *numStack = [[NSMutableArray alloc] init];
    NSMutableArray *operStack = [[NSMutableArray alloc] init];
    [numStack addObject:[numberStack objectAtIndex:0]];
    int i = 1;
    int j = 0;
    while (j < [operatorStack count]) {
        NSString *operator = [operatorStack objectAtIndex:j];
        if ([operator isEqualToString:@"+"] || [operator isEqualToString:@"-"]) {
            [numStack addObject:[numberStack objectAtIndex:i]];
            [operStack addObject:operator];
        } else {
            double num = [[numberStack objectAtIndex:i] doubleValue];
            double res = [[numStack lastObject] doubleValue];
            [numStack removeLastObject];
            NSString *s = [NSString stringWithFormat:@"%.9f", [self calculate:operator first:res second:num]];
            [numStack addObject: s];
        }
        i++;
        j++;
    }
    result= [[numStack firstObject] doubleValue];
    [numStack removeObjectAtIndex:0];
    while ([operStack count] != 0) {
        NSString *op = [operStack firstObject];
        [operStack removeObjectAtIndex:0];
        double num = [[numStack firstObject] doubleValue];
        [numStack removeObjectAtIndex:0];
        result = [self calculate:op first:result second:num];
    }
}

- (double) calculate: (NSString *)operator first: (double) n1 second: (double) n2
{
    double res = 0;
    if ([operator isEqualToString:@"+"]) {
        res = n1 + n2;
    } else if ([operator isEqualToString:@"-"]) {
        res = n1 - n2;
    } else if ([operator isEqualToString:@"*"]) {
        res = n1 * n2;
    } else if ([operator isEqualToString:@"/"]) {
        res = n1 / n2;
    }
    return res;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
