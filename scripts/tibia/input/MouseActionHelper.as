package tibia.input
{
   import tibia.creatures.Creature;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.ObjectInstance;
   import tibia.cursors.DefaultCursor;
   import tibia.cursors.LookCursor;
   import tibia.cursors.UseCursor;
   import tibia.cursors.AttackCursor;
   import tibia.cursors.WalkCursor;
   import tibia.cursors.OpenCursor;
   import tibia.cursors.TalkCursor;
   
   public class MouseActionHelper
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      protected static const NUM_EFFECTS:int = 200;
      
      private static const ACTION_LOOK:int = 6;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const ACTION_TALK:int = 9;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      private static const ACTION_NONE:int = 0;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      private static const ACTION_UNSET:int = -1;
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      private static const ACTION_USE:int = 7;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
       
      
      public function MouseActionHelper()
      {
         super();
      }
      
      public static function resolveActionForAppearanceOrCreature(param1:uint, param2:*, param3:Vector.<uint>) : uint
      {
         var _loc4_:uint = param1;
         var _loc5_:Creature = null;
         var _loc6_:AppearanceInstance = null;
         if(param2 == null)
         {
            return param1;
         }
         if(param2 is AppearanceInstance)
         {
            _loc6_ = param2 as AppearanceInstance;
            if(_loc6_.type.isCreature && _loc6_ is ObjectInstance)
            {
               _loc5_ = Tibia.s_GetCreatureStorage().getCreature((_loc6_ as ObjectInstance).data);
            }
         }
         else if(param2 is Creature)
         {
            _loc5_ = param2 as Creature;
         }
         else
         {
            throw new ArgumentError("MouseActionHelper.resolveActionForAppearanceOrCreature: a_ApperanceOrCreature must be AppearanceInstance or Creature");
         }
         if(_loc4_ == ACTION_SMARTCLICK)
         {
            if(_loc5_ == Tibia.s_GetPlayer())
            {
               _loc4_ = ACTION_LOOK;
            }
            else if(_loc6_ != null && _loc6_.type.isDefaultAction)
            {
               if(_loc6_.type.defaultAction != ACTION_NONE)
               {
                  _loc4_ = _loc6_.type.defaultAction;
               }
               else
               {
                  _loc4_ = ACTION_LOOK;
               }
            }
            else if(_loc6_ != null && _loc6_.type.isCreature || _loc5_ != null)
            {
               _loc4_ = ACTION_ATTACK_OR_TALK;
            }
            else if(_loc6_ != null && _loc6_.type.isUsable)
            {
               _loc4_ = ACTION_USE_OR_OPEN;
            }
            else
            {
               _loc4_ = ACTION_LOOK;
            }
         }
         if(_loc4_ == ACTION_USE_OR_OPEN)
         {
            _loc4_ = ACTION_USE;
            if(_loc6_ != null && _loc6_.type.isContainer)
            {
               _loc4_ = ACTION_OPEN;
            }
         }
         if(_loc4_ == ACTION_ATTACK_OR_TALK)
         {
            _loc4_ = ACTION_ATTACK;
            if(_loc5_ != null && _loc5_.isNPC)
            {
               _loc4_ = ACTION_TALK;
            }
         }
         if(_loc4_ == ACTION_AUTOWALK && _loc6_ != null && _loc6_.type.defaultAction == ACTION_AUTOWALK_HIGHLIGHT)
         {
            _loc4_ = ACTION_AUTOWALK_HIGHLIGHT;
         }
         if(param3 != null && param3.indexOf(_loc4_) == -1)
         {
            _loc4_ = ACTION_NONE;
         }
         return _loc4_;
      }
      
      public static function actionToMouseCursor(param1:int) : Class
      {
         var _loc2_:Class = DefaultCursor;
         switch(param1)
         {
            case ACTION_LOOK:
               _loc2_ = LookCursor;
               break;
            case ACTION_USE:
               _loc2_ = UseCursor;
               break;
            case ACTION_ATTACK:
               _loc2_ = AttackCursor;
               break;
            case ACTION_AUTOWALK:
            case ACTION_AUTOWALK_HIGHLIGHT:
               _loc2_ = WalkCursor;
               break;
            case ACTION_OPEN:
               _loc2_ = OpenCursor;
               break;
            case ACTION_TALK:
               _loc2_ = TalkCursor;
         }
         return _loc2_;
      }
   }
}
