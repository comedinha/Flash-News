package shared.skins
{
   import mx.core.EdgeMetrics;
   import mx.core.IBorder;
   import mx.core.UIComponent;
   import mx.skins.ProgrammaticSkin;
   
   public class VectorBorderSkin extends ProgrammaticSkin implements IBorder
   {
       
      
      protected var m_BorderMetrics:EdgeMetrics;
      
      public function VectorBorderSkin()
      {
         this.m_BorderMetrics = new EdgeMetrics(1,1,1,1);
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return UIComponent.DEFAULT_MEASURED_MIN_WIDTH;
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         var _loc1_:Number = getStyle("borderColor") !== undefined?Number(getStyle("borderThickness")):Number(0);
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
         if(isNaN(param1) || isNaN(param2))
         {
            return;
         }
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
         }
         if(getStyle("backgroundColor") !== undefined)
         {
            _loc3_ = getStyle("backgroundColor");
            _loc4_ = getStyle("backgroundAlpha");
            graphics.beginFill(_loc3_,_loc4_);
         }
         graphics.drawRect(0,0,param1 - _loc5_,param2 - _loc5_);
         graphics.lineStyle(NaN,0,NaN);
         graphics.endFill();
      }
   }
}
