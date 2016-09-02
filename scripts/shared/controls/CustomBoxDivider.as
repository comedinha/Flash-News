package shared.controls
{
   import mx.containers.dividedBoxClasses.BoxDivider;
   import shared.skins.BitmapGrid;
   import mx.core.mx_internal;
   import mx.containers.DividerState;
   
   public class CustomBoxDivider extends BoxDivider
   {
       
      
      private var m_Background:BitmapGrid;
      
      private var m_Knob:BitmapGrid;
      
      public function CustomBoxDivider()
      {
         this.m_Background = new BitmapGrid(null,"dividerBackground");
         this.m_Knob = new BitmapGrid(null,"dividerKnob");
         super();
      }
      
      override public function set styleName(param1:Object) : void
      {
         super.styleName = param1;
         this.m_Background.styleName = param1;
         this.m_Knob.styleName = param1;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         alpha = mx_internal::state == DividerState.DOWN?Number(0.5):Number(1);
         graphics.clear();
         this.m_Background.drawGrid(graphics,0,0,param1,param2);
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         var _loc5_:Number = this.m_Knob.measuredHeight;
         var _loc6_:Number = this.m_Knob.measuredWidth;
         switch(getStyle("dividerKnobAlignment"))
         {
            case "top":
               _loc3_ = (param1 - _loc6_) / 2;
               _loc4_ = 0;
               break;
            case "topLeft":
               _loc3_ = 0;
               _loc4_ = 0;
               break;
            case "left":
               _loc3_ = 0;
               _loc4_ = (param2 - _loc5_) / 2;
               break;
            case "bottomLeft":
               _loc3_ = 0;
               _loc4_ = param2 - _loc5_;
               break;
            case "bottom":
               _loc3_ = (param1 - _loc6_) / 2;
               _loc4_ = param2 - _loc5_;
               break;
            case "bottomRight":
               _loc3_ = param1 - _loc6_;
               _loc4_ = param2 - _loc5_;
               break;
            case "right":
               _loc3_ = param1 - _loc6_;
               _loc4_ = (param2 - _loc5_) / 2;
               break;
            case "topRight":
               _loc3_ = param1 - _loc6_;
               _loc4_ = 0;
               break;
            case "center":
            default:
               _loc3_ = (param1 - _loc6_) / 2;
               _loc4_ = (param2 - _loc5_) / 2;
         }
         this.m_Knob.drawGrid(graphics,_loc3_,_loc4_,_loc6_,_loc5_);
         graphics.endFill();
      }
   }
}
