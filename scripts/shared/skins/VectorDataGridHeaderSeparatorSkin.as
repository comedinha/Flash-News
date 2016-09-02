package shared.skins
{
   import mx.skins.ProgrammaticSkin;
   import mx.core.UIComponent;
   
   public class VectorDataGridHeaderSeparatorSkin extends ProgrammaticSkin
   {
       
      
      public function VectorDataGridHeaderSeparatorSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return 1 + getStyle("borderThickness");
      }
      
      override public function get measuredHeight() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         graphics.clear();
         if(getStyle("borderColor") !== undefined)
         {
            _loc3_ = getStyle("borderColor");
            _loc4_ = getStyle("borderAlpha");
            _loc5_ = getStyle("borderThickness");
            graphics.lineStyle(_loc5_,_loc3_,_loc4_);
            graphics.moveTo(param1 - _loc5_,0);
            graphics.lineTo(param1 - _loc5_,param2 - _loc5_);
            graphics.lineStyle(NaN,0,NaN);
         }
      }
   }
}
