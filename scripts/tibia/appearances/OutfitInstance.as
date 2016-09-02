package tibia.appearances
{
   import flash.display.BitmapData;
   import flash.filters.BitmapFilter;
   import flash.display.Shader;
   import flash.geom.ColorTransform;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Rectangle;
   import tibia.§appearances:ns_appearance_internal§.m_Type;
   import tibia.appearances.widgetClasses.CachedSpriteInformation;
   import shared.utility.Colour;
   import flash.display.BitmapDataChannel;
   import flash.geom.Point;
   import flash.display.ShaderJob;
   
   public class OutfitInstance extends AppearanceInstance
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const s_GreyBitmap:BitmapData = new BitmapData(INSTANCE_CACHE_MAX_WIDTH * INSTANCE_CACHE_MAX_SPRITES,INSTANCE_CACHE_MAX_HEIGHT,true,0);
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const MAP_HEIGHT:int = 11;
      
      private static const REPLACE_BLUE_WIDTH_YELLOW:BitmapFilter = new ColorMatrixFilter([1,-1,0,0,0,-1,1,0,0,0,1,1,0,0,-255,0,0,-1,1,0]);
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      private static const TIBIA_MASKS_SHADER_CLASS:Class = OutfitInstance_TIBIA_MASKS_SHADER_CLASS;
      
      private static const INSTANCE_CACHE_MAX_WIDTH:int = 2 * FIELD_SIZE;
      
      public static const INVISIBLE_OUTFIT_ID:int = 0;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      private static const s_TibiaMasksShader:Shader = new Shader(new TIBIA_MASKS_SHADER_CLASS());
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      public static const MAX_NAME_LENGTH:int = 30;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      private static const s_MaskBitmap:BitmapData = new BitmapData(INSTANCE_CACHE_MAX_WIDTH * INSTANCE_CACHE_MAX_SPRITES,INSTANCE_CACHE_MAX_HEIGHT,true,0);
      
      private static const s_ColourBitmap:BitmapData = new BitmapData(INSTANCE_CACHE_MAX_WIDTH * INSTANCE_CACHE_MAX_SPRITES,INSTANCE_CACHE_MAX_HEIGHT,true,0);
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      private static const INSTANCE_CACHE_MAX_SPRITES:int = 2 * 9 * 4;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      private static const s_ColourTransform:ColorTransform = new ColorTransform();
      
      private static const INSTANCE_CACHE_MAX_HEIGHT:int = 2 * FIELD_SIZE;
      
      private static const s_DestinationBitmap:BitmapData = new BitmapData(INSTANCE_CACHE_MAX_WIDTH * INSTANCE_CACHE_MAX_SPRITES,INSTANCE_CACHE_MAX_HEIGHT,true,0);
      
      protected static const GROUND_LAYER:int = 7;
      
      {
         s_GreyBitmap.lock();
         s_MaskBitmap.lock();
         s_DestinationBitmap.lock();
      }
      
      private var m_TempSpriteInformation:CachedSpriteInformation;
      
      protected var m_ColourLegs:int = 0;
      
      protected var m_AddOns:int = 0;
      
      var m_Phase:uint = 0;
      
      protected var m_ColourTorso:int = 0;
      
      private var m_InstanceCache:Object;
      
      protected var m_ColourDetail:int = 0;
      
      protected var m_ColourHead:int = 0;
      
      public function OutfitInstance(param1:int, param2:AppearanceType, param3:int, param4:int, param5:int, param6:int, param7:int)
      {
         var _loc8_:* = null;
         var _loc9_:SpriteCacheContainer = null;
         this.m_InstanceCache = {};
         this.m_TempSpriteInformation = new CachedSpriteInformation();
         super(param1,param2);
         for(_loc8_ in m_Type.FrameGroups)
         {
            _loc9_ = new SpriteCacheContainer();
            _loc9_.m_InstanceSpriteIDs = m_Type.FrameGroups[_loc8_].spriteIDs;
            _loc9_.m_SpriteProvider = m_Type.FrameGroups[_loc8_].spriteProvider;
            this.m_InstanceCache[_loc8_] = _loc9_;
         }
         this.updateProperties(param3,param4,param5,param6,param7);
      }
      
      private function createInstanceBitmap(param1:uint) : void
      {
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Vector.<Rectangle> = null;
         if(m_Type.FrameGroups[param1].layers != 2 || this.m_InstanceCache[param1].m_UncomittedCreateInstanceBitmap == false)
         {
            return;
         }
         this.m_InstanceCache[param1].m_UncomittedCreateInstanceBitmap = false;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:BitmapData = this.m_InstanceCache[param1].m_InstanceBitmap;
         if(_loc9_ == null)
         {
            _loc10_ = m_Type.FrameGroups[param1].width * FIELD_SIZE;
            _loc11_ = m_Type.FrameGroups[param1].height * FIELD_SIZE;
            _loc9_ = new BitmapData(_loc10_ * m_Type.FrameGroups[param1].phases * m_Type.FrameGroups[param1].patternDepth * m_Type.FrameGroups[param1].patternWidth,_loc11_,true,0);
            _loc9_.lock();
            _loc12_ = new Vector.<Rectangle>(m_Type.FrameGroups[param1].numSprites,true);
            _loc2_ = 0;
            _loc4_ = m_Type.FrameGroups[param1].phases - 1;
            while(_loc4_ >= 0)
            {
               _loc8_ = m_Type.FrameGroups[param1].patternDepth - 1;
               while(_loc8_ >= 0)
               {
                  _loc6_ = m_Type.FrameGroups[param1].patternWidth - 1;
                  while(_loc6_ >= 0)
                  {
                     _loc3_ = (((_loc4_ * m_Type.FrameGroups[param1].patternDepth + _loc8_) * m_Type.FrameGroups[param1].patternHeight + 0) * m_Type.FrameGroups[param1].patternWidth + _loc6_) * m_Type.FrameGroups[param1].layers + 0;
                     _loc12_[_loc3_] = new Rectangle(_loc2_ * _loc10_,0,_loc10_,_loc11_);
                     _loc2_++;
                     _loc6_--;
                  }
                  _loc8_--;
               }
               _loc4_--;
            }
            this.m_InstanceCache[param1].m_InstanceSprite = _loc12_;
            this.m_InstanceCache[param1].m_InstanceBitmap = _loc9_;
         }
      }
      
      override public function getSprite(param1:int, param2:int, param3:int, param4:int, param5:Boolean = false) : CachedSpriteInformation
      {
         var _loc6_:* = null;
         var _loc7_:int = 0;
         var _loc8_:uint = 0;
         if(m_Type.FrameGroups[m_ActiveFrameGroup].layers != 2)
         {
            return super.getSprite(param1,param2,param3,param4,param5);
         }
         for(_loc6_ in this.m_InstanceCache)
         {
            _loc8_ = parseInt(_loc6_);
            if(this.m_InstanceCache[_loc8_].m_CacheDirty || this.m_InstanceCache[_loc8_].m_UncomittedRebuildCache)
            {
               this.rebuildCache(_loc8_);
            }
         }
         _loc7_ = this.getSpriteIndex(param1,param2,param3,param4);
         this.m_TempSpriteInformation.setCachedSpriteInformationTo(m_Type.FrameGroups[m_ActiveFrameGroup].spriteIDs[_loc7_],this.m_InstanceCache[m_ActiveFrameGroup].m_InstanceBitmap,this.m_InstanceCache[m_ActiveFrameGroup].m_InstanceSprite[_loc7_],this.m_InstanceCache[_loc8_].m_CacheDirty);
         return this.m_TempSpriteInformation;
      }
      
      private function colouriseChannel(param1:BitmapData, param2:BitmapData, param3:uint, param4:Colour) : void
      {
         s_ColourBitmap.copyPixels(param1,param1.rect,s_ColourBitmap.rect.topLeft);
         s_ColourBitmap.copyChannel(param2,param2.rect,s_ColourBitmap.rect.topLeft,param3,BitmapDataChannel.ALPHA);
         s_ColourTransform.redMultiplier = param4.redFloat;
         s_ColourTransform.greenMultiplier = param4.greenFloat;
         s_ColourTransform.blueMultiplier = param4.blueFloat;
         s_ColourBitmap.colorTransform(s_ColourBitmap.rect,s_ColourTransform);
         param1.copyPixels(s_ColourBitmap,s_ColourBitmap.rect,param1.rect.topLeft,null,null,true);
      }
      
      private function colouriseOutfitWithInternalMethod(param1:BitmapData, param2:BitmapData, param3:BitmapData) : void
      {
         var _loc4_:Colour = Colour.s_FromHSI(this.m_ColourHead);
         var _loc5_:Colour = Colour.s_FromHSI(this.m_ColourTorso);
         var _loc6_:Colour = Colour.s_FromHSI(this.m_ColourLegs);
         var _loc7_:Colour = Colour.s_FromHSI(this.m_ColourDetail);
         this.colouriseChannel(param1,param2,BitmapDataChannel.BLUE,_loc7_);
         s_MaskBitmap.applyFilter(param2,param2.rect,param2.rect.topLeft,REPLACE_BLUE_WIDTH_YELLOW);
         this.colouriseChannel(param1,param2,BitmapDataChannel.BLUE,_loc4_);
         this.colouriseChannel(param1,param2,BitmapDataChannel.RED,_loc5_);
         this.colouriseChannel(param1,param2,BitmapDataChannel.GREEN,_loc6_);
         param3.copyPixels(s_GreyBitmap,s_GreyBitmap.rect,new Point(0,0));
      }
      
      override public function getSpriteIndex(param1:int, param2:int, param3:int, param4:int) : uint
      {
         var _loc5_:int = (param1 >= 0?param1:this.m_Phase) % m_Type.FrameGroups[m_ActiveFrameGroup].phases;
         var _loc6_:int = param2 >= 0?int(param2 % m_Type.FrameGroups[m_ActiveFrameGroup].patternWidth):0;
         var _loc7_:int = param3 >= 0?int(param3 % m_Type.FrameGroups[m_ActiveFrameGroup].patternHeight):0;
         var _loc8_:int = param4 >= 0?int(param4 % m_Type.FrameGroups[m_ActiveFrameGroup].patternDepth):0;
         var _loc9_:int = (((_loc5_ * m_Type.FrameGroups[m_ActiveFrameGroup].patternDepth + _loc8_) * m_Type.FrameGroups[m_ActiveFrameGroup].patternHeight + _loc7_) * m_Type.FrameGroups[m_ActiveFrameGroup].patternWidth + _loc6_) * m_Type.FrameGroups[m_ActiveFrameGroup].layers + 0;
         return _loc9_;
      }
      
      public function updateProperties(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         var _loc6_:SpriteCacheContainer = null;
         if(this.m_ColourHead != param1 || this.m_ColourTorso != param2 || this.m_ColourLegs != param3 || this.m_ColourDetail != param4 || this.m_AddOns != param5)
         {
            this.m_ColourHead = param1;
            this.m_ColourTorso = param2;
            this.m_ColourLegs = param3;
            this.m_ColourDetail = param4;
            this.m_AddOns = param5;
            for each(_loc6_ in this.m_InstanceCache)
            {
               _loc6_.m_UncomittedRebuildCache = true;
            }
         }
      }
      
      override public function animate(param1:Number, param2:int = 0) : Boolean
      {
         if(m_Animators.hasOwnProperty(m_ActiveFrameGroup))
         {
            m_Animators[m_ActiveFrameGroup].animate(param1,param2);
            this.m_Phase = m_Animators[m_ActiveFrameGroup].phase;
            return !m_Animators[m_ActiveFrameGroup].finished;
         }
         return false;
      }
      
      override public function switchFrameGroup(param1:uint) : void
      {
         if(param1 != m_ActiveFrameGroup)
         {
            m_ActiveFrameGroup = param1;
            if(m_Animators.hasOwnProperty(m_ActiveFrameGroup) && (m_Animators[m_ActiveFrameGroup].lastAnimationTick + AppearanceAnimator.ANIMATION_DELAY_BEFORE_RESET < Tibia.s_FrameTibiaTimestamp || param1 != FrameGroup.FRAME_GROUP_WALKING))
            {
               m_Animators[m_ActiveFrameGroup].reset();
            }
         }
      }
      
      private function rebuildCache(param1:uint) : void
      {
         var _TempSpriteInformation:CachedSpriteInformation = null;
         var a_FrameGroupID:uint = param1;
         if(m_Type.FrameGroups[a_FrameGroupID].layers != 2 || this.m_InstanceCache[a_FrameGroupID].m_CacheDirty == false && this.m_InstanceCache[a_FrameGroupID].m_UncomittedRebuildCache == false)
         {
            return;
         }
         var i:int = 0;
         var c:int = 0;
         var p:int = 0;
         var s:int = 0;
         var x:int = 0;
         var y:int = 0;
         var z:int = 0;
         var CacheDirty:Boolean = false;
         if(this.m_InstanceCache[a_FrameGroupID].m_UncomittedCreateInstanceBitmap)
         {
            this.createInstanceBitmap(a_FrameGroupID);
         }
         this.m_InstanceCache[a_FrameGroupID].m_UncomittedRebuildCache = false;
         var ZeroPoint:Point = new Point(0,0);
         var m_NumberOfAddOns:int = -1;
         try
         {
            y = 0;
            while(true)
            {
               if(y < m_Type.FrameGroups[a_FrameGroupID].patternHeight)
               {
                  if(!(y > 0 && (this.m_AddOns & 1 << y - 1) == 0))
                  {
                     m_NumberOfAddOns++;
                     p = m_Type.FrameGroups[a_FrameGroupID].phases - 1;
                     while(p >= 0)
                     {
                        z = m_Type.FrameGroups[a_FrameGroupID].patternDepth - 1;
                        while(z >= 0)
                        {
                           x = m_Type.FrameGroups[a_FrameGroupID].patternWidth - 1;
                           while(x >= 0)
                           {
                              s = (((p * m_Type.FrameGroups[a_FrameGroupID].patternDepth + z) * m_Type.FrameGroups[a_FrameGroupID].patternHeight + y) * m_Type.FrameGroups[a_FrameGroupID].patternWidth + x) * m_Type.FrameGroups[a_FrameGroupID].layers + 0;
                              c = (((p * m_Type.FrameGroups[a_FrameGroupID].patternDepth + z) * m_Type.FrameGroups[a_FrameGroupID].patternHeight + 0) * m_Type.FrameGroups[a_FrameGroupID].patternWidth + x) * m_Type.FrameGroups[a_FrameGroupID].layers + 0;
                              _TempSpriteInformation = m_Type.FrameGroups[a_FrameGroupID].cachedSpriteInformations[s];
                              _TempSpriteInformation = m_Type.FrameGroups[a_FrameGroupID].spriteProvider.getSprite(m_Type.FrameGroups[a_FrameGroupID].spriteIDs[s],_TempSpriteInformation,this.m_Type);
                              CacheDirty = CacheDirty || _TempSpriteInformation.cacheMiss;
                              if(CacheDirty)
                              {
                                 addr306:
                                 return;
                              }
                              s_GreyBitmap.copyPixels(_TempSpriteInformation.bitmapData,_TempSpriteInformation.rectangle,this.m_InstanceCache[a_FrameGroupID].m_InstanceSprite[c].topLeft);
                              s++;
                              _TempSpriteInformation = m_Type.FrameGroups[a_FrameGroupID].cachedSpriteInformations[s];
                              _TempSpriteInformation = m_Type.FrameGroups[a_FrameGroupID].spriteProvider.getSprite(m_Type.FrameGroups[a_FrameGroupID].spriteIDs[s],_TempSpriteInformation,this.m_Type);
                              CacheDirty = CacheDirty || _TempSpriteInformation.cacheMiss;
                              if(CacheDirty)
                              {
                                 return;
                              }
                              s_MaskBitmap.copyPixels(_TempSpriteInformation.bitmapData,_TempSpriteInformation.rectangle,this.m_InstanceCache[a_FrameGroupID].m_InstanceSprite[c].topLeft);
                              x--;
                           }
                           z--;
                        }
                        p--;
                     }
                     this.colouriseOutfitWithInternalMethod(s_GreyBitmap,s_MaskBitmap,s_DestinationBitmap);
                     this.m_InstanceCache[a_FrameGroupID].m_InstanceBitmap.copyPixels(s_DestinationBitmap,s_DestinationBitmap.rect,ZeroPoint,null,null,y > 0);
                  }
                  y++;
                  continue;
               }
            }
            §§goto(addr306);
            return;
         }
         finally
         {
            while(true)
            {
               if(CacheDirty == false)
               {
                  this.m_InstanceCache[a_FrameGroupID].m_CacheDirty = false;
               }
               else
               {
                  this.m_InstanceCache[a_FrameGroupID].m_CacheDirty = true;
               }
            }
         }
      }
      
      private function colouriseOutfitWithPixelBender(param1:BitmapData, param2:BitmapData, param3:BitmapData) : void
      {
         var _loc4_:Colour = Colour.s_FromHSI(this.m_ColourHead);
         var _loc5_:Colour = Colour.s_FromHSI(this.m_ColourTorso);
         var _loc6_:Colour = Colour.s_FromHSI(this.m_ColourLegs);
         var _loc7_:Colour = Colour.s_FromHSI(this.m_ColourDetail);
         s_TibiaMasksShader.data.red.value = [_loc5_.redFloat,_loc5_.greenFloat,_loc5_.blueFloat,1];
         s_TibiaMasksShader.data.green.value = [_loc6_.redFloat,_loc6_.greenFloat,_loc6_.blueFloat,1];
         s_TibiaMasksShader.data.blue.value = [_loc7_.redFloat,_loc7_.greenFloat,_loc7_.blueFloat,1];
         s_TibiaMasksShader.data.yellow.value = [_loc4_.redFloat,_loc4_.greenFloat,_loc4_.blueFloat,1];
         s_TibiaMasksShader.data.greyscale.input = param1;
         s_TibiaMasksShader.data.mask.input = param2;
         var _loc8_:ShaderJob = new ShaderJob();
         _loc8_.shader = s_TibiaMasksShader;
         _loc8_.target = param3;
         _loc8_.start(true);
      }
      
      override public function get phase() : int
      {
         return this.m_Phase;
      }
      
      override public function set phase(param1:int) : void
      {
         super.phase = param1;
         this.m_Phase = param1;
      }
   }
}

import tibia.appearances.widgetClasses.ISpriteProvider;
import flash.geom.Rectangle;
import flash.display.BitmapData;

class SpriteCacheContainer
{
    
   
   public var m_UncomittedRebuildCache:Boolean = true;
   
   public var m_CacheDirty:Boolean = true;
   
   public var m_SpriteProvider:ISpriteProvider = null;
   
   public var m_InstanceSprite:Vector.<Rectangle> = null;
   
   public var m_UncomittedCreateInstanceBitmap:Boolean = true;
   
   public var m_InstanceBitmap:BitmapData = null;
   
   public var m_InstanceSpriteIDs:Vector.<uint> = null;
   
   function SpriteCacheContainer()
   {
      super();
   }
}
