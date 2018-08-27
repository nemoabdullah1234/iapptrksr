#import "CSUploadMultipleFileApi.h"
#import "AFNetworking.h"

#import "STRYKER-swift.h"


#define  _WEAKREF(obj)         __weak typeof(obj)ref=obj;
#define  _STRONGREF(name)      __strong typeof(ref)name=ref;\
if(!name)return ;\

@interface CSUploadMultipleFileApi()
{
    NSString          *action_name;
    NSArray           *arrayOfFiles;
    NSString          *pathOFDirectory;
    NSDictionary          *idVal;
}
@property(nonatomic,copy)success sucsblock;
@property(nonatomic,copy)failure falureblk;
@end
@implementation CSUploadMultipleFileApi
@synthesize sucsblock,falureblk;
-(void)hitFileUploadAPIWithDictionaryPath:(NSString *)dictPath actionName:(NSString*)action idValue:(NSDictionary*)idValue successBlock:(success)successBlock failureBlock:(failure)failureBlock{
    sucsblock=successBlock;
    falureblk=failureBlock;
    pathOFDirectory=[dictPath copy];
    action_name=action;
    idVal=idValue;
    arrayOfFiles=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dictPath error:nil];
    [self uploadMultipleFile];
    
    
}
-(void)hitFileUploadAPIWithDictionaryPath2:(NSString *)dictPath actionName:(NSString*)action idValue:(NSDictionary*)idValue successBlock:(success)successBlock failureBlock:(failure)failureBlock{
    sucsblock=successBlock;
    falureblk=failureBlock;
    pathOFDirectory=[dictPath copy];
    action_name=action;
    idVal=idValue;
    arrayOfFiles=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dictPath error:nil];
    [self uploadMultipleFile2];
}
    
-(void)hitFileUploadAPIWithDictionaryPath3:(NSString *)dictPath actionName:(NSString*)action idValue:(NSDictionary*)idValue successBlock:(success)successBlock failureBlock:(failure)failureBlock{
    sucsblock=successBlock;
    falureblk=failureBlock;
    pathOFDirectory=[dictPath copy];
    action_name=action;
    idVal=idValue;
    arrayOfFiles=[[NSFileManager defaultManager] contentsOfDirectoryAtPath:dictPath error:nil];
    [self uploadMultipleFile3];
}

-(void)uploadMultipleFile{

    
    
     _WEAKREF(self);
    AFHTTPSessionManager *manager2 =  [AFHTTPSessionManager manager];
    manager2.requestSerializer = [AFHTTPRequestSerializer serializer];
    [ manager2.requestSerializer setValue:@"multipart/form-data; boundary=0484d4db-ff8e-4ea4-a401-4589fd5a16a7" forHTTPHeaderField:@"Content-Type"];
    [ manager2.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [ manager2.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [ manager2.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"DEVICEID"] forHTTPHeaderField:@"deviceId"];
    [ manager2.requestSerializer setValue:@"traquer" forHTTPHeaderField:@"AppType"];
    [ manager2.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"USERToken"] forHTTPHeaderField:@"sid"];
    [ manager2.requestSerializer setValue:@"salesrep" forHTTPHeaderField:@"role"];
    manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager2.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/hal+json"];
    
    STRBaseUrl  *bu = [[STRBaseUrl alloc] init];
    NSString  *pathURL =  [NSString stringWithFormat:@"%@/reader/reportShippingIssue",bu.base];
    
    [manager2 POST:pathURL parameters:idVal constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        _STRONGREF(strongSelf);
        for (NSUInteger i=0;i<strongSelf->arrayOfFiles.count;i++) {
            NSString  *path=[strongSelf->pathOFDirectory stringByAppendingPathComponent:[strongSelf-> arrayOfFiles objectAtIndex: i]];
            NSString  *name=[NSString stringWithFormat:@"images[%d]",(uint)i];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:name fileName:[strongSelf-> arrayOfFiles objectAtIndex:i] mimeType:@"image/png" error:nil];//
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Error: %@", uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@ ", responseObject);
        self.sucsblock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.falureblk(error);
    }];
    
}
-(void)uploadMultipleFile2{
    
    
    
    _WEAKREF(self);
    AFHTTPSessionManager *manager2 =  [AFHTTPSessionManager manager];
    manager2.requestSerializer = [AFHTTPRequestSerializer serializer];
    [ manager2.requestSerializer setValue:@"multipart/form-data; boundary=0484d4db-ff8e-4ea4-a401-4589fd5a16a7" forHTTPHeaderField:@"Content-Type"];
    [ manager2.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [ manager2.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [ manager2.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"DEVICEID"] forHTTPHeaderField:@"deviceId"];
    [ manager2.requestSerializer setValue:@"traquer" forHTTPHeaderField:@"AppType"];
    [ manager2.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"USERToken"] forHTTPHeaderField:@"sid"];
    [ manager2.requestSerializer setValue:@"salesrep" forHTTPHeaderField:@"role"];
    manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager2.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/hal+json"];
    STRBaseUrl  *bu = [[STRBaseUrl alloc] init];
    NSString  *pathURL =  [NSString stringWithFormat:@"%@/reader/postCaseItemComment",bu.base];
    
    [manager2 POST:pathURL parameters:idVal constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        _STRONGREF(strongSelf);
        for (NSUInteger i=0;i<strongSelf->arrayOfFiles.count;i++) {
            NSString  *path=[strongSelf->pathOFDirectory stringByAppendingPathComponent:[strongSelf-> arrayOfFiles objectAtIndex: i]];
            NSString  *name=[NSString stringWithFormat:@"images[%d]",(uint)i];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:name fileName:[strongSelf-> arrayOfFiles objectAtIndex:i] mimeType:@"image/png" error:nil];//
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Error: %@", uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@ ", responseObject);
        self.sucsblock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.falureblk(error);
    }];
    
}

-(void)uploadMultipleFile3{
    
    
    
    _WEAKREF(self);
    AFHTTPSessionManager *manager2 =  [AFHTTPSessionManager manager];
    manager2.requestSerializer = [AFHTTPRequestSerializer serializer];
    [ manager2.requestSerializer setValue:@"multipart/form-data; boundary=0484d4db-ff8e-4ea4-a401-4589fd5a16a7" forHTTPHeaderField:@"Content-Type"];
    [ manager2.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [ manager2.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    [ manager2.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"DEVICEID"] forHTTPHeaderField:@"deviceId"];
    [ manager2.requestSerializer setValue:@"traquer" forHTTPHeaderField:@"AppType"];
    [ manager2.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] stringForKey:@"USERToken"] forHTTPHeaderField:@"sid"];
    [ manager2.requestSerializer setValue:@"salesrep" forHTTPHeaderField:@"role"];
    manager2.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager2.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/hal+json"];
    STRBaseUrl  *bu = [[STRBaseUrl alloc] init];
    NSString  *pathURL =  [NSString stringWithFormat:@"%@/reader/submitSurgeryReport",bu.base];
    
    NSData* dat;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:idVal];
    if ([[idVal allKeys] containsObject:@"surgerysignature"]){
        dat = [idVal valueForKey:@"surgerysignature"];
        [dict removeObjectForKey:@"surgerysignature"];
    }
    idVal = (NSDictionary*)dict;
    [manager2 POST:pathURL parameters:idVal constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        _STRONGREF(strongSelf);
        for (NSUInteger i=0;i<strongSelf->arrayOfFiles.count;i++) {
            NSString  *path=[strongSelf->pathOFDirectory stringByAppendingPathComponent:[strongSelf-> arrayOfFiles objectAtIndex: i]];
            NSString  *name=[NSString stringWithFormat:@"image",(uint)i];
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:name fileName:[strongSelf-> arrayOfFiles objectAtIndex:i] mimeType:@"image/png" error:nil];//
        }
        if (dat != nil) {
            [formData appendPartWithFileData:dat name:@"surgerysignature" fileName:@"surgerysignature" mimeType:@"image/png"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Error: %@", uploadProgress);
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@ ", responseObject);
        self.sucsblock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"Error: %@", error);
        self.falureblk(error);
    }];
}

@end
