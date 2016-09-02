package tibia.input.staticaction
{
   import tibia.actionbar.ActionBarSet;
   import tibia.actionbar.ActionBar;
   import tibia.input.IAction;
   import tibia.options.OptionsStorage;
   import mx.resources.ResourceManager;
   import mx.resources.IResourceManager;
   
   public class TriggerSlot extends StaticAction
   {
       
      
      protected var m_Slot:int = -1;
      
      protected var m_Location:int = -1;
      
      public function TriggerSlot(param1:int, param2:String, param3:uint, param4:int, param5:int)
      {
         super(param1,param2,param3,false);
         if(param4 != ActionBarSet.LOCATION_TOP && param4 != ActionBarSet.LOCATION_BOTTOM && param4 != ActionBarSet.LOCATION_LEFT && param4 != ActionBarSet.LOCATION_RIGHT)
         {
            throw new ArgumentError("TriggerSlot.TriggerSlot: Invalid location: " + param4);
         }
         this.m_Location = param4;
         if(param5 < 0 || param5 >= ActionBar.NUM_ACTIONS)
         {
            throw new RangeError("TriggerSlot.TriggerSlot: Invalid slot: " + param5);
         }
         this.m_Slot = param5;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var a_Repeat:Boolean = param1;
         var Options:OptionsStorage = Tibia.s_GetOptions();
         var _ActionBarSet:ActionBarSet = null;
         var _ActionBar:ActionBar = null;
         var _Action:IAction = null;
         if(Options != null && (_ActionBarSet = Options.getActionBarSet(Options.generalInputSetID)) != null && (_ActionBar = _ActionBarSet.getActionBar(this.m_Location)) != null && (_Action = _ActionBar.getAction(this.m_Slot)) != null)
         {
            try
            {
               _Action.perform(a_Repeat);
               return;
            }
            catch(e:*)
            {
               return;
            }
         }
      }
      
      override public function toString() : String
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         if(m_Label != null)
         {
            return _loc1_.getString(BUNDLE,m_Label,[ActionBar.getLabel(this.m_Location,this.m_Slot)]);
         }
         return _loc1_.getString(BUNDLE,"UNKNOWN_ACTION");
      }
   }
}
