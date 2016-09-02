package tibia.worldmap.widgetClasses
{
   import shared.utility.Colour;
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import tibia.appearances.ObjectInstance;
   import flash.display3D.VertexBuffer3D;
   import flash.geom.Rectangle;
   import tibia.creatures.Creature;
   import tibia.options.OptionsStorage;
   import shared.stage3D.Tibia3D;
   import shared.stage3D.events.Tibia3DEvent;
   import mx.events.PropertyChangeEvent;
   import tibia.worldmap.WorldMapStorage;
   import flash.display3D.IndexBuffer3D;
   import flash.display3D.Context3DBlendFactor;
   import flash.geom.Matrix3D;
   import flash.display3D.Context3DProgramType;
   import flash.display3D.Context3DVertexBufferFormat;
   import flash.utils.Endian;
   import flash.display3D.Program3D;
   import flash.display3D.Context3D;
   import shared.stage3D.Camera2D;
   import shared.utility.Vector3D;
   
   public class TiledLightmapRenderer
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      public static const COLOUR_BELOW_GROUND:Colour = new Colour(255,255,255);
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      public static const COLOUR_ABOVE_GROUND:Colour = new Colour(200,200,255);
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      public static const LIGHTMAP_SHRINK_FACTOR:uint = 8;
      
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
      
      protected static const GROUND_LAYER:int = 7;
       
      
      protected var m_LightmapBitmap:BitmapData = null;
      
      protected var m_UpdateColorBuffer:Boolean;
      
      private const COORDINATES_PER_VERTEX:uint = 2;
      
      private var m_OptionsLevelSeparator:Number = NaN;
      
      private const COLOR_VALUES_COUNT:uint = 1140.0;
      
      protected var m_ColorBuffer:VertexBuffer3D;
      
      protected var m_AmbientColour:Colour;
      
      private var m_Rect:Rectangle = null;
      
      protected var m_AmbientBrightness:int = 0;
      
      protected var m_UpdateLightmap:Boolean;
      
      protected var m_UpdateShaderProgram:Boolean;
      
      protected var m_CoordinatesBuffer:VertexBuffer3D;
      
      protected var m_IndexData:Vector.<uint>;
      
      protected const VERTEX_SHADER_HEX_CODE:String = "a0 01 00 00 00 a1 00 18 00 00 00 00 00 0f 03 00 00 00 e4 00 00 00 00 00 00 00 e4 01 00 00 00 00 00 00 00 00 00 0f 04 01 00 00 e4 00 00 00 00 00 00 00 00 00 00 00 00";
      
      protected var m_Options:OptionsStorage = null;
      
      private const INDICES_COUNT:uint = 190.0;
      
      private var m_OptionsAmbientBrightness:Number = NaN;
      
      protected var m_WorldMapStorage:WorldMapStorage = null;
      
      protected var m_IndexBuffer:IndexBuffer3D;
      
      private const VERTICES_COUNT:uint = 285.0;
      
      protected var m_CoordinatesData:Vector.<Number>;
      
      protected const FRAGMENT_SHADER_HEX_CODE:String = "a0 01 00 00 00 a1 01 00 00 00 00 00 00 0f 03 00 00 00 e4 04 00 00 00 00 00 00 00 00 00 00 00";
      
      protected var m_CurrentColorData:ByteArray;
      
      private const COLOR_VALUES_PER_VERTEX:uint = 4.0;
      
      private const m_CachedLayerBrightnessInfo:Vector.<Vector.<Boolean>> = new Vector.<Vector.<Boolean>>(MAPSIZE_Z,false);
      
      protected var m_ShaderProgram:Program3D;
      
      protected var m_Context3D:Context3D = null;
      
      protected var m_UpdateCoordinatesBuffer:Boolean;
      
      protected var m_OldColorData:ByteArray;
      
      protected var m_LightmapCamera:Camera2D = null;
      
      protected var m_HelperCoordinate:Vector3D;
      
      public function TiledLightmapRenderer()
      {
         this.m_AmbientColour = new Colour(0,0,0);
         this.m_HelperCoordinate = new Vector3D();
         super();
         if(Tibia3D.isReady)
         {
            this.m_Context3D = Tibia3D.instance.context3D;
         }
         this.m_Rect = new Rectangle(0,0,MAPSIZE_X * FIELD_SIZE / LIGHTMAP_SHRINK_FACTOR,MAPSIZE_Y * FIELD_SIZE / LIGHTMAP_SHRINK_FACTOR);
         this.m_CoordinatesData = new Vector.<Number>();
         this.m_CurrentColorData = new ByteArray();
         this.m_CurrentColorData.length = this.COLOR_VALUES_COUNT;
         this.m_CurrentColorData.position = 0;
         this.m_OldColorData = new ByteArray();
         this.m_OldColorData.length = this.COLOR_VALUES_COUNT;
         this.m_OldColorData.position = 0;
         this.m_IndexData = new Vector.<uint>();
         this.m_LightmapCamera = new Camera2D(MAPSIZE_X,MAPSIZE_Y);
         this.m_LightmapCamera.offsetX = 0;
         this.m_LightmapCamera.offsetY = 0;
         this.m_UpdateCoordinatesBuffer = true;
         this.m_UpdateColorBuffer = true;
         this.m_UpdateShaderProgram = true;
         this.createBufferData();
         Tibia3D.instance.addEventListener(Tibia3DEvent.CONTEXT3D_CREATED,this.onContextCreated);
      }
      
      protected function setupShaders() : void
      {
         if(this.m_ShaderProgram != null)
         {
            this.m_ShaderProgram.dispose();
         }
         this.m_ShaderProgram = this.m_Context3D.createProgram();
         var _loc1_:ByteArray = this.hexStringToByteArray(this.VERTEX_SHADER_HEX_CODE);
         var _loc2_:ByteArray = this.hexStringToByteArray(this.FRAGMENT_SHADER_HEX_CODE);
         this.m_ShaderProgram.upload(_loc1_,_loc2_);
      }
      
      public function setLightSource(param1:Number, param2:Number, param3:uint, param4:uint, param5:Colour) : void
      {
         var _loc25_:uint = 0;
         if(param1 < 0 || param1 > MAPSIZE_X || param2 < 0 || param2 > MAPSIZE_Y || param4 <= 0)
         {
            return;
         }
         var _loc6_:uint = 0;
         var _loc7_:uint = param1;
         var _loc8_:uint = param2;
         var _loc9_:int = _loc7_ - param4;
         var _loc10_:int = _loc7_ + param4;
         var _loc11_:int = _loc8_ - param4;
         var _loc12_:int = _loc8_ + param4;
         var _loc13_:uint = 0;
         var _loc14_:uint = 0;
         var _loc15_:uint = param4;
         var _loc16_:Number = 0;
         var _loc17_:uint = 1;
         var _loc18_:uint = 1;
         var _loc19_:uint = 1;
         var _loc20_:ObjectInstance = null;
         var _loc21_:Vector.<Boolean> = this.getLayerInformation(param3);
         var _loc22_:uint = param5.red;
         var _loc23_:uint = param5.green;
         var _loc24_:uint = param5.blue;
         if(_loc9_ < 0)
         {
            _loc9_ = 0;
         }
         if(_loc10_ > MAPSIZE_X)
         {
            _loc10_ = MAPSIZE_X;
         }
         if(_loc11_ < 0)
         {
            _loc11_ = 0;
         }
         if(_loc12_ > MAPSIZE_Y)
         {
            _loc12_ = MAPSIZE_Y;
         }
         _loc8_ = _loc11_;
         while(_loc8_ < _loc12_)
         {
            _loc14_ = _loc8_ + 1 - param2;
            _loc14_ = _loc14_ * _loc14_;
            _loc7_ = _loc9_;
            while(_loc7_ < _loc10_)
            {
               _loc13_ = _loc7_ + 1 - param1;
               _loc13_ = _loc13_ * _loc13_;
               _loc16_ = (_loc15_ - Math.sqrt(_loc13_ + _loc14_)) / 5;
               if(_loc16_ >= 0)
               {
                  if(_loc16_ > 1)
                  {
                     _loc16_ = 1;
                  }
                  _loc17_ = _loc22_ * _loc16_;
                  _loc18_ = _loc23_ * _loc16_;
                  _loc19_ = _loc24_ * _loc16_;
                  _loc25_ = _loc8_ * MAPSIZE_X + _loc7_;
                  if(_loc21_[_loc25_] == true)
                  {
                     _loc17_ = _loc17_ * this.m_OptionsLevelSeparator;
                     _loc18_ = _loc18_ * this.m_OptionsLevelSeparator;
                     _loc19_ = _loc19_ * this.m_OptionsLevelSeparator;
                  }
                  _loc6_ = this.toColorIndexRed(_loc7_,_loc8_);
                  if(_loc17_ > this.m_CurrentColorData[_loc6_])
                  {
                     this.m_CurrentColorData[_loc6_] = _loc17_;
                  }
                  if(_loc18_ > this.m_CurrentColorData[++_loc6_])
                  {
                     this.m_CurrentColorData[_loc6_] = _loc18_;
                  }
                  if(_loc19_ > this.m_CurrentColorData[++_loc6_])
                  {
                     this.m_CurrentColorData[_loc6_] = _loc19_;
                  }
               }
               _loc7_++;
            }
            _loc8_++;
         }
         this.m_UpdateColorBuffer = true;
      }
      
      protected function getLayerInformation(param1:uint) : Vector.<Boolean>
      {
         if(this.m_CachedLayerBrightnessInfo[param1] == null)
         {
            this.m_CachedLayerBrightnessInfo[param1] = this.m_WorldMapStorage.getLightBlockingTilesForZLayer(param1);
         }
         return this.m_CachedLayerBrightnessInfo[param1];
      }
      
      public function calculateCreatureHudBrightnessFactor(param1:Creature, param2:Boolean) : Number
      {
         this.m_WorldMapStorage.toMapClosest(param1.position,this.m_HelperCoordinate);
         var _loc3_:uint = this.getFieldBrightness(this.m_HelperCoordinate.x,this.m_HelperCoordinate.y);
         if(param2)
         {
            _loc3_ = Math.max(_loc3_,Math.max(2,Math.min(param1.brightness,5)) * 51);
         }
         return _loc3_ / 255;
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      public function dispose() : void
      {
         Tibia3D.instance.removeEventListener(Tibia3DEvent.CONTEXT3D_CREATED,this.onContextCreated);
         this.m_UpdateCoordinatesBuffer = true;
         this.m_UpdateColorBuffer = true;
         this.m_UpdateShaderProgram = true;
         this.m_UpdateLightmap = true;
         this.m_ColorBuffer = null;
         this.m_CoordinatesBuffer = null;
         this.m_IndexBuffer = null;
         this.m_LightmapBitmap = null;
      }
      
      protected function onContextCreated(param1:Tibia3DEvent) : void
      {
         if(Tibia3D.isReady)
         {
            this.m_Context3D = Tibia3D.instance.context3D;
         }
         else
         {
            this.m_Context3D = null;
         }
         this.m_UpdateCoordinatesBuffer = true;
         this.m_UpdateColorBuffer = true;
         this.m_UpdateShaderProgram = true;
         this.m_UpdateLightmap = true;
         this.m_ColorBuffer = null;
         this.m_CoordinatesBuffer = null;
         this.m_IndexBuffer = null;
         this.m_LightmapBitmap = null;
      }
      
      public function toColorIndexRed(param1:uint, param2:uint) : uint
      {
         return ((param2 + 1) * (MAPSIZE_X + 1) + (param1 + 1)) * this.COLOR_VALUES_PER_VERTEX;
      }
      
      protected function createBufferData() : void
      {
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc1_:Number = 0;
         var _loc2_:Number = 0;
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         _loc2_ = 0;
         while(_loc2_ < MAPSIZE_Y + 1)
         {
            _loc1_ = 0;
            while(_loc1_ < MAPSIZE_X + 1)
            {
               this.m_CoordinatesData.push(_loc1_,_loc2_);
               _loc1_++;
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < MAPSIZE_Y)
         {
            _loc5_ = _loc2_ * (MAPSIZE_X + 1);
            _loc1_ = 0;
            while(_loc1_ < MAPSIZE_X)
            {
               _loc6_ = _loc1_ + _loc5_;
               _loc7_ = _loc6_ + 1;
               _loc8_ = _loc1_ + _loc5_ + MAPSIZE_X + 1;
               _loc9_ = _loc8_ + 1;
               this.m_IndexData.push(_loc6_,_loc7_,_loc9_,_loc6_,_loc9_,_loc8_);
               _loc1_++;
            }
            _loc2_++;
         }
         _loc3_ = 0;
         while(_loc3_ < this.COLOR_VALUES_COUNT)
         {
            this.m_CurrentColorData[_loc3_] = 255;
            this.m_OldColorData[_loc3_] = 255;
            _loc3_++;
         }
      }
      
      public function createLightmap() : void
      {
         var x:uint = 0;
         var y:uint = 0;
         var DestIndex:uint = 0;
         var SourceIndex:uint = 0;
         var Same:Boolean = false;
         var i:uint = 0;
         try
         {
            if(Tibia3D.isReady)
            {
               if(Tibia3D.instance.viewPort.equals(this.m_Rect) == false)
               {
                  Tibia3D.instance.viewPort = this.m_Rect;
               }
               if(this.lightmapBitmap == null)
               {
                  this.createLightmapBitmap();
                  this.m_UpdateLightmap = true;
               }
               x = 0;
               y = 0;
               DestIndex = 0;
               SourceIndex = 0;
               x = 0;
               while(x < MAPSIZE_X + 1)
               {
                  DestIndex = x * this.COLOR_VALUES_PER_VERTEX;
                  SourceIndex = (x + MAPSIZE_X + 1) * this.COLOR_VALUES_PER_VERTEX;
                  this.m_CurrentColorData[DestIndex] = this.m_CurrentColorData[SourceIndex];
                  this.m_CurrentColorData[DestIndex + 1] = this.m_CurrentColorData[SourceIndex + 1];
                  this.m_CurrentColorData[DestIndex + 2] = this.m_CurrentColorData[SourceIndex + 2];
                  x++;
               }
               y = 0;
               while(y < MAPSIZE_Y + 1)
               {
                  DestIndex = y * (MAPSIZE_X + 1) * this.COLOR_VALUES_PER_VERTEX;
                  SourceIndex = DestIndex + this.COLOR_VALUES_PER_VERTEX;
                  this.m_CurrentColorData[DestIndex] = this.m_CurrentColorData[SourceIndex];
                  this.m_CurrentColorData[DestIndex + 1] = this.m_CurrentColorData[SourceIndex + 1];
                  this.m_CurrentColorData[DestIndex + 2] = this.m_CurrentColorData[SourceIndex + 2];
                  y++;
               }
               Same = true;
               i = 0;
               while(i < this.COLOR_VALUES_COUNT)
               {
                  Same = Same && this.m_OldColorData[i] == this.m_CurrentColorData[i];
                  this.m_OldColorData[i] = this.m_CurrentColorData[i];
                  i++;
               }
               this.m_UpdateLightmap = this.m_UpdateLightmap || Same == false;
               if(this.m_UpdateLightmap)
               {
                  this.m_Context3D.clear(1,1,1,1);
                  this.draw();
                  this.m_Context3D.drawToBitmapData(this.m_LightmapBitmap);
                  this.m_UpdateLightmap = false;
               }
            }
         }
         catch(_Error:Error)
         {
            if(_Error.errorID != 3694)
            {
               throw _Error;
            }
         }
         var z:uint = 0;
         while(z < MAPSIZE_Z)
         {
            this.m_CachedLayerBrightnessInfo[z] = null;
            z++;
         }
      }
      
      public function getFieldBrightness(param1:uint, param2:uint) : uint
      {
         var _loc3_:uint = 0;
         if(param1 < MAPSIZE_X && param2 < MAPSIZE_Y)
         {
            _loc3_ = this.toColorIndexRed(param1,param2);
            return (this.m_CurrentColorData[_loc3_] + this.m_CurrentColorData[_loc3_ + 1] + this.m_CurrentColorData[_loc3_ + 2]) / 3;
         }
         return uint.MAX_VALUE;
      }
      
      public function set options(param1:OptionsStorage) : void
      {
         if(this.m_Options != param1)
         {
            if(this.m_Options != null)
            {
               this.m_Options.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.m_Options = param1;
            if(this.m_Options != null)
            {
               this.m_Options.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onOptionsChange);
            }
            this.updateOptions();
         }
      }
      
      public function draw() : void
      {
         var _loc1_:uint = 0;
         if(Tibia3D.isReady == false)
         {
            return;
         }
         if(this.m_UpdateCoordinatesBuffer)
         {
            if(this.m_CoordinatesBuffer == null)
            {
               this.m_CoordinatesBuffer = this.m_Context3D.createVertexBuffer(this.VERTICES_COUNT,this.COORDINATES_PER_VERTEX);
            }
            this.m_CoordinatesBuffer.uploadFromVector(this.m_CoordinatesData,0,this.VERTICES_COUNT);
            if(this.m_IndexBuffer == null)
            {
               this.m_IndexBuffer = this.m_Context3D.createIndexBuffer(this.m_IndexData.length);
            }
            this.m_IndexBuffer.uploadFromVector(this.m_IndexData,0,this.m_IndexData.length);
            this.m_UpdateCoordinatesBuffer = false;
         }
         if(this.m_UpdateColorBuffer)
         {
            if(this.m_ColorBuffer == null)
            {
               this.m_ColorBuffer = this.m_Context3D.createVertexBuffer(this.VERTICES_COUNT,1);
            }
            this.m_ColorBuffer.uploadFromByteArray(this.m_CurrentColorData,0,0,this.VERTICES_COUNT);
            this.m_UpdateColorBuffer = false;
         }
         if(this.m_UpdateShaderProgram)
         {
            this.setupShaders();
            this.m_UpdateShaderProgram = false;
         }
         this.m_Context3D.setProgram(this.m_ShaderProgram);
         this.m_Context3D.setBlendFactors(Context3DBlendFactor.ONE,Context3DBlendFactor.ZERO);
         var _loc2_:Matrix3D = this.m_LightmapCamera.getViewProjectionMatrix();
         this.m_Context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,_loc2_,true);
         this.m_Context3D.setVertexBufferAt(0,this.m_CoordinatesBuffer,0,Context3DVertexBufferFormat.FLOAT_2);
         this.m_Context3D.setVertexBufferAt(1,this.m_ColorBuffer,0,Context3DVertexBufferFormat.BYTES_4);
         this.m_Context3D.drawTriangles(this.m_IndexBuffer);
         this.m_Context3D.setVertexBufferAt(0,null);
         this.m_Context3D.setVertexBufferAt(1,null);
         this.m_Context3D.setProgram(null);
      }
      
      public function get worldMapStorage() : WorldMapStorage
      {
         return this.m_WorldMapStorage;
      }
      
      protected function hexStringToByteArray(param1:String) : ByteArray
      {
         var _loc5_:String = null;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.endian = Endian.LITTLE_ENDIAN;
         var _loc3_:Array = param1.split(" ");
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            _loc2_.writeByte(parseInt(_loc5_,16));
            _loc4_++;
         }
         _loc2_.position = 0;
         return _loc2_;
      }
      
      public function setFieldBrightness(param1:uint, param2:uint, param3:uint, param4:Boolean) : void
      {
         if(param1 < 0 || param1 >= MAPSIZE_X || param2 < 0 || param2 >= MAPSIZE_Y)
         {
            return;
         }
         var _loc5_:uint = 255;
         var _loc6_:uint = 255;
         var _loc7_:uint = 255;
         var _loc8_:uint = 0;
         var _loc9_:Colour = this.m_WorldMapStorage.getAmbientColour();
         var _loc10_:Number = param3 / 255;
         if(_loc10_ < 0)
         {
            _loc10_ = 0;
         }
         if(_loc10_ > 1)
         {
            _loc10_ = 1;
         }
         _loc6_ = _loc9_.green * _loc10_;
         _loc7_ = _loc9_.blue * _loc10_;
         _loc5_ = _loc9_.red * _loc10_;
         var _loc11_:Colour = null;
         if(param4)
         {
            _loc11_ = COLOUR_ABOVE_GROUND;
         }
         else
         {
            _loc11_ = COLOUR_BELOW_GROUND;
         }
         var _loc12_:Number = this.m_OptionsAmbientBrightness * (255 - _loc5_) / 255;
         _loc5_ = _loc5_ + _loc11_.red * _loc12_;
         _loc6_ = _loc6_ + _loc11_.green * _loc12_;
         _loc7_ = _loc7_ + _loc11_.blue * _loc12_;
         if(_loc5_ > 255)
         {
            _loc5_ = 255;
         }
         if(_loc6_ > 255)
         {
            _loc6_ = 255;
         }
         if(_loc7_ > 255)
         {
            _loc7_ = 255;
         }
         _loc8_ = this.toColorIndexRed(param1,param2);
         this.m_CurrentColorData[_loc8_] = _loc5_;
         var _loc13_:* = ++_loc8_;
         this.m_CurrentColorData[_loc13_] = _loc6_;
         var _loc14_:* = ++_loc8_;
         this.m_CurrentColorData[_loc14_] = _loc7_;
      }
      
      private function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         if(param1 != null)
         {
            switch(param1.property)
            {
               case "rendererAmbientBrightness":
               case "rendererLevelSeparator":
               case "*":
                  this.updateOptions();
            }
         }
      }
      
      public function get lightmapBitmap() : BitmapData
      {
         return this.m_LightmapBitmap;
      }
      
      private function updateOptions() : void
      {
         if(this.m_Options != null)
         {
            this.m_OptionsAmbientBrightness = this.m_Options.rendererAmbientBrightness;
            this.m_OptionsLevelSeparator = this.m_Options.rendererLevelSeparator;
         }
         else
         {
            this.m_OptionsAmbientBrightness = NaN;
            this.m_OptionsLevelSeparator = 4 / 5;
         }
      }
      
      public function set worldMapStorage(param1:WorldMapStorage) : void
      {
         if(this.m_WorldMapStorage != param1)
         {
            this.m_WorldMapStorage = param1;
         }
      }
      
      public function get rect() : Rectangle
      {
         return this.m_Rect;
      }
      
      public function get rawColorData() : ByteArray
      {
         return this.m_CurrentColorData;
      }
      
      protected function createLightmapBitmap() : void
      {
         this.m_LightmapBitmap = new BitmapData(Tibia3D.instance.viewPort.width,Tibia3D.instance.viewPort.height);
      }
      
      public function resetTiles() : void
      {
         var _loc1_:uint = 0;
         while(_loc1_ < this.m_CurrentColorData.length)
         {
            this.m_CurrentColorData[_loc1_] = 255;
            _loc1_++;
         }
         this.m_UpdateColorBuffer = true;
      }
   }
}
