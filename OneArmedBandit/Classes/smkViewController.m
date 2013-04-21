//
//  smkViewController.m
//  OneArmedBandit
//
//  Created by smk-dev on 21.04.2013.
//  Copyright (c) 2013 smk-dev. All rights reserved.
//

#import "smkViewController.h"

#define WHEELS_COUNT 3
#define PICKER_LENGTH 500
#define ICON_COUNT 3
#define SPIN_LIMIT 100
#define SPIN_START_INDEX 3

@interface smkViewController () {
    NSInteger spintWheelCounter[WHEELS_COUNT];
    NSInteger spintWheelStop[WHEELS_COUNT];
}

@end

@implementation smkViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    // set start position
    for (int i = 0; i < WHEELS_COUNT; i++) {
        [self.pickerView selectRow:SPIN_START_INDEX inComponent:i animated:NO];
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return WHEELS_COUNT;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return PICKER_LENGTH;
}

#pragma mark - UIPickerViewDelegate

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    if (!view) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    }
    
    // set image
    [(UIImageView *)view setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon-%d", (row % ICON_COUNT)]]];
    
    return view;
}

#pragma mark - Actions

- (IBAction)spinButtonAction:(id)sender {
    // disable button
    self.spinButton.enabled = NO;
    
    float modifiers[3];
    modifiers[0] = 1.0;
    modifiers[1] = 1.6;
    modifiers[2] = 2.2;
    
    // reset picker
    for (int i = 0; i < WHEELS_COUNT; i++) {
        // reset
        spintWheelCounter[i] = [self.pickerView selectedRowInComponent:i] % ICON_COUNT + ICON_COUNT;
        [self.pickerView selectRow:spintWheelCounter[i] inComponent:i animated:NO];
        
        // new random stop value
        spintWheelStop[i] = spintWheelCounter[i] + (SPIN_LIMIT * modifiers[i]) + (arc4random() % ICON_COUNT);
        
        // spin
        [self spinWheel:i];
    }
}

#pragma mark - Private methods

- (void)spinWheel:(NSInteger)wheel {
    [UIView beginAnimations:[NSString stringWithFormat:@"spinWheel%d", wheel] context:nil];
    [UIPickerView setAnimationDelegate:self];
    [UIPickerView setAnimationDidStopSelector:@selector(spinAnimationFinished:finished:context:)];
    [self.pickerView selectRow:spintWheelCounter[wheel] inComponent:wheel animated:YES];
    spintWheelCounter[wheel]++;
    [UIView commitAnimations];
}

- (void)spinAnimationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
    // determine wheel
    NSInteger wheel = -1;
    if ([animationID isEqualToString:@"spinWheel0"]) {
        wheel = 0;
    } else if ([animationID isEqualToString:@"spinWheel1"]) {
        wheel = 1;
    } else if ([animationID isEqualToString:@"spinWheel2"]) {
        wheel = 2;
    }
    
    // check stop condition
    if (spintWheelCounter[wheel] > spintWheelStop[wheel]) {
        
        // spining did finish
        if (wheel == 2) {
            [self spiningDidFinish];
        }
        return;
    }
    
    // spin
    int remaining = spintWheelStop[wheel] - spintWheelCounter[wheel];
    double delayInSeconds = [self delaySpeed:remaining];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self spinWheel:wheel];
    });
}

- (float)delaySpeed:(NSInteger)remaining {
    if (remaining < 2) {
        return 0.25;
    } else if (remaining < 10) {
        return 0.16;
    } else if (remaining < 15) {
        return 0.15;
    } else if (remaining < 25) {
        return 0.14;
    } else if (remaining < 35) {
        return 0.13;
    } else if (remaining < 45) {
        return 0.12;
    }
    return 0.08;
}

- (void)spiningDidFinish {
    // enable spin button
    self.spinButton.enabled = YES;
    
    // get result
    int result0 = spintWheelCounter[0] % ICON_COUNT;
    int result1 = spintWheelCounter[1] % ICON_COUNT;
    int result2 = spintWheelCounter[2] % ICON_COUNT;
    if (result0 == result1 && result1 == result2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"You won!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

@end
