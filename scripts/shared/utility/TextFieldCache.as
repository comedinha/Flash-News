package shared.utility
{
   import flash.filters.BitmapFilterQuality;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class TextFieldCache extends BitmapCache
   {
      
      public static const DEFAULT_HEIGHT:int = 17;
      
      public static const DEFAULT_WIDTH:int = 330;
      
      protected static var s_Matrix:Matrix = new Matrix(1,0,0,1,0,0);
       
      
      protected var m_AddEllipsis:Boolean = true;
      
      protected var m_EllipsisWidth:int = 0;
      
      protected var m_Matrix:Matrix = null;
      
      protected var m_TextField:TextField = null;
      
      public function TextFieldCache(param1:int, param2:int, param3:uint, param4:Boolean)
      {
         super(param1,param2,param3);
         this.m_TextField = new TextField();
         this.m_TextField.autoSize = TextFieldAutoSize.LEFT;
         this.m_TextField.defaultTextFormat = new TextFormat("Verdana",11,0,true);
         this.m_TextField.filters = [new GlowFilter(0,1,2,2,4,BitmapFilterQuality.LOW,false,false)];
         this.m_AddEllipsis = param4;
         this.updateEllipsis();
      }
      
      private function updateEllipsis() : void
      {
         this.m_TextField.text = "...";
         this.m_EllipsisWidth = this.m_TextField.width;
      }
      
      public function get textFormat() : TextFormat
      {
         return this.m_TextField.defaultTextFormat;
      }
      
      public function set textFormat(param1:TextFormat) : void
      {
         this.m_TextField.defaultTextFormat = param1;
         this.updateEllipsis();
      }
      
      public function get textFilters() : Array
      {
         return this.m_TextField.filters;
      }
      
      override protected function addItem(param1:Rectangle, param2:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:uint = 0;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         if(param2 != null && param2.length > 0)
         {
            _loc3_ = String(param2[0]);
            _loc4_ = uint(this.m_TextField.defaultTextFormat.color);
            _loc5_ = slotWidth;
            if(param2.length > 1)
            {
               _loc4_ = uint(param2[1]);
            }
            if(param2.length > 2)
            {
               _loc5_ = Math.max(0,Math.min(Math.floor(param2[2]),slotWidth));
            }
            this.m_TextField.textColor = _loc4_;
            this.m_TextField.text = _loc3_;
            if(this.m_TextField.width > _loc5_)
            {
               _loc6_ = 0;
               if(this.m_AddEllipsis)
               {
                  _loc6_ = this.m_TextField.getCharIndexAtPoint(_loc5_ - this.m_EllipsisWidth,this.m_TextField.height / 2);
                  this.m_TextField.text = _loc3_.substr(0,_loc6_) + "...";
               }
               else
               {
                  _loc6_ = this.m_TextField.getCharIndexAtPoint(_loc5_,this.m_TextField.height / 2);
                  this.m_TextField.text = _loc3_.substr(0,_loc6_);
               }
            }
            param1.width = this.m_TextField.width;
            param1.height = this.m_TextField.height;
            s_Matrix.tx = param1.x;
            s_Matrix.ty = param1.y;
            draw(this.m_TextField,s_Matrix,null,null,null,false);
         }
      }
      
      public function set textFilters(param1:Array) : void
      {
         this.m_TextField.filters = param1;
         this.updateEllipsis();
      }
   }
}
