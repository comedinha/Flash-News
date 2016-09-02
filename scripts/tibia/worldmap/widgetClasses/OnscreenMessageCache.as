package tibia.worldmap.widgetClasses
{
   import shared.utility.BitmapCache;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.filters.GlowFilter;
   import flash.filters.BitmapFilterQuality;
   
   public class OnscreenMessageCache extends BitmapCache
   {
      
      private static var s_Matrix:Matrix = new Matrix(1,0,0,1,0,0);
       
      
      private var m_TextField:TextField = null;
      
      public function OnscreenMessageCache(param1:Number, param2:Number, param3:uint)
      {
         super(param1,param2,param3);
         this.m_TextField = new TextField();
         this.m_TextField.autoSize = TextFieldAutoSize.LEFT;
         this.m_TextField.height = slotHeight - 2;
         this.m_TextField.defaultTextFormat = new TextFormat("Verdana",11,0,true);
         this.m_TextField.filters = [new GlowFilter(0,1,2,2,4,BitmapFilterQuality.LOW,false,false)];
         this.m_TextField.width = slotWidth - 2;
         this.m_TextField.wordWrap = true;
      }
      
      override protected function addItem(param1:Rectangle, param2:Array) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(param2 != null && param2.length == 1)
         {
            this.m_TextField.htmlText = param2[0] as String;
            _loc3_ = Math.min(slotHeight,this.m_TextField.textHeight + 2);
            _loc4_ = Math.min(slotWidth,this.m_TextField.textWidth + 2);
            param1.height = _loc3_;
            param1.width = _loc4_;
            s_Matrix.tx = param1.x - Math.floor((slotWidth - _loc4_) / 2);
            s_Matrix.ty = param1.y - 2;
            draw(this.m_TextField,s_Matrix,null,null,null,false);
         }
      }
   }
}
