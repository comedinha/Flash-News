package tibia.input.staticaction
{
   import tibia.options.OptionsStorage;
   import tibia.sidebar.SideBarSet;
   import tibia.minimap.MiniMapWidget;
   import tibia.sidebar.Widget;
   
   public class MiniMapZoom extends StaticAction
   {
       
      
      protected var m_Delta:int = 0;
      
      public function MiniMapZoom(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         this.m_Delta = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:SideBarSet = null;
         var _loc4_:MiniMapWidget = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null && (_loc4_ = _loc3_.getWidgetByType(Widget.TYPE_MINIMAP) as MiniMapWidget) != null)
         {
            _loc4_.zoom = _loc4_.zoom + this.m_Delta;
         }
      }
   }
}
