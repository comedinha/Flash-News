package shared.utility
{
   import shared.§utility:ns_extent_cache_internal§.CHUNK_BITS;
   import shared.§utility:ns_extent_cache_internal§.CHUNK_MASK;
   import shared.§utility:ns_extent_cache_internal§.CHUNK_SIZE;
   
   public class ExtentCache
   {
      
      static const CHUNK_SIZE:int = 1 << CHUNK_BITS;
      
      static const CHUNK_BITS:int = 8;
      
      static const CHUNK_MASK:int = 1 << CHUNK_BITS - 1;
       
      
      protected var m_Width:Number = 0;
      
      protected var m_Length:int = 0;
      
      protected var m_Chunks:Array = null;
      
      protected var m_Gap:Number = 0;
      
      protected var m_DefaultSize:Number = NaN;
      
      public function ExtentCache(param1:Number = 0)
      {
         super();
         if(isNaN(param1))
         {
            throw new ArgumentError("ExtentCache.ExtentCache: Invalid default size.");
         }
         this.m_Chunks = new Array();
         this.m_DefaultSize = param1;
      }
      
      public function topToIndex(param1:Number, param2:Boolean = true) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Chunk = null;
         if(param1 <= 0)
         {
            return 0;
         }
         var _loc8_:Number = !!param2?Number(this.m_Gap):Number(0);
         var _loc9_:Number = !!param2?Number(this.m_Gap * CHUNK_SIZE):Number(0);
         while(_loc5_ <= param1 && _loc3_ < this.m_Chunks.length)
         {
            _loc7_ = this.m_Chunks[_loc3_];
            if(_loc7_ != null)
            {
               _loc6_ = _loc9_ + _loc7_.m_Sum + _loc7_.m_NaN * this.m_DefaultSize;
            }
            else
            {
               _loc6_ = _loc9_ + CHUNK_SIZE * this.m_DefaultSize;
            }
            if(_loc5_ + _loc6_ <= param1)
            {
               _loc5_ = _loc5_ + _loc6_;
               _loc3_++;
               continue;
            }
            break;
         }
         _loc7_ = this.m_Chunks[_loc3_];
         if(_loc7_ != null)
         {
            while(_loc5_ <= param1 && _loc4_ < CHUNK_SIZE)
            {
               if(!isNaN(_loc7_.m_Items[_loc4_]))
               {
                  _loc6_ = _loc8_ + _loc7_.m_Items[_loc4_];
               }
               else
               {
                  _loc6_ = _loc8_ + this.m_DefaultSize;
               }
               if(_loc5_ + _loc6_ <= param1)
               {
                  _loc5_ = _loc5_ + _loc6_;
                  _loc4_++;
                  continue;
               }
               break;
            }
         }
         else
         {
            _loc6_ = this.m_DefaultSize + (!!param2?_loc8_:0);
            _loc4_ = Math.floor((param1 - _loc5_) / _loc6_);
         }
         return (_loc3_ << CHUNK_BITS) + _loc4_;
      }
      
      public function set defaultSize(param1:Number) : void
      {
         this.m_DefaultSize = param1;
      }
      
      public function get width() : Number
      {
         return this.m_Width;
      }
      
      public function removeItemAt(param1:int) : Number
      {
         var _loc7_:Chunk = null;
         if(param1 < 0)
         {
            throw new RangeError("ExtentCache.removeItemAt: Index is out of range.");
         }
         var _loc2_:Number = this.getItemAt(param1);
         var _loc3_:* = param1 >> CHUNK_BITS;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = this.m_Chunks.length - 1;
         while(_loc6_ >= _loc3_)
         {
            if(this.m_Chunks[_loc6_] == null)
            {
               _loc5_ = NaN;
            }
            else
            {
               _loc4_ = _loc6_ == _loc3_?param1 & CHUNK_MASK:0;
               _loc5_ = this.m_Chunks[_loc6_].shiftLeft(_loc5_,_loc4_);
            }
            _loc6_--;
         }
         while(this.m_Chunks.length > 0)
         {
            _loc7_ = this.m_Chunks[this.m_Chunks.length - 1];
            if(_loc7_ == null || _loc7_.m_NaN == CHUNK_SIZE)
            {
               this.m_Chunks.pop();
               continue;
            }
            break;
         }
         this.m_Length--;
         return _loc2_;
      }
      
      public function set width(param1:Number) : void
      {
         this.m_Width = param1;
      }
      
      public function reset() : void
      {
         this.m_Chunks.length = 0;
         this.m_Length = 0;
         this.m_Width = 0;
      }
      
      public function top(param1:int, param2:Boolean = true) : Number
      {
         if(param1 < 0)
         {
            throw new RangeError("ExtentCache.top: Index is out of range.");
         }
         var _loc3_:Number = 0;
         var _loc4_:* = param1 >> CHUNK_BITS;
         var _loc5_:* = param1 & CHUNK_MASK;
         var _loc6_:Chunk = null;
         var _loc7_:int = 0;
         var _loc8_:Number = !!param2?Number(this.m_Gap):Number(0);
         var _loc9_:Number = !!param2?Number(this.m_Gap * CHUNK_SIZE):Number(0);
         _loc7_ = 0;
         while(_loc7_ < _loc4_)
         {
            _loc3_ = _loc3_ + _loc9_;
            _loc6_ = this.m_Chunks[_loc7_];
            if(_loc6_ != null)
            {
               _loc3_ = _loc3_ + (_loc6_.m_Sum + _loc6_.m_NaN * this.m_DefaultSize);
            }
            else
            {
               _loc3_ = _loc3_ + CHUNK_SIZE * this.m_DefaultSize;
            }
            _loc7_++;
         }
         _loc6_ = this.m_Chunks[_loc4_];
         if(_loc6_ != null)
         {
            _loc7_ = 0;
            while(_loc7_ < _loc5_)
            {
               _loc3_ = _loc3_ + _loc8_;
               _loc3_ = _loc3_ + (!isNaN(_loc6_.m_Items[_loc7_])?_loc6_.m_Items[_loc7_]:this.m_DefaultSize);
               _loc7_++;
            }
         }
         else
         {
            _loc3_ = _loc3_ + _loc5_ * (_loc8_ + this.m_DefaultSize);
         }
         return _loc3_;
      }
      
      public function updateItemAt(param1:Number, param2:int) : Number
      {
         var _loc5_:Chunk = null;
         if(param2 < 0)
         {
            throw new RangeError("ExtentCache.updateItemAt: Index is out of range.");
         }
         var _loc3_:* = param2 >> CHUNK_BITS;
         var _loc4_:* = param2 & CHUNK_MASK;
         this.m_Length = Math.max(this.m_Length,param2 + 1);
         if(this.m_Chunks[_loc3_] == null)
         {
            _loc5_ = new Chunk();
            _loc5_.update(param1,_loc4_);
            this.m_Chunks[_loc3_] = _loc5_;
            return NaN;
         }
         return this.m_Chunks[_loc3_].update(param1,_loc4_);
      }
      
      public function getItemAt(param1:int) : Number
      {
         var _loc4_:Number = NaN;
         if(param1 < 0)
         {
            throw new RangeError("ExtentCache.getItemAt: Index is out of range.");
         }
         var _loc2_:* = param1 >> CHUNK_BITS;
         var _loc3_:* = param1 & CHUNK_MASK;
         if(this.m_Chunks[_loc2_] == null)
         {
            return this.m_DefaultSize;
         }
         _loc4_ = this.m_Chunks[_loc2_].m_Items[_loc3_];
         return !!isNaN(_loc4_)?Number(this.m_DefaultSize):Number(_loc4_);
      }
      
      public function get gap() : Number
      {
         return this.m_Gap;
      }
      
      public function get defaultSize() : Number
      {
         return this.m_DefaultSize;
      }
      
      public function get length() : int
      {
         return this.m_Length;
      }
      
      public function addItemAt(param1:Number, param2:int) : void
      {
         var _loc7_:Chunk = null;
         if(param2 < 0)
         {
            throw new RangeError("ExtentCache.addItemAt: Index is out of range.");
         }
         var _loc3_:* = param2 >> CHUNK_BITS;
         var _loc4_:* = param2 & CHUNK_MASK;
         while(_loc3_ >= this.m_Chunks.length)
         {
            this.m_Chunks.push(new Chunk());
         }
         var _loc5_:Number = param1;
         var _loc6_:int = _loc3_;
         while(_loc6_ < this.m_Chunks.length)
         {
            _loc5_ = this.m_Chunks[_loc6_].shiftRight(_loc5_,_loc4_);
            _loc4_ = 0;
            _loc6_++;
         }
         if(!isNaN(_loc5_))
         {
            _loc7_ = new Chunk();
            _loc7_.shiftRight(_loc5_,0);
            this.m_Chunks.push(_loc7_);
         }
         this.m_Length = Math.max(this.m_Length,param2) + 1;
      }
      
      public function bottom(param1:int, param2:Boolean = true) : Number
      {
         if(param1 < 0)
         {
            throw new RangeError("ExtentCache.bottom: Index is out of range.");
         }
         return this.top(param1,param2) + this.getItemAt(param1);
      }
      
      public function set gap(param1:Number) : void
      {
         this.m_Gap = param1;
      }
   }
}

import shared.utility.ExtentCache;
import shared.§utility:ns_extent_cache_internal§.*;

class Chunk
{
   
   protected static const CHUNK_SIZE:int = ExtentCache.CHUNK_SIZE;
    
   
   var m_Sum:Number = NaN;
   
   var m_NaN:int = 0;
   
   var m_Items:Vector.<Number> = null;
   
   function Chunk()
   {
      super();
      this.m_Sum = 0;
      this.m_NaN = CHUNK_SIZE;
      this.m_Items = new Vector.<Number>(CHUNK_SIZE,true);
      var _loc1_:int = 0;
      while(_loc1_ < CHUNK_SIZE)
      {
         this.m_Items[_loc1_] = NaN;
         _loc1_++;
      }
   }
   
   public function shiftLeft(param1:Number, param2:int = 0) : Number
   {
      if(param2 < 0 || param2 >= CHUNK_SIZE)
      {
         throw new RangeError("Chunk.shiftLeft: Index is out of range.");
      }
      var _loc3_:Number = this.m_Items[param2];
      if(!isNaN(_loc3_))
      {
         this.m_Sum = this.m_Sum - _loc3_;
         this.m_NaN++;
      }
      if(!isNaN(param1))
      {
         this.m_Sum = this.m_Sum + param1;
         this.m_NaN--;
      }
      var _loc4_:int = CHUNK_SIZE - 1;
      var _loc5_:int = param2;
      while(_loc5_ < _loc4_)
      {
         this.m_Items[_loc5_] = this.m_Items[_loc5_ + 1];
         _loc5_++;
      }
      this.m_Items[_loc4_] = param1;
      return _loc3_;
   }
   
   public function shiftRight(param1:Number, param2:int = 0) : Number
   {
      if(param2 < 0 || param2 >= CHUNK_SIZE)
      {
         throw new RangeError("Chunk.shiftRight: Index is out of range.");
      }
      var _loc3_:Number = this.m_Items[CHUNK_SIZE - 1];
      if(!isNaN(_loc3_))
      {
         this.m_Sum = this.m_Sum - _loc3_;
         this.m_NaN++;
      }
      if(!isNaN(param1))
      {
         this.m_Sum = this.m_Sum + param1;
         this.m_NaN--;
      }
      var _loc4_:int = CHUNK_SIZE - 1;
      while(_loc4_ > param2)
      {
         this.m_Items[_loc4_] = this.m_Items[_loc4_ - 1];
         _loc4_--;
      }
      this.m_Items[param2] = param1;
      return _loc3_;
   }
   
   public function update(param1:Number, param2:int) : Number
   {
      if(param2 < 0 || param2 >= CHUNK_SIZE)
      {
         throw new RangeError("Chunk.update: Index is out of range.");
      }
      var _loc3_:Number = this.m_Items[param2];
      if(param1 == _loc3_)
      {
         return _loc3_;
      }
      if(!isNaN(_loc3_))
      {
         this.m_Sum = this.m_Sum - _loc3_;
         this.m_NaN++;
      }
      if(!isNaN(param1))
      {
         this.m_Sum = this.m_Sum + param1;
         this.m_NaN--;
      }
      this.m_Items[param2] = param1;
      return _loc3_;
   }
}
