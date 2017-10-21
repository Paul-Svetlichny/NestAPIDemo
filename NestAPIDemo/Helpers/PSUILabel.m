//
//  PSUILabel.m
//
//  Created by Paul Svetlichny on 9/27/17.
//  Copyright © 2017 Paul Svetlichny. All rights reserved.
//

#import "PSUILabel.h"

@implementation PSUILabel

- (void)setRotation:(CGFloat)deg
{
    CGFloat rad = M_PI * deg / 180.0;
    
    CGAffineTransform rot = CGAffineTransformMakeRotation(rad);
    
    [self setTransform:rot];
}

@end
