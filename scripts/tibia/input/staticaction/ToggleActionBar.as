package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   import tibia.actionbar.ActionBarSet;
   import tibia.actionbar.ActionBar;
   
   public class ToggleActionBar extends StaticAction
   {
       
      
      private var m_Location:int = -1;
      
      public function ToggleActionBar(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         if(param4 != ActionBarSet.LOCATION_TOP && param4 != ActionBarSet.LOCATION_BOTTOM && param4 != ActionBarSet.LOCATION_LEFT && param4 != ActionBarSet.LOCATION_RIGHT)
         {
            throw new ArgumentError("ToggleActionBar.ToggleActionBar: Invalid location: " + param4);
         }
         this.m_Location = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:ActionBarSet = null;
         var _loc4_:ActionBar = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getActionBarSet(_loc2_.generalInputSetID)) != null && (_loc4_ = _loc3_.getActionBar(this.m_Location)) != null)
         {
            _loc4_.visible = !_loc4_.visible;
         }
      }
   }
}
