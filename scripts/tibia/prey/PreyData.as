package tibia.prey
{
   import flash.events.EventDispatcher;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class PreyData extends EventDispatcher
   {
      
      public static const BONUS_DAMAGE_REDUCTION:uint = 1;
      
      public static const UNLOCK_STORE:uint = 1;
      
      public static const UNLOCK_PREMIUM_OR_STORE:uint = 0;
      
      public static const UNLOCK_NONE:uint = 2;
      
      public static const STATE_ACTIVE:uint = 2;
      
      public static const BONUS_IMPROVED_LOOT:uint = 3;
      
      public static const STATE_SELECTION:uint = 3;
      
      public static const STATE_LOCKED:uint = 0;
      
      public static const STATE_SELECTION_CHANGE_MONSTER:uint = 4;
      
      public static const PREY_MAXIMUM_GRADE:uint = 10;
      
      public static const BONUS_DAMAGE_BOOST:uint = 0;
      
      public static const BONUS_XP_BONUS:uint = 2;
      
      public static const STATE_INACTIVE:uint = 1;
      
      public static const PREY_FULL_DURATION:uint = 60 * 60 * 2;
      
      public static const BONUS_NONE:uint = 4;
       
      
      private var m_BonusValue:uint = 0;
      
      private var m_BonusType:uint = 4;
      
      private var m_UnlockOption:uint = 2;
      
      private var m_Id:uint = 0;
      
      private var m_MinutesUntilFreeListReroll:Number = 0;
      
      private var m_State:uint = 1;
      
      private var m_MonsterList:Vector.<PreyMonsterInformation>;
      
      private var m_Monster:PreyMonsterInformation = null;
      
      private var m_BonusGrade:uint = 0;
      
      private var m_SecondsLeftRunning:Number = 0;
      
      public function PreyData(param1:uint)
      {
         this.m_MonsterList = new Vector.<PreyMonsterInformation>();
         super();
         this.m_Id = param1;
      }
      
      public function get timeUntilFreeListRerollMax() : Number
      {
         return 20 * 60;
      }
      
      public function set bonusType(param1:uint) : void
      {
         if(param1 != this.m_BonusType)
         {
            this.m_BonusType = param1;
            this.dispatchChangeEvent("bonusType");
         }
      }
      
      public function changeStateToActive(param1:uint, param2:uint, param3:uint, param4:PreyMonsterInformation) : void
      {
         if(param1 != BONUS_NONE)
         {
            this.clear();
            this.bonusType = param1;
            this.bonusValue = param2;
            this.bonusGrade = param3;
            this.monster = param4;
            this.state = STATE_ACTIVE;
         }
         else
         {
            this.changeStateToInactive();
         }
      }
      
      public function generateBonusGradeString() : String
      {
         var _loc1_:String = "☆";
         var _loc2_:String = "★";
         var _loc3_:String = "";
         var _loc4_:uint = 0;
         while(_loc4_ < PREY_MAXIMUM_GRADE)
         {
            _loc3_ = _loc3_ + (_loc4_ < this.bonusGrade?_loc2_:_loc1_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function changeStateToLocked(param1:uint) : void
      {
         if(param1 != UNLOCK_NONE)
         {
            this.clear();
            this.unlockOption = param1;
            this.state = STATE_LOCKED;
         }
         else
         {
            this.changeStateToInactive();
         }
      }
      
      public function get preyTimeLeft() : Number
      {
         return this.m_SecondsLeftRunning;
      }
      
      public function get state() : uint
      {
         return this.m_State;
      }
      
      public function generateBonusDescription() : String
      {
         var _loc1_:String = "PreyWidget";
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         if(_loc2_ == null)
         {
            return "";
         }
         if(this.m_BonusType == PreyData.BONUS_DAMAGE_BOOST)
         {
            return _loc2_.getString(_loc1_,"BONUS_DESCRIPTION_DAMAGE_BOOST",[this.m_BonusValue]);
         }
         if(this.m_BonusType == PreyData.BONUS_DAMAGE_REDUCTION)
         {
            return _loc2_.getString(_loc1_,"BONUS_DESCRIPTION_DAMAGE_REDUCTION",[this.m_BonusValue]);
         }
         if(this.m_BonusType == PreyData.BONUS_IMPROVED_LOOT)
         {
            return _loc2_.getString(_loc1_,"BONUS_DESCRIPTION_IMPROVED_LOOT",[this.m_BonusValue]);
         }
         if(this.m_BonusType == PreyData.BONUS_XP_BONUS)
         {
            return _loc2_.getString(_loc1_,"BONUS_DESCRIPTION_XP_BONUS",[this.m_BonusValue]);
         }
         return "";
      }
      
      public function changeStateToSelection(param1:Vector.<PreyMonsterInformation>) : void
      {
         if(param1.length > 0)
         {
            this.clear();
            this.monsterList = param1;
            this.state = STATE_SELECTION;
         }
         else
         {
            this.changeStateToInactive();
         }
      }
      
      public function get monsterList() : Vector.<PreyMonsterInformation>
      {
         return this.m_MonsterList;
      }
      
      public function get unlockOption() : uint
      {
         return this.m_UnlockOption;
      }
      
      public function get id() : uint
      {
         return this.m_Id;
      }
      
      private function clear() : void
      {
         this.unlockOption = UNLOCK_NONE;
         this.bonusType = BONUS_NONE;
         this.bonusValue = 0;
         this.bonusGrade = 0;
         this.monster = null;
         this.monsterList = new Vector.<PreyMonsterInformation>();
         this.preyTimeLeft = 0;
      }
      
      public function get bonusValue() : uint
      {
         return this.m_BonusValue;
      }
      
      public function set state(param1:uint) : void
      {
         if(param1 != this.m_State)
         {
            this.m_State = param1;
            this.dispatchChangeEvent("state");
         }
      }
      
      public function set preyTimeLeft(param1:Number) : void
      {
         if(this.m_SecondsLeftRunning != param1)
         {
            this.m_SecondsLeftRunning = param1;
            this.dispatchChangeEvent("preyTimeLeft");
         }
      }
      
      public function set bonusValue(param1:uint) : void
      {
         if(param1 != this.m_BonusValue)
         {
            this.m_BonusValue = param1;
            this.dispatchChangeEvent("bonusValue");
         }
      }
      
      public function changeStateToInactive() : void
      {
         this.clear();
         this.state = STATE_INACTIVE;
      }
      
      public function get monster() : PreyMonsterInformation
      {
         return this.m_Monster;
      }
      
      public function set timeUntilFreeListReroll(param1:Number) : void
      {
         if(this.m_MinutesUntilFreeListReroll != param1)
         {
            this.m_MinutesUntilFreeListReroll = param1;
            this.dispatchChangeEvent("timeUntilFreeListReroll");
         }
      }
      
      public function set bonusGrade(param1:uint) : void
      {
         if(this.m_BonusGrade != param1)
         {
            this.m_BonusGrade = param1;
            this.dispatchChangeEvent("bonusGrade");
         }
      }
      
      public function set unlockOption(param1:uint) : void
      {
         if(param1 != this.m_UnlockOption)
         {
            this.m_UnlockOption = param1;
            this.dispatchChangeEvent("unlockOption");
         }
      }
      
      public function set monster(param1:PreyMonsterInformation) : void
      {
         if(param1 != null && !param1.equals(this.m_Monster) || param1 == null && this.m_Monster != null)
         {
            this.m_Monster = param1;
            this.dispatchChangeEvent("monster");
         }
      }
      
      public function set monsterList(param1:Vector.<PreyMonsterInformation>) : void
      {
         this.m_MonsterList = param1;
         this.dispatchChangeEvent("monsterList");
      }
      
      public function get bonusGrade() : uint
      {
         return this.m_BonusGrade;
      }
      
      public function get bonusType() : uint
      {
         return this.m_BonusType;
      }
      
      public function get timeUntilFreeListReroll() : Number
      {
         return this.m_MinutesUntilFreeListReroll;
      }
      
      public function changeStateToSelectionChangeMonster(param1:uint, param2:uint, param3:uint, param4:Vector.<PreyMonsterInformation>) : void
      {
         if(param4.length > 0)
         {
            this.clear();
            this.bonusType = param1;
            this.bonusValue = param2;
            this.bonusGrade = param3;
            this.monsterList = param4;
            this.state = STATE_SELECTION_CHANGE_MONSTER;
         }
         else
         {
            this.changeStateToInactive();
         }
      }
      
      public function generateBonusString() : String
      {
         var _loc1_:String = "PreyWidget";
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         if(_loc2_ == null)
         {
            return "";
         }
         if(this.m_BonusType == PreyData.BONUS_DAMAGE_BOOST)
         {
            return _loc2_.getString(_loc1_,"BONUS_DAMAGE_BOOST");
         }
         if(this.m_BonusType == PreyData.BONUS_DAMAGE_REDUCTION)
         {
            return _loc2_.getString(_loc1_,"BONUS_DAMAGE_REDUCTION");
         }
         if(this.m_BonusType == PreyData.BONUS_IMPROVED_LOOT)
         {
            return _loc2_.getString(_loc1_,"BONUS_IMPROVED_LOOT");
         }
         if(this.m_BonusType == PreyData.BONUS_XP_BONUS)
         {
            return _loc2_.getString(_loc1_,"BONUS_XP_BONUS");
         }
         return _loc2_.getString(_loc1_,"BONUS_NONE");
      }
      
      private function dispatchChangeEvent(param1:String) : void
      {
         var _loc2_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc2_.kind = PropertyChangeEventKind.UPDATE;
         _loc2_.property = param1;
         dispatchEvent(_loc2_);
      }
   }
}
