package mx.graphics
{
   import mx.core.IUIComponent;
   import flash.display.DisplayObject;
   import mx.core.UIComponent;
   import flash.display.Stage;
   import flash.utils.ByteArray;
   import mx.utils.Base64Encoder;
   import flash.display.IBitmapDrawable;
   import mx.graphics.codec.IImageEncoder;
   import flash.geom.Matrix;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import mx.core.IFlexDisplayObject;
   import mx.core.mx_internal;
   import flash.geom.ColorTransform;
   import mx.graphics.codec.PNGEncoder;
   
   use namespace mx_internal;
   
   public dynamic class ImageSnapshot
   {
      
      public static var defaultEncoder:Class = PNGEncoder;
      
      public static const MAX_BITMAP_DIMENSION:int = 2880;
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _data:ByteArray;
      
      private var _height:int;
      
      private var _contentType:String;
      
      private var _width:int;
      
      private var _properties:Object;
      
      public function ImageSnapshot(param1:int = 0, param2:int = 0, param3:ByteArray = null, param4:String = null)
      {
         _properties = {};
         super();
         this.contentType = param4;
         this.width = param1;
         this.height = param2;
         this.data = param3;
      }
      
      private static function finishPrintObject(param1:IUIComponent, param2:Array) : void
      {
         var _loc3_:DisplayObject = param1 is DisplayObject?DisplayObject(param1):null;
         var _loc4_:Number = 0;
         while(_loc3_ != null)
         {
            if(_loc3_ is UIComponent)
            {
               UIComponent(_loc3_).finishPrint(param2[_loc4_++],UIComponent(param1));
            }
            else if(_loc3_ is DisplayObject && !(_loc3_ is Stage))
            {
               DisplayObject(_loc3_).mask = param2[_loc4_++];
            }
            _loc3_ = _loc3_.parent is DisplayObject?DisplayObject(_loc3_.parent):null;
         }
      }
      
      public static function encodeImageAsBase64(param1:ImageSnapshot) : String
      {
         var _loc2_:ByteArray = param1.data;
         var _loc3_:Base64Encoder = new Base64Encoder();
         _loc3_.encodeBytes(_loc2_);
         var _loc4_:String = _loc3_.drain();
         return _loc4_;
      }
      
      private static function mergePixelRows(param1:ByteArray, param2:int, param3:ByteArray, param4:int, param5:int) : ByteArray
      {
         var _loc6_:ByteArray = new ByteArray();
         var _loc7_:int = param2 * 4;
         var _loc8_:int = param4 * 4;
         var _loc9_:int = 0;
         while(_loc9_ < param5)
         {
            _loc6_.writeBytes(param1,_loc9_ * _loc7_,_loc7_);
            _loc6_.writeBytes(param3,_loc9_ * _loc8_,_loc8_);
            _loc9_++;
         }
         _loc6_.position = 0;
         return _loc6_;
      }
      
      public static function captureImage(param1:IBitmapDrawable, param2:Number = 0, param3:IImageEncoder = null, param4:Boolean = true) : ImageSnapshot
      {
         var snapshot:ImageSnapshot = null;
         var width:int = 0;
         var height:int = 0;
         var normalState:Array = null;
         var bytes:ByteArray = null;
         var data:BitmapData = null;
         var bitmap:Bitmap = null;
         var bounds:Rectangle = null;
         var source:IBitmapDrawable = param1;
         var dpi:Number = param2;
         var encoder:IImageEncoder = param3;
         var scaleLimited:Boolean = param4;
         var screenDPI:Number = Capabilities.screenDPI;
         if(dpi <= 0)
         {
            dpi = screenDPI;
         }
         var scale:Number = dpi / screenDPI;
         var matrix:Matrix = new Matrix(scale,0,0,scale);
         if(source is IUIComponent)
         {
            normalState = prepareToPrintObject(IUIComponent(source));
         }
         try
         {
            if(source != null)
            {
               if(source is DisplayObject)
               {
                  width = DisplayObject(source).width;
                  height = DisplayObject(source).height;
               }
               else if(source is BitmapData)
               {
                  width = BitmapData(source).width;
                  height = BitmapData(source).height;
               }
               else if(source is IFlexDisplayObject)
               {
                  width = IFlexDisplayObject(source).width;
                  height = IFlexDisplayObject(source).height;
               }
            }
            if(!encoder)
            {
               encoder = new defaultEncoder();
            }
            width = width * matrix.a;
            height = height * matrix.d;
            if(scaleLimited || width <= MAX_BITMAP_DIMENSION && height <= MAX_BITMAP_DIMENSION)
            {
               data = captureBitmapData(source,matrix);
               bitmap = new Bitmap(data);
               width = bitmap.width;
               height = bitmap.height;
               bytes = encoder.encode(data);
            }
            else
            {
               bounds = new Rectangle(0,0,width,height);
               bytes = captureAll(source,bounds,matrix);
               bytes = encoder.encodeByteArray(bytes,width,height);
            }
            snapshot = new ImageSnapshot(width,height,bytes,encoder.contentType);
         }
         finally
         {
            if(source is IUIComponent)
            {
               finishPrintObject(IUIComponent(source),normalState);
            }
         }
         return snapshot;
      }
      
      private static function prepareToPrintObject(param1:IUIComponent) : Array
      {
         var _loc2_:Array = [];
         var _loc3_:DisplayObject = param1 is DisplayObject?DisplayObject(param1):null;
         var _loc4_:Number = 0;
         while(_loc3_ != null)
         {
            if(_loc3_ is UIComponent)
            {
               _loc2_[_loc4_++] = UIComponent(_loc3_).prepareToPrint(UIComponent(param1));
            }
            else if(_loc3_ is DisplayObject && !(_loc3_ is Stage))
            {
               _loc2_[_loc4_++] = DisplayObject(_loc3_).mask;
               DisplayObject(_loc3_).mask = null;
            }
            _loc3_ = _loc3_.parent is DisplayObject?DisplayObject(_loc3_.parent):null;
         }
         return _loc2_;
      }
      
      private static function captureAll(param1:IBitmapDrawable, param2:Rectangle, param3:Matrix, param4:ColorTransform = null, param5:String = null, param6:Rectangle = null, param7:Boolean = false) : ByteArray
      {
         var _loc10_:Rectangle = null;
         var _loc11_:Rectangle = null;
         var _loc12_:Rectangle = null;
         var _loc15_:ByteArray = null;
         var _loc16_:ByteArray = null;
         var _loc17_:ByteArray = null;
         var _loc8_:Matrix = param3.clone();
         var _loc9_:Rectangle = param2.clone();
         if(param2.width > MAX_BITMAP_DIMENSION)
         {
            _loc9_.width = MAX_BITMAP_DIMENSION;
            _loc10_ = new Rectangle();
            _loc10_.x = _loc9_.width;
            _loc10_.y = param2.y;
            _loc10_.width = param2.width - _loc9_.width;
            _loc10_.height = param2.height;
         }
         if(param2.height > MAX_BITMAP_DIMENSION)
         {
            _loc9_.height = MAX_BITMAP_DIMENSION;
            if(_loc10_ != null)
            {
               _loc10_.height = _loc9_.height;
            }
            _loc11_ = new Rectangle();
            _loc11_.x = param2.x;
            _loc11_.y = _loc9_.height;
            _loc11_.width = _loc9_.width;
            _loc11_.height = param2.height - _loc9_.height;
            if(param2.width > MAX_BITMAP_DIMENSION)
            {
               _loc12_ = new Rectangle();
               _loc12_.x = _loc9_.width;
               _loc12_.y = _loc9_.height;
               _loc12_.width = param2.width - _loc9_.width;
               _loc12_.height = param2.height - _loc9_.height;
            }
         }
         _loc8_.translate(-_loc9_.x,-_loc9_.y);
         _loc9_.x = 0;
         _loc9_.y = 0;
         var _loc13_:BitmapData = new BitmapData(_loc9_.width,_loc9_.height,true,0);
         _loc13_.draw(param1,_loc8_,param4,param5,param6,param7);
         var _loc14_:ByteArray = _loc13_.getPixels(_loc9_);
         _loc14_.position = 0;
         if(_loc10_ != null)
         {
            _loc8_ = param3.clone();
            _loc8_.translate(-_loc10_.x,-_loc10_.y);
            _loc10_.x = 0;
            _loc10_.y = 0;
            _loc15_ = captureAll(param1,_loc10_,_loc8_);
            _loc14_ = mergePixelRows(_loc14_,_loc9_.width,_loc15_,_loc10_.width,_loc10_.height);
         }
         if(_loc11_ != null)
         {
            _loc8_ = param3.clone();
            _loc8_.translate(-_loc11_.x,-_loc11_.y);
            _loc11_.x = 0;
            _loc11_.y = 0;
            _loc16_ = captureAll(param1,_loc11_,_loc8_);
            if(_loc12_ != null)
            {
               _loc8_ = param3.clone();
               _loc8_.translate(-_loc12_.x,-_loc12_.y);
               _loc12_.x = 0;
               _loc12_.y = 0;
               _loc17_ = captureAll(param1,_loc12_,_loc8_);
               _loc16_ = mergePixelRows(_loc16_,_loc11_.width,_loc17_,_loc12_.width,_loc12_.height);
            }
            _loc14_.position = _loc14_.length;
            _loc14_.writeBytes(_loc16_);
         }
         _loc14_.position = 0;
         return _loc14_;
      }
      
      public static function captureBitmapData(param1:IBitmapDrawable, param2:Matrix = null, param3:ColorTransform = null, param4:String = null, param5:Rectangle = null, param6:Boolean = false) : BitmapData
      {
         var data:BitmapData = null;
         var width:int = 0;
         var height:int = 0;
         var normalState:Array = null;
         var scaledWidth:Number = NaN;
         var scaledHeight:Number = NaN;
         var reductionScale:Number = NaN;
         var source:IBitmapDrawable = param1;
         var matrix:Matrix = param2;
         var colorTransform:ColorTransform = param3;
         var blendMode:String = param4;
         var clipRect:Rectangle = param5;
         var smoothing:Boolean = param6;
         if(source is IUIComponent)
         {
            normalState = prepareToPrintObject(IUIComponent(source));
         }
         try
         {
            if(source != null)
            {
               if(source is DisplayObject)
               {
                  width = DisplayObject(source).width;
                  height = DisplayObject(source).height;
               }
               else if(source is BitmapData)
               {
                  width = BitmapData(source).width;
                  height = BitmapData(source).height;
               }
               else if(source is IFlexDisplayObject)
               {
                  width = IFlexDisplayObject(source).width;
                  height = IFlexDisplayObject(source).height;
               }
            }
            if(!matrix)
            {
               matrix = new Matrix(1,0,0,1);
            }
            scaledWidth = width * matrix.a;
            scaledHeight = height * matrix.d;
            reductionScale = 1;
            if(scaledWidth > MAX_BITMAP_DIMENSION)
            {
               reductionScale = scaledWidth / MAX_BITMAP_DIMENSION;
               scaledWidth = MAX_BITMAP_DIMENSION;
               scaledHeight = scaledHeight / reductionScale;
               matrix.a = scaledWidth / width;
               matrix.d = scaledHeight / height;
            }
            if(scaledHeight > MAX_BITMAP_DIMENSION)
            {
               reductionScale = scaledHeight / MAX_BITMAP_DIMENSION;
               scaledHeight = MAX_BITMAP_DIMENSION;
               scaledWidth = scaledWidth / reductionScale;
               matrix.a = scaledWidth / width;
               matrix.d = scaledHeight / height;
            }
            data = new BitmapData(scaledWidth,scaledHeight,true,0);
            data.draw(source,matrix,colorTransform,blendMode,clipRect,smoothing);
         }
         finally
         {
            if(source is IUIComponent)
            {
               finishPrintObject(IUIComponent(source),normalState);
            }
         }
         return data;
      }
      
      public function get properties() : Object
      {
         return _properties;
      }
      
      public function set width(param1:int) : void
      {
         _width = param1;
      }
      
      public function set contentType(param1:String) : void
      {
         _contentType = param1;
      }
      
      public function get height() : int
      {
         return _height;
      }
      
      public function get data() : ByteArray
      {
         return _data;
      }
      
      public function set height(param1:int) : void
      {
         _height = param1;
      }
      
      public function get contentType() : String
      {
         return _contentType;
      }
      
      public function set properties(param1:Object) : void
      {
         _properties = param1;
      }
      
      public function set data(param1:ByteArray) : void
      {
         _data = param1;
      }
      
      public function get width() : int
      {
         return _width;
      }
   }
}
