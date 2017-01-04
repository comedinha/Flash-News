package shared.skins
{
   import mx.skins.ProgrammaticSkin;
   
   class BitmapButtonSkinBase extends ProgrammaticSkin
   {
       
      
      private var m_InvalidStyle:Boolean = false;
      
      private var m_Grid:BitmapGrid;
      
      function BitmapButtonSkinBase()
      {
         this.m_Grid = new BitmapGrid();
         super();
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         this.m_Grid.styleChanged(param1);
         this.invalidateStyle();
      }
      
      protected function set stylePrefix(param1:String) : void
      {
         this.m_Grid.stylePrefix = param1;
      }
      
      override public function get measuredWidth() : Number
      {
         this.validateStyle();
         return this.m_Grid.measuredWidth;
      }
      
      public function invalidateStyle() : void
      {
         this.m_InvalidStyle = true;
      }
      
      override public function validateNow() : void
      {
         super.validateNow();
         this.validateStyle();
      }
      
      protected function get stylePrefix() : String
      {
         return this.m_Grid.stylePrefix;
      }
      
      override public function get measuredHeight() : Number
      {
         this.validateStyle();
         return this.m_Grid.measuredHeight;
      }
      
      protected function doValidateStyle() : void
      {
         this.m_Grid.styleName = styleName;
         this.m_Grid.validateStyle();
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
      
      override public function set name(param1:String) : void
      {
         super.name = param1;
         this.invalidateStyle();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         this.validateStyle();
         graphics.clear();
         this.m_Grid.drawGrid(graphics,0,0,param1,param2);
         graphics.endFill();
      }
   }
}
