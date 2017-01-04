package tibia.ingameshop
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.PNGEncoderOptions;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.SharedObject;
   import flash.net.URLRequest;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import shared.utility.BrowserHelper;
   
   public class DynamicImageManager
   {
      
      public static const DEFAULT_CACHE_TIME:int = 60 * 60;
       
      
      private var m_CachePrefix:String;
      
      private var m_BaseURL:String;
      
      private var m_Loaders:Dictionary;
      
      private var m_ImageReferences:Dictionary;
      
      private var m_CacheTime:int;
      
      public function DynamicImageManager(param1:String, param2:String, param3:int)
      {
         super();
         this.m_BaseURL = param1;
         this.m_CachePrefix = param2;
         this.m_CacheTime = param3;
         this.m_ImageReferences = new Dictionary();
         this.m_Loaders = new Dictionary();
      }
      
      private function fetchImageCache(param1:String) : DynamicImage
      {
         var _loc2_:SharedObject = null;
         var _loc3_:Number = NaN;
         var _loc6_:Loader = null;
         var _loc7_:DynamicImage = null;
         _loc2_ = this.getOrCreateCacheObject(param1);
         _loc3_ = new Date().time / 1000;
         var _loc4_:Boolean = _loc2_ != null && _loc2_.data.fetchTime > _loc3_ - this.m_CacheTime;
         var _loc5_:Boolean = _loc2_ != null && _loc2_.data.imageData as ByteArray != null && (_loc2_.data.imageData as ByteArray).length > 0;
         if(_loc4_ && _loc5_)
         {
            _loc6_ = new Loader();
            _loc6_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
            _loc6_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
            _loc6_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadError);
            this.m_Loaders[_loc6_] = param1;
            _loc6_.loadBytes(_loc2_.data.imageData as ByteArray);
            _loc7_ = this.getOrCreateImageReference(param1);
            _loc7_.fetchTime = _loc2_.data.fetchTime;
            _loc7_.state = DynamicImage.STATE_LOADING;
            return _loc7_;
         }
         return this.fetchImageRemote(param1);
      }
      
      private function onLoadError(param1:ErrorEvent) : void
      {
         var _loc2_:LoaderInfo = param1.target as LoaderInfo;
         _loc2_.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         _loc2_.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         _loc2_.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadError);
         var _loc3_:Loader = _loc2_.loader;
         var _loc4_:String = this.m_Loaders[_loc3_] as String;
         delete this.m_Loaders[_loc3_];
         _loc3_.unload();
         param1.preventDefault();
         var _loc5_:DynamicImage = this.getOrCreateImageReference(_loc4_);
         _loc5_.bitmapData = DynamicImage.ICON_ERROR;
         delete this.m_ImageReferences[_loc4_];
      }
      
      public function getImage(param1:String) : DynamicImage
      {
         var _loc2_:DynamicImage = null;
         var _loc3_:Number = NaN;
         if(param1 == null || param1.length == 0)
         {
            return null;
         }
         if(this.m_ImageReferences.hasOwnProperty(param1))
         {
            _loc2_ = this.m_ImageReferences[param1] as DynamicImage;
            _loc3_ = new Date().time / 1000;
            if(_loc2_.state == DynamicImage.STATE_READY && _loc2_.fetchTime < _loc3_ - this.m_CacheTime)
            {
               this.fetchImageRemote(param1);
            }
            return _loc2_;
         }
         return this.fetchImageCache(param1);
      }
      
      private function fetchImageRemote(param1:String) : DynamicImage
      {
         var _loc2_:Loader = new Loader();
         _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete);
         _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         _loc2_.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadError);
         this.m_Loaders[_loc2_] = param1;
         var _loc3_:URLRequest = new URLRequest(this.m_BaseURL + param1);
         _loc2_.load(_loc3_);
         var _loc4_:DynamicImage = this.getOrCreateImageReference(param1);
         _loc4_.fetchTime = new Date().time / 1000;
         _loc4_.state = DynamicImage.STATE_LOADING;
         return _loc4_;
      }
      
      private function getOrCreateImageReference(param1:String) : DynamicImage
      {
         var _loc2_:DynamicImage = null;
         if(this.m_ImageReferences.hasOwnProperty(param1))
         {
            _loc2_ = this.m_ImageReferences[param1] as DynamicImage;
         }
         else
         {
            _loc2_ = new DynamicImage();
            this.m_ImageReferences[param1] = _loc2_;
         }
         return _loc2_;
      }
      
      private function getOrCreateCacheObject(param1:String) : SharedObject
      {
         var CacheObject:SharedObject = null;
         var a_Identifier:String = param1;
         try
         {
            CacheObject = null;
            if(!BrowserHelper.s_CompareFlashPlayerVersion(Tibia.BUGGY_FLASH_PLAYER_VERSION))
            {
               CacheObject = SharedObject.getLocal(this.m_CachePrefix + a_Identifier.replace("/","_"),"/");
            }
            return CacheObject;
         }
         catch(_Error:Error)
         {
         }
         return null;
      }
      
      private function onLoadComplete(param1:Event) : void
      {
         var ImageIdentifier:String = null;
         var Data:Bitmap = null;
         var ErrorImgReference:DynamicImage = null;
         var a_Event:Event = param1;
         var _LoaderInfo:LoaderInfo = a_Event.target as LoaderInfo;
         _LoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete);
         _LoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError);
         _LoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onLoadError);
         var _Loader:Loader = _LoaderInfo.loader;
         ImageIdentifier = this.m_Loaders[_Loader];
         delete this.m_Loaders[_Loader];
         try
         {
            Data = _Loader.content as Bitmap;
         }
         catch(_Error:SecurityError)
         {
            ErrorImgReference = getOrCreateImageReference(ImageIdentifier);
            ErrorImgReference.bitmapData = DynamicImage.ICON_ERROR;
            delete m_ImageReferences[ImageIdentifier];
            return;
         }
         _Loader.unload();
         var CacheObject:SharedObject = this.getOrCreateCacheObject(ImageIdentifier);
         if(CacheObject != null)
         {
            CacheObject.data.fetchTime = new Date().time / 1000;
            CacheObject.data.imageData = new ByteArray();
            Data.bitmapData.encode(Data.bitmapData.rect,new PNGEncoderOptions(),CacheObject.data.imageData);
         }
         var ImgReference:DynamicImage = this.getOrCreateImageReference(ImageIdentifier);
         ImgReference.state = DynamicImage.STATE_READY;
         ImgReference.bitmapData = Data.bitmapData;
      }
   }
}
