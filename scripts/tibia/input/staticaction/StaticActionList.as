package tibia.input.staticaction
{
   import tibia.input.InputEvent;
   import tibia.actionbar.ActionBarSet;
   import tibia.actionbar.ActionBar;
   import tibia.options.OptionsStorage;
   import tibia.chat.ChatStorage;
   import tibia.sidebar.SideBarSet;
   import tibia.sidebar.Widget;
   
   public class StaticActionList
   {
      
      public static const CHAT_COPYPASTE_INSERT:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(265,"CHAT_COPYPASTE_INSERT",InputEvent.KEY_DOWN,true);
      
      public static const MISC_ROOT_CONTAINER:tibia.input.staticaction.OpenRootContainer = new tibia.input.staticaction.OpenRootContainer(19,"MISC_ROOT_CONTAINER",InputEvent.KEY_DOWN);
      
      public static const MISC_SHOW_WIDGET_BUDDYLIST:tibia.input.staticaction.ShowWidget = new tibia.input.staticaction.ShowWidget(36,"MISC_SHOW_WIDGET_BUDDYLIST",InputEvent.KEY_DOWN,Widget.TYPE_BUDDYLIST);
      
      public static const MISC_COMBAT_PVP_YELLOW_HAND:tibia.input.staticaction.CombatPVPMode = new tibia.input.staticaction.CombatPVPMode(48,"MISC_COMBAT_PVP_YELLOW_HAND",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_PVP_MODE_YELLOW_HAND);
      
      public static const MISC_COMBAT_SECURE:tibia.input.staticaction.CombatSecureMode = new tibia.input.staticaction.CombatSecureMode(27,"MISC_COMBAT_SECURE",InputEvent.KEY_DOWN);
      
      public static const MISC_TOGGLE_ACTIONBAR_RIGHT:tibia.input.staticaction.ToggleActionBar = new tibia.input.staticaction.ToggleActionBar(40,"MISC_TOGGLE_ACTIONBAR_RIGHT",InputEvent.KEY_DOWN,ActionBarSet.LOCATION_RIGHT);
      
      public static const MISC_AUTOFIT_GAMEWINDOW:tibia.input.staticaction.AutofitGameWindow = new tibia.input.staticaction.AutofitGameWindow(42,"MISC_AUTOFIT_GAMEWINDOW",InputEvent.KEY_DOWN);
      
      public static const MISC_TOGGLE_LOCK_MODE:tibia.input.staticaction.ToggleActionBarsLock = new tibia.input.staticaction.ToggleActionBarsLock(44,"MISC_TOGGLE_LOCK_MODE",InputEvent.KEY_DOWN);
      
      public static const MISC_SHOW_QUEST_LOG:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(22,"MISC_SHOW_QUEST_LOG",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.HELP_QUEST_LOG);
      
      public static const PLAYER_MOUNT:tibia.input.staticaction.PlayerMount = new tibia.input.staticaction.PlayerMount(525,"PLAYER_MOUNT",InputEvent.KEY_DOWN);
      
      public static const MISC_COMBAT_OFFENSIVE:tibia.input.staticaction.CombatAttackMode = new tibia.input.staticaction.CombatAttackMode(25,"MISC_COMBAT_OFFENSIVE",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_ATTACK_OFFENSIVE);
      
      public static const MISC_COMBAT_PVP_DOVE:tibia.input.staticaction.CombatPVPMode = new tibia.input.staticaction.CombatPVPMode(46,"MISC_COMBAT_PVP_DOVE",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_PVP_MODE_DOVE);
      
      public static const PLAYER_MOVE_UP_RIGHT:tibia.input.staticaction.PlayerMove = new tibia.input.staticaction.PlayerMove(513,"PLAYER_MOVE_UP_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.PlayerMove.NORTH_EAST);
      
      public static const MISC_CHANGE_CHARACTER:tibia.input.staticaction.ChangeCharacter = new tibia.input.staticaction.ChangeCharacter(12,"MISC_CHANGE_CHARACTER",InputEvent.KEY_DOWN);
      
      public static const MISC_SHOW_WIDGET_BATTLELIST:tibia.input.staticaction.ShowWidget = new tibia.input.staticaction.ShowWidget(37,"MISC_SHOW_WIDGET_BATTLELIST",InputEvent.KEY_DOWN,Widget.TYPE_BATTLELIST);
      
      public static const PLAYER_MOVE_RIGHT:tibia.input.staticaction.PlayerMove = new tibia.input.staticaction.PlayerMove(512,"PLAYER_MOVE_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.PlayerMove.EAST);
      
      public static const MISC_COMBAT_CHASE:tibia.input.staticaction.CombatChaseMode = new tibia.input.staticaction.CombatChaseMode(26,"MISC_COMBAT_CHASE",InputEvent.KEY_DOWN);
      
      public static const MMAP_ZOOM_OUT:tibia.input.staticaction.MiniMapZoom = new tibia.input.staticaction.MiniMapZoom(1800,"MMAP_ZOOM_OUT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,-1);
      
      public static const MISC_COMBAT_DEFENSIVE:tibia.input.staticaction.CombatAttackMode = new tibia.input.staticaction.CombatAttackMode(24,"MISC_COMBAT_DEFENSIVE",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_ATTACK_DEFENSIVE);
      
      public static const PLAYER_TURN_UP:tibia.input.staticaction.PlayerTurn = new tibia.input.staticaction.PlayerTurn(521,"PLAYER_TURN_UP",InputEvent.KEY_DOWN,tibia.input.staticaction.PlayerTurn.NORTH);
      
      public static const MISC_TOGGLE_ACTIONBAR_LEFT:tibia.input.staticaction.ToggleActionBar = new tibia.input.staticaction.ToggleActionBar(39,"MISC_TOGGLE_ACTIONBAR_LEFT",InputEvent.KEY_DOWN,ActionBarSet.LOCATION_LEFT);
      
      public static const MISC_SEND_BUG_REPORT:tibia.input.staticaction.SendBugReport = new tibia.input.staticaction.SendBugReport(21,"MISC_SEND_BUG_REPORT",InputEvent.KEY_DOWN);
      
      public static const CHAT_COPYPASTE_SELECT:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(263,"CHAT_COPYPASTE_SELECT",InputEvent.KEY_DOWN,true);
      
      public static const MMAP_MOVE_LEFT:tibia.input.staticaction.MiniMapMove = new tibia.input.staticaction.MiniMapMove(1794,"MMAP_MOVE_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.MiniMapMove.WEST);
      
      public static const PLAYER_TURN_DOWN:tibia.input.staticaction.PlayerTurn = new tibia.input.staticaction.PlayerTurn(523,"PLAYER_TURN_DOWN",InputEvent.KEY_DOWN,tibia.input.staticaction.PlayerTurn.SOUTH);
      
      public static const MISC_SHOW_WIDGET_MINIMAP:tibia.input.staticaction.ShowWidget = new tibia.input.staticaction.ShowWidget(34,"MISC_SHOW_WIDGET_MINIMAP",InputEvent.KEY_DOWN,Widget.TYPE_MINIMAP);
      
      public static const MISC_SHOW_EDIT_MESSAGES:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(7,"MISC_SHOW_EDIT_MESSAGE",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.OPTIONS_MESSAGE);
      
      public static const CHAT_CHANNEL_NEXT:tibia.input.staticaction.ChatTabCycle = new tibia.input.staticaction.ChatTabCycle(273,"CHAT_CHANNEL_NEXT",InputEvent.KEY_DOWN,tibia.input.staticaction.ChatTabCycle.NEXT);
      
      public static const MISC_MAPPING_NEXT:tibia.input.staticaction.MappingSetCycle = new tibia.input.staticaction.MappingSetCycle(13,"MISC_MAPPING_NEXT",InputEvent.KEY_DOWN,tibia.input.staticaction.MappingSetCycle.NEXT);
      
      public static const MMAP_MOVE_UP:tibia.input.staticaction.MiniMapMove = new tibia.input.staticaction.MiniMapMove(1793,"MMAP_MOVE_UP",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.MiniMapMove.NORTH);
      
      public static const PLAYER_MOVE_UP_LEFT:tibia.input.staticaction.PlayerMove = new tibia.input.staticaction.PlayerMove(515,"PLAYER_MOVE_UP_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.PlayerMove.NORTH_WEST);
      
      public static const CHAT_SEND_TEXT:tibia.input.staticaction.ChatSendText = new tibia.input.staticaction.ChatSendText(269,"CHAT_SEND_TEXT",InputEvent.KEY_DOWN,true);
      
      public static const CHAT_TEXT_INPUT:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(256,"CHAT_TEXT_INPUT",InputEvent.TEXT_INPUT,true);
      
      public static const MMAP_LAYER_DOWN:tibia.input.staticaction.MiniMapMove = new tibia.input.staticaction.MiniMapMove(1797,"MMAP_LAYER_DOWN",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.MiniMapMove.DOWN);
      
      public static const CHAT_HISTORY_NEXT:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(268,"CHAT_HISTORY_NEXT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,false);
      
      public static const CHAT_MOVE_CURSOR_RIGHT:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(258,"CHAT_MOVE_CURSOR_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,false);
      
      public static const CHAT_CHANNEL_CLOSE_SECONDARY:tibia.input.staticaction.ChatChannelClose = new tibia.input.staticaction.ChatChannelClose(276,"CHAT_CHANNEL_CLOSE_SECONDARY",InputEvent.KEY_DOWN,false);
      
      public static const PLAYER_MOVE_UP:tibia.input.staticaction.PlayerMove = new tibia.input.staticaction.PlayerMove(514,"PLAYER_MOVE_UP",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.PlayerMove.NORTH);
      
      public static const PLAYER_MOVE_DOWN:tibia.input.staticaction.PlayerMove = new tibia.input.staticaction.PlayerMove(518,"PLAYER_MOVE_DOWN",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.PlayerMove.SOUTH);
      
      public static const MISC_SHOW_WIDGET_GENERALBUTTONS:tibia.input.staticaction.ShowWidget = new tibia.input.staticaction.ShowWidget(32,"MISC_SHOW_WIDGET_GENERALBUTTONS",InputEvent.KEY_DOWN,Widget.TYPE_GENERALBUTTONS);
      
      public static const MISC_TOGGLE_SIDEBAR_OUTER_RIGHT:tibia.input.staticaction.ToggleSideBar = new tibia.input.staticaction.ToggleSideBar(29,"MISC_TOGGLE_SIDEBAR_OUTER_RIGHT",InputEvent.KEY_DOWN,SideBarSet.LOCATION_D);
      
      public static const CHAT_CHANNEL_CLOSE_PRIMARY:tibia.input.staticaction.ChatChannelClose = new tibia.input.staticaction.ChatChannelClose(271,"CHAT_CHANNEL_CLOSE_PRIMARY",InputEvent.KEY_DOWN,true);
      
      public static const MISC_SHOW_WIDGET_SPELLLIST:tibia.input.staticaction.ShowWidget = new tibia.input.staticaction.ShowWidget(45,"MISC_SHOW_WIDGET_SPELLLIST",InputEvent.KEY_DOWN,Widget.TYPE_SPELLLIST);
      
      public static const MISC_SHOW_WIDGET_COMBATCONTROL:tibia.input.staticaction.ShowWidget = new tibia.input.staticaction.ShowWidget(33,"MISC_SHOW_WIDGET_COMBATCONTROL",InputEvent.KEY_DOWN,Widget.TYPE_COMBATCONTROL);
      
      public static const MISC_SHOW_EDIT_STATUS:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(20,"MISC_SHOW_EDIT_STATUS",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.OPTIONS_STATUS);
      
      public static const MISC_EXPIRE_ONSCREEN_MESSAGE:tibia.input.staticaction.ExpireOnScreenMessage = new tibia.input.staticaction.ExpireOnScreenMessage(3,"MISC_EXPIRE_ONSCREEN_MESSAGE",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT);
      
      private static const BUNDLE:String = "StaticAction";
      
      public static const MMAP_MOVE_RIGHT:tibia.input.staticaction.MiniMapMove = new tibia.input.staticaction.MiniMapMove(1792,"MMAP_MOVE_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.MiniMapMove.EAST);
      
      public static const MISC_LOGOUT_CHARACTER:tibia.input.staticaction.LogoutCharacter = new tibia.input.staticaction.LogoutCharacter(11,"MISC_LOGOUT_CHARACTER",InputEvent.KEY_DOWN);
      
      public static const MISC_TOGGLE_SIDEBAR_INNER_LEFT:tibia.input.staticaction.ToggleSideBar = new tibia.input.staticaction.ToggleSideBar(30,"MISC_TOGGLE_SIDEBAR_INNER_LEFT",InputEvent.KEY_DOWN,SideBarSet.LOCATION_B);
      
      public static const MISC_TOGGLE_SIDEBAR_OUTER_LEFT:tibia.input.staticaction.ToggleSideBar = new tibia.input.staticaction.ToggleSideBar(31,"MISC_TOGGLE_SIDEBAR_OUTER_LEFT",InputEvent.KEY_DOWN,SideBarSet.LOCATION_A);
      
      public static const MISC_TOGGLE_STATUSBAR:tibia.input.staticaction.ToggleStatusBar = new tibia.input.staticaction.ToggleStatusBar(43,"MISC_TOGGLE_STATUSBAR",InputEvent.KEY_DOWN);
      
      public static const MISC_SHOW_EDIT_GRAPHICS:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(8,"MISC_SHOW_EDIT_RENDERER",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.OPTIONS_RENDERER);
      
      public static const CHAT_CHANNEL_PREV:tibia.input.staticaction.ChatTabCycle = new tibia.input.staticaction.ChatTabCycle(274,"CHAT_CHANNEL_PREV",InputEvent.KEY_DOWN,tibia.input.staticaction.ChatTabCycle.PREV);
      
      public static const MISC_MAPPING_PREV:tibia.input.staticaction.MappingSetCycle = new tibia.input.staticaction.MappingSetCycle(14,"MISC_MAPPING_PREV",InputEvent.KEY_DOWN,tibia.input.staticaction.MappingSetCycle.PREV);
      
      public static const PLAYER_CANCEL:tibia.input.staticaction.PlayerCancel = new tibia.input.staticaction.PlayerCancel(524,"PLAYER_CANCEL",InputEvent.KEY_DOWN);
      
      public static const CHAT_MOVE_CURSOR_END:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(260,"CHAT_MOVE_CURSOR_END",InputEvent.KEY_DOWN,true);
      
      public static const MISC_SHOW_WIDGET_BODY:tibia.input.staticaction.ShowWidget = new tibia.input.staticaction.ShowWidget(35,"MISC_SHOW_WIDGET_BODY",InputEvent.KEY_DOWN,Widget.TYPE_BODY);
      
      public static const MISC_COMBAT_PVP_RED_FIST:tibia.input.staticaction.CombatPVPMode = new tibia.input.staticaction.CombatPVPMode(49,"MISC_COMBAT_PVP_RED_FIST",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_PVP_MODE_RED_FIST);
      
      public static const MISC_COMBAT_BALANCED:tibia.input.staticaction.CombatAttackMode = new tibia.input.staticaction.CombatAttackMode(23,"MISC_COMBAT_BALANCED",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_ATTACK_BALANCED);
      
      public static const MMAP_ZOOM_IN:tibia.input.staticaction.MiniMapZoom = new tibia.input.staticaction.MiniMapZoom(1799,"MMAP_ZOOM_IN",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,1);
      
      public static const CHAT_HISTORY_PREV:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(267,"CHAT_HISTORY_PREV",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,false);
      
      public static const CHAT_DELETE_NEXT:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(262,"CHAT_DELETE_NEXT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,true);
      
      public static const CHAT_CHANNEL_OPEN:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(270,"CHAT_CHANNEL_OPEN",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.CHAT_CHANNEL_SELECTION);
      
      public static const PLAYER_TURN_LEFT:tibia.input.staticaction.PlayerTurn = new tibia.input.staticaction.PlayerTurn(522,"PLAYER_TURN_LEFT",InputEvent.KEY_DOWN,tibia.input.staticaction.PlayerTurn.WEST);
      
      public static const MISC_ATTACK_NEXT:tibia.input.staticaction.AttackCycle = new tibia.input.staticaction.AttackCycle(15,"MISC_ATTACK_NEXT",InputEvent.KEY_DOWN,tibia.input.staticaction.AttackCycle.NEXT);
      
      public static const MISC_SHOW_EDIT_OPTIONS:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(4,"MISC_SHOW_EDIT_GENERAL",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.OPTIONS_GENERAL);
      
      public static const MISC_SHOW_OUTFIT:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(18,"MISC_SHOW_OUTFIT",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.CHARACTER_OUTFIT);
      
      public static const CHAT_COPYPASTE_COPY:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(264,"CHAT_COPYPASTE_COPY",InputEvent.KEY_DOWN,true);
      
      public static const CHAT_MOVE_CURSOR_HOME:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(259,"CHAT_MOVE_CURSOR_HOME",InputEvent.KEY_DOWN,true);
      
      public static const MISC_TOGGLE_ACTIONBAR_TOP:tibia.input.staticaction.ToggleActionBar = new tibia.input.staticaction.ToggleActionBar(38,"MISC_TOGGLE_ACTIONBAR_TOP",InputEvent.KEY_DOWN,ActionBarSet.LOCATION_TOP);
      
      public static const PLAYER_MOVE_DOWN_LEFT:tibia.input.staticaction.PlayerMove = new tibia.input.staticaction.PlayerMove(517,"PLAYER_MOVE_DOWN_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.PlayerMove.SOUTH_WEST);
      
      public static const MISC_TOGGLE_MAPPING_MODE:tibia.input.staticaction.ToggleMappingMode = new tibia.input.staticaction.ToggleMappingMode(1,"MISC_TOGGLE_MAPPING_MODE",InputEvent.KEY_DOWN);
      
      public static const PLAYER_MOVE_LEFT:tibia.input.staticaction.PlayerMove = new tibia.input.staticaction.PlayerMove(516,"PLAYER_MOVE_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.PlayerMove.WEST);
      
      public static const PLAYER_TURN_RIGHT:tibia.input.staticaction.PlayerTurn = new tibia.input.staticaction.PlayerTurn(520,"PLAYER_TURN_RIGHT",InputEvent.KEY_DOWN,tibia.input.staticaction.PlayerTurn.EAST);
      
      public static const MISC_COMBAT_PVP_WHITE_HAND:tibia.input.staticaction.CombatPVPMode = new tibia.input.staticaction.CombatPVPMode(47,"MISC_COMBAT_PVP_WHITE_HAND",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_PVP_MODE_WHITE_HAND);
      
      public static const CHAT_COPYPASTE_CUT:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(266,"CHAT_COPYPASTE_CUT",InputEvent.KEY_DOWN,true);
      
      public static const MISC_SHOW_EDIT_HOTKEYS:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(5,"MISC_SHOW_EDIT_HOTKEY",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.OPTIONS_HOTKEY);
      
      public static const MMAP_CENTER:tibia.input.staticaction.MiniMapMove = new tibia.input.staticaction.MiniMapMove(1798,"MMAP_CENTER",InputEvent.KEY_DOWN,tibia.input.staticaction.MiniMapMove.CENTER);
      
      public static const CHAT_CHANNEL_DEFAULT:tibia.input.staticaction.ChatChannelShow = new tibia.input.staticaction.ChatChannelShow(272,"CHAT_CHANNEL_DEFAULT",InputEvent.KEY_DOWN,ChatStorage.LOCAL_CHANNEL_ID);
      
      public static const CHAT_DELETE_PREV:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(261,"CHAT_DELETE_PREV",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,true);
      
      public static const CHAT_CHANNEL_SERVER:tibia.input.staticaction.ChatChannelShow = new tibia.input.staticaction.ChatChannelShow(275,"CHAT_CHANNEL_SERVER",InputEvent.KEY_DOWN,ChatStorage.SERVER_CHANNEL_ID);
      
      public static const MMAP_MOVE_DOWN:tibia.input.staticaction.MiniMapMove = new tibia.input.staticaction.MiniMapMove(1795,"MMAP_MOVE_DOWN",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.MiniMapMove.SOUTH);
      
      public static const MMAP_LAYER_UP:tibia.input.staticaction.MiniMapMove = new tibia.input.staticaction.MiniMapMove(1796,"MMAP_LAYER_UP",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.MiniMapMove.UP);
      
      public static const CHAT_MOVE_CURSOR_LEFT:tibia.input.staticaction.ChatEditText = new tibia.input.staticaction.ChatEditText(257,"CHAT_MOVE_CURSOR_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,false);
      
      public static const PLAYER_MOVE_DOWN_RIGHT:tibia.input.staticaction.PlayerMove = new tibia.input.staticaction.PlayerMove(519,"PLAYER_MOVE_DOWN_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,tibia.input.staticaction.PlayerMove.SOUTH_EAST);
      
      public static const MISC_SHOW_EDIT_IGNORELIST:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(6,"MISC_SHOW_EDIT_IGNORELIST",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.OPTIONS_NAME_FILTER);
      
      public static const MISC_TOGGLE_SIDEBAR_INNER_RIGHT:tibia.input.staticaction.ToggleSideBar = new tibia.input.staticaction.ToggleSideBar(28,"MISC_TOGGLE_SIDEBAR_INNER_RIGHT",InputEvent.KEY_DOWN,SideBarSet.LOCATION_C);
      
      public static const MISC_SHOW_CHARACTER:tibia.input.staticaction.ShowDialog = new tibia.input.staticaction.ShowDialog(9,"MISC_SHOW_CHARACTER",InputEvent.KEY_DOWN,tibia.input.staticaction.ShowDialog.CHARACTER_PROFILE);
      
      public static const MISC_TOGGLE_ACTIONBAR_BOTTOM:tibia.input.staticaction.ToggleActionBar = new tibia.input.staticaction.ToggleActionBar(41,"MISC_TOGGLE_ACTIONBAR_BOTTOM",InputEvent.KEY_DOWN,ActionBarSet.LOCATION_BOTTOM);
      
      public static const MISC_ATTACK_PREV:tibia.input.staticaction.AttackCycle = new tibia.input.staticaction.AttackCycle(16,"MISC_ATTACK_PREV",InputEvent.KEY_DOWN,tibia.input.staticaction.AttackCycle.PREV);
      
      {
         initialiseActionButtonTrigger();
      }
      
      public function StaticActionList()
      {
         super();
      }
      
      private static function initialiseActionButtonTrigger() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < ActionBar.NUM_ACTIONS)
         {
            new TriggerSlot(768 + _loc1_,"MISC_TRIGGER_SLOT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,ActionBarSet.LOCATION_TOP,_loc1_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < ActionBar.NUM_ACTIONS)
         {
            new TriggerSlot(1280 + _loc1_,"MISC_TRIGGER_SLOT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,ActionBarSet.LOCATION_LEFT,_loc1_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < ActionBar.NUM_ACTIONS)
         {
            new TriggerSlot(1536 + _loc1_,"MISC_TRIGGER_SLOT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,ActionBarSet.LOCATION_RIGHT,_loc1_);
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < ActionBar.NUM_ACTIONS)
         {
            new TriggerSlot(1024 + _loc1_,"MISC_TRIGGER_SLOT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,ActionBarSet.LOCATION_BOTTOM,_loc1_);
            _loc1_++;
         }
      }
      
      public static function getActionButtonTrigger(param1:int, param2:int) : StaticAction
      {
         if(param2 < 0 || param2 >= ActionBar.NUM_ACTIONS)
         {
            throw new RangeError("StaticActionList.getActionButtonTrigger: Invalid slot: " + param2);
         }
         switch(param1)
         {
            case ActionBarSet.LOCATION_TOP:
               return StaticAction.s_GetAction(768 + param2);
            case ActionBarSet.LOCATION_LEFT:
               return StaticAction.s_GetAction(1280 + param2);
            case ActionBarSet.LOCATION_RIGHT:
               return StaticAction.s_GetAction(1536 + param2);
            case ActionBarSet.LOCATION_BOTTOM:
               return StaticAction.s_GetAction(1024 + param2);
            default:
               throw new RangeError("StaticActionList.getActionButtonTrigger: Invalid location: " + param1);
         }
      }
   }
}
