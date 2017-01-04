package tibia.imbuing.imbuingWidgetClasses
{
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import shared.controls.CustomButton;
   import tibia.controls.TibiaCurrencyView;
   
   public class ImbuementButtonWidget extends Canvas
   {
       
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIButton:CustomButton;
      
      private var m_UICurrencyView:TibiaCurrencyView;
      
      public function ImbuementButtonWidget()
      {
         this.m_UIButton = new CustomButton();
         this.m_UICurrencyView = new TibiaCurrencyView();
         super();
      }
      
      public function get currencyView() : TibiaCurrencyView
      {
         return this.m_UICurrencyView;
      }
      
      public function get button() : CustomButton
      {
         return this.m_UIButton;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:VBox = null;
         var _loc2_:HBox = null;
         var _loc3_:HBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new VBox();
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            _loc2_ = new HBox();
            this.m_UIButton.percentWidth = 100;
            this.m_UIButton.percentHeight = 100;
            _loc2_.addChild(this.m_UIButton);
            _loc2_.percentWidth = 100;
            _loc2_.percentHeight = 100;
            _loc1_.addChild(_loc2_);
            _loc3_ = new HBox();
            _loc3_.percentWidth = 100;
            this.m_UICurrencyView.percentWidth = 100;
            _loc3_.addChild(this.m_UICurrencyView);
            _loc1_.addChild(_loc3_);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
   }
}
