package tibia.input.gameaction
{
   import tibia.creatures.Creature;
   import tibia.input.IActionImpl;
   
   public class ToggleAttackTargetActionImpl implements IActionImpl
   {
       
      
      protected var m_Creature:Creature = null;
      
      protected var m_Send:Boolean = true;
      
      public function ToggleAttackTargetActionImpl(param1:Creature, param2:Boolean)
      {
         super();
         this.m_Creature = param1;
         this.m_Send = param2;
      }
      
      public function perform(param1:Boolean = false) : void
      {
         Tibia.s_GetCreatureStorage().toggleAttackTarget(this.m_Creature,this.m_Send);
      }
   }
}
