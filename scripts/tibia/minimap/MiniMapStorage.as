package tibia.minimap
{
   import flash.events.EventDispatcher;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.geom.Point;
   import mx.core.BitmapAsset;
   import flash.events.TimerEvent;
   import mx.events.PropertyChangeEvent;
   import shared.utility.BrowserHelper;
   import mx.events.PropertyChangeEventKind;
   import shared.utility.SharedObjectManager;
   import flash.net.SharedObject;
   import flash.events.ProgressEvent;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import shared.utility.Vector3D;
   import tibia.worldmap.WorldMapStorage;
   import flash.utils.Timer;
   import flash.utils.ByteArray;
   import flash.errors.MemoryError;
   import flash.utils.Endian;
   import flash.system.System;
   import shared.utility.Heap;
   import shared.utility.IPerformanceCounter;
   import shared.utility.AccumulatingPerformanceCounter;
   
   public class MiniMapStorage extends EventDispatcher
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const NUM_EFFECTS:int = 200;
      
      protected static const PATH_SOUTH:int = 7;
      
      public static const MARK_ICON_SIZE:int = 11;
      
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
      
      private static const MARK_ICON_BITMAP:BitmapData = (new MARK_ICON_CLASS() as BitmapAsset).bitmapData;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      protected static const PATH_MAX_DISTANCE:int = 110;
      
      protected static const MM_SIDEBAR_VIEW_WIDTH:int = 106;
      
      protected static const PATH_NORTH_EAST:int = 2;
      
      protected static const PATH_SOUTH_WEST:int = 6;
      
      protected static const MM_SIDEBAR_VIEW_HEIGHT:int = 106;
      
      protected static const GROUND_LAYER:int = 7;
      
      public static const MARK_ICON_COUNT:int = 20;
      
      private static const MARK_HIGHLIGHT_BITMAP:BitmapData = (new MARK_HIGHLIGHT_CLASS() as BitmapAsset).bitmapData;
      
      protected static const PATH_WEST:int = 5;
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const PATH_ERROR_INTERNAL:int = -5;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      protected static const PATH_COST_UNDEFINED:int = 254;
      
      protected static const PATH_EMPTY:int = 0;
      
      protected static const PATH_ERROR_TOO_FAR:int = -3;
      
      private static const EXPORT_DEFAULT_NAME:String = "ExportedMiniMap.dat";
      
      protected static const PATH_MATRIX_SIZE:int = 2 * PATH_MAX_DISTANCE + 1;
      
      protected static const MM_STORAGE_MIN_VERSION:int = 1;
      
      protected static const PATH_SOUTH_EAST:int = 8;
      
      protected static const PATH_ERROR_GO_UPSTAIRS:int = -2;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      protected static const PATH_COST_MAX:int = 250;
      
      protected static const PATH_MAX_STEPS:int = 128;
      
      protected static const MM_STORAGE_MAX_VERSION:int = 1;
      
      protected static const MM_CACHE_SIZE:int = 48;
      
      private static const MARK_ICON_CLASS:Class = MiniMapStorage_MARK_ICON_CLASS;
      
      protected static const PATH_EXISTS:int = 1;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      private static const MARK_HIGHLIGHT_CLASS:Class = MiniMapStorage_MARK_HIGHLIGHT_CLASS;
      
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
      
      public static const EVENT_HIGHLIGHT_MARKS:String = "highlightMarks";
       
      
      private var m_IEQueue:Array = null;
      
      protected var m_SaveQueue:Vector.<tibia.minimap.MiniMapSector> = null;
      
      private var m_IETimer:Timer = null;
      
      protected var m_PathDirty:Vector.<tibia.minimap.PathItem> = null;
      
      protected var m_SectorX:int = -1;
      
      protected var m_SectorY:int = -1;
      
      protected var m_SectorZ:int = -1;
      
      protected var m_ChangedSector:Boolean = false;
      
      protected var m_SectorCache:Vector.<tibia.minimap.MiniMapSector> = null;
      
      protected var m_LoadQueue:Vector.<tibia.minimap.MiniMapSector> = null;
      
      protected var m_PositionX:int = -1;
      
      protected var m_PositionY:int = -1;
      
      protected var m_PositionZ:int = -1;
      
      protected var m_PathHeap:Heap = null;
      
      private var m_IEBytesTotal:uint = 0;
      
      protected var m_IOTimer:Timer = null;
      
      private var m_IEBytesProcessed:uint = 0;
      
      private var m_PerformanceCounterCalculatePath:IPerformanceCounter;
      
      protected var m_PathMatrix:Vector.<tibia.minimap.PathItem> = null;
      
      protected var m_FlashEnd:Number = 0;
      
      private var m_IEData:ByteArray = null;
      
      public function MiniMapStorage()
      {
         var _loc2_:int = 0;
         this.m_PerformanceCounterCalculatePath = new AccumulatingPerformanceCounter();
         super();
         this.m_SectorCache = new Vector.<tibia.minimap.MiniMapSector>();
         this.m_LoadQueue = new Vector.<tibia.minimap.MiniMapSector>();
         this.m_SaveQueue = new Vector.<tibia.minimap.MiniMapSector>();
         this.m_IOTimer = new Timer(MM_IO_TIMEOUT);
         this.m_IOTimer.addEventListener(TimerEvent.TIMER,this.onIOTimer);
         this.m_IOTimer.start();
         this.m_PositionX = this.m_PositionY = this.m_PositionZ = -1;
         this.m_SectorX = this.m_SectorY = this.m_SectorZ = -1;
         this.m_PathMatrix = new Vector.<tibia.minimap.PathItem>(PATH_MATRIX_SIZE * PATH_MATRIX_SIZE,true);
         var _loc1_:int = 0;
         while(_loc1_ < PATH_MATRIX_SIZE)
         {
            _loc2_ = 0;
            while(_loc2_ < PATH_MATRIX_SIZE)
            {
               this.m_PathMatrix[_loc1_ * PATH_MATRIX_SIZE + _loc2_] = new tibia.minimap.PathItem(_loc2_ - PATH_MATRIX_CENTER,_loc1_ - PATH_MATRIX_CENTER);
               _loc2_++;
            }
            _loc1_++;
         }
         this.m_PathHeap = new Heap();
         this.m_PathDirty = new Vector.<tibia.minimap.PathItem>();
      }
      
      public static function s_GetMarkIcon(param1:int, param2:Boolean, param3:Rectangle) : BitmapData
      {
         var _loc4_:BitmapData = null;
         if(param1 < 0 || param1 > MARK_ICON_COUNT)
         {
            throw new ArgumentError("MiniMapStorage.s_GetMarkIcon: Invalid icon ID: " + param1);
         }
         param3.x = param1 * MARK_ICON_SIZE;
         param3.y = 0;
         param3.width = MARK_ICON_SIZE;
         param3.height = MARK_ICON_SIZE;
         if(param2)
         {
            _loc4_ = MARK_HIGHLIGHT_BITMAP.clone();
            _loc4_.copyPixels(MARK_ICON_BITMAP,param3,new Point((_loc4_.width - param3.width) / 2,(_loc4_.height - param3.height) / 2),null,null,true);
            param3.x = 0;
            param3.y = 0;
            param3.width = _loc4_.width;
            param3.height = _loc4_.height;
            return _loc4_;
         }
         return MARK_ICON_BITMAP;
      }
      
      private function onIOTimer(param1:TimerEvent) : void
      {
         var _loc2_:tibia.minimap.MiniMapSector = null;
         var _loc3_:PropertyChangeEvent = null;
         if(param1 != null)
         {
            _loc2_ = null;
            if(this.m_LoadQueue != null && this.m_LoadQueue.length > 0 && (_loc2_ = this.m_LoadQueue.shift()) != null)
            {
               if(!BrowserHelper.s_CompareFlashPlayerVersion(Tibia.BUGGY_FLASH_PLAYER_VERSION))
               {
                  _loc2_.loadSharedObject();
                  _loc3_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
                  _loc3_.kind = PropertyChangeEventKind.UPDATE;
                  _loc3_.property = "sector";
                  dispatchEvent(_loc3_);
               }
            }
            else if(this.m_IOTimer.currentCount % 10 == 0 && this.m_SaveQueue != null && this.m_SaveQueue.length > 0 && (_loc2_ = this.m_SaveQueue.shift()) != null)
            {
               if(!BrowserHelper.s_CompareFlashPlayerVersion(Tibia.BUGGY_FLASH_PLAYER_VERSION))
               {
                  _loc2_.saveSharedObject(false);
               }
            }
         }
      }
      
      private function enqueue(param1:Vector.<tibia.minimap.MiniMapSector>, param2:tibia.minimap.MiniMapSector) : void
      {
         var _loc3_:int = param1.length - 1;
         while(_loc3_ >= 0)
         {
            if(param2.equals(param1[_loc3_]))
            {
               return;
            }
            _loc3_--;
         }
         param1.push(param2);
      }
      
      public function removeMark(param1:int, param2:int, param3:int, param4:Boolean = true) : void
      {
         var _loc5_:PropertyChangeEvent = null;
         this.acquireSector(param1,param2,param3,false).removeMark(param1,param2,param3);
         if(param4)
         {
            _loc5_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc5_.kind = PropertyChangeEventKind.UPDATE;
            _loc5_.property = "sector";
            dispatchEvent(_loc5_);
         }
         else
         {
            this.m_ChangedSector = true;
         }
      }
      
      public function getSectorY() : int
      {
         return this.m_SectorY;
      }
      
      private function getSectorListing() : Array
      {
         var Name:String = null;
         var Match:Array = null;
         var Listing:Array = [];
         var _SharedObjectManager:SharedObjectManager = SharedObjectManager.s_GetInstance();
         var MatchSectorName:RegExp = /^([0-9a-fA-F]{8})([0-9a-fA-F]{8})([0-9a-fA-F]{2})$/;
         if(SharedObjectManager.s_SharedObjectsAvailable() && _SharedObjectManager != null)
         {
            try
            {
               for each(Name in _SharedObjectManager.getListing(true))
               {
                  Match = MatchSectorName.exec(Name);
                  if(Match != null && Match.length == 4)
                  {
                     Listing.push(Name);
                  }
               }
            }
            catch(_Error:*)
            {
            }
         }
         return Listing;
      }
      
      private function onExportTimer(param1:TimerEvent) : void
      {
         var Name:String = null;
         var _SharedObjectManager:SharedObjectManager = null;
         var _SharedObject:SharedObject = null;
         var _MiniMapSector:tibia.minimap.MiniMapSector = null;
         var _ProgressEvent:ProgressEvent = null;
         var a_Event:TimerEvent = param1;
         if(a_Event != null)
         {
            if(this.m_IEQueue != null && this.m_IEQueue.length > 0)
            {
               Name = String(this.m_IEQueue.shift());
               try
               {
                  _SharedObjectManager = null;
                  _SharedObject = null;
                  _MiniMapSector = null;
                  if(SharedObjectManager.s_SharedObjectsAvailable() && (_SharedObjectManager = SharedObjectManager.s_GetInstance()) != null && (_SharedObject = _SharedObjectManager.getLocal(Name,false,true)) != null && (_MiniMapSector = tibia.minimap.MiniMapSector.s_LoadSharedObject(_SharedObject)) != null)
                  {
                     _MiniMapSector.saveByteArray(this.m_IEData);
                     _ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS);
                     _ProgressEvent.bytesLoaded = this.m_IEData.position;
                     _ProgressEvent.bytesTotal = this.m_IEBytesTotal;
                     dispatchEvent(_ProgressEvent);
                  }
               }
               catch(_Error:Error)
               {
                  cancelImportExport();
                  dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
               }
            }
            else
            {
               this.cancelImportExport();
               dispatchEvent(new Event(Event.COMPLETE));
            }
         }
      }
      
      public function saveSectors(param1:Boolean) : void
      {
         var _loc2_:int = this.m_SaveQueue.length - 1;
         while(_loc2_ >= 0)
         {
            if(!BrowserHelper.s_CompareFlashPlayerVersion(Tibia.BUGGY_FLASH_PLAYER_VERSION))
            {
               this.m_SaveQueue[_loc2_].saveSharedObject(param1);
            }
            _loc2_--;
         }
         this.m_SaveQueue.length = 0;
         var _loc3_:int = this.m_SectorCache.length - 1;
         while(_loc3_ >= 0)
         {
            if(!BrowserHelper.s_CompareFlashPlayerVersion(Tibia.BUGGY_FLASH_PLAYER_VERSION))
            {
               this.m_SectorCache[_loc3_].saveSharedObject(param1);
            }
            _loc3_--;
         }
      }
      
      public function getPositionX() : int
      {
         return this.m_PositionX;
      }
      
      public function getPositionY() : int
      {
         return this.m_PositionY;
      }
      
      public function getPositionZ() : int
      {
         return this.m_PositionZ;
      }
      
      public function calculatePath(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:Boolean, param8:Boolean, param9:Array) : int
      {
         var _loc10_:int = param4 - param1;
         var _loc11_:int = param5 - param2;
         var _loc12_:int = 0;
         if(param9 == null)
         {
            return PATH_ERROR_INTERNAL;
         }
         param9.length = 0;
         if(param6 > param3)
         {
            return PATH_ERROR_GO_DOWNSTAIRS;
         }
         if(param6 < param3)
         {
            return PATH_ERROR_GO_UPSTAIRS;
         }
         if(param4 == param1 && param5 == param2)
         {
            return PATH_EMPTY;
         }
         if(Math.abs(_loc10_) >= PATH_MAX_DISTANCE || Math.abs(_loc11_) >= PATH_MAX_DISTANCE)
         {
            return PATH_ERROR_TOO_FAR;
         }
         if(Math.abs(_loc10_) + Math.abs(_loc11_) == 1)
         {
            _loc12_ = this.getFieldCost(param4,param5,param6);
            if(param8 || _loc12_ < PATH_COST_OBSTACLE)
            {
               if(_loc10_ == 1 && _loc11_ == 0)
               {
                  param9[0] = PATH_EAST;
               }
               if(_loc10_ == 0 && _loc11_ == -1)
               {
                  param9[0] = PATH_NORTH;
               }
               if(_loc10_ == -1 && _loc11_ == 0)
               {
                  param9[0] = PATH_WEST;
               }
               if(_loc10_ == 0 && _loc11_ == 1)
               {
                  param9[0] = PATH_SOUTH;
               }
               param9[0] = param9[0] | _loc12_ << 16;
               return PATH_EXISTS;
            }
            return PATH_EMPTY;
         }
         if(param7 && Math.abs(_loc10_) == 1 && Math.abs(_loc11_) == 1)
         {
            _loc12_ = this.getFieldCost(param4,param5,param6);
            if(param8 || _loc12_ < PATH_COST_OBSTACLE)
            {
               if(_loc10_ == 1 && _loc11_ == -1)
               {
                  param9[0] = PATH_NORTH_EAST;
               }
               if(_loc10_ == -1 && _loc11_ == -1)
               {
                  param9[0] = PATH_NORTH_WEST;
               }
               if(_loc10_ == -1 && _loc11_ == 1)
               {
                  param9[0] = PATH_SOUTH_WEST;
               }
               if(_loc10_ == 1 && _loc11_ == 1)
               {
                  param9[0] = PATH_SOUTH_EAST;
               }
               param9[0] = param9[0] | _loc12_ << 16;
               return PATH_EXISTS;
            }
            return PATH_EMPTY;
         }
         var _loc13_:Vector.<tibia.minimap.MiniMapSector> = new Vector.<tibia.minimap.MiniMapSector>(4,true);
         _loc13_[0] = this.acquireSector(param1 - PATH_MATRIX_CENTER,param2 - PATH_MATRIX_CENTER,param3,false);
         _loc13_[1] = this.acquireSector(param1 - PATH_MATRIX_CENTER,param2 + PATH_MATRIX_CENTER,param3,false);
         _loc13_[2] = this.acquireSector(param1 + PATH_MATRIX_CENTER,param2 + PATH_MATRIX_CENTER,param3,false);
         _loc13_[3] = this.acquireSector(param1 + PATH_MATRIX_CENTER,param2 - PATH_MATRIX_CENTER,param3,false);
         var _loc14_:int = 0;
         var _loc15_:int = int.MAX_VALUE;
         _loc14_ = 0;
         while(_loc14_ < 4)
         {
            _loc15_ = Math.min(_loc15_,_loc13_[_loc14_].minCost);
            _loc14_++;
         }
         var _loc16_:int = _loc13_[0].getSectorX() + MM_SECTOR_SIZE;
         var _loc17_:int = _loc13_[0].getSectorY() + MM_SECTOR_SIZE;
         var _loc18_:tibia.minimap.PathItem = this.m_PathMatrix[PATH_MATRIX_CENTER * PATH_MATRIX_SIZE + PATH_MATRIX_CENTER];
         _loc18_.predecessor = null;
         _loc18_.cost = int.MAX_VALUE;
         _loc18_.pathCost = int.MAX_VALUE;
         _loc18_.pathHeuristic = 0;
         this.m_PathDirty.push(_loc18_);
         var _loc19_:tibia.minimap.PathItem = this.m_PathMatrix[(PATH_MATRIX_CENTER + _loc11_) * PATH_MATRIX_SIZE + (PATH_MATRIX_CENTER + _loc10_)];
         _loc19_.predecessor = null;
         if(param4 < _loc16_)
         {
            if(param5 < _loc17_)
            {
               _loc14_ = 0;
            }
            else
            {
               _loc14_ = 1;
            }
         }
         else if(param5 < _loc17_)
         {
            _loc14_ = 3;
         }
         else
         {
            _loc14_ = 2;
         }
         _loc19_.cost = _loc13_[_loc14_].getCost(param4,param5,param6);
         _loc19_.pathCost = 0;
         _loc19_.pathHeuristic = _loc19_.cost + (_loc19_.distance - 1) * _loc15_;
         this.m_PathDirty.push(_loc19_);
         this.m_PathHeap.clear(false);
         this.m_PathHeap.addItem(_loc19_,_loc19_.pathHeuristic);
         var _loc20_:tibia.minimap.PathItem = null;
         var _loc21_:tibia.minimap.PathItem = null;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         var _loc25_:int = 0;
         var _loc26_:int = 0;
         var _loc27_:tibia.minimap.MiniMapSector = null;
         while((_loc20_ = this.m_PathHeap.extractMinItem() as tibia.minimap.PathItem) != null)
         {
            if(_loc20_.m_HeapKey < _loc18_.pathCost)
            {
               _loc10_ = -1;
               while(_loc10_ < 2)
               {
                  _loc11_ = -1;
                  while(_loc11_ < 2)
                  {
                     if(_loc10_ != 0 || _loc11_ != 0)
                     {
                        _loc23_ = _loc20_.x + _loc10_;
                        _loc24_ = _loc20_.y + _loc11_;
                        if(!(_loc23_ < -PATH_MATRIX_CENTER || _loc23_ > PATH_MATRIX_CENTER || _loc24_ < -PATH_MATRIX_CENTER || _loc24_ > PATH_MATRIX_CENTER))
                        {
                           if(_loc10_ * _loc11_ == 0)
                           {
                              _loc22_ = _loc20_.pathCost + _loc20_.cost;
                           }
                           else
                           {
                              _loc22_ = _loc20_.pathCost + 3 * _loc20_.cost;
                           }
                           _loc21_ = this.m_PathMatrix[(PATH_MATRIX_CENTER + _loc24_) * PATH_MATRIX_SIZE + PATH_MATRIX_CENTER + _loc23_];
                           if(_loc21_.pathCost > _loc22_)
                           {
                              _loc21_.predecessor = _loc20_;
                              _loc21_.pathCost = _loc22_;
                              if(_loc21_.cost == int.MAX_VALUE)
                              {
                                 _loc25_ = param1 + _loc21_.x;
                                 _loc26_ = param2 + _loc21_.y;
                                 if(_loc25_ < _loc16_)
                                 {
                                    if(_loc26_ < _loc17_)
                                    {
                                       _loc14_ = 0;
                                    }
                                    else
                                    {
                                       _loc14_ = 1;
                                    }
                                 }
                                 else if(_loc26_ < _loc17_)
                                 {
                                    _loc14_ = 3;
                                 }
                                 else
                                 {
                                    _loc14_ = 2;
                                 }
                                 _loc21_.cost = _loc13_[_loc14_].getCost(_loc25_,_loc26_,param3);
                                 _loc21_.pathHeuristic = _loc21_.cost + (_loc21_.distance - 1) * _loc15_;
                                 this.m_PathDirty.push(_loc21_);
                              }
                              if(!(_loc21_ == _loc18_ || _loc21_.cost >= PATH_COST_OBSTACLE))
                              {
                                 if(_loc21_.m_HeapParent != null)
                                 {
                                    this.m_PathHeap.updateKey(_loc21_,_loc22_ + _loc21_.pathHeuristic);
                                 }
                                 else
                                 {
                                    this.m_PathHeap.addItem(_loc21_,_loc22_ + _loc21_.pathHeuristic);
                                 }
                              }
                           }
                        }
                     }
                     _loc11_++;
                  }
                  _loc10_++;
               }
               continue;
            }
         }
         var _loc28_:int = PATH_ERROR_INTERNAL;
         if(_loc18_.pathCost < int.MAX_VALUE)
         {
            _loc20_ = _loc18_;
            _loc21_ = null;
            _loc14_ = 0;
            while(_loc20_ != null)
            {
               if(!param8 && _loc20_.x == _loc19_.x && _loc20_.y == _loc19_.y && _loc19_.cost >= PATH_COST_OBSTACLE)
               {
                  _loc20_ = null;
                  break;
               }
               if(_loc20_.cost == PATH_COST_UNDEFINED)
               {
                  break;
               }
               if(_loc21_ != null)
               {
                  _loc10_ = _loc20_.x - _loc21_.x;
                  _loc11_ = _loc20_.y - _loc21_.y;
                  if(_loc10_ == 1 && _loc11_ == 0)
                  {
                     param9[_loc14_] = PATH_EAST;
                  }
                  else if(_loc10_ == 1 && _loc11_ == -1)
                  {
                     param9[_loc14_] = PATH_NORTH_EAST;
                  }
                  else if(_loc10_ == 0 && _loc11_ == -1)
                  {
                     param9[_loc14_] = PATH_NORTH;
                  }
                  else if(_loc10_ == -1 && _loc11_ == -1)
                  {
                     param9[_loc14_] = PATH_NORTH_WEST;
                  }
                  else if(_loc10_ == -1 && _loc11_ == 0)
                  {
                     param9[_loc14_] = PATH_WEST;
                  }
                  else if(_loc10_ == -1 && _loc11_ == 1)
                  {
                     param9[_loc14_] = PATH_SOUTH_WEST;
                  }
                  else if(_loc10_ == 0 && _loc11_ == 1)
                  {
                     param9[_loc14_] = PATH_SOUTH;
                  }
                  else if(_loc10_ == 1 && _loc11_ == 1)
                  {
                     param9[_loc14_] = PATH_SOUTH_EAST;
                  }
                  param9[_loc14_] = param9[_loc14_] | _loc20_.cost << 16;
                  if(++_loc14_ >= PATH_MAX_STEPS)
                  {
                     break;
                  }
               }
               _loc21_ = _loc20_;
               _loc20_ = _loc20_.predecessor;
            }
            if(_loc14_ == 0)
            {
               _loc28_ = PATH_EMPTY;
            }
            else
            {
               _loc28_ = PATH_EXISTS;
            }
         }
         else
         {
            _loc28_ = PATH_ERROR_UNREACHABLE;
         }
         while((_loc21_ = this.m_PathDirty.pop()) != null)
         {
            _loc21_.cost = int.MAX_VALUE;
            _loc21_.pathCost = int.MAX_VALUE;
         }
         return _loc28_;
      }
      
      private function refreshFromWorldMap() : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc1_:WorldMapStorage = Tibia.s_GetWorldMapStorage();
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.getPosition();
            _loc2_.x = _loc2_.x - PLAYER_OFFSET_X;
            _loc2_.y = _loc2_.y - PLAYER_OFFSET_Y;
            _loc3_ = _loc1_.toMap(_loc2_);
            _loc4_ = 0;
            while(_loc4_ < MAPSIZE_X)
            {
               _loc5_ = 0;
               while(_loc5_ < MAPSIZE_Y)
               {
                  _loc6_ = _loc1_.getMiniMapColour(_loc4_,_loc5_,_loc3_.z);
                  _loc7_ = _loc1_.getMiniMapCost(_loc4_,_loc5_,_loc3_.z);
                  this.updateField(_loc2_.x + _loc4_,_loc2_.y + _loc5_,_loc2_.z,_loc6_,_loc7_,false);
                  _loc5_++;
               }
               _loc4_++;
            }
            this.refreshSectors();
         }
      }
      
      public function getFieldColour(param1:int, param2:int, param3:int) : uint
      {
         return this.acquireSector(param1,param2,param3,false).getColour(param1,param2,param3);
      }
      
      public function getFieldCost(param1:int, param2:int, param3:int) : int
      {
         return this.acquireSector(param1,param2,param3,false).getCost(param1,param2,param3);
      }
      
      public function exportMiniMap() : ByteArray
      {
         if(this.m_IEData != null || this.m_IEQueue != null || this.m_IETimer != null)
         {
            throw new Error("MiniMapStorage.exportMiniMap: Concurrent operation detected.");
         }
         this.saveSectors(true);
         this.m_IOTimer.stop();
         this.m_IEQueue = this.getSectorListing();
         this.m_IEBytesProcessed = 0;
         this.m_IEBytesTotal = this.m_IEQueue.length * tibia.minimap.MiniMapSector.MIN_BYTES;
         try
         {
            this.m_IEData = new ByteArray();
            this.m_IEData.endian = Endian.LITTLE_ENDIAN;
            this.m_IEData.position = this.m_IEBytesTotal;
            this.m_IEData.position = 0;
         }
         catch(_Error:MemoryError)
         {
            m_IEQueue = null;
            m_IEData = null;
            throw _Error;
         }
         this.m_IETimer = new Timer(MM_IE_TIMEOUT,0);
         this.m_IETimer.addEventListener(TimerEvent.TIMER,this.onExportTimer);
         this.m_IETimer.start();
         return this.m_IEData;
      }
      
      private function dequeue(param1:Vector.<tibia.minimap.MiniMapSector>, param2:tibia.minimap.MiniMapSector) : void
      {
         var _loc3_:int = param1.length - 1;
         while(_loc3_ >= 0)
         {
            if(param2.equals(param1[_loc3_]))
            {
               param1.splice(_loc3_,1);
               return;
            }
            _loc3_--;
         }
      }
      
      public function getMark(param1:int, param2:int, param3:int) : Object
      {
         return this.acquireSector(param1,param2,param3,false).getMark(param1,param2,param3);
      }
      
      public function updateField(param1:int, param2:int, param3:int, param4:uint, param5:int, param6:Boolean = true) : void
      {
         var _loc8_:PropertyChangeEvent = null;
         var _loc7_:tibia.minimap.MiniMapSector = this.acquireSector(param1,param2,param3,false);
         _loc7_.updateField(param1,param2,param3,param4,param5);
         if(param6)
         {
            _loc8_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc8_.kind = PropertyChangeEventKind.UPDATE;
            _loc8_.property = "sector";
            dispatchEvent(_loc8_);
            this.enqueue(this.m_SaveQueue,_loc7_);
         }
         else
         {
            this.m_ChangedSector = true;
         }
      }
      
      public function setPosition(param1:int, param2:int, param3:int) : void
      {
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(param1 < MAP_MIN_X)
         {
            param1 = MAP_MIN_X;
         }
         if(param1 > MAP_MAX_X)
         {
            param1 = MAP_MAX_X;
         }
         if(param2 < MAP_MIN_Y)
         {
            param2 = MAP_MIN_Y;
         }
         if(param2 > MAP_MAX_Y)
         {
            param2 = MAP_MAX_Y;
         }
         if(param3 < MAP_MIN_Z)
         {
            param3 = MAP_MIN_Z;
         }
         if(param3 > MAP_MAX_Z)
         {
            param3 = MAP_MAX_Z;
         }
         var _loc4_:int = int(param1 / MM_SECTOR_SIZE) * MM_SECTOR_SIZE;
         var _loc5_:int = int(param2 / MM_SECTOR_SIZE) * MM_SECTOR_SIZE;
         var _loc6_:int = param3;
         this.m_PositionX = param1;
         this.m_PositionY = param2;
         this.m_PositionZ = param3;
         if(_loc4_ != this.m_SectorX || _loc5_ != this.m_SectorY || _loc6_ != this.m_SectorZ)
         {
            _loc8_ = -1;
            while(_loc8_ < 2)
            {
               _loc9_ = -1;
               while(_loc9_ < 2)
               {
                  this.acquireSector(_loc4_ + _loc9_ * MM_SECTOR_SIZE,_loc5_ + _loc8_ * MM_SECTOR_SIZE,_loc6_,_loc8_ == 0 && _loc9_ == 0);
                  _loc9_++;
               }
               _loc8_++;
            }
            this.m_SectorX = _loc4_;
            this.m_SectorY = _loc5_;
            this.m_SectorZ = _loc6_;
         }
         var _loc7_:PropertyChangeEvent = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
         _loc7_.kind = PropertyChangeEventKind.UPDATE;
         _loc7_.property = "position";
         dispatchEvent(_loc7_);
      }
      
      public function reset() : void
      {
         var _loc1_:int = 0;
         this.cancelImportExport();
         if(this.m_LoadQueue != null)
         {
            this.m_LoadQueue.length = 0;
         }
         if(this.m_SaveQueue != null)
         {
            this.m_SaveQueue.length = 0;
         }
         if(this.m_SectorCache != null)
         {
            this.m_SectorCache.length = 0;
         }
         if(this.m_PathMatrix != null)
         {
         }
         if(this.m_PathHeap != null)
         {
            this.m_PathHeap.clear();
         }
         if(this.m_PathDirty != null)
         {
            _loc1_ = this.m_PathDirty.length - 1;
            while(_loc1_ >= 0)
            {
               this.m_PathDirty[_loc1_].cost = int.MAX_VALUE;
               this.m_PathDirty[_loc1_].pathCost = int.MAX_VALUE;
               this.m_PathDirty[_loc1_].pathHeuristic = int.MAX_VALUE;
               this.m_PathDirty[_loc1_].predecessor = null;
               _loc1_--;
            }
            this.m_PathDirty.length = 0;
         }
         this.m_PositionX = this.m_PositionY = this.m_PositionZ = -1;
         this.m_SectorX = this.m_SectorY = this.m_SectorZ = -1;
      }
      
      public function cancelImportExport() : void
      {
         this.m_IEBytesProcessed = 0;
         this.m_IEBytesTotal = 0;
         this.m_IEData = null;
         this.m_IEQueue = null;
         if(this.m_IETimer != null)
         {
            this.m_IETimer.removeEventListener(TimerEvent.TIMER,this.onExportTimer);
            this.m_IETimer.stop();
            this.m_IETimer = null;
         }
         System.pauseForGCIfCollectionImminent(0.5);
         if(!this.m_IOTimer.running)
         {
            this.m_IOTimer.start();
         }
      }
      
      public function setMark(param1:int, param2:int, param3:int, param4:int, param5:String, param6:Boolean = true) : void
      {
         var _loc8_:PropertyChangeEvent = null;
         var _loc7_:tibia.minimap.MiniMapSector = this.acquireSector(param1,param2,param3,false);
         _loc7_.setMark(param1,param2,param3,param4,param5);
         if(param6)
         {
            _loc8_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc8_.kind = PropertyChangeEventKind.UPDATE;
            _loc8_.property = "sector";
            dispatchEvent(_loc8_);
            this.enqueue(this.m_SaveQueue,_loc7_);
         }
         else
         {
            this.m_ChangedSector = true;
         }
      }
      
      public function acquireSector(param1:int, param2:int, param3:int, param4:Boolean) : tibia.minimap.MiniMapSector
      {
         var _loc11_:tibia.minimap.MiniMapSector = null;
         param1 = Math.max(MAP_MIN_X,Math.min(param1,MAP_MAX_X));
         param2 = Math.max(MAP_MIN_Y,Math.min(param2,MAP_MAX_Y));
         param3 = Math.max(MAP_MIN_Z,Math.min(param3,MAP_MAX_Z));
         var _loc5_:int = int(param1 / MM_SECTOR_SIZE) * MM_SECTOR_SIZE;
         var _loc6_:int = int(param2 / MM_SECTOR_SIZE) * MM_SECTOR_SIZE;
         var _loc7_:int = param3;
         var _loc8_:tibia.minimap.MiniMapSector = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc9_ = this.m_SectorCache.length - 1;
         while(_loc9_ >= 0)
         {
            if(this.m_SectorCache[_loc9_].equals(_loc5_,_loc6_,_loc7_))
            {
               _loc8_ = this.m_SectorCache[_loc9_];
               this.m_SectorCache.splice(_loc9_,1);
               break;
            }
            _loc9_--;
         }
         if(_loc8_ == null)
         {
            _loc9_ = this.m_SaveQueue.length - 1;
            while(_loc9_ >= 0)
            {
               if(this.m_SaveQueue[_loc9_].equals(_loc5_,_loc6_,_loc7_))
               {
                  _loc8_ = this.m_SaveQueue[_loc9_];
                  break;
               }
               _loc9_--;
            }
         }
         if(_loc8_ == null)
         {
            _loc8_ = new tibia.minimap.MiniMapSector(_loc5_,_loc6_,_loc7_);
            if(BrowserHelper.s_CompareFlashPlayerVersion(Tibia.BUGGY_FLASH_PLAYER_VERSION))
            {
               param4 = false;
            }
            if(param4)
            {
               _loc8_.loadSharedObject();
               this.dequeue(this.m_LoadQueue,_loc8_);
            }
            else
            {
               this.enqueue(this.m_LoadQueue,_loc8_);
            }
         }
         if(this.m_SectorCache.length >= MM_CACHE_SIZE)
         {
            _loc11_ = null;
            _loc9_ = 0;
            _loc10_ = this.m_SectorCache.length;
            while(_loc9_ < _loc10_)
            {
               if(!this.m_SectorCache[_loc9_].dirty)
               {
                  _loc11_ = this.m_SectorCache[_loc9_];
                  this.m_SectorCache.splice(_loc9_,1);
                  break;
               }
               _loc9_++;
            }
            if(_loc11_ == null)
            {
               _loc11_ = this.m_SectorCache[0];
               this.m_SectorCache.splice(0,1);
            }
            this.dequeue(this.m_LoadQueue,_loc11_);
            if(_loc11_.dirty)
            {
               this.enqueue(this.m_SaveQueue,_loc11_);
            }
         }
         this.m_SectorCache.push(_loc8_);
         return _loc8_;
      }
      
      public function highlightMarks() : void
      {
         var _loc1_:Event = new Event(EVENT_HIGHLIGHT_MARKS);
         dispatchEvent(_loc1_);
      }
      
      public function refreshSectors() : void
      {
         var _loc1_:PropertyChangeEvent = null;
         var _loc2_:int = 0;
         if(this.m_ChangedSector)
         {
            _loc1_ = new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE);
            _loc1_.kind = PropertyChangeEventKind.UPDATE;
            _loc1_.property = "sector";
            dispatchEvent(_loc1_);
            _loc2_ = this.m_SectorCache.length - 1;
            while(_loc2_ >= 0)
            {
               if(this.m_SectorCache[_loc2_].dirty)
               {
                  this.enqueue(this.m_SaveQueue,this.m_SectorCache[_loc2_]);
               }
               _loc2_--;
            }
            this.m_ChangedSector = false;
         }
      }
      
      public function getSectorX() : int
      {
         return this.m_SectorX;
      }
      
      public function getSectorZ() : int
      {
         return this.m_SectorZ;
      }
   }
}
