package tibia.sessiondump.hints.condition
{
   import shared.utility.Vector3D;
   import avmplus.getQualifiedClassName;
   
   public class HintConditionBase
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
       
      
      protected var m_HintText:String = null;
      
      protected var m_HintTextUseDestinationPosition:Boolean = false;
      
      protected var m_HintTextOffset:Vector3D = null;
      
      protected var m_Type:String = null;
      
      public function HintConditionBase()
      {
         super();
      }
      
      public static function s_Unmarshall(param1:Object) : HintConditionBase
      {
         var _loc3_:String = null;
         var _loc4_:Object = null;
         var _loc5_:Object = null;
         var _loc2_:HintConditionBase = null;
         if(FIELD_CONDITIONDATA in param1)
         {
            _loc3_ = String(param1[FIELD_CONDITIONTYPE]);
            _loc4_ = param1[FIELD_CONDITIONDATA] as Object;
            switch(_loc3_)
            {
               case HintConditionAutowalk.TYPE:
                  _loc2_ = HintConditionAutowalk.s_Unmarshall(_loc4_);
                  break;
               case HintConditionMove.TYPE:
                  _loc2_ = HintConditionMove.s_Unmarshall(_loc4_);
                  break;
               case HintConditionAttack.TYPE:
                  _loc2_ = HintConditionAttack.s_Unmarshall(_loc4_);
                  break;
               case HintConditionGreet.TYPE:
                  _loc2_ = HintConditionGreet.s_Unmarshall(_loc4_);
                  break;
               case HintConditionTalk.TYPE:
                  _loc2_ = HintConditionTalk.s_Unmarshall(_loc4_);
                  break;
               case HintConditionUse.TYPE:
                  _loc2_ = HintConditionUse.s_Unmarshall(_loc4_);
            }
         }
         else
         {
            _loc2_ = new HintConditionBase();
         }
         if(FIELD_TEXTHINT in _loc4_)
         {
            _loc5_ = _loc4_[FIELD_TEXTHINT] as Object;
            if(_loc5_ != null && FIELD_TEXT in _loc5_ && FIELD_OFFSET in _loc5_)
            {
               if(FIELD_USEDESTINATIONPOSITION in _loc5_)
               {
                  _loc2_.m_HintTextUseDestinationPosition = _loc5_[FIELD_USEDESTINATIONPOSITION] as Boolean;
               }
               _loc2_.m_HintTextOffset = HintConditionBase.s_UnmarshallCoordinate(_loc5_[FIELD_OFFSET]);
               _loc2_.m_HintText = _loc5_[FIELD_TEXT] as String;
            }
            else
            {
               throw new ArgumentError("HintConditionBase.s_Unmarshall: Invalid text hint data");
            }
         }
         return _loc2_;
      }
      
      public static function s_UnmarshallCoordinate(param1:Object) : Vector3D
      {
         var _loc2_:int = 0;
         if(param1 == null || "x" in param1 == false || "y" in param1 == false)
         {
            throw new ArgumentError("SessiondumpHintBase.s_UnmarshallCoordinate: Invalid coordinate object");
         }
         _loc2_ = 0;
         if("z" in param1)
         {
            _loc2_ = param1["z"];
         }
         return new Vector3D(param1["x"],param1["y"],_loc2_);
      }
      
      public function get hintTextUseDestinationPosition() : Boolean
      {
         return this.m_HintTextUseDestinationPosition;
      }
      
      public function get hintTextOffset() : Vector3D
      {
         return this.m_HintTextOffset;
      }
      
      public function toString() : String
      {
         return getQualifiedClassName(this);
      }
      
      public function get hintText() : String
      {
         return this.m_HintText;
      }
   }
}
