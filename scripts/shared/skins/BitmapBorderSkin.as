package shared.skins
{
   import mx.core.EdgeMetrics;
   import mx.core.IBorder;
   import mx.skins.ProgrammaticSkin;
   
   public class BitmapBorderSkin extends ProgrammaticSkin implements IBorder
   {
       
      
      private var m_InvalidStyle:Boolean = false;
      
      private var m_Grid:BitmapGrid;
      
      public function BitmapBorderSkin()
      {
         this.m_Grid = new BitmapGrid(null,"border");
         super();
      }
      
      override public function get measuredWidth() : Number
      {
         this.validateStyle();
         return this.m_Grid.measuredWidth;
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         this.m_Grid.styleChanged(param1);
         this.invalidateStyle();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         this.validateStyle();
         graphics.clear();
         this.m_Grid.drawGrid(graphics,0,0,param1,param2);
         graphics.endFill();
      }
      
      protected function doValidateStyle() : void
      {
         this.m_Grid.styleName = styleName;
         this.m_Grid.validateStyle();
      }
      
      override public function validateNow() : void
      {
         super.validateNow();
         this.validateStyle();
      }
      
      override public function get measuredHeight() : Number
      {
         this.validateStyle();
         return this.m_Grid.measuredHeight;
      }
      
      public function invalidateStyle() : void
      {
         this.m_InvalidStyle = true;
      }
      
      override public function set styleName(param1:Object) : void
      {
         super.styleName = param1;
         this.invalidateStyle();
      }
      
      public function validateStyle() : void
      {
         if(this.m_InvalidStyle)
         {
            this.doValidateStyle();
            this.m_InvalidStyle = false;
         }
      }
      
      public function get borderMetrics() : EdgeMetrics
      {
         this.validateStyle();
         return this.m_Grid.borderMetrics;
      }
   }
}
