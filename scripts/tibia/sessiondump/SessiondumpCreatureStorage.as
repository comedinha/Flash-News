package tibia.sessiondump
{
   import flash.utils.Dictionary;
   import tibia.appearances.AppearanceStorage;
   import tibia.creatures.Creature;
   import tibia.creatures.CreatureStorage;
   
   public class SessiondumpCreatureStorage extends CreatureStorage
   {
       
      
      protected var m_KeyframeCreatures:Dictionary = null;
      
      private var m_KeyframeCreaturesGot:uint = 0;
      
      public function SessiondumpCreatureStorage()
      {
         super();
         m_MaxCreaturesCount = uint.MAX_VALUE;
         this.resetKeyframeCreatures();
      }
      
      override public function replaceCreature(param1:Creature, param2:int = 0) : Creature
      {
         var _loc3_:Creature = null;
         if(param2 != 0)
         {
            _loc3_ = super.getCreature(param2);
            if(_loc3_ == null)
            {
               param2 = 0;
            }
         }
         else if(param1.ID != 0 && param1.ID != m_Player.ID)
         {
            _loc3_ = super.getCreature(param1.ID);
            if(_loc3_ != null)
            {
               param2 = param1.ID;
            }
         }
         return super.replaceCreature(param1,param2);
      }
      
      override public function getCreature(param1:int) : Creature
      {
         var _loc3_:AppearanceStorage = null;
         var _loc2_:Creature = super.getCreature(param1);
         if(_loc2_ == null)
         {
            if(param1 in this.m_KeyframeCreatures)
            {
               _loc2_ = this.m_KeyframeCreatures[param1] as Creature;
               this.m_KeyframeCreaturesGot++;
               super.replaceCreature(_loc2_,0);
               this.m_KeyframeCreatures[param1] = null;
            }
         }
         if(_loc2_ == null)
         {
            _loc3_ = Tibia.s_GetAppearanceStorage();
            _loc2_ = new Creature(param1);
            _loc2_.type = TYPE_MONSTER;
            _loc2_.name = "Unknown";
            _loc2_.outfit = _loc3_.createOutfitInstance(1,0,0,0,0,0);
            _loc2_.setSkillValue(SKILL_HITPOINTS_PERCENT,100);
            _loc2_.setSkillValue(SKILL_GOSTRENGTH,100);
            this.addKeyframeCreature(_loc2_);
         }
         return _loc2_;
      }
      
      public function resetKeyframeCreatures() : void
      {
         this.m_KeyframeCreatures = new Dictionary();
      }
      
      override public function removeCreature(param1:int) : void
      {
         var _loc2_:Creature = super.getCreature(param1);
         if(_loc2_ != null)
         {
            super.removeCreature(param1);
         }
      }
      
      public function getKeyframeCreature(param1:int) : Creature
      {
         return this.m_KeyframeCreatures[param1] as Creature;
      }
      
      public function addKeyframeCreature(param1:Creature) : void
      {
         if(param1 != null)
         {
            this.m_KeyframeCreatures[param1.ID] = param1;
         }
      }
   }
}
