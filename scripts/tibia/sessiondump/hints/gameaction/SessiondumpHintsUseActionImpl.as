package tibia.sessiondump.hints.gameaction
{
   import tibia.input.gameaction.UseActionImpl;
   import tibia.input.gameaction.AutowalkActionImpl;
   import tibia.network.Communication;
   import tibia.creatures.CreatureStorage;
   import tibia.container.ContainerStorage;
   import tibia.creatures.Player;
   import tibia.magic.SpellStorage;
   import tibia.container.BodyContainerView;
   import tibia.sessiondump.controller.SessiondumpHintActionsController;
   import shared.utility.Vector3D;
   import flash.events.MouseEvent;
   import tibia.creatures.Creature;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import tibia.game.IUseWidget;
   import tibia.appearances.ObjectInstance;
   import tibia.appearances.AppearanceInstance;
   import tibia.sessiondump.hints.condition.HintConditionUse;
   
   public class SessiondumpHintsUseActionImpl extends UseActionImpl
   {
      
      protected static var concurrentMultiUse:tibia.sessiondump.hints.gameaction.SessiondumpHintsUseActionImpl = null;
       
      
      private var m_DestinationAbsolute:Vector3D = null;
      
      private var m_DestinationPosition:int = -1;
      
      private var m_DestinationObjectID:int = -1;
      
      public function SessiondumpHintsUseActionImpl(param1:Vector3D, param2:*, param3:int, param4:int = 0)
      {
         super(param1,param2,param3,param4);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc6_:int = 0;
         var _loc7_:AutowalkActionImpl = null;
         var _loc2_:Communication = Tibia.s_GetCommunication();
         var _loc3_:CreatureStorage = Tibia.s_GetCreatureStorage();
         var _loc4_:ContainerStorage = Tibia.s_GetContainerStorage();
         var _loc5_:Player = Tibia.s_GetPlayer();
         if(_loc2_ != null && _loc2_.isGameRunning && _loc3_ != null && _loc4_ != null && _loc5_ != null)
         {
            if(m_Absolute.x == 65535 && m_Absolute.y == 0)
            {
               if(_loc4_.getAvailableInventory(m_Type.ID,m_PositionOrData) < 1)
               {
                  return;
               }
               if(m_Type.isMultiUse && SpellStorage.checkRune(m_Type.ID) && _loc5_.getRuneUses(SpellStorage.getRune(m_Type.ID)) < 1)
               {
                  return;
               }
            }
            if(m_Type.isContainer)
            {
               _loc6_ = 0;
               if(m_Target == TARGET_NEW_WINDOW || m_Absolute.x < 65535 || m_Absolute.y >= BodyContainerView.FIRST_SLOT && m_Absolute.y <= BodyContainerView.LAST_SLOT)
               {
                  _loc6_ = _loc4_.getFreeContainerViewID();
               }
               else if(64 <= m_Absolute.y && m_Absolute.y < 64 + ContainerStorage.MAX_CONTAINER_VIEWS)
               {
                  _loc6_ = m_Absolute.y - 64;
               }
               SessiondumpHintActionsController.getInstance().actionPerformed(this);
            }
            else if(!m_Type.isMultiUse)
            {
               SessiondumpHintActionsController.getInstance().actionPerformed(this);
            }
            else if(m_Target != TARGET_SELF)
            {
               if(!(m_Target == TARGET_ATTACK && _loc3_.getAttackTarget() != null))
               {
                  if(m_Absolute.x < 65535)
                  {
                     _loc7_ = Tibia.s_GameActionFactory.createAutowalkAction(m_Absolute.x,m_Absolute.y,m_Absolute.z,false,false);
                     _loc7_.perform();
                  }
                  if(concurrentMultiUse != null)
                  {
                     concurrentMultiUse.updateGlobalListeners(false);
                     concurrentMultiUse.updateCursor(false);
                     concurrentMultiUse = null;
                  }
                  updateGlobalListeners(true);
                  updateCursor(true);
                  concurrentMultiUse = this;
               }
            }
         }
      }
      
      override protected function onUsePerform(param1:MouseEvent) : void
      {
         var _loc11_:Creature = null;
         param1.preventDefault();
         param1.stopImmediatePropagation();
         updateGlobalListeners(false);
         updateCursor(false);
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
               this.m_DestinationAbsolute = _loc8_.clone();
               this.m_DestinationObjectID = _loc9_.ID;
               this.m_DestinationPosition = int(_loc10_.position);
               SessiondumpHintActionsController.getInstance().actionPerformed(this);
            }
         }
      }
      
      public function meetsCondition(param1:HintConditionUse) : Boolean
      {
         var _loc2_:Boolean = param1.absolutePosition.equals(m_Absolute) || param1.absolutePosition.x == m_Absolute.x && m_Absolute.y == 0 && m_Absolute.z == 0;
         return _loc2_ && param1.useTypeID == m_Type.ID && (param1.useTarget == m_Target || param1.useTarget == UseActionImpl.TARGET_AUTO) && param1.positionOrData == m_PositionOrData && (param1.multiuseTarget == null || param1.multiuseTarget.equals(this.m_DestinationAbsolute) && param1.multiuseObjectID == this.m_DestinationObjectID && param1.multiuseObjectPosition == this.m_DestinationPosition);
      }
   }
}
