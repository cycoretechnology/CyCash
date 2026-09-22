#import "Mancry_getDevicebaseData+Internal.h"

static void(^staticLocationCompletion)(double latitude, double longitude, BOOL authorized, NSError * _Nullable error);
static CLLocationManager *staticLocationManager;
static id staticLocationHelper;

@interface Mancry_LocationHelper : NSObject <CLLocationManagerDelegate>
@property (nonatomic, copy) void(^completionBlock)(double latitude, double longitude, BOOL authorized, NSError * _Nullable error);
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation Mancry_LocationHelper

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return self;
}
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        // 授权成功，开始获取位置
        [manager startUpdatingLocation];
    } else if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        // 授权被拒绝
        if (self.completionBlock) {
            NSError *error = [NSError errorWithDomain:@"Mancry_getDevicebaseData" code:-2 userInfo:@{NSLocalizedDescriptionKey: @"Location permission denied"}];
            self.completionBlock(0, 0, NO, error);
            self.completionBlock = nil;
        }
        staticLocationHelper = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    if (locations.count > 0 && self.completionBlock) {
        CLLocation *location = locations.lastObject;
        self.completionBlock(location.coordinate.latitude, location.coordinate.longitude, YES, nil);
        self.completionBlock = nil;
        [manager stopUpdatingLocation];
        staticLocationHelper = nil;
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.completionBlock) {
        self.completionBlock(0, 0, YES, error);
        self.completionBlock = nil;
        [manager stopUpdatingLocation];
        staticLocationHelper = nil;
    }
}

@end


@implementation Mancry_getDevicebaseData (Location)

- (void)initializeLocationService {

   self.locationManager = [[CLLocationManager alloc] init];
   if (@available(iOS 14.0, *)) {
       CLAuthorizationStatus status = self.locationManager.authorizationStatus;
       if (status == kCLAuthorizationStatusDenied){
           [Mancry_getDevicebaseData goToSettingPage];
       }else if (status == kCLAuthorizationStatusNotDetermined){
           [self.locationManager requestWhenInUseAuthorization];
       }
   } else {
       // Fallback on earlier versions
       if ([CLLocationManager locationServicesEnabled] && ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {

           if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
               [self.locationManager requestWhenInUseAuthorization];
           }
       }else if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {

           [Mancry_getDevicebaseData goToSettingPage];
       }
   }
   self.locationManager.delegate = self;
   self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
   self.locationManager.distanceFilter = kCLDistanceFilterNone;
   [self.locationManager startUpdatingLocation];
   self.geocoder = [[CLGeocoder alloc] init];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
   CLLocation * location = locations.lastObject;
   [[NSNotificationCenter defaultCenter]postNotificationName:kLocationSuccess object:self];
   [manager stopUpdatingLocation];
}

+ (void)goToSettingPage{
   
   dispatch_async(dispatch_get_main_queue(), ^{
       NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
       [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
   });
}

+ (void)getLocationWithCompletion:(void(^)(double latitude, double longitude, BOOL authorized, NSError * _Nullable error))completion {
    if (!completion) {
        return;
    }
    
    // 检查定位服务是否可用
    if (![CLLocationManager locationServicesEnabled]) {
        NSError *error = [NSError errorWithDomain:@"Mancry_getDevicebaseData" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"Location services are not enabled"}];
        completion(0, 0, NO, error);
        return;
    }
    
    // 检查授权状态
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // 如果已拒绝，直接返回
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusRestricted) {
        NSError *error = [NSError errorWithDomain:@"Mancry_getDevicebaseData" code:-2 userInfo:@{NSLocalizedDescriptionKey: @"Location permission denied"}];
        completion(0, 0, NO, error);
        return;
    }
    
    // 创建辅助对象来处理定位回调
    Mancry_LocationHelper *helper = [[Mancry_LocationHelper alloc] init];
    helper.completionBlock = completion;
    staticLocationHelper = helper; // 保持引用，避免被释放
    
    // 如果未授权，请求授权
    if (status == kCLAuthorizationStatusNotDetermined) {
        [helper.locationManager requestWhenInUseAuthorization];
        // 授权请求是异步的，会在授权回调中处理
        return;
    }
    
    // 如果已授权，开始获取位置
    [helper.locationManager startUpdatingLocation];
    
    // 设置超时，10秒后如果还没获取到位置，返回错误
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (helper.completionBlock) {
            NSError *error = [NSError errorWithDomain:@"Mancry_getDevicebaseData" code:-3 userInfo:@{NSLocalizedDescriptionKey: @"Location request timeout"}];
            helper.completionBlock(0, 0, YES, error);
            helper.completionBlock = nil;
            [helper.locationManager stopUpdatingLocation];
            staticLocationHelper = nil;
        }
    });
}

@end
