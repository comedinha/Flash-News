package tibia.input.gameaction
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.ObjectInstance;
   import tibia.container.BodyContainerView;
   import tibia.container.ContainerStorage;
   import tibia.input.IAction;
   import tibia.network.Communication;
   
   public class EquipAction implements IAction
   {
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      private static const BUNDLE:String = "StaticAction";
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
      
      public static const TARGET_AUTO:int = UseActionImpl.TARGET_CROSSHAIR + 1;
       
      
      private var m_Target:int = -1;
      
      private var m_Type:AppearanceType = null;
      
      private var m_Data:int = -1;
      
      public function EquipAction(param1:*, param2:int, param3:int)
      {
         var _loc4_:AppearanceStorage = null;
         super();
         this.m_Type = null;
         if(param1 is ObjectInstance)
         {
            this.m_Type = ObjectInstance(param1).type;
         }
         else if(param1 is AppearanceType)
         {
            this.m_Type = AppearanceType(param1);
         }
         else if(param1 is int)
         {
            _loc4_ = Tibia.s_GetAppearanceStorage();
            if(_loc4_ != null)
            {
               this.m_Type = _loc4_.getObjectType(int(param1));
            }
         }
         if(this.m_Type == null || !this.m_Type.isCloth)
         {
            throw new ArgumentError("EquipAction.EquipAction: Invalid type: " + param1);
         }
         this.m_Data = param2;
         if(param3 != TARGET_AUTO)
         {
            throw new ArgumentError("EquipAction.EquipAction: Invalid target: " + param3);
         }
         if(this.m_Type.clothSlot == 0)
         {
            this.m_Target = BodyContainerView.LEFT_HAND;
         }
         else
         {
            this.m_Target = this.m_Type.clothSlot;
         }
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : EquipAction
      {
         if(param1 == null || param1.localName() != "action" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("EquipAction.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@type) == null || _loc3_.length() != 1 || _loc3_[0].toString() != "equip")
         {
            return null;
         }
         var _loc4_:int = -1;
         if((_loc3_ = param1.@object) != null && _loc3_.length() == 1)
         {
            _loc4_ = parseInt(_loc3_[0].toString());
         }
         var _loc5_:int = 0;
         if((_loc3_ = param1.@data) != null && _loc3_.length() == 1)
         {
            _loc5_ = parseInt(_loc3_[0].toString());
         }
         var _loc6_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         if(_loc6_.getObjectType(_loc4_) != null)
         {
            return new EquipAction(_loc4_,_loc5_,TARGET_AUTO);
         }
         return null;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc2_:Communication = Tibia.s_GetCommunication();
         var _loc3_:ContainerStorage = Tibia.s_GetContainerStorage();
         if(_loc2_ != null && _loc2_.isGameRunning && _loc3_ != null && _loc3_.getAvailableInventory(this.m_Type.ID,this.m_Data) > 0 && !param1)
         {
            _loc2_.sendCEQUIPOBJECT(this.m_Type.ID,this.m_Data);
         }
      }
      
      public function get data() : int
      {
         return this.m_Data;
      }
      
      public function marshall() : XML
      {
         return <action type="equip" object="{this.m_Type.ID}" data="{this.m_Data}"/>;
      }
      
      public function equals(param1:IAction) : Boolean
      {
         return param1 is EquipAction && EquipAction(param1).m_Data == this.m_Data && EquipAction(param1).m_Target == this.m_Target && EquipAction(param1).m_Type == this.m_Type;
      }
      
      public function get hidden() : Boolean
      {
         return true;
      }
      
      public function get type() : AppearanceType
      {
         return this.m_Type;
      }
      
      public function toString() : String
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:ContainerStorage = null;
         var _loc3_:BodyContainerView = null;
         var _loc4_:String = null;
         if((_loc2_ = Tibia.s_GetContainerStorage()) != null && (_loc3_ = _loc2_.getBodyContainerView()) != null && _loc3_.isEquipped(this.m_Type.ID))
         {
            _loc4_ = "GAME_EQUIP_UNEQUIP";
         }
         else
         {
            _loc4_ = "GAME_EQUIP_EQUIP";
         }
         var _loc5_:AppearanceStorage = null;
         var _loc6_:String = null;
         if((_loc5_ = Tibia.s_GetAppearanceStorage()) == null || (_loc6_ = _loc5_.getCachedObjectTypeName(this.m_Type.ID,this.m_Data)) == null)
         {
            _loc6_ = _loc1_.getString(BUNDLE,"GAME_EQUIP_GENERIC_OBJECT");
         }
         return _loc1_.getString(BUNDLE,_loc4_,[_loc6_]);
      }
      
      public function clone() : IAction
      {
         return new EquipAction(this.m_Type,this.m_Data,this.m_Target);
      }
   }
}
