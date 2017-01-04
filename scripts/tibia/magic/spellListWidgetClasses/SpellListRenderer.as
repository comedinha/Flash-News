package tibia.magic.spellListWidgetClasses
{
   import mx.containers.VBox;
   import mx.controls.Label;
   import shared.controls.CustomLabel;
   import tibia.magic.Spell;
   
   public class SpellListRenderer extends SpellTileRenderer
   {
       
      
      private var m_UIFormula:Label = null;
      
      private var m_UIName:Label = null;
      
      private var m_UncommittedSpell:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      public function SpellListRenderer()
      {
         super();
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedSpell)
         {
            if(super.spell != null)
            {
               this.m_UIName.text = super.spell.name;
               this.m_UIFormula.text = super.spell.formula;
            }
            else
            {
               this.m_UIName.text = null;
               this.m_UIFormula.text = null;
            }
            this.m_UncommittedSpell = false;
         }
      }
      
      override protected function set spell(param1:Spell) : void
      {
         if(super.spell != param1)
         {
            super.spell = param1;
            this.m_UncommittedSpell = true;
            invalidateProperties();
         }
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:VBox = null;
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            _loc1_ = new VBox();
            _loc1_.percentHeight = 100;
            _loc1_.percentWidth = 100;
            _loc1_.setStyle("verticalGap",0);
            this.m_UIName = new CustomLabel();
            this.m_UIName.percentWidth = 100;
            this.m_UIName.truncateToFit = true;
            _loc1_.addChild(this.m_UIName);
            this.m_UIFormula = new CustomLabel();
            this.m_UIFormula.percentWidth = 100;
            this.m_UIFormula.truncateToFit = true;
            _loc1_.addChild(this.m_UIFormula);
            addChild(_loc1_);
            this.m_UIConstructed = true;
         }
      }
   }
}
