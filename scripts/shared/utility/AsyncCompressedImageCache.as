package shared.utility
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.AsyncErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.system.ImageDecodingPolicy;
   import flash.system.LoaderContext;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   
   public class AsyncCompressedImageCache extends EventDispatcher
   {
      
      private static const LOADER_POOL_SIZE:uint = 4;
       
      
      private var m_LoaderPool:HeapDictionaryWrapper = null;
      
      private const m_CompressedImages:Dictionary = new Dictionary();
      
      private var m_MemoryUsed:uint = 0;
      
      private var m_MaxMemory:uint = 0;
      
      private var m_UncompressQueueAccessKey:int = 2.147483647E9;
      
      private var m_UncompressedImagesCollection:HeapDictionaryWrapper = null;
      
      private var m_UncompressQueue:HeapDictionaryWrapper = null;
      
      private var m_LoaderPoolKeysLoading:Dictionary = null;
      
      private var m_LoaderContext:LoaderContext = null;
      
      private var m_UncompressedImagesAccessKey:int = -2.147483648E9;
      
      public function AsyncCompressedImageCache(param1:uint = 0)
      {
         var _loc3_:LoaderPoolEntry = null;
         super();
         this.m_LoaderPool = new HeapDictionaryWrapper();
         this.m_LoaderPoolKeysLoading = new Dictionary();
         var _loc2_:uint = 0;
         while(_loc2_ < LOADER_POOL_SIZE)
         {
            _loc3_ = new LoaderPoolEntry();
            _loc3_.m_Loader = new Loader();
            _loc3_.m_Loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onUncompressImageComplete);
            _loc3_.m_Loader.contentLoaderInfo.addEventListener(AsyncErrorEvent.ASYNC_ERROR,this.onUncompressImageError);
            _loc3_.m_Loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onUncompressImageError);
            _loc3_.m_Loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onUncompressImageError);
            this.m_LoaderPool.put(_loc3_.m_Loader,_loc3_,int.MIN_VALUE);
            _loc2_++;
         }
         this.m_MaxMemory = param1;
         this.m_UncompressedImagesCollection = new HeapDictionaryWrapper();
         this.m_UncompressQueue = new HeapDictionaryWrapper();
         this.m_LoaderContext = new LoaderContext();
         this.m_LoaderContext.imageDecodingPolicy = ImageDecodingPolicy.ON_LOAD;
      }
      
      private function onUncompressImageError(param1:Event) : void
      {
         throw Error("AsyncCompressedImageCache.onGetBitmapDataError: Error while uncompressing image");
      }
      
      private function removeUncompressedBitmap(param1:Object) : void
      {
         var _loc2_:BitmapData = null;
         if(this.m_UncompressedImagesCollection.contains(param1))
         {
            _loc2_ = this.m_UncompressedImagesCollection.get(param1,this.m_UncompressedImagesAccessKey++) as BitmapData;
            this.m_MemoryUsed = this.m_MemoryUsed - this.calculateUsedMemory(_loc2_);
            this.m_UncompressedImagesCollection.remove(param1);
            _loc2_.dispose();
            _loc2_ = null;
         }
      }
      
      private function onUncompressImageComplete(param1:Event) : void
      {
         var _loc2_:LoaderInfo = null;
         var _loc3_:LoaderPoolEntry = null;
         var _loc4_:Object = null;
         _loc2_ = LoaderInfo(param1.target);
         _loc3_ = this.m_LoaderPool.get(_loc2_.loader) as LoaderPoolEntry;
         _loc4_ = _loc3_.m_CompressedImageKey;
         _loc3_.m_Busy = false;
         this.m_LoaderPool.updateHeapPriority(_loc3_.m_Loader,int.MIN_VALUE);
         delete this.m_LoaderPoolKeysLoading[_loc4_];
         var _loc5_:BitmapData = (_loc2_.content as Bitmap).bitmapData;
         this.addUncompressedBitmap(_loc4_,_loc5_);
         _loc3_.m_CompressedImageKey = null;
         var _loc6_:AsyncCompressedImageCacheEvent = new AsyncCompressedImageCacheEvent(AsyncCompressedImageCacheEvent.UNCOMPRESS,false,false,_loc4_);
         this.uncompressNextImage();
         dispatchEvent(_loc6_);
      }
      
      public function get memoryUsed() : uint
      {
         return this.m_MemoryUsed;
      }
      
      private function addUncompressRequestToQueue(param1:Object) : void
      {
         if(param1 in this.m_LoaderPoolKeysLoading || this.m_UncompressedImagesCollection.contains(param1))
         {
            return;
         }
         if(param1 in this.m_CompressedImages == false)
         {
            return;
         }
         if(this.m_UncompressQueue.contains(param1))
         {
            this.m_UncompressQueue.updateHeapPriority(param1,this.m_UncompressQueueAccessKey--);
         }
         else
         {
            this.m_UncompressQueue.put(param1,param1,this.m_UncompressQueueAccessKey--);
         }
      }
      
      public function getUncompressedImage(param1:Object) : BitmapData
      {
         var _loc2_:BitmapData = null;
         if(this.m_UncompressedImagesCollection.contains(param1))
         {
            _loc2_ = this.m_UncompressedImagesCollection.get(param1,this.m_UncompressedImagesAccessKey++) as BitmapData;
            return _loc2_;
         }
         this.addUncompressRequestToQueue(param1);
         this.uncompressNextImage();
         return null;
      }
      
      private function uncompressNextImage() : void
      {
         var _loc1_:LoaderPoolEntry = null;
         var _loc2_:Object = null;
         if(this.m_UncompressQueue.length > 0)
         {
            _loc1_ = this.m_LoaderPool.peekMinItem() as LoaderPoolEntry;
            if(_loc1_ == null)
            {
               throw new Error("AsyncCompressedImageCache.uncompressNextImage: Empty loader pool");
            }
            if(_loc1_.m_Busy == true)
            {
               return;
            }
            _loc2_ = this.getAndRemoveNewestUncompressRequestFromQueue();
            if(_loc2_ != null)
            {
               _loc1_.m_CompressedImageKey = _loc2_;
               _loc1_.m_Busy = true;
               _loc1_.m_Loader.loadBytes(this.m_CompressedImages[_loc2_],this.m_LoaderContext);
               this.m_LoaderPoolKeysLoading[_loc1_.m_CompressedImageKey] = true;
               this.m_LoaderPool.updateHeapPriority(_loc1_.m_Loader,int.MAX_VALUE);
            }
         }
      }
      
      private function addUncompressedBitmap(param1:Object, param2:BitmapData) : void
      {
         var _loc4_:Object = null;
         if(this.m_UncompressedImagesCollection.contains(param1))
         {
            this.m_UncompressedImagesCollection.remove(param1);
         }
         var _loc3_:uint = this.calculateUsedMemory(param2);
         while(this.m_MemoryUsed + _loc3_ > this.m_MaxMemory)
         {
            _loc4_ = this.m_UncompressedImagesCollection.peekMinItemKey();
            if(_loc4_ != null)
            {
               this.removeUncompressedBitmap(_loc4_);
               continue;
            }
            break;
         }
         this.m_MemoryUsed = this.m_MemoryUsed + _loc3_;
         this.m_UncompressedImagesCollection.put(param1,param2.clone(),this.m_UncompressedImagesAccessKey++);
      }
      
      public function clearCache() : void
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.m_UncompressedImagesCollection.keys)
         {
            this.removeUncompressedBitmap(_loc1_);
         }
      }
      
      public function addCompressedImage(param1:Object, param2:ByteArray) : void
      {
         if(param1 != null)
         {
            this.m_CompressedImages[param1] = param2;
            this.removeUncompressedBitmap(param1);
         }
      }
      
      private function calculateUsedMemory(param1:BitmapData) : uint
      {
         return param1.width * param1.height * (!!param1.transparent?4:3);
      }
      
      private function getAndRemoveNewestUncompressRequestFromQueue() : Object
      {
         var _loc1_:Object = this.m_UncompressQueue.peekMinItemKey();
         if(_loc1_ != null)
         {
            this.m_UncompressQueue.remove(_loc1_);
            if(this.m_UncompressQueue.length == 0)
            {
               this.m_UncompressQueueAccessKey = int.MAX_VALUE;
            }
            return _loc1_;
         }
         return null;
      }
   }
}

import flash.display.Loader;

class LoaderPoolEntry
{
    
   
   public var m_Loader:Loader = null;
   
   public var m_CompressedImageKey:Object = null;
   
   public var m_Busy:Boolean = false;
   
   function LoaderPoolEntry()
   {
      super();
   }
}
