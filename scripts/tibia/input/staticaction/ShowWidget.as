package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   import tibia.sidebar.SideBarSet;
   import tibia.sidebar.Widget;
   
   public class ShowWidget extends StaticAction
   {
       
      
      private var m_Type:int = -1;
      
      public function ShowWidget(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         if(param4 != Widget.TYPE_BATTLELIST && param4 != Widget.TYPE_BODY && param4 != Widget.TYPE_BUDDYLIST && param4 != Widget.TYPE_COMBATCONTROL && param4 != Widget.TYPE_GENERALBUTTONS && param4 != Widget.TYPE_MINIMAP && param4 != Widget.TYPE_SPELLLIST)
         {
            throw ArgumentError("ShowWidget.ShowWidget: Invalid type: " + param4);
         }
         this.m_Type = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:SideBarSet = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null)
         {
            if(_loc3_.countWidgetType(this.m_Type,-1) > 0)
            {
               _loc3_.hideWidgetType(this.m_Type,-1);
            }
            else
            {
               _loc3_.showWidgetType(this.m_Type,-1,-1);
            }
         }
      }
   }
}
