#import "Mancry_getDevicebaseData+Internal.h"

@implementation Mancry_getDevicebaseData (Hardware)

+ (NSString *)getSystemVersion{
   // Get the current system version
   if ([[UIDevice currentDevice] respondsToSelector:@selector(systemVersion)]) {
       // Make a string for the system version
       NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
       // Set the output to the system version
       return systemVersion;
   } else {
       // System version not found
       return @"";
   }
}

+ (NSString *)getSystem{
   return @"IOS";
}

+ (NSString *)getLanguage{
   
   @try {
       
       NSArray *mancry_larArray = [NSLocale preferredLanguages];
       
       NSString *language = [mancry_larArray objectAtIndex:0];
       
       if (language == nil || language.length <= 0) {
           
           return @"";
       }
       
       return [language componentsSeparatedByString:@"-"].firstObject;
//        return language;
   }
   @catch (NSException *exception) {
       // Error
       return @"";
   }
}

+ (NSNumber *)cpuCount{
   // See if the process info responds to selector
   if ([[NSProcessInfo processInfo] respondsToSelector:@selector(processorCount)]) {
       NSInteger processorCount = [[NSProcessInfo processInfo] processorCount];
       return @(processorCount);
   } else {
       
       return @-1;
   }
}


+ (NSString *)getTimeZone{
   
   @try {
       
       NSTimeZone *localTime = [NSTimeZone systemTimeZone];
       NSString *timeZone = [localTime name];
       // Check for validity
       if (timeZone == nil || timeZone.length <= 0) {
           return @"";
       }
       // Completed Successfully
       return timeZone;
   }
   @catch (NSException *exception) {
       // Error
       return @"";
   }
}


+ (NSNumber *)ramTotalMemory{
   // MB  1024
   double totalMemory = [SystemServices sharedServices].totalMemory;
   //  GB 1024
   totalMemory = totalMemory / 1024.0;
   return @(totalMemory);

}


+ (NSNumber *)mancry_ramWithAvailablewhySize{
   @try {
       double totalUsedMemory = 0.00;
       mach_port_t host_port;
       mach_msg_type_number_t host_size;
       vm_size_t pagesize;
       
       // Get the variable values
       host_port = mach_host_self();
       host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
       host_page_size(host_port, &pagesize);
       
       vm_statistics_data_t vm_stat;
       
       // Check for any system errors
       if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
           return @(-1);
       }
       
       // Memory statistics in bytes
       NSLog(@"%lu",(vm_stat.active_count +
                    vm_stat.inactive_count +
                    vm_stat.wire_count) * pagesize);
       // Memory statitics in MB
       double usedMemory = (double)(((vm_stat.active_count +
                               vm_stat.inactive_count +
                               vm_stat.wire_count) * pagesize));
       usedMemory = usedMemory/1024.0/1024.0/1024.0;
       
       double totalMemory = [[NSProcessInfo processInfo] physicalMemory]/1024.0/1024.0/1024.0;
       double availableMemory = totalMemory - usedMemory;
       return @(availableMemory);
   }
   @catch (NSException *exception) {
       // Error
       return @(-1);
   }
   
}


+ (NSNumber *)cashAvailableSize{
   NSString *freeDiskSpace = [SystemServices sharedServices].freeDiskSpaceinRaw;
   if (freeDiskSpace){
       double freeDiskSpaceDouble = [[freeDiskSpace componentsSeparatedByString:@" "].firstObject doubleValue];
       return @(freeDiskSpaceDouble);
   }
   return @0;
}

+ (NSNumber *)cashTotalSize{
   NSString *diskSpace = [SystemServices sharedServices].diskSpace;
   if (diskSpace){
       double diskSpaceDouble = [[diskSpace componentsSeparatedByString:@" "].firstObject doubleValue];
       return @(diskSpaceDouble);
   }
   return @0;
}



+ (NSNumber *)batteryLevel{
   return @([SystemServices sharedServices].batteryLevel);
}

+ (BOOL)charging{
   return [SystemServices sharedServices].charging;
}

+ (NSNumber *)getBootTime{

   long long int uptime = [self getUptimeWithResting];

   NSTimeInterval interval = (double)uptime / 1000.f;
   //
   NSDate *date = [NSDate dateWithTimeIntervalSinceNow:(0-interval)];

   long timeStamp = [date timeIntervalSince1970] * 1000;
   
   return @(timeStamp);
}


+ (long long int)getUptimeWithResting{
   struct timeval boottime;
   int mib[2] = {CTL_KERN, KERN_BOOTTIME};
   size_t size = sizeof(boottime);
   struct timeval now;
   struct timezone tz;
   gettimeofday(&now, &tz);
   long long int uptime = -1;
   if (sysctl(mib, 2, &boottime, &size, NULL, 0) != -1 && boottime.tv_sec != 0) {
       uptime = ((long long int)(now.tv_sec - boottime.tv_sec)) * 1000;
       uptime += (now.tv_usec - boottime.tv_usec) / 1000;

   }
      
   return uptime;
   

}



+ (NSString *)getScreenResolution{
   CGFloat scale_screen = [UIScreen mainScreen].scale;

   CGRect rect_screen = [[UIScreen mainScreen]bounds];
   //
   CGFloat w = rect_screen.size.width * scale_screen;
   //
   CGFloat h = rect_screen.size.height * scale_screen;
   return [NSString stringWithFormat:@"%d-%d",(int)w,(int)h];
}


+ (float)getScreenBrightness {
   // Get the screen brightness
   @try {
       // Brightness
       float brightness = [UIScreen mainScreen].brightness;
       // Verify validity
       if (brightness < 0.0 || brightness > 1.0) {
           // Invalid brightness
           return -1;
       }
       
       // Successful
       return (brightness * 100);
   }
   @catch (NSException *exception) {
       // Error
       return -1;
   }
}


+ (NSString *)getDeviceName{
   NSString *deviceName = @"";
   UIDevice *device = [UIDevice currentDevice];
   deviceName = device.name;
   return deviceName;
}



+ (long long int)getUptimeWithoutResting{
   // Get the info about a process
   NSProcessInfo *processInfo = [NSProcessInfo processInfo];
   // Get the uptime of the system
   NSTimeInterval uptimeInterval = [processInfo systemUptime];
   return (long long int)(uptimeInterval * 1000);
}


@end
