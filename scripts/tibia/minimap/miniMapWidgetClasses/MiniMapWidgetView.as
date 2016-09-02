package tibia.minimap.miniMapWidgetClasses
{
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import flash.geom.Point;
   import mx.controls.Button;
   import flash.events.MouseEvent;
   import tibia.minimap.MiniMapWidget;
   import tibia.§sidebar:ns_sidebar_internal§.widgetInstance;
   import shared.controls.CustomButton;
   import tibia.minimap.MiniMapStorage;
   import tibia.game.ContextMenuBase;
   import tibia.game.PopUpBase;
   import tibia.input.ModifierKeyEvent;
   import tibia.cursors.CursorHelper;
   import mx.core.EdgeMetrics;
   import tibia.creatures.Player;
   import tibia.input.gameaction.AutowalkActionImpl;
   import tibia.options.OptionsStorage;
   import tibia.input.InputHandler;
   import shared.utility.Vector3D;
   import tibia.input.mapping.MouseBinding;
   import tibia.input.MouseClickBothEvent;
   import tibia.input.MouseActionHelper;
   import mx.core.UIComponent;
   import mx.managers.CursorManagerPriority;
   import mx.core.ScrollPolicy;
   
   public class MiniMapWidgetView extends WidgetView
   {
      
      private static const ACTION_UNSET:int = -1;
      
      private static const MOUSE_BUTTON_LEFT:int = 1;
      
      private static const MOUSE_BUTTON_BOTH:int = 4;
      
      private static const ACTION_USE_OR_OPEN:int = 101;
      
      private static const WIDGET_VIEW_HEIGHT:Number = 108;
      
      private static const ACTION_SMARTCLICK:int = 100;
      
      private static const MOUSE_BUTTON_RIGHT:int = 2;
      
      private static const ACTION_LOOK:int = 6;
      
      public static const BUNDLE:String = "MiniMapWidget";
      
      private static const ACTION_TALK:int = 9;
      
      private static const VALID_ACTIONS:Vector.<uint> = Vector.<uint>([ACTION_AUTOWALK,ACTION_CONTEXT_MENU]);
      
      private static const ACTION_USE:int = 7;
      
      private static const MOUSE_BUTTON_MIDDLE:int = 3;
      
      private static const ACTION_NONE:int = 0;
      
      private static const WIDGET_VIEW_WIDTH:Number = 176;
      
      private static const ACTION_AUTOWALK:int = 3;
      
      private static const WIDGET_COMPONENT_POSITIONS:Array = [{
         "left":1,
         "top":1,
         "width":NaN,
         "height":NaN
      },{
         "left":158,
         "top":23,
         "width":NaN,
         "height":NaN
      },{
         "left":133,
         "top":8,
         "width":NaN,
         "height":NaN
      },{
         "left":118,
         "top":23,
         "width":NaN,
         "height":NaN
      },{
         "left":133,
         "top":48,
         "width":NaN,
         "height":NaN
      },{
         "left":122,
         "top":71,
         "width":NaN,
         "height":NaN
      },{
         "left":122,
         "top":91,
         "width":NaN,
         "height":NaN
      },{
         "left":150,
         "top":72,
         "width":NaN,
         "height":NaN
      },{
         "left":151,
         "top":95,
         "width":NaN,
         "height":NaN
      },{
         "left":134,
         "top":24,
         "width":NaN,
         "height":NaN
      }];
      
      private static const ACTION_ATTACK:int = 1;
      
      private static const ACTION_OPEN:int = 8;
      
      private static const ACTION_AUTOWALK_HIGHLIGHT:int = 4;
      
      private static const ACTION_CONTEXT_MENU:int = 5;
      
      private static var m_TempPoint:Point = new Point();
      
      private static const ACTION_ATTACK_OR_TALK:int = 102;
       
      
      private var m_MouseCursorOverWidget:Boolean = false;
      
      private var m_UncommittedZoom:Boolean = false;
      
      protected var m_Zoom:int = 0;
      
      protected var m_UIButtonEast:Button = null;
      
      private var m_UncommittedMiniMapStorage:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      protected var m_UIButtonSouth:Button = null;
      
      private var m_UncommittedHighlightEnd:Boolean = false;
      
      protected var m_HighlightEnd:Number = 0;
      
      protected var m_UIButtonDown:Button = null;
      
      protected var m_UIButtonUp:Button = null;
      
      protected var m_UIButtonWest:Button = null;
      
      private var m_UncommittedPosition:Boolean = false;
      
      protected var m_PositionX:int = -1;
      
      protected var m_PositionY:int = -1;
      
      protected var m_PositionZ:int = -1;
      
      protected var m_UIButtonZoomOut:Button = null;
      
      private var m_CursorHelper:CursorHelper;
      
      protected var m_MiniMapStorage:MiniMapStorage = null;
      
      protected var m_UIView:tibia.minimap.miniMapWidgetClasses.MiniMapRenderer = null;
      
      protected var m_UIButtonCenter:Button = null;
      
      protected var m_UIButtonNorth:Button = null;
      
      protected var m_UIButtonZoomIn:Button = null;
      
      public function MiniMapWidgetView()
      {
         this.m_CursorHelper = new CursorHelper(CursorManagerPriority.MEDIUM);
         super();
         titleText = resourceManager.getString(BUNDLE,"TITLE");
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         Tibia.s_GetInputHandler().addEventListener(ModifierKeyEvent.MODIFIER_KEYS_CHANGED,this.onModifierKeyEvent);
      }
      
      function get highlightEnd() : Number
      {
         return this.m_HighlightEnd;
      }
      
      protected function onButtonClick(param1:MouseEvent) : void
      {
         var _loc2_:MiniMapWidget = null;
         var _loc3_:int = 0;
         if(param1 != null && widgetInstance is MiniMapWidget)
         {
            _loc2_ = MiniMapWidget(widgetInstance);
            _loc3_ = 1;
            if(param1.shiftKey)
            {
               _loc3_ = 10;
            }
            switch(param1.currentTarget)
            {
               case this.m_UIButtonEast:
                  _loc2_.translatePosition(_loc3_,0,0);
                  break;
               case this.m_UIButtonNorth:
                  _loc2_.translatePosition(0,-_loc3_,0);
                  break;
               case this.m_UIButtonWest:
                  _loc2_.translatePosition(-_loc3_,0,0);
                  break;
               case this.m_UIButtonSouth:
                  _loc2_.translatePosition(0,_loc3_,0);
                  break;
               case this.m_UIButtonUp:
                  _loc2_.translatePosition(0,0,-1);
                  break;
               case this.m_UIButtonDown:
                  _loc2_.translatePosition(0,0,1);
                  break;
               case this.m_UIButtonZoomIn:
                  _loc2_.zoom = _loc2_.zoom + 1;
                  break;
               case this.m_UIButtonZoomOut:
                  _loc2_.zoom = _loc2_.zoom - 1;
                  break;
               case this.m_UIButtonCenter:
                  _loc2_.centerPosition();
            }
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UIView = new tibia.minimap.miniMapWidgetClasses.MiniMapRenderer();
            this.m_UIView.addEventListener(MouseEvent.CLICK,this.onViewClick);
            this.m_UIView.addEventListener(MouseEvent.RIGHT_CLICK,this.onViewClick);
            this.m_UIView.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
            this.m_UIView.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
            this.m_UIView.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
            addChild(this.m_UIView);
            this.m_UIButtonEast = new CustomButton();
            this.m_UIButtonEast.styleName = getStyle("buttonEastStyle");
            this.m_UIButtonEast.toolTip = resourceManager.getString(BUNDLE,"BTN_TOOLTIP_EAST");
            this.m_UIButtonEast.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonEast);
            this.m_UIButtonNorth = new CustomButton();
            this.m_UIButtonNorth.styleName = getStyle("buttonNorthStyle");
            this.m_UIButtonNorth.toolTip = resourceManager.getString(BUNDLE,"BTN_TOOLTIP_NORTH");
            this.m_UIButtonNorth.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonNorth);
            this.m_UIButtonWest = new CustomButton();
            this.m_UIButtonWest.styleName = getStyle("buttonWestStyle");
            this.m_UIButtonWest.toolTip = resourceManager.getString(BUNDLE,"BTN_TOOLTIP_WEST");
            this.m_UIButtonWest.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonWest);
            this.m_UIButtonSouth = new CustomButton();
            this.m_UIButtonSouth.styleName = getStyle("buttonSouthStyle");
            this.m_UIButtonSouth.toolTip = resourceManager.getString(BUNDLE,"BTN_TOOLTIP_SOUTH");
            this.m_UIButtonSouth.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonSouth);
            this.m_UIButtonUp = new CustomButton();
            this.m_UIButtonUp.styleName = getStyle("buttonUpStyle");
            this.m_UIButtonUp.toolTip = resourceManager.getString(BUNDLE,"BTN_TOOLTIP_UP");
            this.m_UIButtonUp.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonUp);
            this.m_UIButtonDown = new CustomButton();
            this.m_UIButtonDown.styleName = getStyle("buttonDownStyle");
            this.m_UIButtonDown.toolTip = resourceManager.getString(BUNDLE,"BTN_TOOLTIP_DOWN");
            this.m_UIButtonDown.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonDown);
            this.m_UIButtonZoomIn = new CustomButton();
            this.m_UIButtonZoomIn.styleName = getStyle("buttonZoomInStyle");
            this.m_UIButtonZoomIn.toolTip = resourceManager.getString(BUNDLE,"BTN_TOOLTIP_ZOOMIN");
            this.m_UIButtonZoomIn.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonZoomIn);
            this.m_UIButtonZoomOut = new CustomButton();
            this.m_UIButtonZoomOut.styleName = getStyle("buttonZoomOutStyle");
            this.m_UIButtonZoomOut.toolTip = resourceManager.getString(BUNDLE,"BTN_TOOLTIP_ZOOMOUT");
            this.m_UIButtonZoomOut.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonZoomOut);
            this.m_UIButtonCenter = new CustomButton();
            this.m_UIButtonCenter.styleName = getStyle("buttonCenterStyle");
            this.m_UIButtonCenter.toolTip = resourceManager.getString(BUNDLE,"BTN_TOOLTIP_CENTER");
            this.m_UIButtonCenter.addEventListener(MouseEvent.CLICK,this.onButtonClick);
            addChild(this.m_UIButtonCenter);
            this.m_UIConstructed = true;
         }
      }
      
      function set highlightEnd(param1:Number) : void
      {
         if(this.m_HighlightEnd != param1)
         {
            this.m_HighlightEnd = param1;
            this.m_UncommittedHighlightEnd = true;
            invalidateProperties();
         }
      }
      
      function set zoom(param1:int) : void
      {
         if(this.m_Zoom != param1)
         {
            this.m_Zoom = param1;
            this.m_UncommittedZoom = true;
            invalidateProperties();
         }
      }
      
      function setPosition(param1:int, param2:int, param3:int) : void
      {
         if(this.m_PositionX != param1 || this.m_PositionY != param2 || this.m_PositionZ != param3)
         {
            this.m_PositionX = param1;
            this.m_PositionY = param2;
            this.m_PositionZ = param3;
            this.m_UncommittedPosition = true;
            invalidateProperties();
         }
      }
      
      protected function onRollOut(param1:MouseEvent) : void
      {
         this.m_MouseCursorOverWidget = false;
         this.m_CursorHelper.resetCursor();
      }
      
      function get miniMapStorage() : MiniMapStorage
      {
         return this.m_MiniMapStorage;
      }
      
      protected function onViewMouseEvent(param1:MouseEvent) : void
      {
         if(param1 != null && widgetInstance is MiniMapWidget && m_Options != null && m_Options.mouseMapping != null && m_Options.mouseMapping.showMouseCursorForAction && ContextMenuBase.getCurrent() == null && PopUpBase.getCurrent() == null)
         {
            this.determineAction(param1,false,true);
         }
         else
         {
            this.m_CursorHelper.resetCursor();
         }
      }
      
      override function releaseInstance() : void
      {
         super.releaseInstance();
         this.m_UIButtonCenter.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonDown.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonEast.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonNorth.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonSouth.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonUp.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonWest.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonZoomIn.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIButtonZoomOut.removeEventListener(MouseEvent.CLICK,this.onButtonClick);
         this.m_UIView.removeEventListener(MouseEvent.CLICK,this.onViewClick);
         this.m_UIView.removeEventListener(MouseEvent.RIGHT_CLICK,this.onViewClick);
         this.m_UIView.removeEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel);
         Tibia.s_GetInputHandler().removeEventListener(ModifierKeyEvent.MODIFIER_KEYS_CHANGED,this.onModifierKeyEvent);
      }
      
      protected function onViewClick(param1:MouseEvent) : void
      {
         this.determineAction(param1,true,false);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.m_UncommittedMiniMapStorage)
         {
            this.m_UIView.miniMapStorage = this.miniMapStorage;
            this.m_UncommittedMiniMapStorage = false;
         }
         if(this.m_UncommittedPosition)
         {
            this.m_UIView.setPosition(this.positionX,this.positionY,this.positionZ);
            this.m_UncommittedPosition = false;
         }
         if(this.m_UncommittedZoom)
         {
            this.m_UIView.zoom = this.zoom;
            this.m_UncommittedZoom = false;
         }
         if(this.m_UncommittedHighlightEnd)
         {
            this.m_UIView.highlightEnd = this.highlightEnd;
            this.m_UncommittedHighlightEnd = false;
         }
      }
      
      function get positionX() : int
      {
         return this.m_PositionX;
      }
      
      function get positionZ() : int
      {
         return this.m_PositionZ;
      }
      
      function get zoom() : int
      {
         return this.m_Zoom;
      }
      
      function get positionY() : int
      {
         return this.m_PositionY;
      }
      
      function set miniMapStorage(param1:MiniMapStorage) : void
      {
         if(this.m_MiniMapStorage != param1)
         {
            this.m_MiniMapStorage = param1;
            this.m_UncommittedMiniMapStorage = true;
            invalidateProperties();
         }
      }
      
      private function onModifierKeyEvent(param1:ModifierKeyEvent) : void
      {
         this.determineAction(null,false,true);
      }
      
      protected function onMouseWheel(param1:MouseEvent) : void
      {
         var _loc2_:MiniMapWidget = null;
         if(param1 != null && widgetInstance is MiniMapWidget)
         {
            _loc2_ = MiniMapWidget(widgetInstance);
            if(param1.delta > 0)
            {
               _loc2_.zoom = _loc2_.zoom + 1;
            }
            else if(param1.delta < 0)
            {
               _loc2_.zoom = _loc2_.zoom - 1;
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var _loc1_:EdgeMetrics = viewMetricsAndPadding;
         measuredMinWidth = measuredWidth = _loc1_.left + WIDGET_VIEW_WIDTH + _loc1_.right;
         measuredMinHeight = measuredHeight = _loc1_.top + WIDGET_VIEW_HEIGHT + _loc1_.bottom;
      }
      
      protected function determineAction(param1:MouseEvent, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc10_:Player = null;
         var _loc11_:MiniMapStorage = null;
         var _loc12_:AutowalkActionImpl = null;
         if(this.m_MouseCursorOverWidget == false)
         {
            return;
         }
         var _loc4_:OptionsStorage = Tibia.s_GetOptions();
         var _loc5_:InputHandler = Tibia.s_GetInputHandler();
         var _loc6_:Vector3D = null;
         var _loc7_:int = ACTION_NONE;
         if(!(widgetInstance is MiniMapWidget))
         {
            return;
         }
         if(param1 != null)
         {
            m_TempPoint.setTo(param1.localX,param1.localY);
         }
         else
         {
            m_TempPoint.setTo(this.mouseX,this.mouseY);
         }
         var _loc8_:Object = this.m_UIView.pointToMark(m_TempPoint.x,m_TempPoint.y);
         if(_loc8_ != null)
         {
            _loc6_ = new Vector3D(_loc8_.x,_loc8_.y,_loc8_.z);
         }
         else
         {
            _loc6_ = this.m_UIView.pointToAbsolute(m_TempPoint.x,m_TempPoint.y);
         }
         var _loc9_:MouseBinding = null;
         if(param1 != null)
         {
            if(param1 is MouseClickBothEvent)
            {
               _loc9_ = _loc4_.mouseMapping.findBindingByMouseEvent(param1);
            }
            else if(_loc5_.isModifierKeyPressed(param1) == false && (param1.type == MouseEvent.CLICK || param1.type == MouseEvent.ROLL_OVER))
            {
               _loc7_ = ACTION_AUTOWALK;
            }
            else if(param1.type == MouseEvent.RIGHT_CLICK && _loc5_.isModifierKeyPressed(param1) == false)
            {
               _loc7_ = ACTION_CONTEXT_MENU;
            }
            else
            {
               _loc9_ = _loc4_.mouseMapping.findBindingByMouseEvent(param1);
            }
         }
         else if(_loc5_.isModifierKeyPressed())
         {
            _loc9_ = _loc4_.mouseMapping.findBindingForLeftMouseButtonAndPressedModifierKey();
         }
         else
         {
            _loc7_ = ACTION_AUTOWALK;
         }
         if(_loc9_ != null)
         {
            _loc7_ = _loc9_.action;
         }
         if(VALID_ACTIONS.indexOf(_loc7_) == -1)
         {
            _loc7_ = ACTION_NONE;
         }
         if(param3 && m_Options != null && m_Options.mouseMapping != null && m_Options.mouseMapping.showMouseCursorForAction)
         {
            this.m_CursorHelper.setCursor(MouseActionHelper.actionToMouseCursor(_loc7_));
         }
         if(param2 && _loc6_ != null)
         {
            switch(_loc7_)
            {
               case ACTION_AUTOWALK:
                  _loc10_ = Tibia.s_GetPlayer();
                  if(_loc10_ != null)
                  {
                     _loc12_ = Tibia.s_GameActionFactory.createAutowalkAction(_loc6_.x,_loc6_.y,_loc6_.z,false,false);
                     _loc12_.perform();
                  }
                  break;
               case ACTION_CONTEXT_MENU:
                  _loc11_ = MiniMapWidget(widgetInstance).miniMapStorage;
                  if(_loc11_ != null)
                  {
                     this.m_CursorHelper.resetCursor();
                     new MiniMapWidgetContextMenu(_loc11_,_loc6_.x,_loc6_.y,_loc6_.z).display(this,param1.stageX,param1.stageY);
                  }
                  break;
               case ACTION_NONE:
            }
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc4_:UIComponent = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         super.updateDisplayList(param1,param2);
         var _loc3_:int = 0;
         while(_loc3_ < WIDGET_COMPONENT_POSITIONS.length)
         {
            _loc4_ = UIComponent(getChildAt(_loc3_));
            _loc4_.move(WIDGET_COMPONENT_POSITIONS[_loc3_].left,WIDGET_COMPONENT_POSITIONS[_loc3_].top);
            _loc5_ = WIDGET_COMPONENT_POSITIONS[_loc3_].width;
            _loc6_ = WIDGET_COMPONENT_POSITIONS[_loc3_].height;
            if(isNaN(_loc5_))
            {
               _loc5_ = _loc4_.getExplicitOrMeasuredHeight();
            }
            if(isNaN(_loc6_))
            {
               _loc6_ = _loc4_.getExplicitOrMeasuredWidth();
            }
            _loc4_.setActualSize(_loc6_,_loc5_);
            _loc3_++;
         }
      }
      
      protected function onRollOver(param1:MouseEvent) : void
      {
         this.m_MouseCursorOverWidget = true;
         if(param1 != null && widgetInstance is MiniMapWidget && m_Options != null && m_Options.mouseMapping != null && m_Options.mouseMapping.showMouseCursorForAction)
         {
            this.determineAction(param1,false,true);
         }
      }
   }
}
