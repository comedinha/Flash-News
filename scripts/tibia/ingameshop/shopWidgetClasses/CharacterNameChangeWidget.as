package tibia.ingameshop.shopWidgetClasses
{
   import mx.containers.HBox;
   import mx.controls.Label;
   import mx.controls.TextInput;
   import shared.controls.EmbeddedDialog;
   import tibia.creatures.Creature;
   import tibia.ingameshop.IngameShopWidget;
   
   public class CharacterNameChangeWidget extends EmbeddedDialog
   {
      
      private static const BUNDLE:String = "IngameShopWidget";
       
      
      private var m_UIName:TextInput;
      
      private var m_OfferID:int;
      
      public function CharacterNameChangeWidget(param1:int)
      {
         super();
         this.m_OfferID = param1;
         title = resourceManager.getString(BUNDLE,"TITLE_NAME_CHANGE");
         buttonFlags = EmbeddedDialog.OKAY | EmbeddedDialog.CANCEL;
         width = IngameShopWidget.EMBEDDED_DIALOG_WIDTH;
      }
      
      override public function setFocus() : void
      {
         super.setFocus();
         this.m_UIName.setFocus();
      }
      
      public function get offerID() : int
      {
         return this.m_OfferID;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         text = resourceManager.getString(BUNDLE,"LBL_CHARACTER_NAME_CHANGE");
         var _loc1_:HBox = new HBox();
         _loc1_.percentWidth = 100;
         content.addChild(_loc1_);
         var _loc2_:Label = new Label();
         _loc2_.text = resourceManager.getString(BUNDLE,"LBL_CHARACTER_NAME_CHANGE_NEW_NAME");
         _loc1_.addChild(_loc2_);
         this.m_UIName = new TextInput();
         this.m_UIName.percentWidth = 100;
         this.m_UIName.maxChars = Creature.MAX_NAME_LENGHT;
         _loc1_.addChild(this.m_UIName);
      }
      
      public function get desiredName() : String
      {
         return this.m_UIName.text;
      }
   }
}
