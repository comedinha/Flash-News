package tibia.sessiondump.hints
{
   import tibia.appearances.OutfitInstance;
   
   public class SessiondumpHints
   {
      
      private static var FIELD_TEXTHINT:String = "texthint";
      
      private static var FIELD_COORDINATE:String = "coordinate";
      
      private static var FIELD_SESSIONDUMP:String = "sessiondump";
      
      private static var FIELD_DESTINATION_COORDINATE:String = "destination";
      
      private static var FIELD_CONDITIONDATA:String = "conditiondata";
      
      private static var FIELD_CHANNEL:String = "channel";
      
      private static var FIELD_TYPE:String = "type";
      
      private static var FIELD_CONDITIONTYPE:String = "conditiontype";
      
      private static var FIELD_USE_TYPE_ID:String = "usetypeid";
      
      private static var FIELD_PLAYER_OUTFIT_COLOR_TORSO:String = "color-torso";
      
      private static var FIELD_OBJECTTYPE:String = "objecttype";
      
      private static var CONDITION_TYPE_CLICK_CREATURE:String = "CLICK_CREATURE";
      
      private static var FIELD_OFFSET:String = "offset";
      
      private static var FIELD_OBJECTTYPEID:String = "objecttypeid";
      
      private static var FIELD_POSITION:String = "position";
      
      private static var FIELD_TARGET:String = "target";
      
      private static var FIELD_PLAYER_OUTFIT:String = "player-outfit";
      
      private static var FIELD_UIELEMENT:String = "uielement";
      
      private static var FIELD_PLAYER_OUTFIT_COLOR_DETAIL:String = "color-detail";
      
      private static var FIELD_MULTIUSE_TARGET:String = "multiusetarget";
      
      private static var FIELD_CHANNEL_ID:String = "channelid";
      
      private static var FIELD_CREATURE_ID:String = "creatureid";
      
      private static var CONDITION_TYPE_DRAG_DROP:String = "DRAG_DROP";
      
      private static var FIELD_MULTIUSE_OBJECT_POSITION:String = "multiuseobjectposition";
      
      private static var FIELD_PLAYER_NAME:String = "player-name";
      
      private static var FIELD_PLAYER_OUTFIT_ID:String = "id";
      
      private static var FIELD_PLAYER_OUTFIT_COLOR_LEGS:String = "color-legs";
      
      private static var FIELD_SKIP_TO_TIMESTAMP:String = "skiptotimestamp";
      
      private static var FIELD_MULTIUSE_OBJECT_ID:String = "multiuseobjectid";
      
      private static var FIELD_TUTORIAL_PROGRESS:String = "tutorialprogress";
      
      private static var FIELD_TIMESTAMP:String = "timestamp";
      
      private static var FIELD_USEDESTINATIONPOSITION:String = "usedestinationposition";
      
      private static var FIELD_PLAYER_OUTFIT_ADDONS:String = "add-ons";
      
      private static var FIELD_AMOUNT:String = "amount";
      
      private static var FIELD_OBJECTID:String = "objectid";
      
      private static var FIELD_CREATURE_NAME:String = "creaturename";
      
      private static var CONDITION_TYPE_CLICK:String = "CLICK";
      
      private static var FIELD_OBJECTDATA:String = "objectdata";
      
      private static var FIELD_TEXT:String = "text";
      
      private static var FIELD_OBJECTINDEX:String = "objectindex";
      
      private static var FIELD_SOURCE_COORDINATE:String = "source";
      
      private static var FIELD_PLAYER_OUTFIT_COLOR_HEAD:String = "color-head";
       
      
      private var m_PlayerOutfit:OutfitInstance = null;
      
      private var m_Hints:Vector.<tibia.sessiondump.hints.SessiondumpHintBase>;
      
      private var m_SessiondumpDuration:uint = 0;
      
      private var m_PlayerName:String = null;
      
      private var m_SessiondumpFilename:String = null;
      
      public function SessiondumpHints()
      {
         this.m_Hints = new Vector.<tibia.sessiondump.hints.SessiondumpHintBase>();
         super();
      }
      
      public static function s_Unmarshall(param1:Object) : SessiondumpHints
      {
         var _loc7_:Object = null;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:Object = null;
         var _loc11_:tibia.sessiondump.hints.SessiondumpHintBase = null;
         if(param1 == null)
         {
            throw new Error("SessiondumpHints.s_Unmarshall: Invalid input.");
         }
         var _loc2_:SessiondumpHints = new SessiondumpHints();
         _loc2_.m_SessiondumpDuration = param1["sessiondump-duration"] as uint;
         var _loc3_:Object = Tibia.s_TutorialData;
         if(_loc3_ != null)
         {
            if(FIELD_PLAYER_NAME in _loc3_)
            {
               _loc2_.m_PlayerName = _loc3_[FIELD_PLAYER_NAME] as String;
            }
            if(FIELD_PLAYER_OUTFIT in _loc3_)
            {
               _loc7_ = _loc3_[FIELD_PLAYER_OUTFIT] as Object;
               if(FIELD_PLAYER_OUTFIT_ID in _loc7_ && FIELD_PLAYER_OUTFIT_COLOR_HEAD in _loc7_ && FIELD_PLAYER_OUTFIT_COLOR_LEGS in _loc7_ && FIELD_PLAYER_OUTFIT_COLOR_TORSO in _loc7_ && FIELD_PLAYER_OUTFIT_COLOR_DETAIL in _loc7_ && FIELD_PLAYER_OUTFIT_ADDONS in _loc7_)
               {
                  _loc2_.m_PlayerOutfit = Tibia.s_GetAppearanceStorage().createOutfitInstance(_loc7_[FIELD_PLAYER_OUTFIT_ID],_loc7_[FIELD_PLAYER_OUTFIT_COLOR_HEAD],_loc7_[FIELD_PLAYER_OUTFIT_COLOR_TORSO],_loc7_[FIELD_PLAYER_OUTFIT_COLOR_LEGS],_loc7_[FIELD_PLAYER_OUTFIT_COLOR_DETAIL],_loc7_[FIELD_PLAYER_OUTFIT_ADDONS]);
               }
               else
               {
                  throw new ArgumentError("SessiondumpHints.s_Unmarshall: Invalid outfit data for player");
               }
            }
         }
         var _loc4_:Object = param1["actions"] as Object;
         var _loc5_:* = null;
         var _loc6_:Array = new Array();
         for(_loc5_ in _loc4_)
         {
            _loc6_.push(Object({
               "timestamp":_loc5_ as uint,
               "actions":_loc4_[_loc5_] as Array
            }));
         }
         _loc6_.sortOn("timestamp",Array.NUMERIC);
         for each(_loc5_ in _loc6_)
         {
            _loc8_ = _loc5_["timestamp"] as uint;
            _loc9_ = _loc5_["actions"] as Array;
            for each(_loc10_ in _loc9_)
            {
               _loc11_ = tibia.sessiondump.hints.SessiondumpHintBase.s_Unmarshall(uint(_loc8_),_loc10_);
               if(_loc11_ != null)
               {
                  _loc2_.m_Hints.push(_loc11_);
               }
            }
         }
         if(FIELD_SESSIONDUMP in param1)
         {
            _loc2_.m_SessiondumpFilename = param1[FIELD_SESSIONDUMP];
         }
         return _loc2_;
      }
      
      public function get playerOutfit() : OutfitInstance
      {
         return this.m_PlayerOutfit;
      }
      
      public function get sessiondumpDuration() : uint
      {
         return this.m_SessiondumpDuration;
      }
      
      public function get playerName() : String
      {
         return this.m_PlayerName;
      }
      
      public function getNextSessiondumpHintToProcess(param1:uint) : tibia.sessiondump.hints.SessiondumpHintBase
      {
         var _loc2_:tibia.sessiondump.hints.SessiondumpHintBase = null;
         for each(_loc2_ in this.m_Hints)
         {
            if(_loc2_.processed == false && _loc2_.timestamp <= param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function reset() : void
      {
         var _loc1_:tibia.sessiondump.hints.SessiondumpHintBase = null;
         for each(_loc1_ in this.m_Hints)
         {
            _loc1_.reset();
         }
      }
      
      public function get hints() : Vector.<tibia.sessiondump.hints.SessiondumpHintBase>
      {
         return this.m_Hints;
      }
   }
}
