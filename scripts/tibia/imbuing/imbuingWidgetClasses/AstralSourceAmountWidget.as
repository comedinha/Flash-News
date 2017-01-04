package tibia.imbuing.imbuingWidgetClasses
{
   import flash.events.MouseEvent;
   import mx.containers.HBox;
   import mx.containers.VBox;
   import mx.controls.Label;
   import shared.controls.ShapeWrapper;
   import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
   
   public class AstralSourceAmountWidget extends VBox
   {
       
      
      private var m_UIAstralSourceAppearance:SimpleAppearanceRenderer = null;
      
      private var m_UncomittedAstralSource:Boolean = false;
      
      private var m_AppearanceTypeID:uint = 0;
      
      private var m_AmountInInventory:uint = 0;
      
      private var m_UILabel:Label = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_AmountNeeded:uint = 0;
      
      public function AstralSourceAmountWidget()
      {
         super();
      }
      
      private function onMouseOver(param1:MouseEvent) : void
      {
      }
      
      public function refreshData(param1:uint, param2:uint, param3:uint) : void
      {
         this.m_AppearanceTypeID = param1;
         this.m_AmountInInventory = param2;
         this.m_AmountNeeded = param3;
         this.m_UncomittedAstralSource = true;
         invalidateProperties();
      }
      
      public function get empty() : Boolean
      {
         return this.m_AppearanceTypeID == 0;
      }
      
      private function onMouseOut(param1:MouseEvent) : void
      {
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncomittedAstralSource)
         {
            if(this.empty)
            {
               this.m_UIAstralSourceAppearance.appearance = null;
               this.m_UILabel.text = "";
            }
            else
            {
               this.m_UIAstralSourceAppearance.appearance = Tibia.s_GetAppearanceStorage().createObjectInstance(this.m_AppearanceTypeID,0);
               ShapeWrapper(this.m_UIAstralSourceAppearance.parent).invalidateSize();
               ShapeWrapper(this.m_UIAstralSourceAppearance.parent).invalidateDisplayList();
               this.m_UILabel.text = this.m_AmountInInventory + "/" + this.m_AmountNeeded;
               if(this.m_AmountInInventory < this.m_AmountNeeded)
               {
                  this.m_UILabel.styleName = "astralSourceLabelAmountMissing";
               }
               else
               {
                  this.m_UILabel.styleName = "astralSourceLabel";
               }
            }
            this.m_UncomittedAstralSource = false;
         }
      }
      
      public function clear() : void
      {
         this.m_AppearanceTypeID = 0;
         this.m_AmountInInventory = 0;
         this.m_AmountNeeded = 0;
         this.m_UncomittedAstralSource = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:HBox = null;
         var _loc2_:ShapeWrapper = null;
         var _loc3_:HBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new HBox();
            _loc2_ = new ShapeWrapper();
            this.m_UIAstralSourceAppearance = new SimpleAppearanceRenderer();
            this.m_UIAstralSourceAppearance.scale = 2;
            this.m_UIAstralSourceAppearance.overlay = false;
            _loc2_.addChild(this.m_UIAstralSourceAppearance);
            _loc2_.percentWidth = 100;
            _loc2_.percentHeight = 100;
            _loc1_.width = 70;
            _loc1_.height = 70;
            _loc1_.addChild(_loc2_);
            _loc1_.verticalScrollPolicy = "off";
            _loc1_.horizontalScrollPolicy = "off";
            addChild(_loc1_);
            _loc3_ = new HBox();
            _loc3_.percentWidth = 100;
            this.m_UILabel = new Label();
            this.m_UILabel.percentWidth = 100;
            _loc3_.addChild(this.m_UILabel);
            addChild(_loc3_);
            _loc1_.styleName = "astralSourceBox";
            _loc2_.styleName = "astralSourceImageWrapper";
            this.m_UILabel.styleName = "astralSourceLabel";
            _loc3_.styleName = "astralSourceBox";
            this.m_UIConstructed = true;
         }
      }
   }
}
