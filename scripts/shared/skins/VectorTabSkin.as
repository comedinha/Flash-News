package shared.skins
{
   import mx.skins.Border;
   import mx.core.UIComponent;
   import flash.display.DisplayObjectContainer;
   import mx.core.EdgeMetrics;
   
   public class VectorTabSkin extends Border
   {
       
      
      protected var m_BorderMetrics:EdgeMetrics;
      
      public function VectorTabSkin()
      {
         this.m_BorderMetrics = new EdgeMetrics(1,1,1,1);
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
      }
      
      private function getTabIndex() : int
      {
         var _loc1_:DisplayObjectContainer = parent;
         var _loc2_:DisplayObjectContainer = _loc1_ != null?_loc1_.parent:null;
         return _loc2_ != null?int(_loc2_.getChildIndex(_loc1_)):-1;
      }
      
      override public function get borderMetrics() : EdgeMetrics
      {
         var _loc1_:Number = Math.max(getStyle("defaultBorderThickness"),getStyle("selectedBorderThickness"));
         this.m_BorderMetrics.bottom = _loc1_;
         this.m_BorderMetrics.left = _loc1_;
         this.m_BorderMetrics.right = _loc1_;
         this.m_BorderMetrics.top = _loc1_;
         return this.m_BorderMetrics;
      }
      
      override public function get measuredHeight() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_HEIGHT;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc10_:int = 0;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:* = this.getTabIndex() > 0;
         var _loc9_:Boolean = false;
         switch(name)
         {
            case "selectedDisabledSkin":
            case "selectedDownSkin":
            case "selectedOverSkin":
            case "selectedUpSkin":
               _loc3_ = getStyle("selectedBorderAlpha");
               _loc6_ = getStyle("selectedBorderColor");
               _loc4_ = getStyle("selectedBorderThickness");
               _loc5_ = getStyle("selectedBackgroundAlpha");
               _loc7_ = getStyle("selectedBackgroundColor");
               _loc9_ = true;
               break;
            case "disabledSkin":
            case "downSkin":
            case "overSkin":
               _loc10_ = 0;
            case "upSkin":
            default:
               _loc3_ = getStyle("defaultBorderAlpha");
               _loc6_ = getStyle("defaultBorderColor");
               _loc4_ = getStyle("defaultBorderThickness");
               _loc5_ = getStyle("defaultBackgroundAlpha");
               _loc7_ = getStyle("defaultBackgroundColor");
         }
         graphics.clear();
         graphics.beginFill(_loc7_,_loc5_);
         graphics.drawRect(_loc4_,_loc4_,param1 - 2 * _loc4_,param2 - 2 * _loc4_);
         graphics.endFill();
         graphics.lineStyle(_loc4_,_loc6_,_loc3_);
         graphics.moveTo(param1 - _loc4_,param2 - _loc4_);
         graphics.lineTo(param1 - _loc4_,0);
         if(!_loc8_ || _loc9_)
         {
            graphics.lineTo(0,0);
            graphics.lineTo(0,param2 - _loc4_);
         }
         else
         {
            graphics.lineTo(_loc4_,0);
         }
      }
   }
}
