package tibia.appearances
{
   public class AppearanceType
   {
      
      private static const ACTION_UNSET:int = -1;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      private static const ACTION_LOOK:int = 6;
      
      private static const ACTION_TALK:int = 9;
      
      private static const ACTION_USE:int = 7;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      private static const ACTION_NONE:int = 0;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
       
      
      public var isMarket:Boolean = false;
      
      public var isHookEast:Boolean = false;
      
      public var isUnmoveable:Boolean = false;
      
      public var isCloth:Boolean = false;
      
      public var isLight:Boolean = false;
      
      public var isHangable:Boolean = false;
      
      public var isUnsight:Boolean = false;
      
      public var ID:int = 0;
      
      public var displacementX:int = 0;
      
      public var displacementY:int = 0;
      
      public var isLiquidContainer:Boolean = false;
      
      public var clothSlot:int = 0;
      
      public var isTopEffect:Boolean = false;
      
      public var isDisplaced:Boolean = false;
      
      public var marketRestrictProfession:uint = 0;
      
      public var isAnimateAlways:Boolean = false;
      
      public var isLiquidPool:Boolean = false;
      
      public var isLyingObject:Boolean = false;
      
      public var marketRestrictLevel:uint = 0;
      
      public var isUnpassable:Boolean = false;
      
      public var brightness:int = 0;
      
      public var marketCategory:int = 0;
      
      public var isIgnoreLook:Boolean = false;
      
      public var elevation:int = 0;
      
      public var lensHelp:int = 0;
      
      public var isHookSouth:Boolean = false;
      
      public var isCachable:Boolean = false;
      
      public var isAvoid:Boolean = false;
      
      public var marketShowAs:int = 0;
      
      public var isContainer:Boolean = false;
      
      public var automapColour:int = 0;
      
      public var FrameGroups:Object;
      
      public var lightColour:int = 0;
      
      public var isBank:Boolean = false;
      
      public var waypoints:int = 0;
      
      public var isClip:Boolean = false;
      
      public var isDonthide:Boolean = false;
      
      public var preventMovementAnimation:Boolean = false;
      
      public var isLensHelp:Boolean = false;
      
      public var marketNameLowerCase:String = null;
      
      public var isTakeable:Boolean = false;
      
      public var isWriteable:Boolean = false;
      
      public var isFullBank:Boolean = false;
      
      public var isCumulative:Boolean = false;
      
      public var isUsable:Boolean = false;
      
      public var isAutomap:Boolean = false;
      
      public var isUnwrappable:Boolean = false;
      
      public var isWrappable:Boolean = false;
      
      public var isTop:Boolean = false;
      
      public var isDefaultAction:Boolean = false;
      
      public var isTranslucent:Boolean = false;
      
      public var isWriteableOnce:Boolean = false;
      
      public var defaultAction:int = -1;
      
      public var isMultiUse:Boolean = false;
      
      public var marketTradeAs:int = 0;
      
      public var isForceUse:Boolean = false;
      
      public var marketName:String = null;
      
      public var isHeight:Boolean = false;
      
      public var isBottom:Boolean = false;
      
      public var maxTextLength:int = 0;
      
      public var isRotateable:Boolean = false;
      
      public function AppearanceType(param1:int)
      {
         this.FrameGroups = {};
         super();
         this.ID = param1;
      }
      
      public function get isCreature() : Boolean
      {
         return this.ID == AppearanceInstance.CREATURE || this.ID == AppearanceInstance.OUTDATEDCREATURE || this.ID == AppearanceInstance.UNKNOWNCREATURE;
      }
   }
}
