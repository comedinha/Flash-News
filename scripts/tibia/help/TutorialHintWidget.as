package tibia.help
{
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.Container;
   import tibia.game.PopUpBase;
   
   public class TutorialHintWidget extends PopUpBase
   {
      
      private static const BUNDLE:String = "TutorialHintWidget";
       
      
      private var m_UIImages:Container = null;
      
      private var m_UncommittedImages:Boolean = false;
      
      private var m_Images:Array = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIText:Text = null;
      
      private var m_UncommittedText:Boolean = false;
      
      public function TutorialHintWidget()
      {
         super();
         title = resourceManager.getString(BUNDLE,"TITLE");
         buttonFlags = PopUpBase.BUTTON_OKAY;
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Image = null;
         super.commitProperties();
         if(this.m_UncommittedImages)
         {
            this.m_UIImages.removeAllChildren();
            _loc1_ = this.images != null?int(this.images.length):0;
            _loc2_ = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = new Image();
               _loc3_.source = this.images[_loc2_];
               this.m_UIImages.addChild(_loc3_);
               _loc2_++;
            }
            this.m_UncommittedImages = false;
         }
      }
      
      public function set images(param1:Array) : void
      {
         if(this.m_Images != param1)
         {
            this.m_Images = param1;
            this.m_UncommittedImages = true;
            invalidateProperties();
         }
      }
      
      public function get images() : Array
      {
         return this.m_Images;
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:VBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new VBox();
            _loc1_.percentWidth = 100;
            _loc1_.percentHeight = 100;
            _loc1_.setStyle("backgroundColor","0x000000");
            _loc1_.setStyle("backgroundAlpha",0.5);
            this.m_UIImages = new HBox();
            this.m_UIImages.percentWidth = 100;
            this.m_UIImages.setStyle("horizontalAlign","center");
            this.m_UIImages.setStyle("verticalAlign","middle");
            addChild(_loc1_);
            _loc1_.addChild(this.m_UIImages);
         }
      }
   }
}
