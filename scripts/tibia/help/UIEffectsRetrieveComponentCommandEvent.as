package tibia.help
{
   import flash.events.Event;
   import mx.core.UIComponent;
   
   public class UIEffectsRetrieveComponentCommandEvent extends Event
   {
      
      public static var GET_UI_COMPONENT:String = "GET_UI_COMPONENT";
       
      
      private var m_SubIdentifier = null;
      
      private var m_ResultUIComponent:UIComponent = null;
      
      private var m_Identifier:Class = null;
      
      public function UIEffectsRetrieveComponentCommandEvent(param1:String, param2:Boolean = false, param3:Boolean = false)
      {
         super(param1,param2,param3);
      }
      
      public function get subIdentifier() : *
      {
         return this.m_SubIdentifier;
      }
      
      public function get resultUIComponent() : UIComponent
      {
         return this.m_ResultUIComponent;
      }
      
      public function get identifier() : Class
      {
         return this.m_Identifier;
      }
      
      public function set identifier(param1:*) : void
      {
         this.m_Identifier = param1;
      }
      
      public function set resultUIComponent(param1:UIComponent) : void
      {
         this.m_ResultUIComponent = param1;
      }
      
      public function set subIdentifier(param1:*) : void
      {
         this.m_SubIdentifier = param1;
      }
   }
}
