package tibia.chat
{
   import flash.events.EventDispatcher;
   import tibia.worldmap.WorldMapStorage;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   
   public class MessageMode extends EventDispatcher
   {
      
      public static const MESSAGE_LOOT:int = 31;
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      public static const MESSAGE_WHISPER:int = 2;
      
      public static const MESSAGE_NPC_TO:int = 12;
      
      private static const MESSAGE_MODE_DEFAULTS:Array = [{
         "mode":MESSAGE_NONE,
         "label":"MESSAGE_NONE",
         "showOnscreen":false,
         "showChannel":false,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_NONE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_SAY,
         "label":"MESSAGE_SAY",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":2,
         "highlightColour":2,
         "editable":false,
         "ignoreNameFilter":false,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_COORDINATE,
         "onscreenHeader":"MESSAGE_SAY_HEADER",
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_WHISPER,
         "label":"MESSAGE_WHISPER",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":2,
         "highlightColour":2,
         "editable":false,
         "ignoreNameFilter":false,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_COORDINATE,
         "onscreenHeader":"MESSAGE_WHISPER_HEADER",
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_YELL,
         "label":"MESSAGE_YELL",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":2,
         "highlightColour":2,
         "editable":false,
         "ignoreNameFilter":false,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_COORDINATE,
         "onscreenHeader":"MESSAGE_YELL_HEADER",
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_PRIVATE_FROM,
         "label":"MESSAGE_PRIVATE_FROM",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":6,
         "highlightColour":6,
         "editable":true,
         "ignoreNameFilter":false,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_TOP,
         "onscreenHeader":null,
         "onscreenPrefix":"MESSAGE_PRIVATE_FROM_PREFIX"
      },{
         "mode":MESSAGE_PRIVATE_TO,
         "label":"MESSAGE_PRIVATE_TO",
         "showOnscreen":false,
         "showChannel":true,
         "textColour":7,
         "highlightColour":7,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_NONE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_CHANNEL_MANAGEMENT,
         "label":"MESSAGE_CHANNEL_MANAGEMENT",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_HIGH,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_CHANNEL,
         "label":"MESSAGE_CHANNEL",
         "showOnscreen":false,
         "showChannel":true,
         "textColour":2,
         "highlightColour":2,
         "editable":false,
         "ignoreNameFilter":false,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_NONE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_CHANNEL_HIGHLIGHT,
         "label":"MESSAGE_CHANNEL_HIGHLIGHT",
         "showOnscreen":false,
         "showChannel":true,
         "textColour":1,
         "highlightColour":1,
         "editable":false,
         "ignoreNameFilter":false,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_NONE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_SPELL,
         "label":"MESSAGE_SPELL",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":2,
         "highlightColour":2,
         "editable":true,
         "ignoreNameFilter":false,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_COORDINATE,
         "onscreenHeader":"MESSAGE_SPELL_HEADER",
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_NPC_FROM_START_BLOCK,
         "label":"MESSAGE_NPC_FROM_START_BLOCK",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":6,
         "highlightColour":5,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_COORDINATE,
         "onscreenHeader":"MESSAGE_NPC_FROM_START_BLOCK_HEADER",
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_NPC_FROM,
         "label":"MESSAGE_NPC_FROM",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":6,
         "highlightColour":5,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_COORDINATE,
         "onscreenHeader":"MESSAGE_NPC_FROM_HEADER",
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_NPC_TO,
         "label":"MESSAGE_NPC_TO",
         "showOnscreen":false,
         "showChannel":true,
         "textColour":7,
         "highlightColour":7,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_NONE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_GAMEMASTER_BROADCAST,
         "label":"MESSAGE_GAMEMASTER_BROADCAST",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":0,
         "highlightColour":0,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_LOW,
         "onscreenHeader":null,
         "onscreenPrefix":"MESSAGE_GAMEMASTER_BROADCAST_PREFIX"
      },{
         "mode":MESSAGE_GAMEMASTER_CHANNEL,
         "label":"MESSAGE_GAMEMASTER_CHANNEL",
         "showOnscreen":false,
         "showChannel":true,
         "textColour":0,
         "highlightColour":0,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_NONE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_GAMEMASTER_PRIVATE_FROM,
         "label":"MESSAGE_GAMEMASTER_PRIVATE_FROM",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":0,
         "highlightColour":0,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_LOW,
         "onscreenHeader":null,
         "onscreenPrefix":"MESSAGE_GAMEMASTER_PRIVATE_FROM_PREFIX"
      },{
         "mode":MESSAGE_GAMEMASTER_PRIVATE_TO,
         "label":"MESSAGE_GAMEMASTER_PRIVATE_TO",
         "showOnscreen":false,
         "showChannel":true,
         "textColour":7,
         "highlightColour":7,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_TOP,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_LOGIN,
         "label":"MESSAGE_LOGIN",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_BOTTOM,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_ADMIN,
         "label":"MESSAGE_ADMIN",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":0,
         "highlightColour":0,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_LOW,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_GAME,
         "label":"MESSAGE_GAME",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_LOW,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_GAME_HIGHLIGHT,
         "label":"MESSAGE_GAME_HIGHLIGHT",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":0,
         "highlightColour":0,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_LOW,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_FAILURE,
         "label":"MESSAGE_FAILURE",
         "showOnscreen":true,
         "showChannel":false,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_BOTTOM,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_LOOK,
         "label":"MESSAGE_LOOK",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_HIGH,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_DAMAGE_DEALED,
         "label":"MESSAGE_DAMAGE_DEALED",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_EFFECT_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_DAMAGE_RECEIVED,
         "label":"MESSAGE_DAMAGE_RECEIVED",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_EFFECT_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_HEAL,
         "label":"MESSAGE_HEAL",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_EFFECT_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_EXP,
         "label":"MESSAGE_EXP",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_EFFECT_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_DAMAGE_OTHERS,
         "label":"MESSAGE_DAMAGE_OTHERS",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_EFFECT_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_HEAL_OTHERS,
         "label":"MESSAGE_HEAL_OTHERS",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_EFFECT_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_EXP_OTHERS,
         "label":"MESSAGE_EXP_OTHERS",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_EFFECT_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_STATUS,
         "label":"MESSAGE_STATUS",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_BOTTOM,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_LOOT,
         "label":"MESSAGE_LOOT",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":3,
         "highlightColour":3,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_HIGH,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_TRADE_NPC,
         "label":"MESSAGE_TRADE_NPC",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":3,
         "highlightColour":3,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_HIGH,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_GUILD,
         "label":"MESSAGE_GUILD",
         "showOnscreen":false,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_LOW,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_PARTY_MANAGEMENT,
         "label":"MESSAGE_PARTY_MANAGEMENT",
         "showOnscreen":false,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_NONE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_PARTY,
         "label":"MESSAGE_PARTY",
         "showOnscreen":false,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_LOW,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_BARK_LOW,
         "label":"MESSAGE_BARK_LOW",
         "showOnscreen":true,
         "showChannel":false,
         "textColour":1,
         "highlightColour":1,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_BARK_LOUD,
         "label":"MESSAGE_BARK_LOUD",
         "showOnscreen":true,
         "showChannel":false,
         "textColour":1,
         "highlightColour":1,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_REPORT,
         "label":"MESSAGE_REPORT",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_LOW,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_HOTKEY_USE,
         "label":"MESSAGE_HOTKEY_USE",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":3,
         "highlightColour":3,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_BOTTOM,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_TUTORIAL_HINT,
         "label":"MESSAGE_HOTKEY_USE",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_BOTTOM,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_THANKYOU,
         "label":"MESSAGE_THANKYOU",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_BOX_LOW,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_MARKET,
         "label":"MESSAGE_MARKET",
         "showOnscreen":false,
         "showChannel":false,
         "textColour":0,
         "highlightColour":0,
         "editable":false,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_NONE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      },{
         "mode":MESSAGE_MANA,
         "label":"MESSAGE_MANA",
         "showOnscreen":true,
         "showChannel":true,
         "textColour":11,
         "highlightColour":11,
         "editable":true,
         "ignoreNameFilter":true,
         "onscreenTarget":WorldMapStorage.ONSCREEN_TARGET_EFFECT_COORDINATE,
         "onscreenHeader":null,
         "onscreenPrefix":null
      }];
      
      public static const MESSAGE_FAILURE:int = 21;
      
      public static const MESSAGE_BARK_LOUD:int = 37;
      
      public static const MESSAGE_PRIVATE_TO:int = 5;
      
      public static const MESSAGE_NPC_FROM_START_BLOCK:int = 10;
      
      public static const MESSAGE_GAMEMASTER_PRIVATE_FROM:int = 15;
      
      public static const MESSAGE_EXP_OTHERS:int = 29;
      
      public static const MESSAGE_HEAL:int = 25;
      
      public static const MESSAGE_HEAL_OTHERS:int = 28;
      
      public static const MESSAGE_STATUS:int = 30;
      
      public static const MESSAGE_THANKYOU:int = 41;
      
      public static const MESSAGE_GAMEMASTER_BROADCAST:int = 13;
      
      public static const MESSAGE_GAME:int = 19;
      
      public static const MESSAGE_DAMAGE_RECEIVED:int = 24;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
      
      public static const MESSAGE_PRIVATE_FROM:int = 4;
      
      public static const MESSAGE_BEYOND_LAST:int = 44;
      
      public static const MESSAGE_TUTORIAL_HINT:int = 40;
      
      public static const MESSAGE_SAY:int = 1;
      
      public static const MESSAGE_PARTY:int = 35;
      
      public static const MESSAGE_CHANNEL_MANAGEMENT:int = 6;
      
      public static const MESSAGE_GUILD:int = 33;
      
      private static const BUNDLE:String = "MessageMode";
      
      public static const MESSAGE_DAMAGE_DEALED:int = 23;
      
      public static const MESSAGE_BARK_LOW:int = 36;
      
      public static const MESSAGE_CHANNEL:int = 7;
      
      public static const MESSAGE_REPORT:int = 38;
      
      public static const MESSAGE_NONE:int = 0;
      
      public static const MESSAGE_MANA:int = 43;
      
      public static const MESSAGE_EXP:int = 26;
      
      public static const MESSAGE_MARKET:int = 42;
      
      public static const MESSAGE_SPELL:int = 9;
      
      public static const MESSAGE_PARTY_MANAGEMENT:int = 34;
      
      public static const MESSAGE_MODE_COLOURS:Array = [4291310080,4291590707,4290750256,4286044524,4281505330,4281774297,4283007474,4288380927,4290732223,4289943924,4286743170,4290690750];
      
      public static const MESSAGE_NPC_FROM:int = 11;
      
      public static const MESSAGE_GAMEMASTER_PRIVATE_TO:int = 16;
      
      public static const MESSAGE_GAMEMASTER_CHANNEL:int = 14;
      
      public static const MESSAGE_ADMIN:int = 18;
      
      public static const MESSAGE_DAMAGE_OTHERS:int = 27;
      
      public static const MESSAGE_GAME_HIGHLIGHT:int = 20;
      
      public static const MESSAGE_CHANNEL_HIGHLIGHT:int = 8;
      
      public static const MESSAGE_YELL:int = 3;
      
      public static const MESSAGE_LOGIN:int = 17;
      
      public static const MESSAGE_HOTKEY_USE:int = 39;
      
      public static const MESSAGE_LOOK:int = 22;
      
      public static const MESSAGE_TRADE_NPC:int = 32;
       
      
      protected var m_TextColour:uint = 0;
      
      protected var m_ShowOnscreenMessage:Boolean = true;
      
      protected var m_ShowChannelMessage:Boolean = true;
      
      protected var m_ID:int = 0;
      
      protected var m_HighlightColour:uint = 0;
      
      public function MessageMode(param1:int)
      {
         super();
         if(!MessageMode.s_CheckMode(param1))
         {
            throw new ArgumentError("MessageMode.MessageMode: Invalid mode ID: " + param1 + ".");
         }
         this.m_ID = param1;
         this.initialiseDefaultValues();
      }
      
      public static function s_CheckMode(param1:int) : Boolean
      {
         return param1 >= 0 && param1 < MessageMode.MESSAGE_BEYOND_LAST;
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : MessageMode
      {
         var _loc4_:int = 0;
         if(param1 == null || param1.localName() != "messagemode" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("MessageFilterSet.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@id) == null || _loc3_.length() != 1)
         {
            return null;
         }
         _loc4_ = parseInt(_loc3_[0].toString());
         var _loc5_:MessageMode = new MessageMode(_loc4_);
         if((_loc3_ = param1.@gamewindow) != null && _loc3_.length() == 1)
         {
            _loc5_.showOnscreenMessage = _loc3_[0].toString() == "true";
         }
         if((_loc3_ = param1.@channel) != null && _loc3_.length() == 1)
         {
            _loc5_.showChannelMessage = _loc3_[0].toString() == "true";
         }
         if((_loc3_ = param1.@textcolour) != null && _loc3_.length() == 1)
         {
            _loc5_.textColour = parseInt(_loc3_[0].toString());
         }
         return _loc5_;
      }
      
      public function get highlightARGB() : uint
      {
         return MESSAGE_MODE_COLOURS[this.m_HighlightColour];
      }
      
      [Bindable(event="propertyChange")]
      public function set showChannelMessage(param1:Boolean) : void
      {
         var _loc2_:Object = this.showChannelMessage;
         if(_loc2_ !== param1)
         {
            this._1918118369showChannelMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showChannelMessage",_loc2_,param1));
         }
      }
      
      public function set highlightColour(param1:uint) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         param1 = Math.max(0,Math.min(param1,MESSAGE_MODE_COLOURS.length));
         if(this.m_HighlightColour != param1)
         {
            this.m_HighlightColour = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.property = "highlightColour";
            dispatchEvent(_loc2_);
         }
      }
      
      public function initialiseDefaultValues() : void
      {
         this.showOnscreenMessage = MESSAGE_MODE_DEFAULTS[this.m_ID].showOnscreen;
         this.showChannelMessage = MESSAGE_MODE_DEFAULTS[this.m_ID].showChannel;
         this.textColour = MESSAGE_MODE_DEFAULTS[this.m_ID].textColour;
         this.highlightColour = MESSAGE_MODE_DEFAULTS[this.m_ID].highlightColour;
      }
      
      public function marshall() : XML
      {
         return <messagemode id="{this.m_ID}" gamewindow="{this.m_ShowOnscreenMessage}" channel="{this.m_ShowChannelMessage}" textcolour="{this.m_TextColour}"/>;
      }
      
      public function get ignoreNameFilter() : Boolean
      {
         return MESSAGE_MODE_DEFAULTS[this.m_ID].ignoreNameFilter;
      }
      
      public function get textColour() : uint
      {
         return this.m_TextColour;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function get highlightColour() : uint
      {
         return this.m_HighlightColour;
      }
      
      public function get showChannelMessage() : Boolean
      {
         return this.m_ShowChannelMessage;
      }
      
      public function get editable() : Boolean
      {
         return MESSAGE_MODE_DEFAULTS[this.m_ID].editable;
      }
      
      private function set _1918118369showChannelMessage(param1:Boolean) : void
      {
         this.m_ShowChannelMessage = param1;
      }
      
      private function set _1720343999showOnscreenMessage(param1:Boolean) : void
      {
         this.m_ShowOnscreenMessage = param1;
      }
      
      override public function toString() : String
      {
         return ResourceManager.getInstance().getString(BUNDLE,MESSAGE_MODE_DEFAULTS[this.m_ID].label);
      }
      
      public function set textColour(param1:uint) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         param1 = Math.max(0,Math.min(param1,MESSAGE_MODE_COLOURS.length));
         if(this.m_TextColour != param1)
         {
            this.m_TextColour = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.property = "textColour";
            dispatchEvent(_loc2_);
         }
      }
      
      public function getOnscreenMessagePrefix(... rest) : String
      {
         var _loc2_:String = MESSAGE_MODE_DEFAULTS[this.m_ID].onscreenPrefix;
         if(_loc2_ != null)
         {
            _loc2_ = ResourceManager.getInstance().getString(BUNDLE,_loc2_,rest);
         }
         return _loc2_;
      }
      
      public function get textARGB() : uint
      {
         return MESSAGE_MODE_COLOURS[this.m_TextColour];
      }
      
      public function getOnscreenMessageHeader(... rest) : String
      {
         var _loc2_:String = MESSAGE_MODE_DEFAULTS[this.m_ID].onscreenHeader;
         if(_loc2_ != null)
         {
            _loc2_ = ResourceManager.getInstance().getString(BUNDLE,_loc2_,rest);
         }
         return _loc2_;
      }
      
      public function get onscreenTarget() : int
      {
         return MESSAGE_MODE_DEFAULTS[this.m_ID].onscreenTarget;
      }
      
      [Bindable(event="propertyChange")]
      public function set showOnscreenMessage(param1:Boolean) : void
      {
         var _loc2_:Object = this.showOnscreenMessage;
         if(_loc2_ !== param1)
         {
            this._1720343999showOnscreenMessage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showOnscreenMessage",_loc2_,param1));
         }
      }
      
      public function get showOnscreenMessage() : Boolean
      {
         return this.m_ShowOnscreenMessage;
      }
   }
}
