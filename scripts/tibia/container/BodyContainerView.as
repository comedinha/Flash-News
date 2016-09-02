package tibia.container
{
   import flash.events.EventDispatcher;
   import tibia.appearances.ObjectInstance;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.AppearanceStorage;
   
   public class BodyContainerView extends EventDispatcher
   {
      
      public static const STORE:int = 12;
      
      public static const STOREINBOX:int = 11;
      
      public static const BOTH_HANDS:int = 0;
      
      public static const LAST_SLOT:int = BLESSINGS;
      
      public static const FIRST_SLOT:int = HEAD;
      
      public static const RIGHT_HAND:int = 5;
      
      public static const TORSO:int = 4;
      
      public static const NECK:int = 2;
      
      public static const HEAD:int = 1;
      
      public static const LEGS:int = 7;
      
      public static const LEFT_HAND:int = 6;
      
      public static const FINGER:int = 9;
      
      public static const BLESSINGS:int = 13;
      
      public static const BACK:int = 3;
      
      public static const HIP:int = 10;
      
      public static const FEET:int = 8;
       
      
      private var m_Objects:Vector.<ObjectInstance> = null;
      
      public function BodyContainerView()
      {
         super();
         this.m_Objects = new Vector.<ObjectInstance>(LAST_SLOT - FIRST_SLOT + 1,true);
      }
      
      public function setObject(param1:int, param2:ObjectInstance) : void
      {
         if(param1 < FIRST_SLOT || param1 > LAST_SLOT)
         {
            throw new RangeError("BodyContainerView.getObject: Index out of range: " + param1);
         }
         this.m_Objects[param1 - FIRST_SLOT] = param2;
         var _loc3_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc3_.property = "objects";
         _loc3_.kind = PropertyChangeEventKind.UPDATE;
         dispatchEvent(_loc3_);
      }
      
      public function getObject(param1:int) : ObjectInstance
      {
         if(param1 < FIRST_SLOT || param1 > LAST_SLOT)
         {
            throw new RangeError("BodyContainerView.getObject: Index out of range: " + param1);
         }
         return this.m_Objects[param1 - FIRST_SLOT];
      }
      
      public function isEquipped(param1:int) : Boolean
      {
         var _loc4_:int = 0;
         var _loc5_:ObjectInstance = null;
         var _loc2_:AppearanceType = null;
         var _loc3_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         if(_loc3_ != null)
         {
            _loc2_ = _loc3_.getObjectType(param1);
         }
         if(_loc2_ != null && _loc2_.isCloth)
         {
            _loc4_ = _loc2_.clothSlot;
            if(_loc4_ == BOTH_HANDS)
            {
               _loc4_ = LEFT_HAND;
            }
            _loc5_ = this.m_Objects[_loc4_ - FIRST_SLOT];
            return _loc5_ != null && _loc5_.ID == param1;
         }
         return false;
      }
      
      public function reset() : void
      {
         var _loc1_:int = FIRST_SLOT;
         while(_loc1_ <= LAST_SLOT)
         {
            this.m_Objects[_loc1_ - FIRST_SLOT] = null;
            _loc1_++;
         }
         var _loc2_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc2_.property = "objects";
         _loc2_.kind = PropertyChangeEventKind.UPDATE;
         dispatchEvent(_loc2_);
      }
   }
}
