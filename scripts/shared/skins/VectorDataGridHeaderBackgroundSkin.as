package shared.skins
{
   import mx.skins.ProgrammaticSkin;
   import mx.core.UIComponent;
   
   public class VectorDataGridHeaderBackgroundSkin extends ProgrammaticSkin
   {
       
      
      public function VectorDataGridHeaderBackgroundSkin()
      {
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
      }
      
      override public function get measuredHeight() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         var _loc5_:Number = 0;
         graphics.clear();
         if(getStyle("borderColor") !== undefined)
         {
            _loc3_ = getStyle("borderColor");
            _loc4_ = getStyle("borderAlpha");
            _loc5_ = getStyle("borderThickness");
            graphics.lineStyle(_loc5_,_loc3_,_loc4_);
            graphics.moveTo(0,param2 - _loc5_);
            graphics.lineTo(param1 - _loc5_,param2 - _loc5_);
            graphics.lineStyle(NaN,0,NaN);
         }
         if(getStyle("backgroundColor") !== undefined)
         {
            _loc3_ = getStyle("backgroundColor");
            _loc4_ = getStyle("backgroundAlpha");
            graphics.beginFill(_loc3_,_loc4_);
            graphics.drawRect(0,0,param1,param2 - _loc5_);
            graphics.endFill();
         }
      }
   }
}
