package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   import tibia.sidebar.SideBar;
   import tibia.sidebar.SideBarSet;
   
   public class ToggleSideBar extends StaticAction
   {
       
      
      private var m_Location:int = -1;
      
      public function ToggleSideBar(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         if(param4 != SideBarSet.LOCATION_A && param4 != SideBarSet.LOCATION_B && param4 != SideBarSet.LOCATION_C && param4 != SideBarSet.LOCATION_D)
         {
            throw new ArgumentError("ToggleSideBar.ToggleSideBar: Invalid location: " + param4);
         }
         this.m_Location = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:SideBarSet = null;
         var _loc4_:SideBar = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null && (_loc4_ = _loc3_.getSideBar(this.m_Location)) != null)
         {
            _loc4_.visible = !_loc4_.visible;
         }
      }
   }
}
