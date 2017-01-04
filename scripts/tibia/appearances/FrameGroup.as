package tibia.appearances
{
   import tibia.appearances.widgetClasses.CachedSpriteInformation;
   import tibia.appearances.widgetClasses.ISpriteProvider;
   
   public class FrameGroup
   {
      
      private static const ENVIRONMENTAL_EFFECTS:Array = [];
      
      public static const ANIMATION_DELAY_BEFORE_RESET:int = 1000;
      
      public static const FRAME_GROUP_WALKING:uint = 1;
      
      public static const PHASE_AUTOMATIC:int = -1;
      
      protected static const APPEARANCE_EFFECT:uint = 2;
      
      public static const SPRITE_CACHE_PAGE_DIMENSION:uint = 512;
      
      public static const FRAME_GROUP_DEFAULT:uint = FRAME_GROUP_IDLE;
      
      private static const MAX_SPEED_DELAY:int = 100;
      
      public static const FRAME_GROUP_IDLE:uint = 0;
      
      public static const COMPRESSED_IMAGES_CACHE_MEMORY:uint = 4 * 768 * 768 * 15;
      
      public static const ANIMATION_ASYNCHRON:int = 0;
      
      protected static const APPEARANCE_MISSILE:uint = 3;
      
      public static const PHASE_RANDOM:int = 254;
      
      private static const MINIMUM_SPEED_FRAME_DURATION:int = 90 * 8;
      
      public static const PHASE_ASYNCHRONOUS:int = 255;
      
      public static const SPRITE_CACHE_PAGE_COUNT:uint = 5 * 5;
      
      private static const MIN_SPEED_DELAY:int = 550;
      
      protected static const APPEARANCE_OBJECT:uint = 0;
      
      private static const MAXIMUM_SPEED_FRAME_DURATION:int = 35 * 8;
      
      protected static const APPEARANCE_OUTFIT:uint = 1;
      
      public static const ANIMATION_SYNCHRON:int = 1;
       
      
      public var layers:int = 0;
      
      public var width:int = 0;
      
      public var spriteIDs:Vector.<uint>;
      
      public var patternWidth:int = 0;
      
      public var patternHeight:int = 0;
      
      public var phases:int = 0;
      
      public var patternDepth:int = 0;
      
      public var spriteProvider:ISpriteProvider = null;
      
      public var exactSize:int = 0;
      
      public var animator:AppearanceAnimator = null;
      
      public var numSprites:int = 0;
      
      public var cachedSpriteInformations:Vector.<CachedSpriteInformation>;
      
      public var height:int = 0;
      
      public var isAnimation:Boolean = false;
      
      public var spritesheetIDs:Vector.<uint>;
      
      public function FrameGroup()
      {
         this.spriteIDs = new Vector.<uint>();
         this.spritesheetIDs = new Vector.<uint>();
         this.cachedSpriteInformations = new Vector.<CachedSpriteInformation>();
         super();
      }
   }
}
