package tibia.options
{
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   
   public class UiServerHints
   {
       
      
      private var m_canChangePvPFramingOption:Boolean = true;
      
      private var m_Options:tibia.options.OptionsStorage = null;
      
      private var m_expertModeButtonEnabled:Boolean = true;
      
      public function UiServerHints(param1:tibia.options.OptionsStorage)
      {
         super();
         this.m_Options = param1;
      }
      
      public function get expertModeButtonEnabled() : Boolean
      {
         return this.m_expertModeButtonEnabled;
      }
      
      public function set expertModeButtonEnabled(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(this.m_expertModeButtonEnabled != param1)
         {
            this.m_expertModeButtonEnabled = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "uiHints";
            this.m_Options.dispatchEvent(_loc2_);
         }
      }
      
      public function set canChangePvPFramingOption(param1:Boolean) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(this.m_canChangePvPFramingOption != param1)
         {
            this.m_canChangePvPFramingOption = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "uiHints";
            this.m_Options.dispatchEvent(_loc2_);
         }
      }
      
      public function get canChangePvPFramingOption() : Boolean
      {
         return this.m_canChangePvPFramingOption;
      }
      
      public function set options(param1:tibia.options.OptionsStorage) : void
      {
         this.m_Options = param1;
      }
      
      public function clone() : UiServerHints
      {
         var _loc1_:UiServerHints = new UiServerHints(this.m_Options);
         _loc1_.canChangePvPFramingOption = this.canChangePvPFramingOption;
         _loc1_.expertModeButtonEnabled = this.expertModeButtonEnabled;
         return _loc1_;
      }
      
      public function get options() : tibia.options.OptionsStorage
      {
         return this.m_Options;
      }
   }
}
