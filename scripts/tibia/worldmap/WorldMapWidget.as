package tibia.worldmap
{
   import mx.core.UIComponent;
   import tibia.game.IUseWidget;
   import tibia.game.IMoveWidget;
   import flash.display.Bitmap;
   import flash.geom.Point;
   import tibia.game.ObjectDragImpl;
   import tibia.help.UIEffectsRetrieveComponentCommandEvent;
   import tibia.worldmap.widgetClasses.RendererImpl;
   import flash.events.MouseEvent;
   import tibia.game.ContextMenuBase;
   import tibia.game.PopUpBase;
   import tibia.creatures.Player;
   import mx.core.FlexShape;
   import shared.controls.ShapeWrapper;
   import mx.controls.Label;
   import flash.events.Event;
   import tibia.options.OptionsStorage;
   import shared.utility.Vector3D;
   import tibia.network.IServerConnection;
   import flash.utils.getTimer;
   import tibia.network.Connection;
   import mx.events.PropertyChangeEvent;
   import tibia.creatures.CreatureStorage;
   import tibia.cursors.CursorHelper;
   import flash.geom.Rectangle;
   import tibia.creatures.Creature;
   import tibia.appearances.AppearanceInstance;
   import tibia.appearances.ObjectInstance;
   import tibia.input.gameaction.AutowalkActionImpl;
   import tibia.network.Communication;
   import tibia.input.mapping.MouseBinding;
   import tibia.input.MouseActionHelper;
   import tibia.input.gameaction.UseActionImpl;
   import tibia.input.gameaction.LookActionImpl;
   import tibia.game.ObjectContextMenu;
   import flash.display.Graphics;
   import mx.events.ResizeEvent;
   import mx.managers.CursorManagerPriority;
   import build.ObjectDragImplFactory;
   
   public class WorldMapWidget extends UIComponent implements IUseWidget, IMoveWidget
   {
      
      protected static const RENDERER_DEFAULT_HEIGHT:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const ACTION_LOOK:int = 6;
      
      protected static const NUM_EFFECTS:int = 200;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      private static const ACTION_TALK:int = 9;
      
      protected static const ONSCREEN_MESSAGE_WIDTH:int = 295;
      
      protected static const FIELD_ENTER_POSSIBLE:uint = 0;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      protected static const DRAG_TYPE_CHANNEL:String = "channel";
      
      protected static const FIELD_ENTER_NOT_POSSIBLE:uint = 2;
      
      protected static const FIELD_HEIGHT:int = 24;
      
      protected static const DRAG_TYPE_WIDGETBASE:String = "widgetBase";
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      protected static const UNDERGROUND_LAYER:int = 2;
      
      private static const LATENCY_ICON_MEDIUM:Bitmap = new EMBED_LATENCY_ICON_MEDIUM();
      
      protected static const ONSCREEN_MESSAGE_HEIGHT:int = 195;
      
      private static const s_TempPoint:Point = new Point();
      
      protected static const FIELD_CACHESIZE:int = FIELD_SIZE;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      protected static const FIELD_SIZE:int = 32;
      
      protected static const FIELD_ENTER_POSSIBLE_NO_ANIMATION:uint = 1;
      
      protected static const PLAYER_OFFSET_X:int = 8;
      
      protected static const PLAYER_OFFSET_Y:int = 6;
      
      protected static const DRAG_TYPE_ACTION:String = "action";
      
      protected static const DRAG_TYPE_STATUSWIDGET:String = "statusWidget";
      
      protected static const DRAG_TYPE_OBJECT:String = "object";
      
      protected static const MAP_MAX_X:int = MAP_MIN_X + (1 << 14 - 1);
      
      protected static const MAP_MAX_Y:int = MAP_MIN_Y + (1 << 14 - 1);
      
      protected static const MAP_MAX_Z:int = 15;
      
      protected static const NUM_ONSCREEN_MESSAGES:int = 16;
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const EMBED_LATENCY_ICON_LOW:Class = WorldMapWidget_EMBED_LATENCY_ICON_LOW;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      protected static const GROUND_LAYER:int = 7;
      
      private static const VALID_ACTIONS:Vector.<uint> = Vector.<uint>([ACTION_AUTOWALK,ACTION_AUTOWALK_HIGHLIGHT,ACTION_TALK,ACTION_ATTACK,ACTION_USE,ACTION_OPEN,ACTION_LOOK,ACTION_CONTEXT_MENU]);
      
      private static const EMBED_LATENCY_ICON_HIGH:Class = WorldMapWidget_EMBED_LATENCY_ICON_HIGH;
      
      private static const BUNDLE:String = "WorldMapStorage";
      
      private static const LATENCY_ICON_HIGH:Bitmap = new EMBED_LATENCY_ICON_HIGH();
      
      protected static const MAP_HEIGHT:int = 11;
      
      protected static const RENDERER_DEFAULT_WIDTH:Number = MAP_WIDTH * FIELD_SIZE;
      
      private static const ACTION_NONE:int = 0;
      
      private static const EMBED_LATENCY_ICON_MEDIUM:Class = WorldMapWidget_EMBED_LATENCY_ICON_MEDIUM;
      
      protected static const NUM_FIELDS:int = MAPSIZE_Z * MAPSIZE_Y * MAPSIZE_X;
      
      private static const ACTION_OPEN:int = 8;
      
      protected static const DRAG_TYPE_SPELL:String = "spell";
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      private static const LATENCY_ICON_LOW:Bitmap = new EMBED_LATENCY_ICON_LOW();
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      private static const ACTION_UNSET:int = -1;
      
      protected static const MAP_MIN_X:int = 24576;
      
      protected static const MAP_MIN_Y:int = 24576;
      
      protected static const MAP_MIN_Z:int = 0;
      
      protected static const RENDERER_MIN_HEIGHT:Number = Math.round(MAP_HEIGHT * 2 / 3 * FIELD_SIZE);
      
      protected static const MAPSIZE_W:int = 10;
      
      protected static const MAPSIZE_X:int = MAP_WIDTH + 3;
      
      protected static const MAPSIZE_Y:int = MAP_HEIGHT + 3;
      
      protected static const MAPSIZE_Z:int = 8;
      
      protected static const RENDERER_MIN_WIDTH:Number = Math.round(MAP_WIDTH * 2 / 3 * FIELD_SIZE);
      
      private static const ACTION_USE:int = 7;
      
      protected static const DRAG_OPACITY:Number = 0.75;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      protected static const MAP_WIDTH:int = 15;
      
      private static const s_InteractiveObjectWrapper:Object = new Object();
       
      
      private var m_DragHandler:ObjectDragImpl;
      
      private var m_Player:Player = null;
      
      private var m_InfoTimestamp:Number = -Infinity;
      
      private var m_UIBackdrop:FlexShape = null;
      
      private var m_Options:OptionsStorage = null;
      
      private var m_UIInfoFramerate:Label = null;
      
      private var m_WorldMapStorage:tibia.worldmap.WorldMapStorage = null;
      
      private var m_MouseCursorOverRenderer:Boolean = false;
      
      private var m_UIRendererImpl:RendererImpl = null;
      
      private var m_CreatureStorage:CreatureStorage = null;
      
      private var m_UncommittedOptions:Boolean = false;
      
      private var m_UncommittedPlayer:Boolean = false;
      
      private var m_CursorHelper:CursorHelper;
      
      private var m_UncommittedWorldMapStorage:Boolean = false;
      
      private var m_UIInfoLatency:ShapeWrapper = null;
      
      private var m_UncommittedCreatureStorage:Boolean = false;
      
      public function WorldMapWidget()
      {
         this.m_CursorHelper = new CursorHelper(CursorManagerPriority.MEDIUM);
         super();
         this.m_DragHandler = ObjectDragImplFactory.s_CreateObjectDragImpl();
         addEventListener(ResizeEvent.RESIZE,this.onResize);
         Tibia.s_GetUIEffectsManager().addEventListener(UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT,this.onUIEffectsCommandEvent);
      }
      
      private function onUIEffectsCommandEvent(param1:UIEffectsRetrieveComponentCommandEvent) : void
      {
         if(param1.type == UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT && param1.identifier == WorldMapWidget && param1.subIdentifier == RendererImpl)
         {
            param1.resultUIComponent = this.m_UIRendererImpl;
         }
      }
      
      private function onMouseMove(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.ROLL_OVER)
         {
            this.m_MouseCursorOverRenderer = true;
            if(this.m_MouseCursorOverRenderer)
            {
               this.determineAction(param1,false,true,true);
            }
         }
         else if(param1.type == MouseEvent.ROLL_OUT)
         {
            this.m_MouseCursorOverRenderer = false;
            this.m_CursorHelper.resetCursor();
         }
         if(this.m_MouseCursorOverRenderer && this.m_UIRendererImpl != null && this.m_Options != null && this.m_Options.rendererHighlight > 0 && ContextMenuBase.getCurrent() == null && PopUpBase.getCurrent() == null)
         {
            if(param1.type != MouseEvent.ROLL_OUT)
            {
               this.m_UIRendererImpl.highlightTile = this.m_UIRendererImpl.pointToMap(param1.localX,param1.localY,false);
            }
            else
            {
               this.m_UIRendererImpl.highlightTile = null;
            }
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.m_UIBackdrop = new FlexShape();
         this.m_UIBackdrop.name = "backdrop";
         addChild(this.m_UIBackdrop);
         this.m_UIRendererImpl = new RendererImpl();
         this.m_UIRendererImpl.name = "renderer";
         this.m_UIRendererImpl.addEventListener(MouseEvent.CLICK,this.onMouseClick);
         this.m_UIRendererImpl.addEventListener(MouseEvent.RIGHT_CLICK,this.onMouseClick);
         this.m_UIRendererImpl.addEventListener(MouseEvent.MIDDLE_CLICK,this.onMouseClick);
         this.m_UIRendererImpl.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove);
         this.m_UIRendererImpl.addEventListener(MouseEvent.ROLL_OUT,this.onMouseMove);
         this.m_UIRendererImpl.addEventListener(MouseEvent.ROLL_OVER,this.onMouseMove);
         addChild(this.m_UIRendererImpl);
         this.m_DragHandler.addDragComponent(this.m_UIRendererImpl);
         this.m_UIInfoLatency = new ShapeWrapper();
         this.m_UIInfoLatency.name = "latency";
         addChild(this.m_UIInfoLatency);
         this.m_UIInfoFramerate = new Label();
         this.m_UIInfoFramerate.name = "framerate";
         this.m_UIInfoFramerate.text = null;
         this.m_UIInfoFramerate.setStyle("color",65280);
         this.m_UIInfoFramerate.setStyle("fontSize",12);
         this.m_UIInfoFramerate.setStyle("fontWeight","bold");
         addChild(this.m_UIInfoFramerate);
         addEventListener(Event.ENTER_FRAME,this.onEnterFrame);
      }
      
      public function get options() : OptionsStorage
      {
         return this.m_Options;
      }
      
      private function onMouseClick(param1:MouseEvent) : void
      {
         this.determineAction(param1,true,false);
      }
      
      public function getMoveObjectUnderPoint(param1:Point) : Object
      {
         var _loc2_:Point = null;
         var _loc3_:Vector3D = null;
         var _loc4_:Object = null;
         if(this.m_UIRendererImpl != null && this.m_WorldMapStorage != null)
         {
            _loc2_ = this.m_UIRendererImpl.globalToLocal(param1);
            _loc3_ = this.m_UIRendererImpl.pointToMap(_loc2_.x,_loc2_.y,false);
            if(_loc3_ != null)
            {
               _loc4_ = {"absolute":this.m_WorldMapStorage.toAbsolute(_loc3_)};
               this.m_WorldMapStorage.getTopMoveObject(_loc3_.x,_loc3_.y,_loc3_.z,_loc4_);
               return _loc4_;
            }
         }
         return null;
      }
      
      public function getUseObjectUnderPoint(param1:Point) : Object
      {
         var _loc2_:Point = null;
         var _loc3_:Vector3D = null;
         var _loc4_:Object = null;
         if(this.m_UIRendererImpl != null && this.m_WorldMapStorage != null)
         {
            _loc2_ = this.m_UIRendererImpl.globalToLocal(param1);
            _loc3_ = this.m_UIRendererImpl.pointToMap(_loc2_.x,_loc2_.y,false);
            if(_loc3_ != null)
            {
               _loc4_ = {"absolute":this.m_WorldMapStorage.toAbsolute(_loc3_)};
               this.m_WorldMapStorage.getTopUseObject(_loc3_.x,_loc3_.y,_loc3_.z,_loc4_);
               return _loc4_;
            }
         }
         return null;
      }
      
      private function onEnterFrame(param1:Event) : void
      {
         var _loc2_:Vector3D = null;
         var _loc3_:Vector3D = null;
         var _loc4_:uint = 0;
         var _loc5_:IServerConnection = null;
         var _loc6_:* = null;
         if(this.m_UIRendererImpl != null && this.m_Options != null && this.m_Options.rendererHighlight > 0 && ContextMenuBase.getCurrent() == null && PopUpBase.getCurrent() == null)
         {
            _loc2_ = this.m_UIRendererImpl.highlightTile;
            _loc3_ = this.m_UIRendererImpl.pointToMap(this.m_UIRendererImpl.mouseX,this.m_UIRendererImpl.mouseY,false);
            if(_loc3_ != null && _loc2_ != null)
            {
               _loc3_.x = _loc2_.x;
               _loc3_.y = _loc2_.y;
            }
            if(this.m_MouseCursorOverRenderer)
            {
               this.m_UIRendererImpl.highlightTile = _loc3_;
            }
            else
            {
               this.m_UIRendererImpl.highlightTile = null;
            }
         }
         if(this.m_MouseCursorOverRenderer)
         {
            this.determineAction(null,false,true,true);
         }
         else if(this.m_CreatureStorage != null && this.m_CreatureStorage.getAim() != null)
         {
            this.m_UIRendererImpl.highlightObject = this.m_CreatureStorage.getAim();
         }
         else
         {
            this.m_UIRendererImpl.highlightObject = null;
         }
         if(this.m_Options != null && this.m_Options.rendererShowFrameRate)
         {
            _loc4_ = getTimer();
            if(this.m_UIRendererImpl != null && this.m_WorldMapStorage != null && _loc4_ > this.m_InfoTimestamp + 500)
            {
               this.m_InfoTimestamp = _loc4_;
               _loc5_ = Tibia.s_GetConnection();
               this.m_UIInfoLatency.removeChildren();
               if(_loc5_ != null && _loc5_.isGameRunning)
               {
                  if(_loc5_.latency < Connection.LATENCY_LOW)
                  {
                     this.m_UIInfoLatency.toolTip = resourceManager.getString(BUNDLE,"LATENCY_TOOTLIP_LOW");
                     this.m_UIInfoLatency.addChild(LATENCY_ICON_LOW);
                  }
                  else if(_loc5_.latency < Connection.LATENCY_MEDIUM)
                  {
                     this.m_UIInfoLatency.toolTip = resourceManager.getString(BUNDLE,"LATENCY_TOOTLIP_MEDIUM");
                     this.m_UIInfoLatency.addChild(LATENCY_ICON_MEDIUM);
                  }
                  else
                  {
                     this.m_UIInfoLatency.toolTip = resourceManager.getString(BUNDLE,"LATENCY_TOOTLIP_HIGH");
                     this.m_UIInfoLatency.addChild(LATENCY_ICON_HIGH);
                  }
               }
               else
               {
                  this.m_UIInfoLatency.toolTip = resourceManager.getString(BUNDLE,"LATENCY_TOOTLIP_NO_CONNECTION");
                  this.m_UIInfoLatency.addChild(LATENCY_ICON_HIGH);
               }
               _loc6_ = this.m_UIRendererImpl.fps + " FPS";
               this.m_UIInfoFramerate.text = _loc6_;
            }
         }
      }
      
      public function get worldMapStorage() : tibia.worldmap.WorldMapStorage
      {
         return this.m_WorldMapStorage;
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
            this.m_UncommittedOptions = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function set player(param1:Player) : void
      {
         if(this.m_Player != param1)
         {
            this.m_Player = param1;
            this.m_UncommittedPlayer = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function get creatureStorage() : CreatureStorage
      {
         return this.m_CreatureStorage;
      }
      
      public function reset() : void
      {
         if(this.m_UIRendererImpl != null)
         {
            this.m_UIRendererImpl.reset();
         }
      }
      
      public function pointToAbsolute(param1:Point) : Vector3D
      {
         var _loc2_:Point = null;
         if(this.m_UIRendererImpl != null)
         {
            _loc2_ = this.m_UIRendererImpl.globalToLocal(param1);
            return this.m_UIRendererImpl.pointToAbsolute(_loc2_.x,_loc2_.y,false);
         }
         return null;
      }
      
      public function pointToMap(param1:Point) : Vector3D
      {
         var _loc2_:Point = null;
         if(this.m_UIRendererImpl != null)
         {
            _loc2_ = this.m_UIRendererImpl.globalToLocal(param1);
            return this.m_UIRendererImpl.pointToMap(_loc2_.x,_loc2_.y,false);
         }
         return null;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedCreatureStorage)
         {
            this.m_UIRendererImpl.creatureStorage = this.m_CreatureStorage;
            this.m_UncommittedCreatureStorage = false;
         }
         if(this.m_UncommittedOptions)
         {
            this.m_UIRendererImpl.options = this.m_Options;
            this.m_UncommittedOptions = false;
         }
         if(this.m_UncommittedPlayer)
         {
            this.m_UIRendererImpl.player = this.m_Player;
            this.m_UncommittedPlayer = false;
         }
         if(this.m_UncommittedWorldMapStorage)
         {
            this.m_UIRendererImpl.worldMapStorage = this.m_WorldMapStorage;
            this.m_UncommittedWorldMapStorage = false;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         measuredMinHeight = 2 + (!isNaN(this.m_UIRendererImpl.explicitMinHeight)?this.m_UIRendererImpl.explicitMinHeight:this.m_UIRendererImpl.measuredMinHeight);
         measuredMinWidth = 2 + (!isNaN(this.m_UIRendererImpl.explicitMinWidth)?this.m_UIRendererImpl.explicitMinWidth:this.m_UIRendererImpl.measuredMinWidth);
         measuredHeight = 2 + this.m_UIRendererImpl.getExplicitOrMeasuredHeight();
         measuredWidth = 2 + this.m_UIRendererImpl.getExplicitOrMeasuredWidth();
      }
      
      public function get player() : Player
      {
         return this.m_Player;
      }
      
      public function set worldMapStorage(param1:tibia.worldmap.WorldMapStorage) : void
      {
         if(this.m_WorldMapStorage != param1)
         {
            this.m_WorldMapStorage = param1;
            this.m_UncommittedWorldMapStorage = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      public function calculateOptimalSize(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Number = NaN;
         if(MAP_WIDTH > MAP_HEIGHT)
         {
            return new Rectangle(0,0,param1,Math.round(param1 * MAP_HEIGHT / MAP_WIDTH));
         }
         if(MAP_HEIGHT < MAP_WIDTH)
         {
            return new Rectangle(0,0,Math.round(param2 * MAP_WIDTH / MAP_HEIGHT),param2);
         }
         _loc3_ = Math.min(param1,param2);
         return new Rectangle(0,0,_loc3_,_loc3_);
      }
      
      private function onOptionsChange(param1:PropertyChangeEvent) : void
      {
         invalidateDisplayList();
      }
      
      public function determineAction(param1:MouseEvent, param2:Boolean = false, param3:Boolean = false, param4:Boolean = false) : uint
      {
         var _loc10_:Vector3D = null;
         var _loc11_:Creature = null;
         var _loc12_:Object = null;
         var _loc13_:Object = null;
         var _loc14_:Object = null;
         var _loc15_:uint = 0;
         var _loc16_:AppearanceInstance = null;
         var _loc17_:Creature = null;
         var _loc18_:ObjectInstance = null;
         var _loc19_:AutowalkActionImpl = null;
         var _loc5_:Communication = null;
         var _loc6_:uint = ACTION_NONE;
         var _loc7_:MouseBinding = null;
         var _loc8_:Vector3D = null;
         var _loc9_:Point = null;
         if(this.m_Options == null)
         {
            return ACTION_NONE;
         }
         if(param1 != null)
         {
            _loc7_ = this.m_Options.mouseMapping.findBindingByMouseEvent(param1);
            s_TempPoint.setTo(param1.localX,param1.localY);
         }
         else
         {
            _loc7_ = this.m_Options.mouseMapping.findBindingForLeftMouseButtonAndPressedModifierKey();
            s_TempPoint.setTo(this.m_UIRendererImpl.mouseX,this.m_UIRendererImpl.mouseY);
         }
         if(_loc7_ != null)
         {
            _loc6_ = _loc7_.action;
         }
         if(this.m_WorldMapStorage != null && this.m_Player != null && (_loc5_ = Tibia.s_GetCommunication()) != null && _loc5_.isGameRunning && this.m_UIRendererImpl != null && (_loc8_ = this.m_UIRendererImpl.pointToMap(s_TempPoint.x,s_TempPoint.y,false)) != null)
         {
            _loc10_ = this.m_WorldMapStorage.toAbsolute(_loc8_);
            if(_loc6_ != ACTION_SMARTCLICK && _loc6_ != ACTION_AUTOWALK || _loc8_.z == this.m_WorldMapStorage.m_PlayerZPlane)
            {
               _loc11_ = this.m_UIRendererImpl.pointToCreature(s_TempPoint.x,s_TempPoint.y,true);
               _loc12_ = new Object();
               if(_loc11_ != null)
               {
                  this.m_WorldMapStorage.getCreatureObjectForCreature(_loc11_,_loc12_);
                  _loc17_ = null;
                  if(_loc12_.object != null)
                  {
                     _loc17_ = _loc11_;
                  }
               }
               _loc13_ = new Object();
               _loc14_ = new Object();
               if(_loc12_.object == null)
               {
                  this.m_WorldMapStorage.getTopLookObject(_loc8_.x,_loc8_.y,_loc8_.z,_loc13_);
               }
               else
               {
                  _loc13_ = _loc12_;
               }
               this.m_WorldMapStorage.getTopUseObject(_loc8_.x,_loc8_.y,_loc8_.z,_loc14_);
               _loc15_ = _loc6_;
               _loc16_ = null;
               if(_loc17_ != null && _loc17_ != this.m_Player)
               {
                  _loc6_ = MouseActionHelper.resolveActionForAppearanceOrCreature(_loc6_,_loc17_,VALID_ACTIONS);
               }
               else if(_loc14_.object != null && AppearanceInstance(_loc14_.object).type.isUsable)
               {
                  _loc16_ = _loc14_.object as AppearanceInstance;
                  _loc6_ = MouseActionHelper.resolveActionForAppearanceOrCreature(_loc6_,_loc16_,VALID_ACTIONS);
               }
               else if(_loc13_.object != null)
               {
                  _loc16_ = _loc13_.object as AppearanceInstance;
                  _loc6_ = MouseActionHelper.resolveActionForAppearanceOrCreature(_loc6_,_loc16_,VALID_ACTIONS);
               }
            }
            else
            {
               _loc6_ = ACTION_AUTOWALK;
            }
            if(_loc16_ != null && (!_loc16_.type.isDefaultAction || _loc16_.type.isDefaultAction && _loc16_.type.defaultAction == ACTION_NONE) && _loc15_ != _loc6_ && _loc6_ == ACTION_LOOK && this.m_WorldMapStorage.getEnterPossibleFlag(_loc8_.x,_loc8_.y,this.m_WorldMapStorage.m_PlayerZPlane,true) != FIELD_ENTER_NOT_POSSIBLE)
            {
               _loc6_ = ACTION_AUTOWALK;
            }
         }
         else
         {
            _loc6_ = ACTION_NONE;
         }
         if(param3 && this.m_Options != null && this.m_Options.mouseMapping != null && this.m_Options.mouseMapping.showMouseCursorForAction)
         {
            this.m_CursorHelper.setCursor(MouseActionHelper.actionToMouseCursor(_loc6_));
         }
         if(param4)
         {
            _loc18_ = null;
            switch(_loc6_)
            {
               case ACTION_NONE:
               case ACTION_AUTOWALK:
                  break;
               case ACTION_AUTOWALK_HIGHLIGHT:
                  _loc18_ = _loc13_.object;
                  break;
               case ACTION_TALK:
               case ACTION_ATTACK:
                  if(_loc17_ != null && _loc17_ != this.m_Player)
                  {
                     _loc18_ = _loc12_.object;
                  }
                  break;
               case ACTION_USE:
               case ACTION_OPEN:
               case ACTION_CONTEXT_MENU:
                  if(_loc14_.object != null)
                  {
                     _loc18_ = _loc14_.object;
                  }
                  break;
               case ACTION_LOOK:
                  if(_loc13_.object != null)
                  {
                     _loc18_ = _loc13_.object;
                  }
            }
            if(_loc18_ != null && ContextMenuBase.getCurrent() == null && PopUpBase.getCurrent() == null)
            {
               this.m_UIRendererImpl.highlightObject = _loc18_;
            }
            else
            {
               this.m_UIRendererImpl.highlightObject = null;
            }
         }
         if(param2)
         {
            switch(_loc6_)
            {
               case ACTION_NONE:
                  break;
               case ACTION_AUTOWALK:
               case ACTION_AUTOWALK_HIGHLIGHT:
                  _loc10_ = this.m_UIRendererImpl.pointToAbsolute(s_TempPoint.x,s_TempPoint.y,true,_loc10_);
                  _loc19_ = Tibia.s_GameActionFactory.createAutowalkAction(_loc10_.x,_loc10_.y,_loc10_.z,false,true);
                  _loc19_.perform();
                  break;
               case ACTION_ATTACK:
                  if(_loc17_ != null && _loc17_ != this.m_Player)
                  {
                     Tibia.s_GameActionFactory.createToggleAttackTargetAction(_loc17_,true).perform();
                  }
                  break;
               case ACTION_USE:
               case ACTION_OPEN:
                  if(_loc14_.object != null)
                  {
                     Tibia.s_GameActionFactory.createUseAction(_loc10_,_loc14_.object,_loc14_.position,UseActionImpl.TARGET_AUTO).perform();
                  }
                  break;
               case ACTION_TALK:
                  if(_loc17_ != null && _loc17_ != this.m_Player)
                  {
                     Tibia.s_GameActionFactory.createGreetAction(_loc17_).perform();
                  }
                  break;
               case ACTION_LOOK:
                  if(_loc13_.object != null)
                  {
                     if(_loc13_ == _loc12_)
                     {
                        _loc10_ = _loc17_.position;
                     }
                     new LookActionImpl(_loc10_,_loc13_.object,_loc13_.position).perform();
                  }
                  break;
               case ACTION_CONTEXT_MENU:
                  s_TempPoint.copyFrom(this.m_UIRendererImpl.localToGlobal(s_TempPoint));
                  new ObjectContextMenu(_loc10_,_loc13_,_loc14_,_loc17_).display(this,s_TempPoint.x,s_TempPoint.y);
                  break;
               case ACTION_UNSET:
            }
         }
         return _loc6_;
      }
      
      public function getMultiUseObjectUnderPoint(param1:Point) : Object
      {
         var _loc2_:Point = null;
         var _loc3_:Vector3D = null;
         var _loc4_:Object = null;
         if(this.m_UIRendererImpl != null && this.m_WorldMapStorage != null)
         {
            _loc2_ = this.m_UIRendererImpl.globalToLocal(param1);
            _loc3_ = this.m_UIRendererImpl.pointToMap(_loc2_.x,_loc2_.y,false);
            if(_loc3_ != null)
            {
               _loc4_ = {"absolute":this.m_WorldMapStorage.toAbsolute(_loc3_)};
               this.m_WorldMapStorage.getTopMultiUseObject(_loc3_.x,_loc3_.y,_loc3_.z,_loc4_);
               return _loc4_;
            }
         }
         return null;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = Math.max(0,param2 - 2);
         var _loc4_:Number = Math.max(0,param1 - 2);
         var _loc5_:Number = MAP_HEIGHT * FIELD_SIZE;
         var _loc6_:Number = MAP_WIDTH * FIELD_SIZE;
         if(this.m_Options != null && this.m_Options.rendererScaleMap || _loc3_ < _loc5_ || _loc4_ < _loc6_)
         {
            _loc10_ = Math.min(_loc3_ / _loc5_,_loc4_ / _loc6_);
            _loc5_ = Math.floor(_loc5_ * _loc10_);
            _loc6_ = Math.floor(_loc6_ * _loc10_);
         }
         var _loc7_:Number = Math.floor((param1 - _loc6_) / 2);
         var _loc8_:Number = Math.floor((param2 - _loc5_) / 2);
         this.m_UIBackdrop.x = _loc7_ - 1;
         this.m_UIBackdrop.y = _loc8_ - 1;
         var _loc9_:Graphics = this.m_UIBackdrop.graphics;
         _loc9_.clear();
         _loc9_.beginFill(0,1);
         _loc9_.drawRect(0,0,_loc6_ + 2,_loc5_ + 2);
         _loc9_.endFill();
         this.m_UIRendererImpl.move(_loc7_,_loc8_);
         this.m_UIRendererImpl.setActualSize(_loc6_,_loc5_);
         if(this.m_Options != null && this.m_Options.rendererShowFrameRate)
         {
            _loc6_ = this.m_UIInfoLatency.getExplicitOrMeasuredWidth();
            _loc5_ = this.m_UIInfoLatency.getExplicitOrMeasuredHeight();
            _loc11_ = Math.max(_loc5_,this.m_UIInfoFramerate.getExplicitOrMeasuredHeight());
            _loc7_ = 5;
            _loc8_ = param2 - _loc11_ - 5;
            this.m_UIInfoLatency.visible = true;
            this.m_UIInfoLatency.move(_loc7_,_loc8_ + (_loc11_ - _loc5_) / 2);
            this.m_UIInfoLatency.setActualSize(_loc6_,_loc5_);
            _loc7_ = _loc7_ + _loc6_;
            _loc6_ = this.m_UIInfoFramerate.getExplicitOrMeasuredWidth();
            _loc5_ = this.m_UIInfoFramerate.getExplicitOrMeasuredHeight();
            this.m_UIInfoFramerate.visible = true;
            this.m_UIInfoFramerate.move(_loc7_,_loc8_ + (_loc11_ - _loc5_) / 2);
            this.m_UIInfoFramerate.setActualSize(_loc6_,_loc5_);
         }
         else
         {
            this.m_UIInfoLatency.visible = false;
            this.m_UIInfoFramerate.visible = false;
         }
      }
      
      public function set creatureStorage(param1:CreatureStorage) : void
      {
         if(this.m_CreatureStorage != param1)
         {
            this.m_CreatureStorage = param1;
            this.m_UncommittedCreatureStorage = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      private function onResize(param1:ResizeEvent) : void
      {
         if(this.m_WorldMapStorage != null)
         {
            this.m_WorldMapStorage.invalidateOnscreenMessages();
         }
      }
   }
}
