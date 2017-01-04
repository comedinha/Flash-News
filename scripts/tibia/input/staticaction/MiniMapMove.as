package tibia.input.staticaction
{
   import tibia.minimap.MiniMapWidget;
   import tibia.options.OptionsStorage;
   import tibia.sidebar.SideBarSet;
   import tibia.sidebar.Widget;
   
   public class MiniMapMove extends StaticAction
   {
      
      public static const NORTH:int = 1;
      
      public static const DOWN:int = 5;
      
      public static const SOUTH:int = 3;
      
      public static const WEST:int = 2;
      
      public static const CENTER:int = 6;
      
      public static const UP:int = 4;
      
      public static const EAST:int = 0;
       
      
      protected var m_Direction:int = 0;
      
      public function MiniMapMove(param1:int, param2:String, param3:uint, param4:int)
      {
         super(param1,param2,param3,false);
         if(param4 != EAST && param4 != NORTH && param4 != WEST && param4 != SOUTH && param4 != UP && param4 != DOWN && param4 != CENTER)
         {
            throw new ArgumentError("MiniMapMove.MiniMapMove: Invalid movement direction: " + param4 + ".");
         }
         this.m_Direction = param4;
      }
      
      override public function perform(param1:Boolean = false) : void
      {
         var _loc2_:OptionsStorage = Tibia.s_GetOptions();
         var _loc3_:SideBarSet = null;
         var _loc4_:MiniMapWidget = null;
         if(_loc2_ != null && (_loc3_ = _loc2_.getSideBarSet(SideBarSet.DEFAULT_SET)) != null && (_loc4_ = _loc3_.getWidgetByType(Widget.TYPE_MINIMAP) as MiniMapWidget) != null)
         {
            switch(this.m_Direction)
            {
               case EAST:
                  _loc4_.translatePosition(1,0,0);
                  break;
               case NORTH:
                  _loc4_.translatePosition(0,-1,0);
                  break;
               case WEST:
                  _loc4_.translatePosition(-1,0,0);
                  break;
               case SOUTH:
                  _loc4_.translatePosition(0,1,0);
                  break;
               case UP:
                  _loc4_.translatePosition(0,0,-1);
                  break;
               case DOWN:
                  _loc4_.translatePosition(0,0,1);
                  break;
               case CENTER:
                  _loc4_.centerPosition();
            }
         }
      }
   }
}
