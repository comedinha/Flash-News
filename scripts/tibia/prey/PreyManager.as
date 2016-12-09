package tibia.prey
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   
   public class PreyManager extends EventDispatcher
   {
      
      private static var s_Instance:tibia.prey.PreyManager = null;
      
      public static var PREY_ACTION_MONSTERSELECTION:uint = 2;
      
      private static const MAXIMUM_NUMBER_OF_PREYS:uint = 3;
      
      public static var PREY_ACTION_LISTREROLL:uint = 0;
      
      public static var PREY_ACTION_BONUSREROLL:uint = 1;
       
      
      private var m_ListRerollPrice:Number = 0;
      
      private var m_Preys:Vector.<tibia.prey.PreyData> = null;
      
      private var m_BonusRerollAmount:uint = 0;
      
      private var m_StillNeedsInformationForPrey:Vector.<uint> = null;
      
      public function PreyManager()
      {
         super();
         this.m_Preys = new Vector.<tibia.prey.PreyData>();
         this.m_StillNeedsInformationForPrey = new Vector.<uint>();
         var _loc1_:uint = 0;
         while(_loc1_ < MAXIMUM_NUMBER_OF_PREYS)
         {
            this.m_Preys.push(new tibia.prey.PreyData(_loc1_));
            this.m_StillNeedsInformationForPrey.push(_loc1_);
            _loc1_++;
         }
      }
      
      public static function getInstance() : tibia.prey.PreyManager
      {
         if(s_Instance == null)
         {
            s_Instance = new tibia.prey.PreyManager();
         }
         return s_Instance;
      }
      
      public function changeStateToSelectionChangeMonster(param1:uint, param2:uint, param3:uint, param4:uint, param5:Vector.<PreyMonsterInformation>) : void
      {
         if(param1 < this.m_Preys.length)
         {
            this.m_Preys[param1].changeStateToSelectionChangeMonster(param2,param3,param4,param5);
            this.setInformationAvailable(param1);
         }
      }
      
      public function changeStateToActive(param1:uint, param2:uint, param3:uint, param4:uint, param5:PreyMonsterInformation) : void
      {
         if(param1 < this.m_Preys.length)
         {
            this.m_Preys[param1].changeStateToActive(param2,param3,param4,param5);
            this.setInformationAvailable(param1);
         }
      }
      
      public function get preys() : Vector.<tibia.prey.PreyData>
      {
         return this.m_Preys;
      }
      
      public function changeStateToLocked(param1:uint, param2:uint) : void
      {
         if(param1 < this.m_Preys.length)
         {
            this.m_Preys[param1].changeStateToLocked(param2);
            this.setInformationAvailable(param1);
         }
      }
      
      public function get bonusRerollAmount() : uint
      {
         return this.m_BonusRerollAmount;
      }
      
      public function setPreyTimeLeft(param1:uint, param2:Number) : void
      {
         if(param1 < this.m_Preys.length)
         {
            this.m_Preys[param1].preyTimeLeft = param2;
         }
      }
      
      public function set bonusRerollAmount(param1:uint) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 != this.m_BonusRerollAmount)
         {
            this.m_BonusRerollAmount = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "bonusRerollAmount";
            dispatchEvent(_loc2_);
         }
      }
      
      public function changeStateToSelection(param1:uint, param2:Vector.<PreyMonsterInformation>) : void
      {
         if(param1 < this.m_Preys.length)
         {
            this.m_Preys[param1].changeStateToSelection(param2);
            this.setInformationAvailable(param1);
         }
      }
      
      private function setInformationAvailable(param1:uint) : void
      {
         var _loc3_:PropertyChangeEvent = null;
         var _loc2_:int = this.m_StillNeedsInformationForPrey.indexOf(param1);
         if(_loc2_ >= 0)
         {
            this.m_StillNeedsInformationForPrey.splice(_loc2_,1);
            if(this.m_StillNeedsInformationForPrey.length == 0)
            {
               _loc3_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
               _loc3_.kind = PropertyChangeEventKind.UPDATE;
               _loc3_.property = "prey";
               dispatchEvent(_loc3_);
            }
         }
      }
      
      public function setTimeUntilFreeListReroll(param1:uint, param2:Number) : void
      {
         if(param1 < this.m_Preys.length)
         {
            this.m_Preys[param1].timeUntilFreeListReroll = param2;
         }
      }
      
      public function get listRerollPrice() : Number
      {
         return this.m_ListRerollPrice;
      }
      
      public function set listRerollPrice(param1:Number) : void
      {
         var _loc2_:PropertyChangeEvent = null;
         if(param1 != this.m_ListRerollPrice)
         {
            this.m_ListRerollPrice = param1;
            _loc2_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc2_.kind = PropertyChangeEventKind.UPDATE;
            _loc2_.property = "listRerollPrice";
            dispatchEvent(_loc2_);
         }
      }
      
      public function changeStateToInactive(param1:uint) : void
      {
         if(param1 < this.m_Preys.length)
         {
            this.m_Preys[param1].changeStateToInactive();
            this.setInformationAvailable(param1);
         }
      }
   }
}
