package tibia.sessiondump.hints.condition
{
   import shared.utility.Vector3D;
   
   public class HintConditionUse extends HintConditionBase
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
      
      public static const TYPE:String = "USE";
      
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
       
      
      protected var m_UseTarget:int = 0;
      
      protected var m_MultiuseObjectPosition:int = 0;
      
      protected var m_Absolute:Vector3D = null;
      
      protected var m_UseTypeID:int = 0;
      
      protected var m_PositionOrData:int = 0;
      
      protected var m_MultiuseTarget:Vector3D = null;
      
      protected var m_MultiuseObjectID:int = 0;
      
      public function HintConditionUse()
      {
         super();
         m_Type = TYPE;
      }
      
      public static function s_Unmarshall(param1:Object) : HintConditionUse
      {
         var _loc2_:HintConditionUse = null;
         if(param1 != null && FIELD_COORDINATE in param1 && FIELD_USE_TYPE_ID in param1 && FIELD_POSITION in param1 && FIELD_TARGET in param1)
         {
            _loc2_ = new HintConditionUse();
            _loc2_.m_Absolute = HintConditionBase.s_UnmarshallCoordinate(param1[FIELD_COORDINATE]);
            _loc2_.m_UseTypeID = param1[FIELD_USE_TYPE_ID] as int;
            _loc2_.m_PositionOrData = param1[FIELD_POSITION] as int;
            _loc2_.m_UseTarget = param1[FIELD_TARGET] as int;
            if(FIELD_MULTIUSE_TARGET in param1)
            {
               _loc2_.m_MultiuseTarget = HintConditionBase.s_UnmarshallCoordinate(param1[FIELD_MULTIUSE_TARGET]);
               _loc2_.m_MultiuseObjectID = param1[FIELD_MULTIUSE_OBJECT_ID] as int;
               _loc2_.m_MultiuseObjectPosition = param1[FIELD_MULTIUSE_OBJECT_POSITION] as int;
            }
            return _loc2_;
         }
         throw new ArgumentError("HintConditionUse.s_Unmarshall: Invalid hint data");
      }
      
      public function get absolutePosition() : Vector3D
      {
         return this.m_Absolute;
      }
      
      public function get multiuseObjectID() : int
      {
         return this.m_MultiuseObjectID;
      }
      
      public function get positionOrData() : int
      {
         return this.m_PositionOrData;
      }
      
      public function get useTarget() : int
      {
         return this.m_UseTarget;
      }
      
      public function get useTypeID() : int
      {
         return this.m_UseTypeID;
      }
      
      public function get multiuseObjectPosition() : int
      {
         return this.m_MultiuseObjectPosition;
      }
      
      public function get multiuseTarget() : Vector3D
      {
         return this.m_MultiuseTarget;
      }
   }
}
