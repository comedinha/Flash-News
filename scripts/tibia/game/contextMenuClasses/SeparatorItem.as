package tibia.game.contextMenuClasses
{
   import mx.core.UIComponent;
   
   public class SeparatorItem extends UIComponent implements IContextMenuItem
   {
       
      
      public function SeparatorItem()
      {
         super();
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:Number = getStyle("separatorHeight");
         measuredMinHeight = _loc1_;
         measuredHeight = _loc1_;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         graphics.clear();
         graphics.lineStyle(1,getStyle("separatorColor"),getStyle("separatorAlpha"));
         var _loc3_:Number = param1 * (1 - getStyle("separatorWidth")) / 2;
         var _loc4_:Number = param2 / 2;
         graphics.moveTo(_loc3_,_loc4_);
         graphics.lineTo(param1 - _loc3_,_loc4_);
      }
   }
}
