package shared.utility
{
   import flash.utils.Dictionary;
   
   public class PagedBitmapCache
   {
       
      
      private var m_UncomittedFillFactor:Boolean = true;
      
      private var m_CurrentBufferCachePage:CachePage = null;
      
      private var m_CurrentAccessKey:uint = 0;
      
      private var m_PagesCount:uint = 0;
      
      private var m_FilledPagesCount:uint = 0;
      
      private var m_CurrentInvalidCachePage:CachePage = null;
      
      private var m_KeyToCachePageInformation:Dictionary = null;
      
      private var m_FillFactor:Number = 0;
      
      private var m_CachePages:Vector.<CachePage> = null;
      
      private var m_CachedBitmaps:uint = 0;
      
      public function PagedBitmapCache(param1:Vector.<BitmapPart>)
      {
         var _loc3_:CachePage = null;
         super();
         if(param1 == null || param1.length < 2)
         {
            throw new ArgumentError("PagedBitmapCache.PagedBitmapCache: cache pages vector must not be null and contain at least two pages");
         }
         this.m_CachePages = new Vector.<CachePage>(param1.length,true);
         this.m_KeyToCachePageInformation = new Dictionary();
         this.m_PagesCount = this.m_CachePages.length;
         var _loc2_:uint = 0;
         while(_loc2_ < this.m_PagesCount)
         {
            _loc3_ = new CachePage();
            _loc3_.m_BitmapCache = new BinPackedBitmapCache(param1[_loc2_]);
            this.m_CachePages[_loc2_] = _loc3_;
            _loc2_++;
         }
         this.m_CurrentBufferCachePage = this.m_CachePages[0];
         this.m_CurrentInvalidCachePage = null;
      }
      
      public function get invalidCachePage() : BitmapPart
      {
         if(this.m_CurrentInvalidCachePage != null)
         {
            return this.m_CurrentInvalidCachePage.m_BitmapCache.bitmapCache;
         }
         return null;
      }
      
      private function calculateUsedSpace() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:CachePage = null;
         if(this.m_UncomittedFillFactor == true)
         {
            this.m_UncomittedFillFactor = false;
            _loc1_ = 0;
            _loc2_ = 0;
            _loc3_ = 0;
            _loc4_ = 0;
            while(_loc4_ < this.m_PagesCount)
            {
               _loc5_ = this.m_CachePages[_loc4_];
               if(_loc5_ != this.m_CurrentInvalidCachePage)
               {
                  _loc1_ = _loc1_ + _loc5_.m_BitmapCache.availableSpace;
                  _loc2_ = _loc2_ + _loc5_.m_BitmapCache.usedSpace;
                  _loc3_ = _loc3_ + _loc5_.m_BitmapCache.cachedBitmaps;
               }
               _loc4_++;
            }
            this.m_FillFactor = _loc2_ / _loc1_;
            this.m_CachedBitmaps = _loc3_;
         }
      }
      
      public function put(param1:Object, param2:BitmapPart) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:uint = 0;
         while(_loc3_ == false && _loc4_ < this.m_PagesCount)
         {
            if(this.m_CurrentBufferCachePage.m_BitmapCache.put(param1,param2) == true)
            {
               this.m_KeyToCachePageInformation[param1] = this.m_CurrentBufferCachePage;
               this.m_CurrentBufferCachePage.m_LastAccessKey = this.m_CurrentAccessKey++;
               _loc3_ = true;
               this.onBitmapAdded(param1);
            }
            else
            {
               _loc4_++;
               this.setNewBufferCachePage();
            }
         }
         return _loc3_;
      }
      
      private function getMinValidCachePage() : CachePage
      {
         var _loc3_:CachePage = null;
         var _loc1_:CachePage = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.m_PagesCount)
         {
            _loc3_ = this.m_CachePages[_loc2_];
            if(_loc3_.m_Valid && (_loc1_ == null || _loc3_.m_LastAccessKey < _loc1_.m_LastAccessKey))
            {
               _loc1_ = _loc3_;
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      protected function onBitmapRemoved(param1:Object) : void
      {
         this.m_UncomittedFillFactor = true;
      }
      
      private function setNewBufferCachePage() : void
      {
         var _loc1_:Vector.<Object> = null;
         var _loc2_:uint = 0;
         var _loc3_:uint = 0;
         var _loc4_:CachePage = null;
         var _loc5_:Object = null;
         var _loc6_:CachePage = null;
         if(this.m_CurrentBufferCachePage.m_BitmapCache.full)
         {
            if(this.m_FilledPagesCount >= this.m_PagesCount - 2)
            {
               if(this.m_CurrentInvalidCachePage != null)
               {
                  _loc1_ = this.m_CurrentInvalidCachePage.m_BitmapCache.storedKeys;
                  _loc2_ = _loc1_.length;
                  while(_loc3_ < _loc2_)
                  {
                     _loc5_ = _loc1_[_loc3_] as Object;
                     _loc6_ = this.m_KeyToCachePageInformation[_loc5_] as CachePage;
                     if(_loc6_ != null && _loc6_ == this.m_CurrentInvalidCachePage)
                     {
                        delete this.m_KeyToCachePageInformation[_loc5_];
                        this.onBitmapRemoved(_loc5_);
                     }
                     _loc3_++;
                  }
                  this.m_CurrentInvalidCachePage.m_BitmapCache.clear();
                  _loc4_ = this.getMinValidCachePage();
                  this.markCachePageAsInvalid(_loc4_);
                  this.m_CurrentInvalidCachePage.m_LastAccessKey = uint.MIN_VALUE;
                  this.m_CurrentInvalidCachePage.m_Valid = true;
                  this.m_CurrentBufferCachePage = this.m_CurrentInvalidCachePage;
                  this.m_CurrentInvalidCachePage = _loc4_;
               }
               else
               {
                  this.m_CurrentBufferCachePage = this.getMinValidCachePage();
                  this.m_CurrentBufferCachePage.m_LastAccessKey = int.MAX_VALUE;
                  this.m_CurrentInvalidCachePage = this.getMinValidCachePage();
                  this.markCachePageAsInvalid(this.m_CurrentInvalidCachePage);
               }
            }
            else
            {
               this.m_CurrentBufferCachePage = this.getMinValidCachePage();
               this.m_FilledPagesCount++;
            }
            if(this.m_CurrentInvalidCachePage != null && this.m_CurrentBufferCachePage == this.m_CurrentInvalidCachePage)
            {
               throw new Error("PagedBitmapCache.setNewCachePageIndices: Current buffer cache page can\'t be the same as the current invalid cache page.");
            }
         }
      }
      
      public function get(param1:Object, param2:BitmapPart = null) : BitmapPart
      {
         var _loc4_:BitmapPart = null;
         var _loc5_:Boolean = false;
         var _loc3_:CachePage = this.m_KeyToCachePageInformation[param1] as CachePage;
         if(_loc3_ !== null)
         {
            _loc4_ = _loc3_.m_BitmapCache.get(param1,param2);
            if(this.m_CurrentInvalidCachePage != null && _loc3_ == this.m_CurrentInvalidCachePage)
            {
               _loc5_ = this.m_CurrentBufferCachePage.m_BitmapCache.put(param1,_loc4_);
               if(_loc5_ == false)
               {
                  this.setNewBufferCachePage();
                  return null;
               }
               this.m_KeyToCachePageInformation[param1] = this.m_CurrentBufferCachePage;
               this.onBitmapPositionChanged(param1);
               return this.get(param1,param2);
            }
            _loc3_.m_LastAccessKey = this.m_CurrentAccessKey++;
            return _loc4_;
         }
         return null;
      }
      
      public function get currentBufferCachePage() : BitmapPart
      {
         return this.m_CurrentBufferCachePage.m_BitmapCache.bitmapCache;
      }
      
      public function get cachedBitmaps() : uint
      {
         this.calculateUsedSpace();
         return this.m_CachedBitmaps;
      }
      
      protected function deprecateBitmap(param1:Object) : void
      {
         this.m_UncomittedFillFactor = true;
      }
      
      protected function onBitmapAdded(param1:Object) : void
      {
         this.m_UncomittedFillFactor = true;
      }
      
      public function get fillFactor() : Number
      {
         this.calculateUsedSpace();
         return this.m_FillFactor;
      }
      
      private function markCachePageAsInvalid(param1:CachePage) : void
      {
         var _loc2_:Vector.<Object> = null;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc5_:Object = null;
         if(param1.m_Valid == true)
         {
            param1.m_Valid = false;
            _loc2_ = param1.m_BitmapCache.storedKeys;
            _loc3_ = _loc2_.length;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_[_loc4_] as Object;
               this.deprecateBitmap(_loc5_);
               _loc4_++;
            }
         }
      }
      
      protected function onBitmapPositionChanged(param1:Object) : void
      {
         this.m_UncomittedFillFactor = true;
      }
   }
}

import shared.utility.BinPackedBitmapCache;

class CachePage
{
    
   
   public var m_BitmapCache:BinPackedBitmapCache = null;
   
   public var m_LastAccessKey:uint = 0;
   
   public var m_Valid:Boolean = true;
   
   function CachePage()
   {
      super();
   }
}
