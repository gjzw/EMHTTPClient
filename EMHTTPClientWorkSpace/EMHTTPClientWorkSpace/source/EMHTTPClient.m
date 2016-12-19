//
//  EMHTTPClient.m
//  EMCommunication
//
//  Created by gjz on 15/10/23.
//  Copyright © 2015年 gjz. All rights reserved.
//

#import "EMHTTPClient.h"
#import "NSTimer+BlocksKit.h"
#import <objc/runtime.h>



#pragma mark - ----
static char key_AFHTTPRequestOperation_Key;

@interface AFHTTPRequestOperation(EMExt)

- (id)extObject;

- (void)setExtObject:(id)extObj;

@end

@implementation AFHTTPRequestOperation(EMExt)

- (id)extObject
{
    return objc_getAssociatedObject(self, &key_AFHTTPRequestOperation_Key);
}

- (void)setExtObject:(id)extObj
{
    objc_setAssociatedObject(self, &key_AFHTTPRequestOperation_Key, extObj, OBJC_ASSOCIATION_RETAIN);
}

@end

#pragma mark - ----

@interface AFHTTPRequestOperation(AFHTTPRequestOperationHelper)

@end

@implementation AFHTTPRequestOperation(AFHTTPRequestOperationHelper)

+(void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(cancel);
        SEL swizzledSelector = @selector(swizzled_cancel);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        }
        else {
            
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)swizzled_cancel {
    NSTimer *timer = (NSTimer *)self.extObject;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    [self swizzled_cancel];
}

@end

#pragma mark - ----

@implementation EMMediaObject

+ (EMMediaObject *)mediaObjectWithBytes:(NSData *)bytes name:(NSString *)name
{
    EMMediaObject *mediaObj = [[EMMediaObject alloc] init];
    mediaObj.bytes = bytes;
    mediaObj.fieldName = name;
    mediaObj.fileName = @"image.jpg";
    mediaObj.mimeType = @"image/jpeg";
    return mediaObj;
}

@end

#pragma mark - ----

@interface EMHTTPClient()
{
    
}

@property (nonatomic, strong) AFHTTPRequestOperationManager *inner_httpRequestManager;

- (AFHTTPRequestOperation *)inner_asyncHTTPRequest:(NSString *)url
                                         paramters:(NSDictionary *)paramDict
                                            method:(NSString *)method
                                           timeout:(NSUInteger)timeout
                                           success:(AFSuccessBlock)successBlock
                                             faild:(AFFaildBlock)faildBlock;

- (AFHTTPRequestOperation *)inner_syncHTTPRequest:(NSString *)url
                                         paramters:(NSDictionary *)paramDict
                                            method:(NSString *)method
                                           timeout:(NSUInteger)timeout;

- (AFHTTPRequestOperation* )inner_asyncDownloadRequest:(NSString *)url
                                             paramters:(NSDictionary *)kvParams
                                       destinationPath:(NSString *)destinationPath
                                                method:(NSString *)method
                                               timeout:(NSUInteger)timeout
                                               success:(AFSuccessBlock)successBlock
                                                 faild:(AFFaildBlock)faildBlock;

@end

@implementation EMHTTPClient

#pragma mark - ---- 初始化

+ (instancetype)client
{
    return [[self alloc] init];
}

- (EMHTTPClient *)init
{
    if (self = [super init]) {
        self.inner_httpRequestManager = [AFHTTPRequestOperationManager manager];
        [self resetSerializer];
    }
    
    return self;
}

- (void)resetSerializer
{
    self.inner_httpRequestManager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    self.inner_httpRequestManager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
}

- (AFHTTPRequestOperationManager *)httpRequestManager
{
    return self.inner_httpRequestManager;
}

- (void)setValue:(id)value forHTTPHeaderKey:(NSString *)key
{
    [self.inner_httpRequestManager.requestSerializer setValue:value forHTTPHeaderField:key];
}

-(void)setStringEncoding:(NSStringEncoding)stringEncoding {
    _stringEncoding = stringEncoding;
    if (self.inner_httpRequestManager) {
        self.inner_httpRequestManager.requestSerializer.stringEncoding = stringEncoding;
    }
}

#pragma mark - ----- 各种请求发送

- (AFHTTPRequestOperation*)asyncRawDataGet:(NSString *)url
                                 paramters:(NSDictionary *)kvParams
                                   timeout:(NSUInteger)timeout
                                   success:(AFSuccessBlock)successBlock
                                     faild:(AFFaildBlock)faildBlock
{
    
    NSParameterAssert(url);
    return [self inner_asyncHTTPRequest:url
                       paramters:kvParams
                          method:@"GET"
                         timeout:timeout
                         success:successBlock
                           faild:faildBlock];
}

- (AFHTTPRequestOperation* )asyncDownloadGet:(NSString *)url
                                   paramters:(NSDictionary *)kvParams
                             destinationPath:(NSString *)destinationPath
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock {
    NSParameterAssert(url);
    return [self inner_asyncDownloadRequest:url
                                  paramters:kvParams
                            destinationPath:destinationPath
                                     method:@"GET"
                                    timeout:timeout
                                    success:successBlock
                                      faild:faildBlock];
}

- (AFHTTPRequestOperation* )syncRawDataGet:(NSString *)url
                                 paramters:(NSDictionary *)kvParams
                                   timeout:(NSUInteger)timeout {
    NSParameterAssert(url);
    AFHTTPRequestOperation *operation = [self inner_syncHTTPRequest:url paramters:kvParams method:@"GET" timeout:timeout];
    [operation start];
    [operation waitUntilFinished];
    return operation;
}

- (AFHTTPRequestOperation *)asyncRawDataPost:(NSString *)url
                                   paramters:(NSDictionary *)paramDict
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock
{
    NSParameterAssert(url);
    return [self inner_asyncHTTPRequest:url
                       paramters:paramDict
                          method:@"POST"
                         timeout:timeout
                         success:successBlock
                           faild:faildBlock];
}

- (AFHTTPRequestOperation* )asyncDownloadPost:(NSString *)url
                                    paramters:(NSDictionary *)kvParams
                              destinationPath:(NSString *)destinationPath
                                      timeout:(NSUInteger)timeout
                                      success:(AFSuccessBlock)successBlock
                                        faild:(AFFaildBlock)faildBlock {
    
    NSParameterAssert(url);
    return [self inner_asyncDownloadRequest:url
                                  paramters:kvParams
                            destinationPath:destinationPath
                                     method:@"POST"
                                    timeout:timeout
                                    success:successBlock
                                      faild:faildBlock];
}

- (AFHTTPRequestOperation *)syncRawDataPost:(NSString *)url
                                  paramters:(NSDictionary *)paramDict
                                    timeout:(NSUInteger)timeout {
    NSParameterAssert(url);
    return [self inner_syncHTTPRequest:url
                              paramters:paramDict
                                 method:@"POST"
                                timeout:timeout];
}

- (AFHTTPRequestOperation *)asyncRawDataRequest:(NSURLRequest *)request
                                        timeout:(NSUInteger)timeout
                                        success:(AFSuccessBlock)successBlock
                                          faild:(AFFaildBlock)faildBlock
{
    NSParameterAssert(request);
    
    __block int fTimeout = (int)timeout;
    
    if (timeout > kMaxTimeout || timeout < kMinTimeout) {
        fTimeout = kDefaultTimeout;
    }
    
    AFHTTPRequestOperation *opt = [self.inner_httpRequestManager HTTPRequestOperationWithRequest:request
                                                                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                                                             NSTimer *timer = (NSTimer *)opt.extObject;
                                                                                             [timer invalidate];
                                                                                             timer = nil;
                                                                        
                                                                                             
                                                                                             if (successBlock) {
                                                                                                 successBlock(operation, responseObject);
                                                                                             }
                                                                                         }
                                                                                         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                                                    
                                                                                             NSTimer *timer = (NSTimer *)opt.extObject;
                                                                                             [timer invalidate];
                                                                                             timer = nil;
                                                                                             if (faildBlock) {
                                                                                                 faildBlock(operation, error);
                                                                                             }
                                                                                         }];
    
    NSTimer *timerd = [NSTimer bk_scheduledTimerWithTimeInterval:fTimeout
                                                           block:^(NSTimer *timer) {
                                                               
                                                               [opt cancel];
                                                               [opt setExtObject:nil];
                                                               if(!opt.isFinished && !opt.isCancelled) {
                                                                   NSError *timeoutError = [self timeoutError:fTimeout];
                                                   
                                                                   if (faildBlock) {
                                                                       faildBlock(opt, timeoutError);
                                                                   }
                                                               }
                                                               [timer invalidate];
                                                               timer = nil;
                                                           }
                                                         repeats:NO];
    [opt setExtObject:timerd];
    [self.inner_httpRequestManager.operationQueue  addOperation:opt];
    return opt;
}

- (AFHTTPRequestOperation *)syncRawDataRequest:(NSURLRequest *)request
                                       timeout:(NSUInteger)timeout {
    NSParameterAssert(request);
    
    AFHTTPRequestOperation *opt = [self.inner_httpRequestManager HTTPRequestOperationWithRequest:request success:nil failure:nil];
    
    [opt start];
    [opt waitUntilFinished];
    
    return opt;
}

- (AFHTTPRequestOperation*)asyncRawDataMultipartFormPost:(NSString *)url
                                               paramters:(NSDictionary *)paramDict
                                             mediaObject:(EMMediaObject *)mediaObj
                                                 timeout:(NSUInteger)timeout
                                                 success:(AFSuccessBlock)successBlock
                                                   faild:(AFFaildBlock)faildBlock
{
    NSParameterAssert(url);
    
    NSString *urld = [url copy];
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.httpRequestManager.requestSerializer multipartFormRequestWithMethod:@"POST"
                                                                                                   URLString:urld
                                                                                                  parameters:paramDict
                                                                                   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                                                       [formData appendPartWithFileData:mediaObj.bytes
                                                                                                                   name:mediaObj.fieldName
                                                                                                               fileName:mediaObj.fileName
                                                                                                               mimeType:mediaObj.mimeType];
                                                                                   }
                                                                                                       error:&serializationError];
    if (serializationError && faildBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            faildBlock(nil, serializationError);
        });
        return nil;
    }
    else {
        return [self asyncRawDataRequest:request timeout:timeout success:successBlock faild:faildBlock];
    }
}

- (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         timeout:(NSUInteger)timeout
                         success:(AFSuccessBlock)successBlock
                           faild:(AFFaildBlock)faildBlock {
    __block int fTimeout = (int)timeout;
    
    if (timeout > kMaxTimeout || timeout < kMinTimeout) {
        fTimeout = kDefaultTimeout;
    }
    
    AFHTTPRequestOperation *opt = [self.inner_httpRequestManager HEAD:URLString
                                                           parameters:parameters
                                                              success:^(AFHTTPRequestOperation * _Nonnull operation) {
                                                                  NSTimer *timer = (NSTimer *)operation.extObject;
                                                                  [timer invalidate];
                                                                  timer = nil;
                                                                  
                                                                  
                                                                  if (successBlock) {
                                                                      successBlock(operation, operation.responseObject);
                                                                  }
                                                              } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                                                  NSTimer *timer = (NSTimer *)opt.extObject;
                                                                  [timer invalidate];
                                                                  timer = nil;
                                                                  if (faildBlock) {
                                                                      faildBlock(operation, error);
                                                                  }
                                                              }];
    
 
    
    NSTimer *timerd = [NSTimer bk_scheduledTimerWithTimeInterval:fTimeout
                                                           block:^(NSTimer *timer) {
                                                               
                                                               [opt cancel];
                                                               [opt setExtObject:nil];
                                                               if(!opt.isFinished && !opt.isCancelled) {
                                                                   NSError *timeoutError = [self timeoutError:fTimeout];
                                                                   
                                                                   if (faildBlock) {
                                                                       faildBlock(opt, timeoutError);
                                                                   }
                                                               }
                                                               [timer invalidate];
                                                               timer = nil;
                                                           }
                                                         repeats:NO];
    [opt setExtObject:timerd];
    return opt;

}

#pragma mark - ---- 请求取消

- (void)cancelRequest:(NSString*)url
{
    if (url == nil) {
        return;
    }
    
    NSArray *opts = self.inner_httpRequestManager.operationQueue.operations;
    for (AFHTTPRequestOperation *opt in opts) {
        if ([[opt.request.URL.absoluteString lowercaseString] hasPrefix:[url lowercaseString]]) {
            [opt cancel];
            NSTimer *timer = (NSTimer*)opt.extObject;
            if (timer) {
                [timer invalidate];
                timer = nil;
            }
        }
    }
}

- (void)cancelOperation:(AFHTTPRequestOperation*)operation {
    if (operation == nil) {
        return;
    }
    [operation cancel];
    NSTimer *timer = (NSTimer*)operation.extObject;
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
}

- (void)cancelAllRequest
{
    NSArray *opts = self.inner_httpRequestManager.operationQueue.operations;
    for (AFHTTPRequestOperation *opt in opts) {
        NSTimer *timer = (NSTimer*)opt.extObject;
        [timer invalidate];
        timer = nil;
    }
    [self.inner_httpRequestManager.operationQueue cancelAllOperations];
}

#pragma mark - ---------- 类方法

+ (void)resetSerializer
{
    [EMHTTPClient client].inner_httpRequestManager.requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    [EMHTTPClient client].inner_httpRequestManager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
}



+ (void)setValue:(id)value forHTTPHeaderKey:(NSString *)key
{
    [[EMHTTPClient client].inner_httpRequestManager.requestSerializer setValue:value forHTTPHeaderField:key];
}

+ (void)setStringEncoding:(NSStringEncoding)encodeing {
    [[EMHTTPClient client] setStringEncoding:encodeing];
}

#pragma mark - ----- 各种请求发送

+ (AFHTTPRequestOperation*)asyncRawDataGet:(NSString *)url
                                 paramters:(NSDictionary *)kvParams
                                   timeout:(NSUInteger)timeout
                                   success:(AFSuccessBlock)successBlock
                                     faild:(AFFaildBlock)faildBlock
{
    
    return [[EMHTTPClient client]asyncRawDataGet:url paramters:kvParams timeout:timeout success:successBlock faild:faildBlock];
}

+ (AFHTTPRequestOperation* )asyncDownloadGet:(NSString *)url
                                   paramters:(NSDictionary *)kvParams
                             destinationPath:(NSString *)destinationPath
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock {
    return [[EMHTTPClient client] asyncDownloadGet:url
                                         paramters:kvParams
                                   destinationPath:destinationPath
                                           timeout:timeout
                                           success:successBlock
                                             faild:faildBlock];
}

+ (AFHTTPRequestOperation* )syncRawDataGet:(NSString *)url
                                 paramters:(NSDictionary *)kvParams
                                   timeout:(NSUInteger)timeout {
    NSParameterAssert(url);
    return [[EMHTTPClient client] inner_syncHTTPRequest:url paramters:kvParams method:@"GET" timeout:timeout];
}

+ (AFHTTPRequestOperation *)asyncRawDataPost:(NSString *)url
                                   paramters:(NSDictionary *)paramDict
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock
{
    return [[EMHTTPClient client]asyncRawDataPost:url paramters:paramDict timeout:timeout success:successBlock faild:faildBlock];
}

+ (AFHTTPRequestOperation* )asyncDownloadPost:(NSString *)url
                                    paramters:(NSDictionary *)kvParams
                              destinationPath:(NSString *)destinationPath
                                      timeout:(NSUInteger)timeout
                                      success:(AFSuccessBlock)successBlock
                                        faild:(AFFaildBlock)faildBlock {
    return [[EMHTTPClient client]asyncDownloadPost:url
                                         paramters:kvParams
                                   destinationPath:destinationPath
                                           timeout:timeout
                                           success:successBlock
                                             faild:faildBlock];
}

+ (AFHTTPRequestOperation *)syncRawDataPost:(NSString *)url
                                  paramters:(NSDictionary *)paramDict
                                    timeout:(NSUInteger)timeout {
    return [[EMHTTPClient client] syncRawDataPost:url paramters:paramDict timeout:timeout];
}

+ (AFHTTPRequestOperation *)asyncRawDataRequest:(NSURLRequest *)request
                                        timeout:(NSUInteger)timeout
                                        success:(AFSuccessBlock)successBlock
                                          faild:(AFFaildBlock)faildBlock
{
    return [[EMHTTPClient client]asyncRawDataRequest:request timeout:timeout success:successBlock faild:faildBlock];
}

+ (AFHTTPRequestOperation *)syncRawDataRequest:(NSURLRequest *)request
                                       timeout:(NSUInteger)timeout {
    return [[EMHTTPClient client]syncRawDataRequest:request timeout:timeout];
}

+ (AFHTTPRequestOperation*)asyncRawDataMultipartFormPost:(NSString *)url
                                               paramters:(NSDictionary *)paramDict
                                             mediaObject:(EMMediaObject *)mediaObj
                                                 timeout:(NSUInteger)timeout
                                                 success:(AFSuccessBlock)successBlock
                                                   faild:(AFFaildBlock)faildBlock
{
    return [[EMHTTPClient client]asyncRawDataMultipartFormPost:url paramters:paramDict mediaObject:mediaObj timeout:timeout success:successBlock faild:faildBlock];
}

+ (AFHTTPRequestOperation *)HEAD:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         timeout:(NSUInteger)timeout
                         success:(AFSuccessBlock)successBlock
                           faild:(AFFaildBlock)faildBlock {
    return [[EMHTTPClient client]HEAD:URLString
                           parameters:parameters
                              timeout:timeout
                              success:successBlock
                                faild:faildBlock];
}


#pragma mark - ---- 请求取消

+ (void)cancelRequest:(NSString*)url
{
    [[EMHTTPClient client]cancelRequest:url];
}

+ (void)cancelOperation:(AFHTTPRequestOperation*)operation {
    [[EMHTTPClient client]cancelOperation:operation];
}

+ (void)cancelAllRequest
{
    [[EMHTTPClient client]cancelAllRequest];
}


#pragma mark - ---- inner

- (NSError *)timeoutError:(int)timeout
{
    return [NSError errorWithDomain:[NSString stringWithFormat:@"网络请求超过设置的超时时间[%d]", timeout] code:kTimeoutErrorCode userInfo:nil];
}




- (AFHTTPRequestOperation *)inner_asyncHTTPRequest:(NSString *)url
                                         paramters:(NSDictionary *)paramDict
                                            method:(NSString *)method
                                           timeout:(NSUInteger)timeout
                                           success:(AFSuccessBlock)successBlock
                                             faild:(AFFaildBlock)faildBlock
{
    NSParameterAssert(url);
    NSParameterAssert(method);
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.inner_httpRequestManager.requestSerializer requestWithMethod:method
                                                                                            URLString:[url copy]
                                                                                           parameters:paramDict
                                                                                                error:&serializationError];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    request.timeoutInterval = timeout;
    if (serializationError && faildBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            faildBlock(nil, serializationError);
        });
        return nil;
    } else {
        return [self asyncRawDataRequest:request timeout:timeout success:successBlock faild:faildBlock];
    }
}

- (AFHTTPRequestOperation *)inner_syncHTTPRequest:(NSString *)url
                                        paramters:(NSDictionary *)paramDict
                                           method:(NSString *)method
                                          timeout:(NSUInteger)timeout {
    NSParameterAssert(url);
    NSParameterAssert(method);
    
    int fTimeout = (int)timeout;
    
    if (timeout > kMaxTimeout || timeout < kMinTimeout) {
        fTimeout = kDefaultTimeout;
    }
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.inner_httpRequestManager.requestSerializer requestWithMethod:method
                                                                                            URLString:[url copy]
                                                                                           parameters:paramDict
                                                                                                error:&serializationError];
    
    request.timeoutInterval = timeout;
    
    if (serializationError) {
        return nil;
    } else {
        return [self syncRawDataRequest:request timeout:timeout];
    }

}

- (AFHTTPRequestOperation* )inner_asyncDownloadRequest:(NSString *)url
                                             paramters:(NSDictionary *)kvParams
                                       destinationPath:(NSString *)destinationPath
                                                method:(NSString *)method
                                               timeout:(NSUInteger)timeout
                                               success:(AFSuccessBlock)successBlock
                                                 faild:(AFFaildBlock)faildBlock {
    
    
    NSParameterAssert(url);
    NSParameterAssert(method);
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.inner_httpRequestManager.requestSerializer requestWithMethod:method
                                                                                            URLString:[url copy]
                                                                                           parameters:kvParams
                                                                                                error:&serializationError];
    
    request.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
    AFHTTPRequestOperation *operation = nil;
    if (serializationError && faildBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            faildBlock(nil, serializationError);
        });
        return nil;
    } else {
        operation = [self asyncRawDataRequest:request timeout:timeout success:successBlock faild:faildBlock];
    }
    
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:destinationPath append:NO];
    return operation;
}

@end

#pragma mark - ----- Request

@implementation EMHTTPClient (Request)


+ (NSMutableURLRequest *)httpRequest:(NSString *)url
                           paramters:(NSDictionary *)paramDict
                              method:(NSString *)method
                             timeout:(NSUInteger)timeout {
    
    NSParameterAssert(url);
    NSParameterAssert(method);
    
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [[EMHTTPClient client].inner_httpRequestManager.requestSerializer requestWithMethod:method
                                                                                            URLString:[url copy]
                                                                                           parameters:paramDict
                                                                                                error:&serializationError];
    if(serializationError) {
        return nil;
    }
    else
    {
        return request;
    }
}

+ (NSMutableURLRequest *)multipartFormRequestWithMethod:(NSString *)method
                                              URLString:(NSString *)URLString
                                             parameters:(NSDictionary *)parameters
                              constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block {
    NSError *error;
    NSMutableURLRequest *request = [[EMHTTPClient client].inner_httpRequestManager.requestSerializer multipartFormRequestWithMethod:method URLString:URLString parameters:parameters constructingBodyWithBlock:block error:&error];
    if (error) {
        return nil;
    }
    else {
        return request;
    }
}


@end


#pragma mark - ----- JSON Request

@implementation EMHTTPClient(JSON)

/**
 *  发送GET请求，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation*)asyncJSONGet:(NSString *)url
                              paramters:(NSDictionary *)kvParams
                                timeout:(NSUInteger)timeout
                                success:(AFSuccessBlock)successBlock
                                  faild:(AFFaildBlock)faildBlock
{
    return [self asyncRawDataGet:url
                paramters:kvParams
                  timeout:timeout
                  success:^(AFHTTPRequestOperation *operation, id responseObject) {
                      [EMHTTPClient JSONRequestSuccessCallbackWithOperation:operation
                                                                   response:responseObject
                                                               successBlock:successBlock
                                                                 faildBlock:faildBlock];
                  }
                    faild:faildBlock];
}



/**
 *  发送Post请求, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONPost:(NSString *)url
                                paramters:(NSDictionary *)paramDict
                                  timeout:(NSUInteger)timeout
                                  success:(AFSuccessBlock)successBlock
                                    faild:(AFFaildBlock)faildBlock
{
    return [self asyncRawDataPost:url
                 paramters:paramDict
                   timeout:timeout success:^(AFHTTPRequestOperation *operation, id responseObject) {
                       [EMHTTPClient JSONRequestSuccessCallbackWithOperation:operation
                                                                    response:responseObject
                                                                successBlock:successBlock
                                                                  faildBlock:faildBlock];
                   }
                     faild:faildBlock];
}


/**
 *  发送自定义Request, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONRequest:(NSURLRequest *)request
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock
{
    return [self asyncRawDataRequest:request
                      timeout:timeout success:^(AFHTTPRequestOperation *operation, id responseObject) {
                          [EMHTTPClient JSONRequestSuccessCallbackWithOperation:operation
                                                                       response:responseObject
                                                                   successBlock:successBlock
                                                                     faildBlock:faildBlock];
                      }
                        faild:faildBlock];
    
}



/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
- (AFHTTPRequestOperation *)asyncJSONMultipartFormPost:(NSString *)url
                                             paramters:(NSDictionary *)paramDict
                                           mediaObject:(EMMediaObject *)mediaObj
                                               timeout:(NSUInteger)timeout
                                               success:(AFSuccessBlock)successBlock
                                                 faild:(AFFaildBlock)faildBlock
{
    return [self asyncRawDataMultipartFormPost:url
                              paramters:paramDict
                            mediaObject:mediaObj
                                timeout:timeout success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                    [EMHTTPClient JSONRequestSuccessCallbackWithOperation:operation
                                                                                 response:responseObject
                                                                             successBlock:successBlock
                                                                               faildBlock:faildBlock];
                                }
                                  faild:faildBlock];
    
    
}


/**
 *  发送GET请求，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，参数带在URL里面，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation*)asyncJSONGet:(NSString *)url
                              paramters:(NSDictionary *)kvParams
                                timeout:(NSUInteger)timeout
                                success:(AFSuccessBlock)successBlock
                                  faild:(AFFaildBlock)faildBlock
{
    return [[EMHTTPClient client] asyncRawDataGet:url
                       paramters:kvParams
                         timeout:timeout
                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                             [EMHTTPClient JSONRequestSuccessCallbackWithOperation:operation
                                                                          response:responseObject
                                                                      successBlock:successBlock
                                                                        faildBlock:faildBlock];
                         }
                           faild:faildBlock];
}



/**
 *  发送Post请求, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          请求的URL，不能为空
 *  @param paramDict    post的参数key，value形式
 *  @param timeout     timeout时间，单位是秒,如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONPost:(NSString *)url
                                paramters:(NSDictionary *)paramDict
                                  timeout:(NSUInteger)timeout
                                  success:(AFSuccessBlock)successBlock
                                    faild:(AFFaildBlock)faildBlock
{
    return [[EMHTTPClient client] asyncRawDataPost:url
                        paramters:paramDict
                          timeout:timeout success:^(AFHTTPRequestOperation *operation, id responseObject) {
                              [EMHTTPClient JSONRequestSuccessCallbackWithOperation:operation
                                                                           response:responseObject
                                                                       successBlock:successBlock
                                                                         faildBlock:faildBlock];
                          }
                            faild:faildBlock];
}


/**
 *  发送自定义Request, 服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param request    发送的Request对象，不能为空
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=kMaxTimeout(120秒)||timeout<=kMinTimeout(3秒)时候，会使用默认值kDefaultTimeout(15秒)
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONRequest:(NSURLRequest *)request
                                     timeout:(NSUInteger)timeout
                                     success:(AFSuccessBlock)successBlock
                                       faild:(AFFaildBlock)faildBlock
{
    return [[EMHTTPClient client] asyncRawDataRequest:request
                             timeout:timeout success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                 [EMHTTPClient JSONRequestSuccessCallbackWithOperation:operation
                                                                              response:responseObject
                                                                          successBlock:successBlock
                                                                            faildBlock:faildBlock];
                             }
                               faild:faildBlock];
    
}



/**
 *  上传多媒体文件，比如图片, multipart-form形式post上传，服务端返回的数据会被JSON Decode，再通过callback返回
 *
 *  @param url          上传URL，不能为空
 *  @param paramDict    参数key，value形式
 *  @param mediaObj     media数据
 *  @param timeout    timeout时间，单位是秒, 如果timeout>=120||timeout<=0时候，会使用默认值15s
 *  @param successBlock 成功回调
 *  @param faildBlock   失败回调
 */
+ (AFHTTPRequestOperation *)asyncJSONMultipartFormPost:(NSString *)url
                                             paramters:(NSDictionary *)paramDict
                                           mediaObject:(EMMediaObject *)mediaObj
                                               timeout:(NSUInteger)timeout
                                               success:(AFSuccessBlock)successBlock
                                                 faild:(AFFaildBlock)faildBlock
{
    return [[EMHTTPClient client] asyncRawDataMultipartFormPost:url
                                     paramters:paramDict
                                   mediaObject:mediaObj
                                       timeout:timeout success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                           [EMHTTPClient JSONRequestSuccessCallbackWithOperation:operation
                                                                                        response:responseObject
                                                                                    successBlock:successBlock
                                                                                      faildBlock:faildBlock];
                                       }
                                         faild:faildBlock];
    
    
}

#pragma mark - --- inner API

+ (id)objectFromJSONResponseData:(NSData *)responseData
{
    NSError *error = nil;
    id retObj = nil;
    if (responseData == nil) {
        error = [NSError errorWithDomain:@"JSON_Decode_Empty_Response" code:-1001 userInfo:nil];
    }
    else {
        retObj = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
    }
    
    if (error == nil && retObj != nil) {
        return retObj;
    }
    else {
        error = [NSError errorWithDomain:@"JSON_Decode_Failed" code:-1002 userInfo:nil];
        return error;
    }
}

+ (void)JSONRequestSuccessCallbackWithOperation:(AFHTTPRequestOperation*)operation
                                       response:(id)responseObject
                                   successBlock:(AFSuccessBlock)cbSuccessBlock
                                     faildBlock:(AFFaildBlock)cbFaildBlock
{
    
    if (cbSuccessBlock != nil) {
        id retObj = [EMHTTPClient objectFromJSONResponseData:responseObject];
        if ([retObj isKindOfClass:[NSError class]]) {
            if (cbFaildBlock != nil) {
                cbFaildBlock(operation, retObj);
            }
        }
        else {
            cbSuccessBlock(operation, retObj);
        }
    }
}

@end
