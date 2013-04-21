//
//  smkButton.m
//  NoAdsWebView
//
//  Created by smk-dev on 01.04.2013.
//  Copyright (c) 2013 smk-dev. All rights reserved.
//

#import "smkButton.h"
#import <QuartzCore/QuartzCore.h>

@interface smkButton() {
    UIColor *tempColor;
}
@end

@implementation smkButton

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.cornerRadius = 5.0f;
        self.layer.borderWidth = 1.0f;
        self.backgroundColor = [UIColor blackColor];
        self.highlightColor = [UIColor yellowColor];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    }
    return self;
}

- (void)dealloc {
    self.highlightColor = nil;
    tempColor = nil;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    tempColor = self.backgroundColor;
    self.backgroundColor = self.highlightColor;
    self.highlighted = YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    self.backgroundColor = tempColor;
    self.highlighted = NO;
}

@end
