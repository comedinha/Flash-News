package shared.utility
{
   import flash.utils.Dictionary;
   import flash.geom.Rectangle;
   
   public class BinPackedBitmapCache
   {
       
      
      private var m_Full:Boolean = false;
      
      private var m_Dictionary:Dictionary = null;
      
      private var m_DynamicBinPacker:shared.utility.DynamicBinPacker = null;
      
      private var m_TempBitmapPart:shared.utility.BitmapPart;
      
      private var m_StoredKeys:Vector.<Object> = null;
      
      private var m_CacheBitmapPart:shared.utility.BitmapPart;
      
      public function BinPackedBitmapCache(param1:shared.utility.BitmapPart)
      {
         this.m_CacheBitmapPart = new shared.utility.BitmapPart();
         this.m_TempBitmapPart = new shared.utility.BitmapPart();
         super();
         this.m_CacheBitmapPart = param1;
         this.m_CacheBitmapPart.setBitmapPartTo(param1.bitmapData,param1.rectangle);
         this.m_DynamicBinPacker = new shared.utility.DynamicBinPacker(param1.rectangle);
         this.m_Dictionary = new Dictionary();
         this.m_StoredKeys = new Vector.<Object>();
         this.m_Full = false;
      }
      
      public function get usedSpace() : uint
      {
         return this.m_DynamicBinPacker.usedSpace;
      }
      
      public function clear() : void
      {
         this.m_CacheBitmapPart.bitmapData.fillRect(this.m_CacheBitmapPart.rectangle,0);
         this.m_Dictionary = new Dictionary();
         this.m_StoredKeys = new Vector.<Object>();
         this.m_DynamicBinPacker.clear();
         this.m_Full = false;
      }
      
      public function get count() : uint
      {
         return this.m_StoredKeys.length;
      }
      
      public function get bitmapCache() : shared.utility.BitmapPart
      {
         return this.m_CacheBitmapPart;
      }
      
      public function put(param1:Object, param2:shared.utility.BitmapPart) : Boolean
      {
         var _loc3_:Rectangle = this.m_DynamicBinPacker.insert(param2.rectangle);
         if(_loc3_ == null)
         {
            this.m_Full = true;
            return false;
         }
         this.m_CacheBitmapPart.bitmapData.copyPixels(param2.bitmapData,param2.rectangle,_loc3_.topLeft);
         this.m_Dictionary[param1] = _loc3_;
         this.m_StoredKeys.push(param1);
         return true;
      }
      
      public function get(param1:Object, param2:shared.utility.BitmapPart = null) : shared.utility.BitmapPart
      {
         var _loc3_:Rectangle = this.m_Dictionary[param1] as Rectangle;
         if(_loc3_ != null)
         {
            if(param2 == null)
            {
               this.m_TempBitmapPart.setBitmapPartTo(this.m_CacheBitmapPart.bitmapData,_loc3_);
               return this.m_TempBitmapPart;
            }
            param2.setBitmapPartTo(this.m_CacheBitmapPart.bitmapData,_loc3_);
            return param2;
         }
         return null;
      }
      
      public function get full() : Boolean
      {
         return this.m_Full;
      }
      
      public function contains(param1:Object) : Boolean
      {
         return param1 in this.m_Dictionary;
      }
      
      public function get cachedBitmaps() : uint
      {
         return this.m_DynamicBinPacker.packedRectangles;
      }
      
      public function get fillFactor() : Number
      {
         return this.m_DynamicBinPacker.fillFactor;
      }
      
      public function get storedKeys() : Vector.<Object>
      {
         return this.m_StoredKeys;
      }
      
      public function get availableSpace() : uint
      {
         return this.m_DynamicBinPacker.availableSpace;
      }
   }
}
