package tibia.sidebar.sideBarWidgetClasses
{
   import mx.skins.ProgrammaticSkin;
   import mx.core.IBorder;
   import shared.skins.BitmapGrid;
   import mx.core.EdgeMetrics;
   
   public class WidgetViewSkin extends ProgrammaticSkin implements IBorder
   {
       
      
      private var m_Center:BitmapGrid;
      
      private var m_Footer:BitmapGrid;
      
      private var m_Header:BitmapGrid;
      
      public function WidgetViewSkin()
      {
         this.m_Header = new BitmapGrid(null,"borderHeader");
         this.m_Center = new BitmapGrid(null,"borderCenter");
         this.m_Footer = new BitmapGrid(null,"borderFooter");
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         return Math.max(this.m_Header.measuredWidth,this.m_Center.measuredWidth,this.m_Footer.measuredWidth);
      }
      
      public function get footerHeight() : Number
      {
         return this.m_Footer.measuredHeight;
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         this.m_Header.styleChanged(param1);
         this.m_Center.styleChanged(param1);
         this.m_Footer.styleChanged(param1);
      }
      
      override public function get measuredHeight() : Number
      {
         return this.m_Header.measuredHeight + this.m_Center.measuredHeight + this.m_Footer.measuredHeight;
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         var _loc1_:EdgeMetrics = new EdgeMetrics();
         var _loc2_:EdgeMetrics = this.m_Center.borderMetrics;
         _loc1_.bottom = this.m_Footer.measuredHeight + _loc2_.bottom;
         _loc1_.left = _loc2_.left;
         _loc1_.right = _loc2_.right;
         _loc1_.top = this.m_Header.measuredHeight + _loc2_.top;
         return _loc1_;
      }
      
      override public function set styleName(param1:Object) : void
      {
         super.styleName = param1;
         this.m_Header.styleName = param1;
         this.m_Center.styleName = param1;
         this.m_Footer.styleName = param1;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Number = param2;
         var _loc4_:Number = 0;
         graphics.clear();
         if(_loc3_ > 0)
         {
            this.m_Header.drawGrid(graphics,0,0,param1,this.m_Header.measuredHeight);
            _loc4_ = this.m_Header.measuredHeight;
            _loc3_ = _loc3_ - this.m_Header.measuredHeight;
         }
         if(_loc3_ > 0)
         {
            this.m_Footer.drawGrid(graphics,0,param2 - this.m_Footer.measuredHeight,param1,this.m_Footer.measuredHeight);
            _loc3_ = _loc3_ - this.m_Footer.measuredHeight;
         }
         if(_loc3_ > 0)
         {
            this.m_Center.drawGrid(graphics,0,_loc4_,param1,_loc3_);
         }
         graphics.endFill();
      }
      
      public function get headerHeight() : Number
      {
         return this.m_Header.measuredHeight;
      }
   }
}
