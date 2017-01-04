package tibia.input.gameaction
{
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.ObjectInstance;
   import tibia.container.ContainerStorage;
   import tibia.game.Delay;
   import tibia.input.IAction;
   import tibia.magic.SpellStorage;
   import tibia.network.IServerConnection;
   
   public class UseAction implements IAction
   {
      
      protected static const OPTIONS_MAX_COMPATIBLE_VERSION:Number = 5;
      
      protected static const OPTIONS_MIN_COMPATIBLE_VERSION:Number = 2;
      
      private static const BUNDLE:String = "StaticAction";
      
      public static const TARGET_SELF:int = UseActionImpl.TARGET_SELF;
      
      public static const TARGET_CROSSHAIR:int = UseActionImpl.TARGET_CROSSHAIR;
      
      public static const TARGET_ATTACK:int = UseActionImpl.TARGET_ATTACK;
       
      
      private var m_LastPerform:Number = 0;
      
      private var m_Target:int = -1;
      
      private var m_Type:AppearanceType = null;
      
      private var m_Data:int = -1;
      
      public function UseAction(param1:*, param2:int, param3:int)
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
         if(this.m_Type == null)
         {
            throw new ArgumentError("UseAction.UseAction: Invalid type: " + param1);
         }
         this.m_Data = param2;
         if(param3 != TARGET_ATTACK && param3 != TARGET_CROSSHAIR && param3 != TARGET_SELF)
         {
            throw new ArgumentError("UseAction.UseAction: Invalid target: " + param3);
         }
         this.m_Target = param3;
      }
      
      public static function s_Unmarshall(param1:XML, param2:Number) : UseAction
      {
         if(param1 == null || param1.localName() != "action" || param2 < OPTIONS_MIN_COMPATIBLE_VERSION || param2 > OPTIONS_MAX_COMPATIBLE_VERSION)
         {
            throw new Error("UseAction.s_Unmarshall: Invalid input.");
         }
         var _loc3_:XMLList = null;
         if((_loc3_ = param1.@type) == null || _loc3_.length() != 1 || _loc3_[0].toString() != "use")
         {
            return null;
         }
         var _loc4_:int = -1;
         if((_loc3_ = param1.@object) != null && _loc3_.length() == 1)
         {
            _loc4_ = parseInt(_loc3_[0].toString());
         }
         var _loc5_:int = -1;
         if((_loc3_ = param1.@data) != null && _loc3_.length() == 1)
         {
            _loc5_ = parseInt(_loc3_[0].toString());
         }
         var _loc6_:int = -1;
         if((_loc3_ = param1.@target) != null && _loc3_.length() == 1)
         {
            _loc6_ = parseInt(_loc3_[0].toString());
         }
         var _loc7_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         if(_loc7_.getObjectType(_loc4_) != null && (_loc6_ == UseAction.TARGET_SELF || _loc6_ == UseAction.TARGET_ATTACK || _loc6_ == UseAction.TARGET_CROSSHAIR))
         {
            return new UseAction(_loc4_,_loc5_,_loc6_);
         }
         return null;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc5_:Delay = null;
         var _loc2_:IServerConnection = Tibia.s_GetConnection();
         var _loc3_:ContainerStorage = Tibia.s_GetContainerStorage();
         var _loc4_:SpellStorage = Tibia.s_GetSpellStorage();
         if(param1 && _loc2_ != null && _loc3_ != null && _loc4_ != null)
         {
            if(this.m_Type.isMultiUse)
            {
               if(this.m_LastPerform + ContainerStorage.MIN_MULTI_USE_DELAY / 2 > Tibia.s_FrameTibiaTimestamp)
               {
                  return;
               }
               _loc5_ = Delay.merge(_loc3_.getMultiUseDelay(),_loc4_.getRuneDelay(this.m_Type.ID));
               if(_loc5_ != null && _loc5_.end - _loc2_.latency > Tibia.s_FrameTibiaTimestamp)
               {
                  return;
               }
            }
            else if(this.m_LastPerform + ContainerStorage.MIN_USE_DELAY > Tibia.s_FrameTibiaTimestamp)
            {
               return;
            }
         }
         Tibia.s_GameActionFactory.createUseAction(ContainerStorage.INVENTORY_ANY,this.m_Type,this.m_Data,this.m_Target).perform(param1);
         this.m_LastPerform = Tibia.s_FrameTibiaTimestamp;
      }
      
      public function get target() : int
      {
         return this.m_Target;
      }
      
      public function marshall() : XML
      {
         return <action type="use" object="{this.m_Type.ID}" data="{this.m_Data}" target="{this.m_Target}"/>;
      }
      
      public function get data() : int
      {
         return this.m_Data;
      }
      
      public function equals(param1:IAction) : Boolean
      {
         return param1 is UseAction && UseAction(param1).m_Data == this.m_Data && UseAction(param1).m_Target == this.m_Target && UseAction(param1).m_Type == this.m_Type;
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
         var _loc1_:AppearanceStorage = Tibia.s_GetAppearanceStorage();
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:String = null;
         switch(this.m_Target)
         {
            case TARGET_SELF:
               _loc3_ = "GAME_USE_TARGET_SELF";
               break;
            case TARGET_ATTACK:
               _loc3_ = "GAME_USE_TARGET_ATTACK";
               break;
            case TARGET_CROSSHAIR:
               _loc3_ = "GAME_USE_TARGET_CROSSHAIR";
         }
         var _loc4_:String = null;
         if(_loc1_ == null || (_loc4_ = _loc1_.getCachedObjectTypeName(this.m_Type.ID,this.m_Data)) == null)
         {
            _loc4_ = _loc2_.getString(BUNDLE,"GAME_USE_GENERIC_OBJECT");
         }
         return _loc2_.getString(BUNDLE,_loc3_,[_loc4_]);
      }
      
      public function clone() : IAction
      {
         return new UseAction(this.m_Type,this.m_Data,this.m_Target);
      }
   }
}
