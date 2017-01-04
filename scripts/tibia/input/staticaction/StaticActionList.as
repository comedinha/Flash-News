package tibia.input.staticaction
{
   import tibia.actionbar.ActionBar;
   import tibia.actionbar.ActionBarSet;
   import tibia.chat.ChatStorage;
   import tibia.input.InputEvent;
   import tibia.options.OptionsStorage;
   import tibia.sidebar.SideBarSet;
   import tibia.sidebar.Widget;
   
   public class StaticActionList
   {
      
      public static const CHAT_COPYPASTE_INSERT:ChatEditText = new ChatEditText(265,"CHAT_COPYPASTE_INSERT",InputEvent.KEY_DOWN,true);
      
      public static const MISC_ROOT_CONTAINER:OpenRootContainer = new OpenRootContainer(19,"MISC_ROOT_CONTAINER",InputEvent.KEY_DOWN);
      
      public static const MISC_SHOW_WIDGET_BUDDYLIST:ShowWidget = new ShowWidget(36,"MISC_SHOW_WIDGET_BUDDYLIST",InputEvent.KEY_DOWN,Widget.TYPE_BUDDYLIST);
      
      public static const MISC_COMBAT_PVP_YELLOW_HAND:CombatPVPMode = new CombatPVPMode(48,"MISC_COMBAT_PVP_YELLOW_HAND",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_PVP_MODE_YELLOW_HAND);
      
      public static const MISC_COMBAT_SECURE:CombatSecureMode = new CombatSecureMode(27,"MISC_COMBAT_SECURE",InputEvent.KEY_DOWN);
      
      public static const MISC_TOGGLE_ACTIONBAR_RIGHT:ToggleActionBar = new ToggleActionBar(40,"MISC_TOGGLE_ACTIONBAR_RIGHT",InputEvent.KEY_DOWN,ActionBarSet.LOCATION_RIGHT);
      
      public static const MISC_AUTOFIT_GAMEWINDOW:AutofitGameWindow = new AutofitGameWindow(42,"MISC_AUTOFIT_GAMEWINDOW",InputEvent.KEY_DOWN);
      
      public static const MISC_TOGGLE_LOCK_MODE:ToggleActionBarsLock = new ToggleActionBarsLock(44,"MISC_TOGGLE_LOCK_MODE",InputEvent.KEY_DOWN);
      
      public static const MISC_SHOW_QUEST_LOG:ShowDialog = new ShowDialog(22,"MISC_SHOW_QUEST_LOG",InputEvent.KEY_DOWN,ShowDialog.HELP_QUEST_LOG);
      
      public static const PLAYER_MOUNT:PlayerMount = new PlayerMount(525,"PLAYER_MOUNT",InputEvent.KEY_DOWN);
      
      public static const MISC_COMBAT_OFFENSIVE:CombatAttackMode = new CombatAttackMode(25,"MISC_COMBAT_OFFENSIVE",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_ATTACK_OFFENSIVE);
      
      public static const MISC_COMBAT_PVP_DOVE:CombatPVPMode = new CombatPVPMode(46,"MISC_COMBAT_PVP_DOVE",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_PVP_MODE_DOVE);
      
      public static const PLAYER_MOVE_UP_RIGHT:PlayerMove = new PlayerMove(513,"PLAYER_MOVE_UP_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,PlayerMove.NORTH_EAST);
      
      public static const MISC_CHANGE_CHARACTER:ChangeCharacter = new ChangeCharacter(12,"MISC_CHANGE_CHARACTER",InputEvent.KEY_DOWN);
      
      public static const MISC_SHOW_PREY_DIALOG:ShowDialog = new ShowDialog(50,"MISC_SHOW_PREY_DIALOG",InputEvent.KEY_DOWN,ShowDialog.PREY_DIALOG);
      
      public static const PLAYER_MOVE_RIGHT:PlayerMove = new PlayerMove(512,"PLAYER_MOVE_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,PlayerMove.EAST);
      
      public static const MISC_COMBAT_CHASE:CombatChaseMode = new CombatChaseMode(26,"MISC_COMBAT_CHASE",InputEvent.KEY_DOWN);
      
      public static const MMAP_ZOOM_OUT:MiniMapZoom = new MiniMapZoom(1800,"MMAP_ZOOM_OUT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,-1);
      
      public static const MISC_SHOW_WIDGET_BATTLELIST:ShowWidget = new ShowWidget(37,"MISC_SHOW_WIDGET_BATTLELIST",InputEvent.KEY_DOWN,Widget.TYPE_BATTLELIST);
      
      public static const MISC_COMBAT_DEFENSIVE:CombatAttackMode = new CombatAttackMode(24,"MISC_COMBAT_DEFENSIVE",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_ATTACK_DEFENSIVE);
      
      public static const PLAYER_TURN_UP:PlayerTurn = new PlayerTurn(521,"PLAYER_TURN_UP",InputEvent.KEY_DOWN,PlayerTurn.NORTH);
      
      public static const MISC_TOGGLE_ACTIONBAR_LEFT:ToggleActionBar = new ToggleActionBar(39,"MISC_TOGGLE_ACTIONBAR_LEFT",InputEvent.KEY_DOWN,ActionBarSet.LOCATION_LEFT);
      
      public static const MISC_SEND_BUG_REPORT:SendBugReport = new SendBugReport(21,"MISC_SEND_BUG_REPORT",InputEvent.KEY_DOWN);
      
      public static const MMAP_MOVE_LEFT:MiniMapMove = new MiniMapMove(1794,"MMAP_MOVE_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,MiniMapMove.WEST);
      
      public static const PLAYER_TURN_DOWN:PlayerTurn = new PlayerTurn(523,"PLAYER_TURN_DOWN",InputEvent.KEY_DOWN,PlayerTurn.SOUTH);
      
      public static const MISC_SHOW_WIDGET_MINIMAP:ShowWidget = new ShowWidget(34,"MISC_SHOW_WIDGET_MINIMAP",InputEvent.KEY_DOWN,Widget.TYPE_MINIMAP);
      
      public static const CHAT_COPYPASTE_SELECT:ChatEditText = new ChatEditText(263,"CHAT_COPYPASTE_SELECT",InputEvent.KEY_DOWN,true);
      
      public static const MISC_SHOW_EDIT_MESSAGES:ShowDialog = new ShowDialog(7,"MISC_SHOW_EDIT_MESSAGE",InputEvent.KEY_DOWN,ShowDialog.OPTIONS_MESSAGE);
      
      public static const CHAT_CHANNEL_NEXT:ChatTabCycle = new ChatTabCycle(273,"CHAT_CHANNEL_NEXT",InputEvent.KEY_DOWN,ChatTabCycle.NEXT);
      
      public static const MISC_MAPPING_NEXT:MappingSetCycle = new MappingSetCycle(13,"MISC_MAPPING_NEXT",InputEvent.KEY_DOWN,MappingSetCycle.NEXT);
      
      public static const MMAP_MOVE_UP:MiniMapMove = new MiniMapMove(1793,"MMAP_MOVE_UP",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,MiniMapMove.NORTH);
      
      public static const PLAYER_MOVE_UP_LEFT:PlayerMove = new PlayerMove(515,"PLAYER_MOVE_UP_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,PlayerMove.NORTH_WEST);
      
      public static const CHAT_SEND_TEXT:ChatSendText = new ChatSendText(269,"CHAT_SEND_TEXT",InputEvent.KEY_DOWN,true);
      
      public static const CHAT_TEXT_INPUT:ChatEditText = new ChatEditText(256,"CHAT_TEXT_INPUT",InputEvent.TEXT_INPUT,true);
      
      public static const MMAP_LAYER_DOWN:MiniMapMove = new MiniMapMove(1797,"MMAP_LAYER_DOWN",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,MiniMapMove.DOWN);
      
      public static const CHAT_HISTORY_NEXT:ChatEditText = new ChatEditText(268,"CHAT_HISTORY_NEXT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,false);
      
      public static const CHAT_MOVE_CURSOR_RIGHT:ChatEditText = new ChatEditText(258,"CHAT_MOVE_CURSOR_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,false);
      
      public static const CHAT_CHANNEL_CLOSE_SECONDARY:ChatChannelClose = new ChatChannelClose(276,"CHAT_CHANNEL_CLOSE_SECONDARY",InputEvent.KEY_DOWN,false);
      
      public static const PLAYER_MOVE_UP:PlayerMove = new PlayerMove(514,"PLAYER_MOVE_UP",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,PlayerMove.NORTH);
      
      public static const PLAYER_MOVE_DOWN:PlayerMove = new PlayerMove(518,"PLAYER_MOVE_DOWN",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,PlayerMove.SOUTH);
      
      public static const MISC_SHOW_WIDGET_GENERALBUTTONS:ShowWidget = new ShowWidget(32,"MISC_SHOW_WIDGET_GENERALBUTTONS",InputEvent.KEY_DOWN,Widget.TYPE_GENERALBUTTONS);
      
      public static const MISC_TOGGLE_SIDEBAR_OUTER_RIGHT:ToggleSideBar = new ToggleSideBar(29,"MISC_TOGGLE_SIDEBAR_OUTER_RIGHT",InputEvent.KEY_DOWN,SideBarSet.LOCATION_D);
      
      public static const CHAT_CHANNEL_CLOSE_PRIMARY:ChatChannelClose = new ChatChannelClose(271,"CHAT_CHANNEL_CLOSE_PRIMARY",InputEvent.KEY_DOWN,true);
      
      public static const MISC_SHOW_WIDGET_SPELLLIST:ShowWidget = new ShowWidget(45,"MISC_SHOW_WIDGET_SPELLLIST",InputEvent.KEY_DOWN,Widget.TYPE_SPELLLIST);
      
      public static const MISC_SHOW_WIDGET_COMBATCONTROL:ShowWidget = new ShowWidget(33,"MISC_SHOW_WIDGET_COMBATCONTROL",InputEvent.KEY_DOWN,Widget.TYPE_COMBATCONTROL);
      
      public static const MISC_SHOW_EDIT_STATUS:ShowDialog = new ShowDialog(20,"MISC_SHOW_EDIT_STATUS",InputEvent.KEY_DOWN,ShowDialog.OPTIONS_STATUS);
      
      public static const MISC_EXPIRE_ONSCREEN_MESSAGE:ExpireOnScreenMessage = new ExpireOnScreenMessage(3,"MISC_EXPIRE_ONSCREEN_MESSAGE",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT);
      
      private static const BUNDLE:String = "StaticAction";
      
      public static const MMAP_MOVE_RIGHT:MiniMapMove = new MiniMapMove(1792,"MMAP_MOVE_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,MiniMapMove.EAST);
      
      public static const MISC_LOGOUT_CHARACTER:LogoutCharacter = new LogoutCharacter(11,"MISC_LOGOUT_CHARACTER",InputEvent.KEY_DOWN);
      
      public static const MISC_TOGGLE_SIDEBAR_INNER_LEFT:ToggleSideBar = new ToggleSideBar(30,"MISC_TOGGLE_SIDEBAR_INNER_LEFT",InputEvent.KEY_DOWN,SideBarSet.LOCATION_B);
      
      public static const MISC_TOGGLE_SIDEBAR_OUTER_LEFT:ToggleSideBar = new ToggleSideBar(31,"MISC_TOGGLE_SIDEBAR_OUTER_LEFT",InputEvent.KEY_DOWN,SideBarSet.LOCATION_A);
      
      public static const MISC_TOGGLE_STATUSBAR:ToggleStatusBar = new ToggleStatusBar(43,"MISC_TOGGLE_STATUSBAR",InputEvent.KEY_DOWN);
      
      public static const MISC_SHOW_EDIT_GRAPHICS:ShowDialog = new ShowDialog(8,"MISC_SHOW_EDIT_RENDERER",InputEvent.KEY_DOWN,ShowDialog.OPTIONS_RENDERER);
      
      public static const CHAT_CHANNEL_PREV:ChatTabCycle = new ChatTabCycle(274,"CHAT_CHANNEL_PREV",InputEvent.KEY_DOWN,ChatTabCycle.PREV);
      
      public static const MISC_MAPPING_PREV:MappingSetCycle = new MappingSetCycle(14,"MISC_MAPPING_PREV",InputEvent.KEY_DOWN,MappingSetCycle.PREV);
      
      public static const PLAYER_CANCEL:PlayerCancel = new PlayerCancel(524,"PLAYER_CANCEL",InputEvent.KEY_DOWN);
      
      public static const CHAT_MOVE_CURSOR_END:ChatEditText = new ChatEditText(260,"CHAT_MOVE_CURSOR_END",InputEvent.KEY_DOWN,true);
      
      public static const MISC_SHOW_WIDGET_BODY:ShowWidget = new ShowWidget(35,"MISC_SHOW_WIDGET_BODY",InputEvent.KEY_DOWN,Widget.TYPE_BODY);
      
      public static const MISC_COMBAT_PVP_RED_FIST:CombatPVPMode = new CombatPVPMode(49,"MISC_COMBAT_PVP_RED_FIST",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_PVP_MODE_RED_FIST);
      
      public static const MISC_COMBAT_BALANCED:CombatAttackMode = new CombatAttackMode(23,"MISC_COMBAT_BALANCED",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_ATTACK_BALANCED);
      
      public static const MMAP_ZOOM_IN:MiniMapZoom = new MiniMapZoom(1799,"MMAP_ZOOM_IN",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,1);
      
      public static const CHAT_HISTORY_PREV:ChatEditText = new ChatEditText(267,"CHAT_HISTORY_PREV",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,false);
      
      public static const CHAT_DELETE_NEXT:ChatEditText = new ChatEditText(262,"CHAT_DELETE_NEXT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,true);
      
      public static const CHAT_CHANNEL_OPEN:ShowDialog = new ShowDialog(270,"CHAT_CHANNEL_OPEN",InputEvent.KEY_DOWN,ShowDialog.CHAT_CHANNEL_SELECTION);
      
      public static const PLAYER_TURN_LEFT:PlayerTurn = new PlayerTurn(522,"PLAYER_TURN_LEFT",InputEvent.KEY_DOWN,PlayerTurn.WEST);
      
      public static const MISC_ATTACK_NEXT:AttackCycle = new AttackCycle(15,"MISC_ATTACK_NEXT",InputEvent.KEY_DOWN,AttackCycle.NEXT);
      
      public static const MISC_SHOW_EDIT_OPTIONS:ShowDialog = new ShowDialog(4,"MISC_SHOW_EDIT_GENERAL",InputEvent.KEY_DOWN,ShowDialog.OPTIONS_GENERAL);
      
      public static const MISC_SHOW_OUTFIT:ShowDialog = new ShowDialog(18,"MISC_SHOW_OUTFIT",InputEvent.KEY_DOWN,ShowDialog.CHARACTER_OUTFIT);
      
      public static const CHAT_COPYPASTE_COPY:ChatEditText = new ChatEditText(264,"CHAT_COPYPASTE_COPY",InputEvent.KEY_DOWN,true);
      
      public static const CHAT_MOVE_CURSOR_HOME:ChatEditText = new ChatEditText(259,"CHAT_MOVE_CURSOR_HOME",InputEvent.KEY_DOWN,true);
      
      public static const MISC_TOGGLE_ACTIONBAR_TOP:ToggleActionBar = new ToggleActionBar(38,"MISC_TOGGLE_ACTIONBAR_TOP",InputEvent.KEY_DOWN,ActionBarSet.LOCATION_TOP);
      
      public static const PLAYER_MOVE_DOWN_LEFT:PlayerMove = new PlayerMove(517,"PLAYER_MOVE_DOWN_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,PlayerMove.SOUTH_WEST);
      
      public static const MISC_TOGGLE_MAPPING_MODE:ToggleMappingMode = new ToggleMappingMode(1,"MISC_TOGGLE_MAPPING_MODE",InputEvent.KEY_DOWN);
      
      public static const PLAYER_MOVE_LEFT:PlayerMove = new PlayerMove(516,"PLAYER_MOVE_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,PlayerMove.WEST);
      
      public static const PLAYER_TURN_RIGHT:PlayerTurn = new PlayerTurn(520,"PLAYER_TURN_RIGHT",InputEvent.KEY_DOWN,PlayerTurn.EAST);
      
      public static const MISC_COMBAT_PVP_WHITE_HAND:CombatPVPMode = new CombatPVPMode(47,"MISC_COMBAT_PVP_WHITE_HAND",InputEvent.KEY_DOWN,OptionsStorage.COMBAT_PVP_MODE_WHITE_HAND);
      
      public static const CHAT_COPYPASTE_CUT:ChatEditText = new ChatEditText(266,"CHAT_COPYPASTE_CUT",InputEvent.KEY_DOWN,true);
      
      public static const MISC_SHOW_EDIT_HOTKEYS:ShowDialog = new ShowDialog(5,"MISC_SHOW_EDIT_HOTKEY",InputEvent.KEY_DOWN,ShowDialog.OPTIONS_HOTKEY);
      
      public static const MMAP_CENTER:MiniMapMove = new MiniMapMove(1798,"MMAP_CENTER",InputEvent.KEY_DOWN,MiniMapMove.CENTER);
      
      public static const CHAT_CHANNEL_DEFAULT:ChatChannelShow = new ChatChannelShow(272,"CHAT_CHANNEL_DEFAULT",InputEvent.KEY_DOWN,ChatStorage.LOCAL_CHANNEL_ID);
      
      public static const CHAT_DELETE_PREV:ChatEditText = new ChatEditText(261,"CHAT_DELETE_PREV",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,true);
      
      public static const CHAT_CHANNEL_SERVER:ChatChannelShow = new ChatChannelShow(275,"CHAT_CHANNEL_SERVER",InputEvent.KEY_DOWN,ChatStorage.SERVER_CHANNEL_ID);
      
      public static const MMAP_MOVE_DOWN:MiniMapMove = new MiniMapMove(1795,"MMAP_MOVE_DOWN",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,MiniMapMove.SOUTH);
      
      public static const MMAP_LAYER_UP:MiniMapMove = new MiniMapMove(1796,"MMAP_LAYER_UP",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,MiniMapMove.UP);
      
      public static const CHAT_MOVE_CURSOR_LEFT:ChatEditText = new ChatEditText(257,"CHAT_MOVE_CURSOR_LEFT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,false);
      
      public static const PLAYER_MOVE_DOWN_RIGHT:PlayerMove = new PlayerMove(519,"PLAYER_MOVE_DOWN_RIGHT",InputEvent.KEY_DOWN | InputEvent.KEY_REPEAT,PlayerMove.SOUTH_EAST);
      
      public static const MISC_SHOW_EDIT_IGNORELIST:ShowDialog = new ShowDialog(6,"MISC_SHOW_EDIT_IGNORELIST",InputEvent.KEY_DOWN,ShowDialog.OPTIONS_NAME_FILTER);
      
      public static const MISC_TOGGLE_SIDEBAR_INNER_RIGHT:ToggleSideBar = new ToggleSideBar(28,"MISC_TOGGLE_SIDEBAR_INNER_RIGHT",InputEvent.KEY_DOWN,SideBarSet.LOCATION_C);
      
      public static const MISC_SHOW_CHARACTER:ShowDialog = new ShowDialog(9,"MISC_SHOW_CHARACTER",InputEvent.KEY_DOWN,ShowDialog.CHARACTER_PROFILE);
      
      public static const MISC_TOGGLE_ACTIONBAR_BOTTOM:ToggleActionBar = new ToggleActionBar(41,"MISC_TOGGLE_ACTIONBAR_BOTTOM",InputEvent.KEY_DOWN,ActionBarSet.LOCATION_BOTTOM);
      
      public static const MISC_ATTACK_PREV:AttackCycle = new AttackCycle(16,"MISC_ATTACK_PREV",InputEvent.KEY_DOWN,AttackCycle.PREV);
      
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
