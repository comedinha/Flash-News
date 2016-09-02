package tibia.input.gameaction
{
   import tibia.input.IActionImpl;
   import tibia.options.OptionsStorage;
   import tibia.creatures.BuddySet;
   import tibia.input.widgetClasses.AskPlayerNameWidget;
   import mx.resources.ResourceManager;
   import mx.events.CloseEvent;
   import tibia.game.PopUpBase;
   
   public class BuddylistActionImpl implements IActionImpl
   {
      
      private static const BUNDLE:String = "BuddylistWidget";
      
      public static const ADD_BY_NAME:int = 0;
      
      public static const REMOVE:int = 2;
      
      public static const ADD_ASK_NAME:int = 1;
       
      
      private var m_TargetID:int = -1;
      
      private var m_Type:int = -1;
      
      private var m_TargetName:String = null;
      
      public function BuddylistActionImpl(param1:int, param2:*)
      {
         super();
         if(param1 == ADD_BY_NAME && param2 is String)
         {
            this.m_Type = ADD_BY_NAME;
            this.m_TargetID = -1;
            this.m_TargetName = String(param2);
         }
         else if(param1 == ADD_ASK_NAME)
         {
            this.m_Type = ADD_ASK_NAME;
            this.m_TargetID = -1;
            this.m_TargetName = null;
         }
         else if(param1 == REMOVE && param2 is int)
         {
            this.m_Type = REMOVE;
            this.m_TargetID = int(param2);
            this.m_TargetName = null;
         }
         else
         {
            throw new ArgumentError("BuddylistActionImpl.BuddylistActionImpl: Invalid parameters: " + param1 + ", " + param2 + ".");
         }
      }
      
      public static function s_IsBuddy(param1:*) : Boolean
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:BuddySet = null;
         return _loc2_ != null && (_loc3_ = _loc2_.getBuddySet(BuddySet.DEFAULT_SET)) != null && _loc3_.getBuddy(param1) != null;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc4_:AskPlayerNameWidget = null;
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:BuddySet = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getBuddySet(BuddySet.DEFAULT_SET)) != null)
         {
            switch(this.m_Type)
            {
               case ADD_ASK_NAME:
                  _loc4_ = new AskPlayerNameWidget();
                  _loc4_.prompt = ResourceManager.getInstance().getString(BUNDLE,"ASK_NAME_PROMPT");
                  _loc4_.title = ResourceManager.getInstance().getString(BUNDLE,"ASK_NAME_TITLE");
                  _loc4_.addEventListener(CloseEvent.CLOSE,this.onWidgetClose);
                  _loc4_.show();
                  break;
               case ADD_BY_NAME:
                  _loc3_.addBuddy(this.m_TargetName,true);
                  break;
               case REMOVE:
                  _loc3_.removeBuddy(this.m_TargetID,true);
            }
         }
      }
      
      protected function onWidgetClose(param1:CloseEvent) : void
      {
         var _loc2_:AskPlayerNameWidget = null;
         if(param1 != null && param1.detail == PopUpBase.BUTTON_OKAY && (_loc2_ = param1.currentTarget as AskPlayerNameWidget) != null && _loc2_.playerName != null && _loc2_.playerName.length > 0)
         {
            new BuddylistActionImpl(BuddylistActionImpl.ADD_BY_NAME,_loc2_.playerName).perform();
         }
      }
   }
}
