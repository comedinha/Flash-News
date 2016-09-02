package tibia.sidebar.sideBarWidgetClasses
{
   import mx.controls.Button;
   import flash.events.MouseEvent;
   import tibia.input.staticaction.StaticActionList;
   import tibia.premium.PremiumManager;
   import shared.controls.CustomButton;
   import mx.core.ScrollPolicy;
   
   public class GeneralButtonsWidgetView extends WidgetView
   {
      
      private static const BUNDLE:String = "GeneralButtonsWidget";
       
      
      protected var m_UIButtonChangeCharacter:Button = null;
      
      protected var m_UIButtonLogout:Button = null;
      
      protected var m_UIButtonOptions:Button = null;
      
      protected var m_UIButtonSpellList:Button = null;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIButtonCharacterProfile:Button = null;
      
      protected var m_UIButtonQuestLog:Button = null;
      
      protected var m_UIButtonPremium:Button = null;
      
      public function GeneralButtonsWidgetView()
      {
         super();
         titleText = resourceManager.getString(BUNDLE,"TITLE");
         verticalScrollPolicy = ScrollPolicy.OFF;
         horizontalScrollPolicy = ScrollPolicy.OFF;
      }
      
      override function releaseInstance() : void
      {
         super.releaseInstance();
         this.m_UIButtonChangeCharacter.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonCharacterProfile.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonLogout.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonOptions.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonQuestLog.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonSpellList.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonPremium.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
      }
      
      protected function onButtonClick(param1:MouseEvent) : void
      {
         switch(param1.currentTarget)
         {
            case this.m_UIButtonLogout:
               StaticActionList.MISC_LOGOUT_CHARACTER.perform();
               break;
            case this.m_UIButtonChangeCharacter:
               StaticActionList.MISC_CHANGE_CHARACTER.perform();
               break;
            case this.m_UIButtonOptions:
               StaticActionList.MISC_SHOW_EDIT_OPTIONS.perform();
               break;
            case this.m_UIButtonQuestLog:
               StaticActionList.MISC_SHOW_QUEST_LOG.perform();
               break;
            case this.m_UIButtonCharacterProfile:
               StaticActionList.MISC_SHOW_CHARACTER.perform();
               break;
            case this.m_UIButtonSpellList:
               StaticActionList.MISC_SHOW_WIDGET_SPELLLIST.perform();
               break;
            case this.m_UIButtonPremium:
               Tibia.s_GetPremiumManager().goToPaymentWebsite(PremiumManager.PREMIUM_BUTTON_GENERAL_CONTROLS);
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIButtonLogout = new CustomButton();
            this.m_UIButtonLogout.percentWidth = 100;
            this.m_UIButtonLogout.label = resourceManager.getString(BUNDLE,"BTN_LOGOUT_CHARACTER");
            this.m_UIButtonLogout.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonLogout);
            this.m_UIButtonChangeCharacter = new CustomButton();
            this.m_UIButtonChangeCharacter.percentWidth = 100;
            this.m_UIButtonChangeCharacter.label = resourceManager.getString(BUNDLE,"BTN_CHANGE_CHARACTER");
            this.m_UIButtonChangeCharacter.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonChangeCharacter);
            this.m_UIButtonOptions = new CustomButton();
            this.m_UIButtonOptions.percentWidth = 100;
            this.m_UIButtonOptions.label = resourceManager.getString(BUNDLE,"BTN_OPTIONS");
            this.m_UIButtonOptions.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonOptions);
            this.m_UIButtonQuestLog = new CustomButton();
            this.m_UIButtonQuestLog.percentWidth = 100;
            this.m_UIButtonQuestLog.label = resourceManager.getString(BUNDLE,"BTN_QUEST_LOG");
            this.m_UIButtonQuestLog.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonQuestLog);
            this.m_UIButtonCharacterProfile = new CustomButton();
            this.m_UIButtonCharacterProfile.percentWidth = 100;
            this.m_UIButtonCharacterProfile.label = resourceManager.getString(BUNDLE,"BTN_CHARACTER_PROFILE");
            this.m_UIButtonCharacterProfile.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonCharacterProfile);
            this.m_UIButtonSpellList = new CustomButton();
            this.m_UIButtonSpellList.percentWidth = 100;
            this.m_UIButtonSpellList.label = resourceManager.getString(BUNDLE,"BTN_SPELLLIST");
            this.m_UIButtonSpellList.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonSpellList);
            this.m_UIButtonPremium = new CustomButton();
            this.m_UIButtonPremium.percentWidth = 100;
            this.m_UIButtonPremium.label = resourceManager.getString(BUNDLE,"BTN_PREMIUM");
            this.m_UIButtonPremium.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonPremium);
            this.m_UIConstructed = true;
         }
      }
   }
}
