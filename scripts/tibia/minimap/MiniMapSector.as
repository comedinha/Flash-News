package tibia.minimap
{
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import flash.geom.Rectangle;
   import flash.geom.Point;
   import flash.display.BitmapData;
   import tibia.§minimap:ns_minimap_internal§.s_GetWaypointsSafe;
   import shared.utility.SharedObjectManager;
   import tibia.§minimap:ns_minimap_internal§.s_GetSectorName;
   import shared.utility.Colour;
   import shared.utility.StringHelper;
   
   public class MiniMapSector
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const PATH_SOUTH:int = 7;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const MM_SECTOR_SIZE:int = 256;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      protected static const PATH_ERROR_GO_DOWNSTAIRS:int = -1;
      
      protected static const PATH_NORTH_WEST:int = 4;
      
      protected static const MM_IE_TIMEOUT:Number = 50;
      
      protected static const MM_IO_TIMEOUT:Number = 500;
      
      protected static const MM_SIDEBAR_ZOOM_MIN:int = -1;
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const MM_COLOUR_DEFAULT:uint = 0;
      
      protected static const PATH_COST_OBSTACLE:int = 255;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      protected static const MM_SIDEBAR_ZOOM_MAX:int = 2;
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      protected static const PATH_ERROR_UNREACHABLE:int = -4;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const PATH_NORTH:int = 3;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const PATH_MAX_DISTANCE:int = 110;
      
      protected static const MM_SIDEBAR_VIEW_WIDTH:int = 106;
      
      protected static const PATH_NORTH_EAST:int = 2;
      
      protected static const PATH_SOUTH_WEST:int = 6;
      
      protected static const MM_SIDEBAR_VIEW_HEIGHT:int = 106;
      
      protected static const GROUND_LAYER:int = 7;
      
      protected static const PATH_WEST:int = 5;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const PATH_ERROR_INTERNAL:int = -5;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const PATH_COST_UNDEFINED:int = 254;
      
      protected static const PATH_EMPTY:int = 0;
      
      protected static const PATH_ERROR_TOO_FAR:int = -3;
      
      protected static const PATH_MATRIX_SIZE:int = 2 * PATH_MAX_DISTANCE + 1;
      
      protected static const MM_STORAGE_MIN_VERSION:int = 1;
      
      protected static const PATH_SOUTH_EAST:int = 8;
      
      protected static const PATH_ERROR_GO_UPSTAIRS:int = -2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const PATH_COST_MAX:int = 250;
      
      protected static const PATH_MAX_STEPS:int = 128;
      
      protected static const MM_STORAGE_MAX_VERSION:int = 1;
      
      protected static const MM_CACHE_SIZE:int = 48;
      
      protected static const PATH_EXISTS:int = 1;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const MM_SIDEBAR_HIGHLIGHT_DURATION:Number = 10000;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      protected static const PATH_EAST:int = 1;
      
      protected static const MAP_WIDTH:int = 15;
      
      protected static const PATH_MATRIX_CENTER:int = PATH_MAX_DISTANCE;
      
      static const MIN_BYTES:uint = 5 + MM_SECTOR_SIZE * MM_SECTOR_SIZE + MM_SECTOR_SIZE * MM_SECTOR_SIZE + 2;
       
      
      protected var m_SectorX:int = 0;
      
      protected var m_SectorY:int = 0;
      
      protected var m_SectorZ:int = 0;
      
      var m_MinCost:int = 254;
      
      var m_Cost:Vector.<int> = null;
      
      var m_Marks:Array = null;
      
      protected var m_Dirty:Boolean = false;
      
      var m_BitmapData:BitmapData = null;
      
      public function MiniMapSector(param1:int, param2:int, param3:int)
      {
         super();
         if(param1 < MAP_MIN_X || param1 > MAP_MAX_X || param1 % MM_SECTOR_SIZE != 0)
         {
            throw new ArgumentError("MiniMapSector.MiniMapSector: Invalid x co-ordinate: " + param1);
         }
         if(param2 < MAP_MIN_Y || param2 > MAP_MAX_Y || param2 % MM_SECTOR_SIZE != 0)
         {
            throw new ArgumentError("MiniMapSector.MiniMapSector: Invalid y co-ordinate: " + param2);
         }
         if(param3 < MAP_MIN_Z || param3 > MAP_MAX_Z)
         {
            throw new ArgumentError("MiniMapSector.MiniMapSector: Invalid z co-ordinate: " + param3);
         }
         this.m_SectorX = param1;
         this.m_SectorY = param2;
         this.m_SectorZ = param3;
         this.m_BitmapData = new BitmapData(MM_SECTOR_SIZE,MM_SECTOR_SIZE,true,MM_COLOUR_DEFAULT);
         this.m_Cost = new Vector.<int>(MM_SECTOR_SIZE * MM_SECTOR_SIZE,true);
         var _loc4_:int = this.m_Cost.length - 1;
         while(_loc4_ >= 0)
         {
            this.m_Cost[_loc4_] = PATH_COST_UNDEFINED;
            _loc4_--;
         }
         this.m_MinCost = PATH_COST_UNDEFINED;
         this.m_Marks = [];
         this.m_Dirty = false;
      }
      
      static function s_GetSectorName(param1:Object, param2:int = 0, param3:int = 0) : String
      {
         var _loc4_:int = 0;
         var _loc5_:MiniMapSector = param1 as MiniMapSector;
         if(_loc5_ != null)
         {
            _loc4_ = _loc5_.getSectorX();
            param2 = _loc5_.getSectorY();
            param3 = _loc5_.getSectorZ();
         }
         else
         {
            _loc4_ = int(param1);
         }
         _loc4_ = Math.floor(_loc4_ / MM_SECTOR_SIZE) * MM_SECTOR_SIZE;
         param2 = Math.floor(param2 / MM_SECTOR_SIZE) * MM_SECTOR_SIZE;
         return ("00000000" + _loc4_.toString(16)).substr(-8) + ("00000000" + param2.toString(16)).substr(-8) + ("00" + param3.toString(16)).substr(-2);
      }
      
      private static function s_LoadSharedObjectInternal(param1:SharedObject, param2:MiniMapSector) : MiniMapSector
      {
         var Colours:ByteArray = null;
         var Waypoints:Vector.<int> = null;
         var Marks:Array = null;
         var BitmapRect:Rectangle = null;
         var BitmapOrigin:Point = null;
         var CurrentColours:BitmapData = null;
         var i:int = 0;
         var CurrentMarks:Array = null;
         var Mark:Object = null;
         var j:int = 0;
         var a_SharedObject:SharedObject = param1;
         var a_MiniMapSector:MiniMapSector = param2;
         var Data:Object = null;
         if(a_SharedObject != null && (Data = a_SharedObject.data) != null && Data.hasOwnProperty("version") && Data.hasOwnProperty("sectorX") && Data.hasOwnProperty("sectorY") && Data.hasOwnProperty("sectorZ") && Data.hasOwnProperty("bitmapDataBytes") && Data.hasOwnProperty("cost") && Data.hasOwnProperty("minCost") && Data.hasOwnProperty("mark"))
         {
            if(Data.version < MM_STORAGE_MIN_VERSION || Data.version > MM_STORAGE_MAX_VERSION)
            {
               return null;
            }
            if(a_MiniMapSector != null && (a_MiniMapSector.m_SectorX != Data.sectorX || a_MiniMapSector.m_SectorY != Data.sectorY || a_MiniMapSector.m_SectorZ != Data.sectorZ))
            {
               return null;
            }
            Colours = Data.bitmapDataBytes as ByteArray;
            if(Colours == null || Colours.bytesAvailable != MM_SECTOR_SIZE * MM_SECTOR_SIZE * 4)
            {
               return null;
            }
            Waypoints = Data.cost as Vector.<int>;
            if(Waypoints == null || Waypoints.length != MM_SECTOR_SIZE * MM_SECTOR_SIZE)
            {
               return null;
            }
            Marks = Data.mark as Array;
            if(Marks == null)
            {
               return null;
            }
            try
            {
               if(a_MiniMapSector == null)
               {
                  a_MiniMapSector = new MiniMapSector(Data.sectorX,Data.sectorY,Data.sectorZ);
               }
            }
            catch(_Error:*)
            {
               return null;
            }
            BitmapRect = new Rectangle(0,0,MM_SECTOR_SIZE,MM_SECTOR_SIZE);
            BitmapOrigin = new Point(0,0);
            if(a_MiniMapSector.m_Dirty)
            {
               CurrentColours = a_MiniMapSector.m_BitmapData.clone();
               a_MiniMapSector.m_BitmapData.setPixels(BitmapRect,Colours);
               a_MiniMapSector.m_BitmapData.copyPixels(CurrentColours,BitmapRect,BitmapOrigin,null,null,true);
               i = Waypoints.length - 1;
               while(i >= 0)
               {
                  if(a_MiniMapSector.m_Cost[i] == PATH_COST_UNDEFINED)
                  {
                     a_MiniMapSector.m_Cost[i] = s_GetWaypointsSafe(Waypoints[i]);
                  }
                  i--;
               }
               a_MiniMapSector.m_MinCost = Math.min(a_MiniMapSector.m_MinCost,s_GetWaypointsSafe(Data.minCost));
               CurrentMarks = a_MiniMapSector.m_Marks;
               a_MiniMapSector.m_Marks = Marks;
               for each(Mark in CurrentMarks)
               {
                  a_MiniMapSector.setMark(Mark.x,Mark.y,Mark.z,Mark.icon,Mark.text);
               }
            }
            else
            {
               a_MiniMapSector.m_BitmapData.setPixels(BitmapRect,Colours);
               j = Waypoints.length - 1;
               while(j >= 0)
               {
                  a_MiniMapSector.m_Cost[j] = s_GetWaypointsSafe(Waypoints[j]);
                  j--;
               }
               a_MiniMapSector.m_MinCost = s_GetWaypointsSafe(Data.minCost);
               a_MiniMapSector.m_Marks = Marks;
            }
            return a_MiniMapSector;
         }
         return null;
      }
      
      static function s_LoadSharedObject(param1:SharedObject) : MiniMapSector
      {
         return s_LoadSharedObjectInternal(param1,null);
      }
      
      static function s_GetWaypointsSafe(param1:int) : int
      {
         if(param1 >= 0 && param1 <= PATH_COST_MAX || param1 == PATH_COST_OBSTACLE)
         {
            return param1;
         }
         return PATH_COST_UNDEFINED;
      }
      
      public function getCost(param1:int, param2:int, param3:int) : int
      {
         return this.m_Cost[param2 % MM_SECTOR_SIZE * MM_SECTOR_SIZE + param1 % MM_SECTOR_SIZE];
      }
      
      public function equals(param1:Object, param2:int = 0, param3:int = 0) : Boolean
      {
         var _loc4_:MiniMapSector = param1 as MiniMapSector;
         if(_loc4_ != null)
         {
            return this.m_SectorX == _loc4_.m_SectorX && this.m_SectorY == _loc4_.m_SectorY && this.m_SectorZ == _loc4_.m_SectorZ;
         }
         return this.m_SectorX == int(param1) && this.m_SectorY == param2 && this.m_SectorZ == param3;
      }
      
      function getMark(param1:int, param2:int, param3:int) : Object
      {
         var _loc4_:Object = null;
         var _loc5_:int = this.m_Marks.length - 1;
         while(_loc5_ >= 0)
         {
            if((_loc4_ = this.m_Marks[_loc5_]) != null && _loc4_.x == param1 && _loc4_.y == param2)
            {
               return _loc4_;
            }
            _loc5_--;
         }
         return null;
      }
      
      public function getColour(param1:int, param2:int, param3:int) : uint
      {
         return 4278190080 | this.m_BitmapData.getPixel32(param1 % MM_SECTOR_SIZE,param2 % MM_SECTOR_SIZE);
      }
      
      function get dirty() : Boolean
      {
         return this.m_Dirty;
      }
      
      function get marks() : Array
      {
         return this.m_Marks;
      }
      
      function loadSharedObject() : void
      {
         var Name:String = null;
         var _SharedObjectManager:SharedObjectManager = null;
         var _SharedObject:SharedObject = null;
         try
         {
            Name = s_GetSectorName(this.m_SectorX,this.m_SectorY,this.m_SectorZ);
            _SharedObjectManager = null;
            _SharedObject = null;
            if(SharedObjectManager.s_SharedObjectsAvailable() && (_SharedObjectManager = SharedObjectManager.s_GetInstance()) != null && (_SharedObject = _SharedObjectManager.getLocal(Name,true,true)) != null)
            {
               s_LoadSharedObjectInternal(_SharedObject,this);
            }
            return;
         }
         catch(_Error:*)
         {
            return;
         }
      }
      
      function setMark(param1:int, param2:int, param3:int, param4:int, param5:String) : void
      {
         var _loc6_:String = param5.substr(0,65535);
         this.removeMark(param1,param2,param3);
         this.m_Marks.push({
            "x":param1,
            "y":param2,
            "z":param3,
            "icon":param4,
            "text":_loc6_
         });
         this.m_Dirty = true;
      }
      
      function saveSharedObject(param1:Boolean) : void
      {
         var Name:String = null;
         var _SharedObjectManager:SharedObjectManager = null;
         var _SharedObject:SharedObject = null;
         var BitmapDataBytes:ByteArray = null;
         var Cost:Vector.<int> = null;
         var Data:Object = null;
         var a_Flush:Boolean = param1;
         try
         {
            Name = s_GetSectorName(this.m_SectorX,this.m_SectorY,this.m_SectorZ);
            _SharedObjectManager = null;
            _SharedObject = null;
            if(this.m_Dirty && SharedObjectManager.s_SharedObjectsAvailable() && (_SharedObjectManager = SharedObjectManager.s_GetInstance()) != null && (_SharedObject = _SharedObjectManager.getLocal(Name,true,true)) != null)
            {
               BitmapDataBytes = this.m_BitmapData.getPixels(new Rectangle(0,0,MM_SECTOR_SIZE,MM_SECTOR_SIZE));
               Cost = this.m_Cost.slice();
               Data = _SharedObject.data;
               Data.version = MM_STORAGE_MAX_VERSION;
               Data.sectorX = this.m_SectorX;
               Data.sectorY = this.m_SectorY;
               Data.sectorZ = this.m_SectorZ;
               Data.bitmapDataBytes = BitmapDataBytes;
               Data.cost = Cost;
               Data.minCost = this.m_MinCost;
               Data.mark = this.m_Marks;
               if(a_Flush)
               {
                  _SharedObject.flush();
               }
            }
            this.m_Dirty = false;
            return;
         }
         catch(_Error:*)
         {
            return;
         }
      }
      
      function set dirty(param1:Boolean) : void
      {
         this.m_Dirty = param1;
      }
      
      function updateField(param1:int, param2:int, param3:int, param4:uint, param5:int) : void
      {
         var _loc6_:int = param1 % MM_SECTOR_SIZE;
         var _loc7_:int = param2 % MM_SECTOR_SIZE;
         this.m_BitmapData.setPixel32(_loc6_,_loc7_,param4);
         param5 = s_GetWaypointsSafe(param5);
         this.m_Cost[_loc7_ * MM_SECTOR_SIZE + _loc6_] = param5;
         this.m_MinCost = Math.min(this.m_MinCost,param5);
         this.m_Dirty = true;
      }
      
      function saveByteArray(param1:ByteArray) : void
      {
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:int = 0;
         param1.writeShort(this.m_SectorX & 65535);
         param1.writeShort(this.m_SectorY & 65535);
         param1.writeByte(this.m_SectorZ & 255);
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < MM_SECTOR_SIZE)
         {
            _loc2_ = 0;
            while(_loc2_ < MM_SECTOR_SIZE)
            {
               _loc5_ = this.m_BitmapData.getPixel32(_loc2_,_loc3_) & 16777215;
               _loc6_ = Colour.s_EightBitFromARGB(_loc5_);
               param1.writeByte(_loc6_ & 255);
               _loc2_++;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < MM_SECTOR_SIZE)
         {
            _loc2_ = 0;
            while(_loc2_ < MM_SECTOR_SIZE)
            {
               param1.writeByte(this.m_Cost[_loc3_ * MM_SECTOR_SIZE + _loc2_] & 255);
               _loc2_++;
            }
            _loc3_++;
         }
         param1.writeShort(this.m_Marks.length & 65535);
         for each(_loc4_ in this.m_Marks)
         {
            param1.writeShort(_loc4_.x & 65535);
            param1.writeShort(_loc4_.y & 65535);
            param1.writeByte(_loc4_.z & 255);
            param1.writeByte(_loc4_.icon);
            StringHelper.s_WriteToByteArray(param1,_loc4_.text,65535);
         }
      }
      
      function removeMark(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:Object = null;
         var _loc5_:int = this.m_Marks.length - 1;
         while(_loc5_ >= 0)
         {
            if((_loc4_ = this.m_Marks[_loc5_]) != null && _loc4_.x == param1 && _loc4_.y == param2)
            {
               this.m_Marks.splice(_loc5_,1);
            }
            _loc5_--;
         }
         this.m_Dirty = true;
      }
      
      function get bitmapData() : BitmapData
      {
         return this.m_BitmapData;
      }
      
      public function getSectorX() : int
      {
         return this.m_SectorX;
      }
      
      public function getSectorY() : int
      {
         return this.m_SectorY;
      }
      
      public function getSectorZ() : int
      {
         return this.m_SectorZ;
      }
      
      public function get minCost() : int
      {
         return this.m_MinCost;
      }
   }
}
