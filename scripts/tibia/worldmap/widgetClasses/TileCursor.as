package tibia.worldmap.widgetClasses
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.display.BitmapData;
   import flash.geom.ColorTransform;
   
   public class TileCursor
   {
      
      protected static const s_TempPoint:Point = new Point(0,0);
      
      protected static const s_TempRect:Rectangle = new Rectangle(0,0,0,0);
       
      
      private var m_UncommittedScaleOpacity:Boolean = false;
      
      private var m_ScaleOpacity:Boolean = false;
      
      private var m_CachedOpacity:Number = NaN;
      
      private var m_Opacity:Number = 1.0;
      
      protected var m_CachedFrameSize:Rectangle = null;
      
      protected var m_CachedFrameCount:int = 0;
      
      private var m_UncommittedBitmapData:Boolean = false;
      
      private var m_BitmapData:BitmapData = null;
      
      protected var m_CachedBitmapData:BitmapData = null;
      
      private var m_FrameDuration:Number = 0.0;
      
      private var m_UncommittedOpacity:Boolean = false;
      
      public function TileCursor()
      {
         super();
      }
      
      public function set bitmapData(param1:BitmapData) : void
      {
         if(this.m_BitmapData != param1)
         {
            this.m_BitmapData = param1;
            this.m_UncommittedOpacity = true;
            this.m_UncommittedBitmapData = true;
         }
      }
      
      public function set frameDuration(param1:Number) : void
      {
         this.m_FrameDuration = param1;
      }
      
      public function set scaleOpacity(param1:Boolean) : void
      {
         if(this.m_ScaleOpacity != param1)
         {
            this.m_ScaleOpacity = param1;
            this.m_UncommittedOpacity = true;
            this.m_UncommittedScaleOpacity = true;
         }
      }
      
      protected function commitProperties() : void
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Vector.<uint> = null;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:ColorTransform = null;
         var _loc6_:Rectangle = null;
         if(this.m_UncommittedBitmapData)
         {
            if(this.m_BitmapData != null)
            {
               if(this.m_BitmapData.width % this.m_BitmapData.height == 0)
               {
                  this.m_CachedFrameCount = this.m_BitmapData.width / this.m_BitmapData.height;
                  this.m_CachedFrameSize = new Rectangle(0,0,this.m_BitmapData.height,this.m_BitmapData.height);
               }
               else
               {
                  this.m_CachedFrameCount = 1;
                  this.m_CachedFrameSize = new Rectangle(0,0,this.m_BitmapData.width,this.m_BitmapData.height);
               }
               this.m_CachedOpacity = 0;
               _loc1_ = new Rectangle(0,0,this.m_BitmapData.width,this.m_BitmapData.height);
               _loc2_ = this.m_BitmapData.getVector(_loc1_);
               for each(_loc3_ in _loc2_)
               {
                  this.m_CachedOpacity = Math.max(this.m_CachedOpacity,_loc3_ >>> 24);
               }
               this.m_CachedOpacity = this.m_CachedOpacity / 255;
            }
            else
            {
               this.m_CachedFrameCount = 0;
               this.m_CachedFrameSize = null;
               this.m_CachedOpacity = NaN;
            }
            this.m_UncommittedBitmapData = false;
         }
         if(this.m_UncommittedOpacity || this.m_UncommittedScaleOpacity)
         {
            if(this.m_BitmapData != null)
            {
               this.m_CachedBitmapData = this.m_BitmapData.clone();
               if(this.m_CachedOpacity > 0)
               {
                  _loc4_ = !!this.m_ScaleOpacity?Number(this.m_Opacity / this.m_CachedOpacity):Number(this.m_Opacity);
                  _loc5_ = new ColorTransform(1,1,1,_loc4_);
                  _loc6_ = new Rectangle(0,0,this.m_CachedBitmapData.width,this.m_CachedBitmapData.height);
                  this.m_CachedBitmapData.colorTransform(_loc6_,_loc5_);
               }
            }
            else
            {
               this.m_CachedBitmapData = null;
            }
            this.m_UncommittedScaleOpacity = false;
            this.m_UncommittedOpacity = false;
         }
      }
      
      public function get opacity() : Number
      {
         return this.m_Opacity;
      }
      
      protected function getFrameIndex(param1:Number) : int
      {
         if(!isNaN(param1) && !isNaN(this.m_FrameDuration) && this.m_FrameDuration > 0 && this.m_CachedFrameCount > 0)
         {
            return int(param1 / this.m_FrameDuration) % this.m_CachedFrameCount;
         }
         return 0;
      }
      
      public function drawTo(param1:BitmapData, param2:Number, param3:Number, param4:Number = NaN) : void
      {
         this.commitProperties();
         s_TempRect.setTo(this.getFrameIndex(param4) * this.m_CachedFrameSize.width,0,this.m_CachedFrameSize.width,this.m_CachedFrameSize.height);
         s_TempPoint.setTo(param2 - this.m_CachedFrameSize.width,param3 - this.m_CachedFrameSize.height);
         param1.copyPixels(this.m_CachedBitmapData,s_TempRect,s_TempPoint,null,null,true);
      }
      
      public function get frameDuration() : Number
      {
         return this.m_FrameDuration;
      }
      
      public function set opacity(param1:Number) : void
      {
         param1 = Math.max(0,Math.min(param1,1));
         if(this.m_Opacity != param1)
         {
            this.m_Opacity = param1;
            this.m_UncommittedOpacity = true;
         }
      }
      
      public function get scaleOpacity() : Boolean
      {
         return this.m_ScaleOpacity;
      }
      
      public function get bitmapData() : BitmapData
      {
         return this.m_BitmapData;
      }
   }
}
