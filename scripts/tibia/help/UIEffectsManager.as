package tibia.help
{
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.UIComponent;
   import mx.effects.Glow;
   import mx.effects.Sequence;
   import shared.utility.Vector3D;
   import tibia.appearances.EffectInstance;
   import tibia.chat.chatWidgetClasses.ChannelMessageRenderer;
   import tibia.worldmap.WorldMapStorage;
   import tibia.worldmap.WorldMapWidget;
   import tibia.worldmap.widgetClasses.RendererImpl;
   
   public class UIEffectsManager extends EventDispatcher
   {
      
      private static const KEYWORD_MARGIN:uint = 8;
      
      private static var m_CreatedTextHints:Vector.<TextHint> = new Vector.<TextHint>();
      
      private static var m_CreatedMouseButtonHints:Vector.<MouseButtonHint> = new Vector.<MouseButtonHint>();
      
      private static var m_CreatedEffects:Vector.<EffectInstance> = new Vector.<EffectInstance>();
      
      private static const MOUSE_BUTTON_HINT_FULL_ALPHA:Number = 1;
      
      private static var m_CreatedArrowHints:Vector.<ArrowHint> = new Vector.<ArrowHint>();
      
      private static var m_CreatedGlowElements:Vector.<UIComponent> = new Vector.<UIComponent>();
      
      private static var m_CreatedEventListeners:Vector.<EventListenersInfo> = null;
       
      
      private var m_SequenceGlow:Sequence = null;
      
      public function UIEffectsManager(param1:IEventDispatcher = null)
      {
         super(param1);
         this.initializeGlowSequence();
         m_CreatedEventListeners = new Vector.<EventListenersInfo>();
      }
      
      public function highlightUIElementByCoordinate(param1:Vector3D, param2:Boolean = true) : void
      {
         var _loc3_:Object = GUIRectangle.s_GetCoordinateInfo(param1);
         if("coordinate" in _loc3_)
         {
            this.showMapEffect(param1);
         }
         else if("identifier" in _loc3_)
         {
            this.higlightUIElementByIdentifier(_loc3_["identifier"] as Class,_loc3_["subIdentifier"],param2);
         }
      }
      
      public function showKeywordEffect(param1:String) : void
      {
         var _GUIRectangle:GUIRectangle = null;
         var _Rectangle:Rectangle = null;
         var NewRectangle:Rectangle = null;
         var GlowElement:UIComponent = null;
         var ArrowPosition:Point = null;
         var _ArrowHint:ArrowHint = null;
         var _UIComponent:UIComponent = null;
         var _EventListenerInfo:EventListenersInfo = null;
         var a_Keyword:String = param1;
         _GUIRectangle = GUIRectangle.s_FromKeyword(a_Keyword);
         if(_GUIRectangle.rectangle != null)
         {
            _Rectangle = _GUIRectangle.rectangle;
            NewRectangle = new Rectangle(_Rectangle.x - KEYWORD_MARGIN,_Rectangle.y - KEYWORD_MARGIN,_Rectangle.width + 2 * KEYWORD_MARGIN,_Rectangle.height + 2 * KEYWORD_MARGIN);
            GlowElement = this.createGlowingRectangle(NewRectangle,NewRectangle.height - KEYWORD_MARGIN);
            ArrowPosition = null;
            ArrowPosition = _GUIRectangle.rectangle.bottomRight.clone();
            ArrowPosition.y = ArrowPosition.y - _GUIRectangle.rectangle.height / 2;
            ArrowPosition.x = ArrowPosition.x + KEYWORD_MARGIN;
            _ArrowHint = this.showArrowEffect(ArrowPosition);
            _UIComponent = this.findUIElementByIdentifier(ChannelMessageRenderer,a_Keyword).parent as UIComponent;
            _EventListenerInfo = new EventListenersInfo();
            _EventListenerInfo.m_EventDispatcher = Tibia.s_GetSecondaryTimer();
            _EventListenerInfo.m_EventName = TimerEvent.TIMER;
            _EventListenerInfo.m_EventFunction = function():void
            {
               _GUIRectangle.refresh();
               if(_GUIRectangle.rectangle != null)
               {
                  ArrowPosition = _GUIRectangle.rectangle.bottomRight.clone();
                  ArrowPosition.y = ArrowPosition.y - _GUIRectangle.rectangle.height / 2;
                  ArrowPosition.x = ArrowPosition.x + KEYWORD_MARGIN;
                  _ArrowHint.updateArrowPosition(ArrowPosition);
                  GlowElement.x = _GUIRectangle.rectangle.x - KEYWORD_MARGIN;
                  GlowElement.y = _GUIRectangle.rectangle.y - KEYWORD_MARGIN;
               }
            };
            _EventListenerInfo.attach();
            m_CreatedEventListeners.push(_EventListenerInfo);
         }
      }
      
      public function addUIComponentGlowEffect(param1:UIComponent, param2:Boolean = true, param3:Boolean = false) : void
      {
         (this.m_SequenceGlow.children[0] as Glow).inner = param2;
         (this.m_SequenceGlow.children[1] as Glow).inner = param2;
         (this.m_SequenceGlow.children[0] as Glow).knockout = param3;
         (this.m_SequenceGlow.children[1] as Glow).knockout = param3;
         this.m_SequenceGlow.targets.push(param1);
         if(this.m_SequenceGlow.isPlaying)
         {
            this.m_SequenceGlow.end();
         }
         this.m_SequenceGlow.play();
      }
      
      public function removeUIComponentGlowEffect(param1:UIComponent) : void
      {
         var _loc2_:int = 0;
         if(this.m_SequenceGlow != null)
         {
            _loc2_ = this.m_SequenceGlow.targets.indexOf(param1);
            if(_loc2_ > -1)
            {
               this.m_SequenceGlow.targets.splice(_loc2_,1);
               if(this.m_SequenceGlow.isPlaying)
               {
                  this.m_SequenceGlow.end();
                  if(this.m_SequenceGlow.targets.length > 0)
                  {
                     this.m_SequenceGlow.play();
                  }
               }
            }
         }
      }
      
      public function findUIElementByIdentifier(param1:Class, param2:*) : UIComponent
      {
         var _loc3_:UIEffectsRetrieveComponentCommandEvent = new UIEffectsRetrieveComponentCommandEvent(UIEffectsRetrieveComponentCommandEvent.GET_UI_COMPONENT);
         _loc3_.identifier = param1;
         _loc3_.subIdentifier = param2;
         dispatchEvent(_loc3_);
         return _loc3_.resultUIComponent;
      }
      
      public function showMapEffect(param1:Vector3D) : void
      {
         var MapCoordinate:Vector3D = null;
         var a_AbsolutePosition:Vector3D = param1;
         var _WorldMapStorage:WorldMapStorage = Tibia.s_GetWorldMapStorage();
         var _EffectInstance:EffectInstance = null;
         try
         {
            _EffectInstance = Tibia.s_GetAppearanceStorage().createEffectInstance(56);
            _EffectInstance.setEndless();
            m_CreatedEffects.push(_EffectInstance);
            MapCoordinate = _WorldMapStorage.toMap(a_AbsolutePosition);
            _WorldMapStorage.appendEffect(a_AbsolutePosition.x,a_AbsolutePosition.y,a_AbsolutePosition.z,_EffectInstance);
            _EffectInstance = Tibia.s_GetAppearanceStorage().createEffectInstance(57);
            _EffectInstance.setEndless();
            m_CreatedEffects.push(_EffectInstance);
            _WorldMapStorage.appendEffect(a_AbsolutePosition.x,a_AbsolutePosition.y,a_AbsolutePosition.z,_EffectInstance);
            return;
         }
         catch(e:Error)
         {
            throw new Error("UIEffectsManager.showMapEffect: Failed to add map effect at " + a_AbsolutePosition.toString());
         }
      }
      
      public function showDragDropEffect(param1:Vector3D, param2:Vector3D) : void
      {
         var SourceGUIRectangle:GUIRectangle = null;
         var DestinationGUIRectangle:GUIRectangle = null;
         var _MouseButtonHint:MouseButtonHint = null;
         var _Sequence:Sequence = null;
         var _EventListenerInfo:EventListenersInfo = null;
         var a_SourcePosition:Vector3D = param1;
         var a_DestinationPosition:Vector3D = param2;
         var _Renderer:RendererImpl = this.findUIElementByIdentifier(WorldMapWidget,RendererImpl) as RendererImpl;
         SourceGUIRectangle = GUIRectangle.s_FromCoordinate(a_SourcePosition);
         DestinationGUIRectangle = GUIRectangle.s_FromCoordinate(a_DestinationPosition);
         if(SourceGUIRectangle.rectangle != null && DestinationGUIRectangle.rectangle != null)
         {
            this.highlightUIElementByCoordinate(a_SourcePosition);
            this.highlightUIElementByCoordinate(a_DestinationPosition);
            _MouseButtonHint = new MouseButtonHint();
            _MouseButtonHint.alpha = 1;
            _MouseButtonHint.visible = true;
            _MouseButtonHint.phase = 0;
            _Sequence = new Sequence();
            _MouseButtonHint.x = 200;
            _MouseButtonHint.y = 200;
            _MouseButtonHint.visible = true;
            _MouseButtonHint.addMousePhaseChange(MouseButtonHint.DEFAULT_NO_MOUSE_BUTTON);
            _MouseButtonHint.addMove(SourceGUIRectangle.centerPoint,SourceGUIRectangle.centerPoint,0);
            _MouseButtonHint.addFadeIn(MOUSE_BUTTON_HINT_FULL_ALPHA);
            _MouseButtonHint.addPause();
            _MouseButtonHint.addMousePhaseChange(MouseButtonHint.CROSSHAIR_LEFT_MOUSE_BUTTON);
            _MouseButtonHint.addHintTextChange("Drag",500);
            _MouseButtonHint.addPause();
            _MouseButtonHint.addMove(SourceGUIRectangle.centerPoint,DestinationGUIRectangle.centerPoint,1000);
            _MouseButtonHint.addPause(200);
            _MouseButtonHint.addHintTextChange("Drop",500,true);
            _MouseButtonHint.addPause();
            _MouseButtonHint.addMousePhaseChange(MouseButtonHint.DEFAULT_NO_MOUSE_BUTTON);
            _MouseButtonHint.addPause();
            _MouseButtonHint.addHintTextChange(null,200);
            _MouseButtonHint.addFadeOut(MOUSE_BUTTON_HINT_FULL_ALPHA);
            _MouseButtonHint.repeatCount = int.MAX_VALUE;
            _EventListenerInfo = new EventListenersInfo();
            _EventListenerInfo.m_EventDispatcher = Tibia.s_GetSecondaryTimer();
            _EventListenerInfo.m_EventName = TimerEvent.TIMER;
            _EventListenerInfo.m_EventFunction = function():void
            {
               SourceGUIRectangle.refresh();
               DestinationGUIRectangle.refresh();
               _MouseButtonHint.updateMoveEffect(SourceGUIRectangle.centerPoint,SourceGUIRectangle.centerPoint,0);
               _MouseButtonHint.updateMoveEffect(SourceGUIRectangle.centerPoint,DestinationGUIRectangle.centerPoint,1);
            };
            _EventListenerInfo.attach();
            _MouseButtonHint.show();
            _MouseButtonHint.play();
            m_CreatedMouseButtonHints.push(_MouseButtonHint);
            m_CreatedEventListeners.push(_EventListenerInfo);
         }
      }
      
      private function calculateTextHintBasePosition(param1:Rectangle, param2:Vector3D) : Point
      {
         var _loc3_:Point = param1.topLeft.clone();
         switch(param2.z)
         {
            case 1:
               _loc3_.offset(param1.width,0);
               break;
            case 2:
               _loc3_.offset(param1.width,param1.height);
               break;
            case 3:
               _loc3_.offset(0,param1.height);
         }
         _loc3_.offset(param2.x,param2.y);
         return _loc3_;
      }
      
      public function clearEffects() : void
      {
         var _loc1_:EventListenersInfo = null;
         var _loc2_:EffectInstance = null;
         var _loc3_:MouseButtonHint = null;
         var _loc4_:ArrowHint = null;
         var _loc5_:UIComponent = null;
         var _loc6_:TextHint = null;
         while(m_CreatedEventListeners.length > 0)
         {
            _loc1_ = m_CreatedEventListeners.pop();
            _loc1_.detach();
         }
         if(this.m_SequenceGlow != null)
         {
            this.m_SequenceGlow.end();
            this.m_SequenceGlow.targets.length = 0;
         }
         while(m_CreatedEffects.length > 0)
         {
            _loc2_ = m_CreatedEffects.pop();
            _loc2_.end();
         }
         while(m_CreatedMouseButtonHints.length > 0)
         {
            _loc3_ = m_CreatedMouseButtonHints.pop();
            _loc3_.end();
            _loc3_.hide();
         }
         while(m_CreatedArrowHints.length > 0)
         {
            _loc4_ = m_CreatedArrowHints.pop();
            _loc4_.hide();
         }
         while(m_CreatedGlowElements.length > 0)
         {
            _loc5_ = m_CreatedGlowElements.pop();
            TransparentHintLayer.getInstance().removeChild(_loc5_);
         }
         while(m_CreatedTextHints.length > 0)
         {
            _loc6_ = m_CreatedTextHints.pop();
            _loc6_.hide();
         }
      }
      
      public function createGlowingRectangle(param1:Rectangle, param2:uint = 0) : UIComponent
      {
         var _loc3_:UIComponent = new UIComponent();
         TransparentHintLayer.getInstance().addChild(_loc3_);
         _loc3_.x = param1.x;
         _loc3_.y = param1.y;
         _loc3_.width = param1.width;
         _loc3_.height = param1.height;
         _loc3_.graphics.lineStyle(3,16711680,0.6);
         if(param2 > 0)
         {
            _loc3_.graphics.drawRoundRect(0,0,_loc3_.width,_loc3_.height,param2,param2);
         }
         else
         {
            _loc3_.graphics.drawRect(0,0,_loc3_.width,_loc3_.height);
         }
         this.addUIComponentGlowEffect(_loc3_,false,false);
         TransparentHintLayer.getInstance().addChild(_loc3_);
         m_CreatedGlowElements.push(_loc3_);
         return _loc3_;
      }
      
      public function showTextHint(param1:String, param2:GUIRectangle, param3:Vector3D) : TextHint
      {
         var _TextHint:TextHint = null;
         var TextHintPosition:Point = null;
         var a_Text:String = param1;
         var a_GUIRectangle:GUIRectangle = param2;
         var a_Offset:Vector3D = param3;
         _TextHint = null;
         if(a_GUIRectangle.rectangle != null)
         {
            TextHintPosition = this.calculateTextHintBasePosition(a_GUIRectangle.rectangle,a_Offset);
            _TextHint = new TextHint(TextHintPosition);
            _TextHint.hintText = a_Text;
            _TextHint.show();
            m_CreatedTextHints.push(_TextHint);
         }
         var _EventListenerInfo:EventListenersInfo = new EventListenersInfo();
         _EventListenerInfo.m_EventDispatcher = Tibia.s_GetSecondaryTimer();
         _EventListenerInfo.m_EventName = TimerEvent.TIMER;
         _EventListenerInfo.m_EventFunction = function():void
         {
            var _loc1_:Point = null;
            a_GUIRectangle.refresh();
            if(a_GUIRectangle.rectangle != null)
            {
               _loc1_ = calculateTextHintBasePosition(a_GUIRectangle.rectangle,a_Offset);
               _TextHint.updateTextPosition(_loc1_);
            }
         };
         _EventListenerInfo.attach();
         m_CreatedEventListeners.push(_EventListenerInfo);
         return _TextHint;
      }
      
      public function showUseEffect(param1:Vector3D, param2:Vector3D) : void
      {
         var SourceGUIRectangle:GUIRectangle = null;
         var DestinationGUIRectangle:GUIRectangle = null;
         var _MouseButtonHint:MouseButtonHint = null;
         var ArrowPosition:Point = null;
         var _ArrowHint:ArrowHint = null;
         var a_Coordinate:Vector3D = param1;
         var a_MultiUseTarget:Vector3D = param2;
         var _Renderer:RendererImpl = this.findUIElementByIdentifier(WorldMapWidget,RendererImpl) as RendererImpl;
         SourceGUIRectangle = GUIRectangle.s_FromCoordinate(a_Coordinate);
         DestinationGUIRectangle = GUIRectangle.s_FromCoordinate(a_MultiUseTarget);
         this.highlightUIElementByCoordinate(a_Coordinate);
         var _EventListenerInfo:EventListenersInfo = null;
         if(SourceGUIRectangle.rectangle != null && DestinationGUIRectangle.rectangle != null)
         {
            this.highlightUIElementByCoordinate(a_MultiUseTarget);
            _MouseButtonHint = new MouseButtonHint();
            _MouseButtonHint.alpha = 1;
            _MouseButtonHint.visible = true;
            _MouseButtonHint.phase = 0;
            _MouseButtonHint.addMousePhaseChange(MouseButtonHint.DEFAULT_NO_MOUSE_BUTTON);
            _MouseButtonHint.addMove(SourceGUIRectangle.centerPoint,SourceGUIRectangle.centerPoint,0);
            _MouseButtonHint.addFadeIn(MOUSE_BUTTON_HINT_FULL_ALPHA);
            _MouseButtonHint.addHintTextChange("1st Click",500);
            _MouseButtonHint.addMousePhaseChange(MouseButtonHint.DEFAULT_LEFT_MOUSE_BUTTON);
            _MouseButtonHint.addPause();
            _MouseButtonHint.addMousePhaseChange(MouseButtonHint.CROSSHAIR_NO_MOUSE_BUTTON);
            _MouseButtonHint.addPause();
            _MouseButtonHint.addFadeOut(MOUSE_BUTTON_HINT_FULL_ALPHA);
            _MouseButtonHint.addHintTextChange(null);
            _MouseButtonHint.addMove(DestinationGUIRectangle.centerPoint,DestinationGUIRectangle.centerPoint,0);
            _MouseButtonHint.addFadeIn(MOUSE_BUTTON_HINT_FULL_ALPHA);
            _MouseButtonHint.addMousePhaseChange(MouseButtonHint.CROSSHAIR_NO_MOUSE_BUTTON);
            _MouseButtonHint.addHintTextChange("2nd Click",500);
            _MouseButtonHint.addMousePhaseChange(MouseButtonHint.CROSSHAIR_LEFT_MOUSE_BUTTON);
            _MouseButtonHint.addPause();
            _MouseButtonHint.addMousePhaseChange(MouseButtonHint.DEFAULT_NO_MOUSE_BUTTON);
            _MouseButtonHint.addPause();
            _MouseButtonHint.addFadeOut(MOUSE_BUTTON_HINT_FULL_ALPHA);
            _MouseButtonHint.addHintTextChange(null);
            _MouseButtonHint.repeatCount = int.MAX_VALUE;
            _EventListenerInfo = new EventListenersInfo();
            _EventListenerInfo.m_EventDispatcher = Tibia.s_GetSecondaryTimer();
            _EventListenerInfo.m_EventName = TimerEvent.TIMER;
            _EventListenerInfo.m_EventFunction = function():void
            {
               SourceGUIRectangle.refresh();
               DestinationGUIRectangle.refresh();
               _MouseButtonHint.updateMoveEffect(SourceGUIRectangle.centerPoint,SourceGUIRectangle.centerPoint,0);
               _MouseButtonHint.updateMoveEffect(DestinationGUIRectangle.centerPoint,DestinationGUIRectangle.centerPoint,1);
            };
            _EventListenerInfo.attach();
            _MouseButtonHint.show();
            _MouseButtonHint.play();
            m_CreatedMouseButtonHints.push(_MouseButtonHint);
            m_CreatedEventListeners.push(_EventListenerInfo);
         }
         else if(SourceGUIRectangle.rectangle != null && GUIRectangle.s_IsMapCoordinate(a_Coordinate) == false)
         {
            ArrowPosition = SourceGUIRectangle.rectangle.bottomRight.clone();
            ArrowPosition.y = ArrowPosition.y - SourceGUIRectangle.rectangle.height / 2;
            _ArrowHint = this.showArrowEffect(ArrowPosition);
            _EventListenerInfo = new EventListenersInfo();
            _EventListenerInfo.m_EventDispatcher = Tibia.s_GetSecondaryTimer();
            _EventListenerInfo.m_EventName = TimerEvent.TIMER;
            _EventListenerInfo.m_EventFunction = function():void
            {
               SourceGUIRectangle.refresh();
               var _loc1_:Point = SourceGUIRectangle.rectangle.bottomRight.clone();
               _loc1_.y = _loc1_.y - SourceGUIRectangle.rectangle.height / 2;
               _ArrowHint.updateArrowPosition(_loc1_);
            };
            _EventListenerInfo.attach();
            m_CreatedEventListeners.push(_EventListenerInfo);
         }
      }
      
      public function showArrowEffect(param1:Point) : ArrowHint
      {
         var _loc2_:ArrowHint = null;
         if(param1 != null)
         {
            _loc2_ = new ArrowHint(param1);
            _loc2_.show();
            m_CreatedArrowHints.push(_loc2_);
            return _loc2_;
         }
         return null;
      }
      
      private function initializeGlowSequence() : void
      {
         var _loc1_:Glow = new Glow();
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 0.7;
         _loc1_.color = 16711680;
         _loc1_.blurXFrom = 8;
         _loc1_.blurXTo = 16;
         _loc1_.blurYFrom = 8;
         _loc1_.blurYTo = 16;
         _loc1_.strength = 4;
         _loc1_.duration = 1000;
         _loc1_.inner = true;
         var _loc2_:Glow = new Glow();
         _loc2_.alphaFrom = 0.7;
         _loc2_.alphaTo = 0;
         _loc2_.color = 16711680;
         _loc2_.blurXFrom = 16;
         _loc2_.blurXTo = 8;
         _loc2_.blurYFrom = 16;
         _loc2_.blurYTo = 8;
         _loc2_.strength = 4;
         _loc2_.duration = 1000;
         _loc2_.inner = true;
         this.m_SequenceGlow = new Sequence();
         this.m_SequenceGlow.addChild(_loc1_);
         this.m_SequenceGlow.addChild(_loc2_);
         this.m_SequenceGlow.repeatCount = int.MAX_VALUE;
      }
      
      public function higlightUIElementByIdentifier(param1:Class, param2:*, param3:Boolean = true) : void
      {
         var _loc4_:UIComponent = null;
         if(param1 == null)
         {
            this.clearEffects();
         }
         else
         {
            _loc4_ = this.findUIElementByIdentifier(param1,param2);
            if(_loc4_ != null)
            {
               this.addUIComponentGlowEffect(_loc4_,param3);
            }
         }
      }
   }
}

import flash.events.EventDispatcher;

class EventListenersInfo
{
    
   
   public var m_EventFunction:Function = null;
   
   public var m_EventName:String = null;
   
   public var m_EventDispatcher:EventDispatcher = null;
   
   function EventListenersInfo()
   {
      super();
   }
   
   public function attach() : void
   {
      this.m_EventDispatcher.addEventListener(this.m_EventName,this.m_EventFunction);
   }
   
   public function detach() : void
   {
      this.m_EventDispatcher.removeEventListener(this.m_EventName,this.m_EventFunction);
   }
}
