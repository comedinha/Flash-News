package shared.utility
{
   import flash.geom.Rectangle;
   
   public class DynamicBinPacker
   {
       
      
      private var m_PackedRectangles:uint = 0;
      
      private var m_AvailableSpace:uint = 0;
      
      private var m_RootNode:DynamicBinPackerNode = null;
      
      private var m_UsedSpace:uint = 0;
      
      private var m_Rectangle:Rectangle = null;
      
      public function DynamicBinPacker(param1:Rectangle)
      {
         super();
         if(param1 == null || param1.width == 0 || param1.height == 0)
         {
            throw new ArgumentError("DynamicBinPacker.DynamicBinPacker: Invalid rectangle");
         }
         this.m_Rectangle = param1.clone();
         this.m_RootNode = new DynamicBinPackerNode(this.m_Rectangle);
         this.m_AvailableSpace = this.m_Rectangle.width * this.m_Rectangle.height;
      }
      
      public function get packedRectangles() : uint
      {
         return this.m_PackedRectangles;
      }
      
      public function get availableSpace() : uint
      {
         return this.m_AvailableSpace;
      }
      
      public function get splitRectangles() : Vector.<Rectangle>
      {
         var _loc1_:Vector.<Rectangle> = new Vector.<Rectangle>();
         this.m_RootNode.getRectangles(_loc1_);
         return _loc1_;
      }
      
      public function get usedSpace() : uint
      {
         return this.m_UsedSpace;
      }
      
      public function clear() : void
      {
         this.m_RootNode.m_Childs[0] = null;
         this.m_RootNode.m_Childs[1] = null;
         this.m_RootNode.m_Filled = false;
         this.m_UsedSpace = 0;
         this.m_PackedRectangles = 0;
      }
      
      public function get fillFactor() : Number
      {
         return this.m_UsedSpace / this.m_AvailableSpace;
      }
      
      public function insert(param1:Rectangle) : Rectangle
      {
         var _loc2_:DynamicBinPackerNode = this.m_RootNode.insert(param1);
         if(_loc2_ != null)
         {
            this.m_UsedSpace = this.m_UsedSpace + _loc2_.m_Rectangle.width * _loc2_.m_Rectangle.height;
            this.m_PackedRectangles++;
            return _loc2_.m_Rectangle;
         }
         return null;
      }
   }
}

import flash.geom.Rectangle;

class DynamicBinPackerNode
{
    
   
   public var m_Filled:Boolean = false;
   
   public var m_Childs:Vector.<DynamicBinPackerNode>;
   
   public var m_Rectangle:Rectangle = null;
   
   function DynamicBinPackerNode(param1:Rectangle)
   {
      this.m_Childs = new Vector.<DynamicBinPackerNode>(2,true);
      super();
      this.m_Rectangle = param1;
   }
   
   public function insert(param1:Rectangle) : DynamicBinPackerNode
   {
      var _loc3_:DynamicBinPackerNode = null;
      var _loc4_:uint = 0;
      var _loc5_:uint = 0;
      var _loc6_:Rectangle = null;
      var _loc2_:DynamicBinPackerNode = null;
      if(this.m_Childs[0] != null && this.m_Childs[1] != null)
      {
         for each(_loc3_ in this.m_Childs)
         {
            if(_loc3_.m_Filled == false && _loc3_.m_Rectangle.width >= param1.width && _loc3_.m_Rectangle.height >= param1.height)
            {
               _loc2_ = _loc3_.insert(param1);
               if(_loc2_ != null)
               {
                  break;
               }
            }
         }
         if(this.m_Childs[0].m_Filled && this.m_Childs[1].m_Filled)
         {
            this.m_Filled = true;
         }
         return _loc2_;
      }
      if(this.m_Filled)
      {
         return null;
      }
      if(param1.width > this.m_Rectangle.width || param1.height > this.m_Rectangle.height)
      {
         return null;
      }
      if(this.m_Rectangle.width == param1.width && this.m_Rectangle.height == param1.height)
      {
         this.m_Filled = true;
         return this;
      }
      _loc4_ = this.m_Rectangle.width - param1.width;
      _loc5_ = this.m_Rectangle.height - param1.height;
      _loc6_ = new Rectangle();
      if(_loc4_ > _loc5_)
      {
         this.m_Childs[0] = new DynamicBinPackerNode(new Rectangle(this.m_Rectangle.left,this.m_Rectangle.top,param1.width,this.m_Rectangle.height));
         this.m_Childs[1] = new DynamicBinPackerNode(new Rectangle(this.m_Rectangle.left + param1.width,this.m_Rectangle.top,this.m_Rectangle.width - param1.width,this.m_Rectangle.height));
      }
      else
      {
         this.m_Childs[0] = new DynamicBinPackerNode(new Rectangle(this.m_Rectangle.left,this.m_Rectangle.top,this.m_Rectangle.width,param1.height));
         this.m_Childs[1] = new DynamicBinPackerNode(new Rectangle(this.m_Rectangle.left,this.m_Rectangle.top + param1.height,this.m_Rectangle.width,this.m_Rectangle.height - param1.height));
      }
      return this.m_Childs[0].insert(param1);
   }
   
   public function getRectangles(param1:Vector.<Rectangle>) : void
   {
      if(this.m_Childs[0] != null)
      {
         param1.push(this.m_Childs[0].m_Rectangle);
         this.m_Childs[0].getRectangles(param1);
      }
      if(this.m_Childs[1] != null)
      {
         param1.push(this.m_Childs[1].m_Rectangle);
         this.m_Childs[1].getRectangles(param1);
      }
   }
}
