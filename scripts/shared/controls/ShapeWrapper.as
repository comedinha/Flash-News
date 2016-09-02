package shared.controls
{
   import mx.core.UIComponent;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   
   public class ShapeWrapper extends UIComponent
   {
       
      
      public function ShapeWrapper()
      {
         super();
      }
      
      override public function removeChildren(param1:int = 0, param2:int = 2.147483647E9) : void
      {
         invalidateDisplayList();
         invalidateSize();
         super.removeChildren(param1,param2);
      }
      
      override public function addChildAt(param1:DisplayObject, param2:int) : DisplayObject
      {
         invalidateDisplayList();
         invalidateSize();
         return super.addChildAt(param1,param2);
      }
      
      override public function removeChildAt(param1:int) : DisplayObject
      {
         invalidateDisplayList();
         invalidateSize();
         return super.removeChildAt(param1);
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc6_:DisplayObject = null;
         var _loc7_:Rectangle = null;
         super.updateDisplayList(param1,param2);
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         switch(getStyle("horizontalAlign"))
         {
            case "left":
               _loc3_ = 0;
               break;
            case "center":
               _loc3_ = 1;
               break;
            case "right":
               _loc3_ = 2;
               break;
            default:
               _loc3_ = 0;
         }
         switch(getStyle("verticalAlign"))
         {
            case "top":
               _loc4_ = 0;
               break;
            case "middle":
               _loc4_ = 1;
               break;
            case "bottom":
               _loc4_ = 2;
               break;
            default:
               _loc4_ = 0;
         }
         var _loc5_:int = numChildren - 1;
         while(_loc5_ >= 0)
         {
            _loc6_ = getChildAt(_loc5_);
            _loc7_ = _loc6_.getRect(_loc6_);
            _loc6_.x = _loc3_ * (param1 - _loc7_.width) / 2;
            _loc6_.y = _loc4_ * (param2 - _loc7_.height) / 2;
            _loc5_--;
         }
      }
      
      override public function removeChild(param1:DisplayObject) : DisplayObject
      {
         invalidateDisplayList();
         invalidateSize();
         return super.removeChild(param1);
      }
      
      override public function addChild(param1:DisplayObject) : DisplayObject
      {
         invalidateDisplayList();
         invalidateSize();
         return super.addChild(param1);
      }
      
      override protected function measure() : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Rectangle = null;
         super.measure();
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:int = numChildren - 1;
         while(_loc3_ >= 0)
         {
            _loc4_ = getChildAt(_loc3_);
            _loc5_ = _loc4_.getRect(_loc4_);
            _loc1_ = Math.max(_loc1_,_loc5_.width);
            _loc2_ = Math.max(_loc2_,_loc5_.height);
            _loc3_--;
         }
         measuredMinWidth = measuredWidth = _loc1_;
         measuredMinHeight = measuredHeight = _loc2_;
      }
   }
}
