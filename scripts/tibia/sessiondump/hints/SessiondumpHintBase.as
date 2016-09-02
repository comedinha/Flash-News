package tibia.sessiondump.hints
{
   public class SessiondumpHintBase
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
      
      public static const TYPE:String = "UNKNOWN";
      
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
       
      
      private var m_Timestamp:uint = 0;
      
      protected var m_Type:String = "UNKNOWN";
      
      protected var m_Processed:Boolean = false;
      
      public function SessiondumpHintBase()
      {
         super();
      }
      
      public static function s_Unmarshall(param1:uint, param2:Object) : SessiondumpHintBase
      {
         var _loc4_:String = null;
         var _loc3_:SessiondumpHintBase = null;
         if(FIELD_TYPE in param2)
         {
            _loc4_ = param2[FIELD_TYPE] as String;
            switch(_loc4_)
            {
               case SessiondumpHintCondition.TYPE:
                  _loc3_ = SessiondumpHintCondition.s_Unmarshall(param2);
                  break;
               case SessiondumpHintSkipTo.TYPE:
                  _loc3_ = SessiondumpHintSkipTo.s_Unmarshall(param2);
                  break;
               case SessiondumpHintSwitchChannel.TYPE:
                  _loc3_ = SessiondumpHintSwitchChannel.s_Unmarshall(param2);
                  break;
               case SessiondumpHintTutorialProgress.TYPE:
                  _loc3_ = SessiondumpHintTutorialProgress.s_Unmarshall(param2);
                  break;
               default:
                  _loc3_ = new SessiondumpHintBase();
            }
            _loc3_.m_Timestamp = param1;
         }
         return _loc3_;
      }
      
      public function perform() : void
      {
         this.m_Processed = true;
      }
      
      public function cancel() : void
      {
         this.m_Processed = true;
      }
      
      public function get processed() : Boolean
      {
         return this.m_Processed;
      }
      
      public function reset() : void
      {
         this.m_Processed = false;
      }
      
      public function get timestamp() : uint
      {
         return this.m_Timestamp;
      }
      
      public function get type() : String
      {
         return this.m_Type;
      }
      
      public function toString() : String
      {
         return this.m_Timestamp + ":" + this.m_Type;
      }
   }
}
