package tibia.market.marketWidgetClasses
{
   import mx.controls.Label;
   import tibia.appearances.AppearanceType;
   import shared.controls.CustomLabel;
   
   public class AppearanceTypeListRenderer extends AppearanceTypeTileRenderer
   {
       
      
      private var m_UIName:Label = null;
      
      private var m_UncommittedAppearance:Boolean = false;
      
      public function AppearanceTypeListRenderer()
      {
         super();
      }
      
      override protected function set appearance(param1:AppearanceType) : void
      {
         if(super.appearance != param1)
         {
            super.appearance = param1;
            this.m_UncommittedAppearance = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedAppearance)
         {
            if(super.appearance != null)
            {
               this.m_UIName.text = super.appearance.marketName;
            }
            else
            {
               this.m_UIName.text = null;
            }
            this.m_UncommittedAppearance = false;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIName = new CustomLabel();
         this.m_UIName.percentWidth = 100;
         this.m_UIName.truncateToFit = true;
         addChild(this.m_UIName);
      }
   }
}
