//
//  smkViewController.h
//  OneArmedBandit
//
//  Created by smk-dev on 21.04.2013.
//  Copyright (c) 2013 smk-dev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "smkButton.h"

@interface smkViewController : UIViewController<UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet smkButton *spinButton;

- (IBAction)spinButtonAction:(id)sender;

@end
