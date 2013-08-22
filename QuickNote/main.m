//
//  main.m
//  QuickNote
//
//  Created by Yixi Liu on 13-7-18.
//  Copyright (c) 2013年 Yixi Liu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PXEngine/PXEngine.h>

#import "YXAppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        [PXEngine licenseKey:@"OE3EQ-PLFEV-KAQ0A-FMS8A-62S4J-TMFOG-TM28V-38420-GP9EP-MRR71-TLQ6N-FJV0V-46KGE-ESEG1-BSKJU-26" forUser:@"lyh1112@gmail.com"];
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([YXAppDelegate class]));
    }
}
