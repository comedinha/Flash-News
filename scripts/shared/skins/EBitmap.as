package shared.skins
{
   public class EBitmap
   {
      
      public static const ALL:int = -1;
      
      public static const LEFT:int = 2;
      
      public static const TOP_LEFT:int = 1;
      
      public static const CENTER:int = 8;
      
      public static const BOTTOM_LEFT:int = 3;
      
      public static const BOTTOM_RIGHT:int = 5;
      
      public static const NUM_BITMAPS:int = 9;
      
      public static const BOTTOM:int = 4;
      
      public static const TOP:int = 0;
      
      public static const NONE:int = -2;
      
      public static const TOP_RIGHT:int = 7;
      
      public static const RIGHT:int = 6;
       
      
      public function EBitmap()
      {
         super();
      }
      
      public static function s_ToString(param1:int) : String
      {
         switch(param1)
         {
            case CENTER:
               return "center";
            case TOP_RIGHT:
               return "topRight";
            case RIGHT:
               return "right";
            case BOTTOM_RIGHT:
               return "bottomRight";
            case BOTTOM:
               return "bottom";
            case BOTTOM_LEFT:
               return "bottomLeft";
            case LEFT:
               return "left";
            case TOP_LEFT:
               return "topLeft";
            case TOP:
               return "top";
            case ALL:
               return "all";
            default:
               return "none";
         }
      }
      
      public static function s_ParseString(param1:String) : int
      {
         switch(param1)
         {
            case "center":
               return CENTER;
            case "topRight":
               return TOP_RIGHT;
            case "right":
               return RIGHT;
            case "bottomRight":
               return BOTTOM_RIGHT;
            case "bottom":
               return BOTTOM;
            case "bottomLeft":
               return BOTTOM_LEFT;
            case "left":
               return LEFT;
            case "topLeft":
               return TOP_LEFT;
            case "top":
               return TOP;
            case "all":
               return ALL;
            default:
               return NONE;
         }
      }
   }
}
