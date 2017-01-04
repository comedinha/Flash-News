package tibia.appearances
{
   import flash.display.BitmapData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import tibia.appearances.widgetClasses.CachedSpriteInformation;
   
   public class AppearanceInstance
   {
      
      protected static const s_TempRect:Rectangle = new Rectangle(0,0,0,0);
      
      public static const CREATURE:int = 99;
      
      public static const OUTDATEDCREATURE:int = 98;
      
      public static const UNKNOWNCREATURE:int = 97;
      
      protected static const s_TempPoint:Point = new Point(0,0);
      
      public static const PURSE:int = 16087;
       
      
      protected var m_LastPhase:int = -2.147483648E9;
      
      protected var m_LastInternalPhase:int = -2.147483648E9;
      
      protected var m_CacheDirty:Boolean = false;
      
      protected var m_LastCachedSpriteIndex:uint = 4.294967295E9;
      
      var mapData:int = -1;
      
      protected var m_ActiveFrameGroup:uint = 0;
      
      var m_Type:AppearanceType = null;
      
      var m_ID:int = 0;
      
      protected var m_LastPatternX:int = -2.147483648E9;
      
      protected var m_LastPatternY:int = -2.147483648E9;
      
      protected var m_LastPatternZ:int = -2.147483648E9;
      
      protected var m_Animators:Object;
      
      var mapField:int = -1;
      
      protected var m_TempAlternativePhases:Vector.<uint> = null;
      
      public function AppearanceInstance(param1:int, param2:AppearanceType)
      {
         var _loc3_:* = null;
         this.m_Animators = {};
         super();
         this.m_ID = param1;
         this.m_Type = param2;
         if(this.m_Type != null && this.m_Type.FrameGroups[this.m_ActiveFrameGroup].isAnimation)
         {
            this.m_TempAlternativePhases = new Vector.<uint>(this.m_Type.FrameGroups[this.m_ActiveFrameGroup].phases,true);
         }
         if(param2 != null)
         {
            for(_loc3_ in param2.FrameGroups)
            {
               if(param2.FrameGroups[_loc3_].animator != null)
               {
                  this.m_Animators[parseInt(_loc3_)] = param2.FrameGroups[_loc3_].animator.clone();
               }
            }
         }
      }
      
      public function get type() : AppearanceType
      {
         return this.m_Type;
      }
      
      public function switchFrameGroup(param1:uint) : void
      {
      }
      
      public function getSprite(param1:int, param2:int, param3:int, param4:int, param5:Boolean = false) : CachedSpriteInformation
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc6_:uint = this.getSpriteIndex(param1,param2,param3,param4);
         var _loc7_:CachedSpriteInformation = this.m_Type.FrameGroups[this.m_ActiveFrameGroup].cachedSpriteInformations[_loc6_];
         _loc7_ = this.m_Type.FrameGroups[this.m_ActiveFrameGroup].spriteProvider.getSprite(_loc7_.spriteID,_loc7_,this.m_Type);
         if(_loc7_.cacheMiss == false || param5 == false)
         {
            return _loc7_;
         }
         _loc8_ = 0;
         while(_loc8_ < this.m_Type.FrameGroups[this.m_ActiveFrameGroup].phases)
         {
            _loc9_ = this.getSpriteIndex(_loc8_,param2,param3,param4);
            _loc7_ = this.m_Type.FrameGroups[this.m_ActiveFrameGroup].cachedSpriteInformations[_loc9_];
            _loc7_ = this.m_Type.FrameGroups[this.m_ActiveFrameGroup].spriteProvider.getSprite(_loc7_.spriteID,_loc7_,this.m_Type);
            if(_loc7_.cacheMiss == false)
            {
               break;
            }
            _loc8_++;
         }
         return _loc7_;
      }
      
      public function getSpriteIndex(param1:int, param2:int, param3:int, param4:int) : uint
      {
         if(this.phase == this.m_LastInternalPhase && param2 == this.m_LastPatternX && param4 >= 0 && param3 == this.m_LastPatternY && param3 >= 0 && param4 == this.m_LastPatternZ && param2 >= 0)
         {
            return this.m_LastCachedSpriteIndex;
         }
         var _loc5_:int = this.phase;
         var _loc6_:int = param4 >= 0?int(param4 % this.m_Type.FrameGroups[this.m_ActiveFrameGroup].patternDepth):0;
         var _loc7_:int = param3 >= 0?int(param3 % this.m_Type.FrameGroups[this.m_ActiveFrameGroup].patternHeight):0;
         var _loc8_:int = param2 >= 0?int(param2 % this.m_Type.FrameGroups[this.m_ActiveFrameGroup].patternWidth):0;
         var _loc9_:int = ((_loc5_ * this.m_Type.FrameGroups[this.m_ActiveFrameGroup].patternDepth + _loc6_) * this.m_Type.FrameGroups[this.m_ActiveFrameGroup].patternHeight + _loc7_) * this.m_Type.FrameGroups[this.m_ActiveFrameGroup].patternWidth + _loc8_;
         this.m_LastInternalPhase = this.phase;
         this.m_LastPatternX = param2;
         this.m_LastPatternY = param3;
         this.m_LastPatternZ = param4;
         this.m_LastCachedSpriteIndex = _loc9_;
         return _loc9_;
      }
      
      public function get ID() : int
      {
         return this.m_ID;
      }
      
      public function drawTo(param1:BitmapData, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         var _loc7_:CachedSpriteInformation = null;
         _loc7_ = this.getSprite(-1,param4,param5,param6,this.m_Type.FrameGroups[this.m_ActiveFrameGroup].isAnimation);
         this.m_CacheDirty = _loc7_.cacheMiss;
         var _loc8_:Rectangle = _loc7_.rectangle;
         s_TempPoint.setTo(param2 - _loc8_.width - this.m_Type.displacementX,param3 - _loc8_.height - this.m_Type.displacementY);
         param1.copyPixels(_loc7_.bitmapData,_loc8_,s_TempPoint,null,null,true);
      }
      
      public function animate(param1:Number, param2:int = 0) : Boolean
      {
         if(this.m_Animators.hasOwnProperty(this.m_ActiveFrameGroup))
         {
            this.m_Animators[this.m_ActiveFrameGroup].animate(param1,0);
            return !this.m_Animators[this.m_ActiveFrameGroup].finished;
         }
         return false;
      }
      
      public function set phase(param1:int) : void
      {
         if(this.m_Animators.hasOwnProperty(this.m_ActiveFrameGroup))
         {
            this.m_Animators[this.m_ActiveFrameGroup].phase = param1;
         }
      }
      
      public function get cacheDirty() : Boolean
      {
         return this.m_CacheDirty;
      }
      
      public function get phase() : int
      {
         if(this.m_Animators.hasOwnProperty(this.m_ActiveFrameGroup))
         {
            return this.m_Animators[this.m_ActiveFrameGroup].phase;
         }
         return 0;
      }
   }
}
