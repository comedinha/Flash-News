package tibia.options.configurationWidgetClasses
{
   import shared.controls.EmbeddedDialog;
   import mx.events.ListEvent;
   import mx.controls.ComboBox;
   import mx.containers.Box;
   import mx.core.ClassFactory;
   import shared.controls.CustomList;
   
   public class AddMappingSetDialog extends EmbeddedDialog
   {
      
      private static const BUNDLE:String = "OptionsConfigurationWidget";
       
      
      private var m_SelectedIndex:int = -1;
      
      private var m_UncommittedSelectedIndex:Boolean = false;
      
      private var m_MappingSets:Array = null;
      
      private var m_UncommittedMappingSets:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UIMappingSets:ComboBox = null;
      
      public function AddMappingSetDialog()
      {
         super();
      }
      
      private function onSelectMappingSet(param1:ListEvent) : void
      {
         this.selectedIndex = ComboBox(param1.currentTarget).selectedIndex;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedMappingSets)
         {
            this.m_UIMappingSets.dataProvider = this.m_MappingSets;
            this.m_UncommittedMappingSets = false;
         }
         if(this.m_UncommittedSelectedIndex)
         {
            this.m_UIMappingSets.selectedIndex = this.m_SelectedIndex;
            this.m_UncommittedSelectedIndex = false;
         }
      }
      
      public function set selectedIndex(param1:int) : void
      {
         if(this.m_SelectedIndex != param1)
         {
            this.m_SelectedIndex = param1;
            this.m_UncommittedSelectedIndex = true;
            invalidateProperties();
         }
      }
      
      public function get selectedIndex() : int
      {
         return this.m_SelectedIndex;
      }
      
      override protected function createContent(param1:Box) : void
      {
         super.createContent(param1);
         this.m_UIMappingSets = new ComboBox();
         this.m_UIMappingSets.dropdownFactory = new ClassFactory(CustomList);
         this.m_UIMappingSets.labelField = "name";
         this.m_UIMappingSets.addEventListener(ListEvent.CHANGE,this.onSelectMappingSet);
         param1.addChild(this.m_UIMappingSets);
         param1.minHeight = 62;
         param1.setStyle("horizontalAlign","center");
      }
      
      public function set mappingSets(param1:Array) : void
      {
         if(this.m_MappingSets != param1)
         {
            this.m_MappingSets = param1;
            this.m_UncommittedMappingSets = true;
            invalidateProperties();
         }
      }
      
      public function get mappingSets() : Array
      {
         return this.m_MappingSets;
      }
   }
}
