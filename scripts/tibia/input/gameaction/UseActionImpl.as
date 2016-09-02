package tibia.input.gameaction
{
   import tibia.input.IActionImpl;
   import flash.events.MouseEvent;
   import tibia.creatures.Creature;
   import tibia.network.Communication;
   import tibia.container.ContainerStorage;
   import tibia.creatures.CreatureStorage;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import tibia.game.IUseWidget;
   import shared.utility.Vector3D;
   import tibia.appearances.ObjectInstance;
   import tibia.appearances.AppearanceInstance;
   import tibia.creatures.Player;
   import tibia.magic.SpellStorage;
   import tibia.container.BodyContainerView;
   import flash.events.Event;
   import tibia.cursors.CursorHelper;
   import mx.core.EventPriority;
   import mx.events.SandboxMouseEvent;
   import tibia.appearances.AppearanceType;
   import tibia.cursors.CrosshairCursor;
   import tibia.appearances.AppearanceStorage;
   import mx.managers.CursorManagerPriority;
   
   public class UseActionImpl implements IActionImpl
   {
      
      public static const TARGET_NEW_WINDOW:int = 1;
      
      protected static var concurrentMultiUse:tibia.input.gameaction.UseActionImpl = null;
      
      public static const TARGET_CROSSHAIR:int = 4;
      
      public static const TARGET_ATTACK:int = 3;
      
      public static const TARGET_SELF:int = 2;
      
      public static const TARGET_AUTO:int = 0;
       
      
      protected var m_Target:int = -1;
      
      protected var m_PositionOrData:int = -1;
      
      protected var m_Absolute:Vector3D = null;
      
      private var m_CursorHelper:CursorHelper;
      
      protected var m_Type:AppearanceType = null;
      
      public function UseActionImpl(param1:Vector3D, param2:*, param3:int, param4:int = 0)
      {
         var _loc5_:AppearanceStorage = null;
         this.m_CursorHelper = new CursorHelper(CursorManagerPriority.HIGH);
         super();
         if(param1 == null)
         {
            throw new ArgumentError("UseActionImpl.UseActionImpl: Invalid co-ordinate.");
         }
         this.m_Absolute = param1.clone();
         this.m_Type = null;
         if(param2 is ObjectInstance)
         {
            this.m_Type = ObjectInstance(param2).type;
         }
         else if(param2 is AppearanceType)
         {
            this.m_Type = AppearanceType(param2);
         }
         else if(param2 is int)
         {
            _loc5_ = Tibia.s_GetAppearanceStorage();
            if(_loc5_ != null)
            {
               this.m_Type = _loc5_.getObjectType(int(param2));
            }
         }
         if(this.m_Type == null)
         {
            throw new ArgumentError("UseActionImpl.UseActionImpl: Invalid type: " + param2);
         }
         if(this.m_Absolute.x == 65535 && this.m_Absolute.y == 0)
         {
            this.m_PositionOrData = param3;
         }
         else if(this.m_Absolute.x == 65535 && this.m_Absolute.y != 0)
         {
            this.m_PositionOrData = this.m_Absolute.z;
         }
         else
         {
            this.m_PositionOrData = param3;
         }
         if(param4 != TARGET_AUTO && param4 != TARGET_NEW_WINDOW && param4 != TARGET_SELF && param4 != TARGET_ATTACK && param4 != TARGET_CROSSHAIR)
         {
            throw new ArgumentError("UseActionImpl.UseActionImpl: Invalid target: " + param4);
         }
         this.m_Target = param4;
      }
      
      protected function onUsePerform(param1:MouseEvent) : void
      {
         var _loc11_:Creature = null;
         param1.preventDefault();
         param1.stopImmediatePropagation();
         this.updateGlobalListeners(false);
         this.updateCursor(false);
         concurrentMultiUse = null;
         var _loc2_:Communication = Tibia.s_GetCommunication();
         var _loc3_:ContainerStorage = Tibia.s_GetContainerStorage();
         var _loc4_:CreatureStorage = Tibia.s_GetCreatureStorage();
         if(_loc2_ == null || !_loc2_.isGameRunning || _loc3_ == null || _loc4_ == null)
         {
            return;
         }
         var _loc5_:DisplayObject = param1.target as DisplayObject;
         var _loc6_:Point = null;
         if(_loc5_ != null)
         {
            _loc6_ = _loc5_.localToGlobal(new Point(param1.localX,param1.localY));
         }
         var _loc7_:IUseWidget = null;
         while(_loc5_ != null && (_loc7_ = _loc5_ as IUseWidget) == null)
         {
            _loc5_ = _loc5_.parent;
         }
         var _loc8_:Vector3D = null;
         var _loc9_:ObjectInstance = null;
         var _loc10_:Object = null;
         if(_loc7_ != null && _loc6_ != null && (_loc10_ = _loc7_.getMultiUseObjectUnderPoint(_loc6_)) != null && (_loc9_ = _loc10_.object as ObjectInstance) != null)
         {
            _loc11_ = null;
            if(_loc9_.ID == AppearanceInstance.CREATURE)
            {
               _loc11_ = _loc4_.getCreature(_loc9_.data);
            }
            if((_loc11_ == null || _loc11_.isHuman) && (_loc8_ = _loc10_.absolute as Vector3D) != null && int(_loc10_.position) > -1)
            {
               _loc2_.sendCUSETWOOBJECTS(this.m_Absolute.x,this.m_Absolute.y,this.m_Absolute.z,this.m_Type.ID,this.m_PositionOrData,_loc8_.x,_loc8_.y,_loc8_.z,_loc9_.ID,int(_loc10_.position));
            }
            else
            {
               _loc2_.sendCUSEONCREATURE(this.m_Absolute.x,this.m_Absolute.y,this.m_Absolute.z,this.m_Type.ID,this.m_PositionOrData,_loc11_.ID);
            }
         }
      }
      
      public function perform(param1:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:AutowalkActionImpl = null;
         var _loc2_:Communication = Tibia.s_GetCommunication();
         var _loc3_:CreatureStorage = Tibia.s_GetCreatureStorage();
         var _loc4_:ContainerStorage = Tibia.s_GetContainerStorage();
         var _loc5_:Player = Tibia.s_GetPlayer();
         if(_loc2_ != null && _loc2_.isGameRunning && _loc3_ != null && _loc4_ != null && _loc5_ != null)
         {
            if(this.m_Absolute.x == 65535 && this.m_Absolute.y == 0)
            {
               if(_loc4_.getAvailableInventory(this.m_Type.ID,this.m_PositionOrData) < 1)
               {
                  return;
               }
               if(this.m_Type.isMultiUse && SpellStorage.checkRune(this.m_Type.ID) && _loc5_.getRuneUses(SpellStorage.getRune(this.m_Type.ID)) < 1)
               {
                  return;
               }
            }
            if(this.m_Type.isContainer)
            {
               _loc6_ = 0;
               if(this.m_Target == TARGET_NEW_WINDOW || this.m_Absolute.x < 65535 || this.m_Absolute.y >= BodyContainerView.FIRST_SLOT && this.m_Absolute.y <= BodyContainerView.LAST_SLOT)
               {
                  _loc6_ = _loc4_.getFreeContainerViewID();
               }
               else if(64 <= this.m_Absolute.y && this.m_Absolute.y < 64 + ContainerStorage.MAX_CONTAINER_VIEWS)
               {
                  _loc6_ = this.m_Absolute.y - 64;
               }
               _loc2_.sendCUSEOBJECT(this.m_Absolute.x,this.m_Absolute.y,this.m_Absolute.z,this.m_Type.ID,this.m_PositionOrData,_loc6_);
            }
            else if(!this.m_Type.isMultiUse)
            {
               _loc2_.sendCUSEOBJECT(this.m_Absolute.x,this.m_Absolute.y,this.m_Absolute.z,this.m_Type.ID,this.m_PositionOrData,0);
            }
            else if(this.m_Target == TARGET_SELF)
            {
               _loc2_.sendCUSEONCREATURE(this.m_Absolute.x,this.m_Absolute.y,this.m_Absolute.z,this.m_Type.ID,this.m_PositionOrData,_loc5_.ID);
            }
            else if(this.m_Target == TARGET_ATTACK && _loc3_.getAttackTarget() != null)
            {
               _loc2_.sendCUSEONCREATURE(this.m_Absolute.x,this.m_Absolute.y,this.m_Absolute.z,this.m_Type.ID,this.m_PositionOrData,_loc3_.getAttackTarget().ID);
            }
            else
            {
               if(this.m_Absolute.x < 65535)
               {
                  _loc7_ = Tibia.s_GameActionFactory.createAutowalkAction(this.m_Absolute.x,this.m_Absolute.y,this.m_Absolute.z,false,false);
                  _loc7_.perform();
               }
               if(concurrentMultiUse != null)
               {
                  concurrentMultiUse.updateGlobalListeners(false);
                  concurrentMultiUse.updateCursor(false);
                  concurrentMultiUse = null;
               }
               this.updateGlobalListeners(true);
               this.updateCursor(true);
               concurrentMultiUse = this;
            }
         }
      }
      
      private function onUseAbort(param1:Event) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
         this.updateGlobalListeners(false);
         this.updateCursor(false);
         concurrentMultiUse = null;
      }
      
      protected function updateGlobalListeners(param1:Boolean) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Tibia = Tibia.s_GetInstance();
         if(_loc3_ != null && _loc3_.systemManager != null)
         {
            _loc2_ = _loc3_.systemManager.getSandboxRoot();
         }
         if(_loc2_ != null)
         {
            if(param1)
            {
               _loc2_.addEventListener(MouseEvent.MOUSE_UP,this.onUsePerform,true,EventPriority.DEFAULT,false);
               _loc2_.addEventListener(MouseEvent.MOUSE_DOWN,this.onUseIgnore,true,EventPriority.DEFAULT,false);
               _loc2_.addEventListener(MouseEvent.CLICK,this.onUseIgnore,true,EventPriority.DEFAULT,false);
               _loc2_.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onUseAbort,true,EventPriority.DEFAULT,false);
               _loc2_.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onUseIgnore,true,EventPriority.DEFAULT,false);
               _loc2_.addEventListener(MouseEvent.RIGHT_CLICK,this.onUseIgnore,true,EventPriority.DEFAULT,false);
               _loc2_.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onUseAbort);
               _loc2_.addEventListener(Event.DEACTIVATE,this.onUseAbort);
            }
            else
            {
               _loc2_.removeEventListener(MouseEvent.MOUSE_UP,this.onUsePerform,true);
               _loc2_.removeEventListener(MouseEvent.MOUSE_DOWN,this.onUseIgnore,true);
               _loc2_.removeEventListener(MouseEvent.CLICK,this.onUseIgnore,true);
               _loc2_.removeEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onUseAbort,true);
               _loc2_.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onUseIgnore,true);
               _loc2_.removeEventListener(MouseEvent.RIGHT_CLICK,this.onUseIgnore,true);
               _loc2_.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.onUseAbort);
               _loc2_.removeEventListener(Event.DEACTIVATE,this.onUseAbort);
            }
         }
      }
      
      private function onUseIgnore(param1:MouseEvent) : void
      {
         param1.preventDefault();
         param1.stopImmediatePropagation();
      }
      
      protected function updateCursor(param1:Boolean) : void
      {
         if(param1)
         {
            this.m_CursorHelper.setCursor(CrosshairCursor);
         }
         else
         {
            this.m_CursorHelper.resetCursor();
         }
      }
   }
}
