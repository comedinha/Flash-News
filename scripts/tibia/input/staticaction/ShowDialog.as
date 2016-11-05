package tibia.input.staticaction
{
   import tibia.options.ConfigurationWidget;
   import tibia.network.Communication;
   import tibia.creatures.CharacterProfileWidget;
   import tibia.prey.PreyWidget;
   
   public class ShowDialog extends StaticAction
   {
      
      public static const OPTIONS_HOTKEY:int = 4;
      
      public static const CHARACTER_SPELLS:int = 7;
      
      public static const OPTIONS_MOUSE_CONTROL:int = 6;
      
      public static const OPTIONS_GENERAL:int = 0;
      
      public static const CHARACTER_PROFILE:int = 8;
      
      public static const OPTIONS_STATUS:int = 2;
      
      public static const OPTIONS_RENDERER:int = 1;
      
      public static const CHAT_CHANNEL_SELECTION:int = 10;
      
      public static const OPTIONS_NAME_FILTER:int = 5;
      
      public static const HELP_QUEST_LOG:int = 11;
      
      public static const PREY_DIALOG:int = 12;
      
      public static const OPTIONS_MESSAGE:int = 3;
      
      public static const CHARACTER_OUTFIT:int = 9;
       
      
      protected var m_Dialog:int = 0;
      
      public function ShowDialog(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         if(param4 < 0 || param4 > PREY_DIALOG)
         {
            throw new ArgumentError("ShowDialog.ShowDialog: Invalid dialog: " + param4);
         }
         this.m_Dialog = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var OptionsWidget:ConfigurationWidget = null;
         var _Communication:Communication = null;
         var a_Repeat:Boolean = param1;
         try
         {
            OptionsWidget = null;
            _Communication = Tibia.s_GetCommunication();
            switch(this.m_Dialog)
            {
               case OPTIONS_GENERAL:
                  OptionsWidget = new ConfigurationWidget();
                  OptionsWidget.selectedIndex = ConfigurationWidget.GENERAL;
                  OptionsWidget.show();
                  break;
               case OPTIONS_RENDERER:
                  OptionsWidget = new ConfigurationWidget();
                  OptionsWidget.selectedIndex = ConfigurationWidget.RENDERER;
                  OptionsWidget.show();
                  break;
               case OPTIONS_STATUS:
                  OptionsWidget = new ConfigurationWidget();
                  OptionsWidget.selectedIndex = ConfigurationWidget.STATUS;
                  OptionsWidget.show();
                  break;
               case OPTIONS_MESSAGE:
                  OptionsWidget = new ConfigurationWidget();
                  OptionsWidget.selectedIndex = ConfigurationWidget.MESSAGE;
                  OptionsWidget.show();
                  break;
               case OPTIONS_HOTKEY:
                  OptionsWidget = new ConfigurationWidget();
                  OptionsWidget.selectedIndex = ConfigurationWidget.HOTKEY;
                  OptionsWidget.show();
                  break;
               case OPTIONS_NAME_FILTER:
                  OptionsWidget = new ConfigurationWidget();
                  OptionsWidget.selectedIndex = ConfigurationWidget.NAME_FILTER;
                  OptionsWidget.show();
                  break;
               case OPTIONS_MOUSE_CONTROL:
                  OptionsWidget = new ConfigurationWidget();
                  OptionsWidget.selectedIndex = ConfigurationWidget.MOUSE;
                  OptionsWidget.show();
                  break;
               case CHARACTER_SPELLS:
                  break;
               case CHARACTER_PROFILE:
                  new CharacterProfileWidget().show();
                  break;
               case CHARACTER_OUTFIT:
                  if(_Communication != null && _Communication.isGameRunning)
                  {
                     _Communication.sendCGETOUTFIT();
                  }
                  break;
               case CHAT_CHANNEL_SELECTION:
                  if(_Communication != null && _Communication.isGameRunning)
                  {
                     _Communication.sendCGETCHANNELS();
                  }
                  break;
               case HELP_QUEST_LOG:
                  if(_Communication != null && _Communication.isGameRunning)
                  {
                     _Communication.sendCGETQUESTLOG();
                  }
                  break;
               case PREY_DIALOG:
                  if(_Communication != null && _Communication.isGameRunning)
                  {
                     PreyWidget.s_ShowIfAppropriate();
                  }
            }
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
   }
}
