//
//  JstyleWave.h
//  Exquisite
//
//  Created by 赵涛 on 16/5/11.
//  Copyright © 2016年 LanBao. All rights reserved.
//


#import "JstyleWave.h"

@interface JSProxy : NSObject

@property (weak, nonatomic) id executor;

@end

@implementation JSProxy

-(void)callback {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [_executor performSelector:@selector(wave)];
    
#pragma clang diagnostic pop
}

@end

@interface JstyleWave ()
//刷屏器
@property (nonatomic, strong) CADisplayLink *timer;
//真实浪
@property (nonatomic, strong) CAShapeLayer *realWaveLayer;
//遮罩浪1
@property (nonatomic, strong) CAShapeLayer *maskWaveLayer1;
//遮罩浪2
@property (nonatomic, strong) CAShapeLayer *maskWaveLayer2;

@property (nonatomic, assign) CGFloat offset;

@end

@implementation JstyleWave

- (void)awakeFromNib{
    [super awakeFromNib];
    [self initData];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
}

- (void)initData{
    //初始化
    self.waveSpeed = 0.6;
    self.waveCurvature = 1.2;
    self.waveHeight = 8;
    self.realWaveColor = [UIColor whiteColor];
    self.maskWaveColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
    
    [self.layer addSublayer:self.realWaveLayer];
    [self.layer addSublayer:self.maskWaveLayer1];
    [self.layer addSublayer:self.maskWaveLayer2];
    
}

- (CAShapeLayer *)realWaveLayer{
    
    if (!_realWaveLayer) {
        _realWaveLayer = [CAShapeLayer layer];
        CGRect frame = [self bounds];
        frame.origin.y = frame.size.height-self.waveHeight;
        frame.size.height = self.waveHeight;
        _realWaveLayer.frame = frame;
        _realWaveLayer.fillColor = self.realWaveColor.CGColor;
        
    }
    return _realWaveLayer;
}

- (CAShapeLayer *)maskWaveLayer1{
    
    if (!_maskWaveLayer1) {
        _maskWaveLayer1 = [CAShapeLayer layer];
        CGRect frame = [self bounds];
        frame.origin.y = frame.size.height-self.waveHeight;
        frame.size.height = self.waveHeight;
        _maskWaveLayer1.frame = frame;
        _maskWaveLayer1.fillColor = self.maskWaveColor.CGColor;
    }
    return _maskWaveLayer1;
}

- (CAShapeLayer *)maskWaveLayer2{
    
    if (!_maskWaveLayer2) {
        _maskWaveLayer2 = [CAShapeLayer layer];
        CGRect frame = [self bounds];
        frame.origin.y = frame.size.height-self.waveHeight;
        frame.size.height = self.waveHeight;
        _maskWaveLayer2.frame = frame;
        _maskWaveLayer2.fillColor = self.maskWaveColor.CGColor;
    }
    return _maskWaveLayer2;
}

- (void)setWaveHeight:(CGFloat)waveHeight{
    _waveHeight = waveHeight;
    
    CGRect frame = [self bounds];
    frame.origin.y = frame.size.height-self.waveHeight;
    frame.size.height = self.waveHeight;
    _realWaveLayer.frame = frame;
    
    CGRect frame1 = [self bounds];
    frame1.origin.y = frame1.size.height-self.waveHeight;
    frame1.size.height = self.waveHeight;
    _maskWaveLayer1.frame = frame1;
    
}

- (void)startWaveAnimation{
    JSProxy *proxy = [[JSProxy alloc] init];
    proxy.executor = self;
    self.timer = [CADisplayLink displayLinkWithTarget:proxy selector:@selector(callback)];
    [self.timer addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
}

- (void)stopWaveAnimation{
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)wave{
    
    self.offset += self.waveSpeed;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = self.waveHeight;
    
    //真实浪
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, height);
    CGFloat y = 0.f;
    //遮罩浪
    CGMutablePathRef maskpath = CGPathCreateMutable();
    CGPathMoveToPoint(maskpath, NULL, 0, height);
    CGFloat maskY = 0.f;
    for (CGFloat x = 0.f; x <= width ; x++) {
        y = height * sinf(0.01 * self.waveCurvature * x + self.offset * 0.055);
        CGPathAddLineToPoint(path, NULL, x, y);
        maskY = -y;
        CGPathAddLineToPoint(maskpath, NULL, x, maskY);
    }
    
    //变化的中间Y值
    CGFloat centX = self.bounds.size.width/2;
    CGFloat CentY = height * sinf(0.01 * self.waveCurvature *centX  + self.offset * 0.055);
    if (self.waveBlock) {
        self.waveBlock(CentY);
    }
    
//    CGPathAddLineToPoint(path, NULL, width, height);
//    CGPathAddLineToPoint(path, NULL, 0, height);
//    CGPathCloseSubpath(path);
//    self.realWaveLayer.path = path;
//    self.realWaveLayer.fillColor = self.realWaveColor.CGColor;
//    CGPathRelease(path);
    
    CGPathAddLineToPoint(maskpath, NULL, width, height);
    CGPathAddLineToPoint(maskpath, NULL, 0, height);
    CGPathCloseSubpath(maskpath);
    self.maskWaveLayer1.path = maskpath;
    self.maskWaveLayer1.fillColor = self.maskWaveColor.CGColor;
    CGPathRelease(maskpath);
    
    //遮罩浪2
    CGMutablePathRef maskpath2 = CGPathCreateMutable();
    CGPathMoveToPoint(maskpath2, NULL, 0, height);
    CGFloat maskY2 = 0.f;
    for (CGFloat x = 0.f; x <= width ; x++) {
        y = height * sinf(0.01 * self.waveCurvature * x + self.offset * 0.095);
        CGPathAddLineToPoint(path, NULL, x, y);
        maskY2 = -y;
        CGPathAddLineToPoint(maskpath2, NULL, x, maskY2);
    }
    
    CGPathRelease(path);
    
    CGPathAddLineToPoint(maskpath2, NULL, width, height);
    CGPathAddLineToPoint(maskpath2, NULL, 0, height);
    CGPathCloseSubpath(maskpath2);
    self.maskWaveLayer2.path = maskpath2;
    self.maskWaveLayer2.fillColor = self.maskWaveColor.CGColor;
    CGPathRelease(maskpath2);
}

@end
