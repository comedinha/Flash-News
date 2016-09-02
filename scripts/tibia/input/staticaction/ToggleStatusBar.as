package tibia.input.staticaction
{
   import tibia.creatures.StatusWidget;
   
   public class ToggleStatusBar extends StaticAction
   {
       
      
      private var m_PreviousStyle:int = -1;
      
      public function ToggleStatusBar(param1:int, param2:String, param3:uint)
      {
         super(param1,param2,param3,false);
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:StatusWidget = Tibia.s_GetStatusWidget();
         if(_loc2_ != null)
         {
            _loc2_.visible = !_loc2_.visible;
         }
      }
   }
}
