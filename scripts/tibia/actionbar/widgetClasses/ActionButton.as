package tibia.actionbar.widgetClasses
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.events.TimerEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFormat;
   import flash.utils.Timer;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import shared.utility.TextFieldCache;
   import tibia.actionbar.ActionBar;
   import tibia.actionbar.ActionBarSet;
   import tibia.appearances.AppearanceStorage;
   import tibia.appearances.AppearanceType;
   import tibia.appearances.FrameGroup;
   import tibia.appearances.ObjectInstance;
   import tibia.appearances.widgetClasses.CachedSpriteInformation;
   import tibia.container.BodyContainerView;
   import tibia.container.ContainerStorage;
   import tibia.creatures.Player;
   import tibia.game.Delay;
   import tibia.input.IAction;
   import tibia.input.gameaction.EquipAction;
   import tibia.input.gameaction.SpellAction;
   import tibia.input.gameaction.TalkAction;
   import tibia.input.gameaction.UseAction;
   import tibia.magic.Rune;
   import tibia.magic.Spell;
   import tibia.magic.SpellStorage;
   
   public class ActionButton extends UIComponent implements IActionButton
   {
      
      private static const BUNDLE:String = "ActionBarWidget";
      
      private static var s_ZeroPoint:Point = new Point(0,0);
      
      private static const OVERLAY_TOP:int = 1;
      
      private static const ICON_SIZE:int = 32;
      
      protected static var s_LabelTextCache:TextFieldCache = null;
      
      protected static var s_Rect:Rectangle = new Rectangle();
      
      protected static var s_OverlayTextCache:TextFieldCache = null;
      
      private static const OVERLAY_BOTTOM:int = 0;
      
      protected static var s_Trans:Matrix = new Matrix();
      
      protected static var s_TalkTextCache:TalkActionIconCache = null;
      
      {
         initializeStatic();
         initialiseStyle();
      }
      
      private var m_ActionBar:ActionBar = null;
      
      private var m_UIActionIcon:FlexShape = null;
      
      private var m_ActionIconCacheMiss:Boolean = false;
      
      private var m_ActionSpell:Spell = null;
      
      private var m_LocalAppearanceBitmapCache:BitmapData = null;
      
      private var m_UncommittedAction:Boolean = false;
      
      private var m_OverlayText:String = null;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_UISkinHighlight:IFlexDisplayObject = null;
      
      private var m_OverlayPosition:int = 1;
      
      private var m_UICooldownMask:FlexShape = null;
      
      private var m_ActionRune:Rune = null;
      
      private var m_ActionObject:ObjectInstance = null;
      
      private var m_Highlight:Boolean = false;
      
      private var m_UIOverlay:FlexShape = null;
      
      private var m_UncommittedCooldownDelay:Boolean = true;
      
      private var m_UISkinBackground:IFlexDisplayObject = null;
      
      private var m_UncommittedOverlayText:Boolean = true;
      
      private var m_Available:Boolean = true;
      
      private var m_UncommittedPosition:Boolean = true;
      
      private var m_Position:int = 0;
      
      private var m_UISkinCooldown:IFlexDisplayObject = null;
      
      private var m_CooldownPhase:int = -1;
      
      private var m_UISkinDisabled:IFlexDisplayObject = null;
      
      private var m_CooldownDelay:Delay = null;
      
      private var m_Action:IAction = null;
      
      private var m_UncommittedActionBar:Boolean = false;
      
      private var m_UILabel:FlexShape = null;
      
      public function ActionButton()
      {
         super();
      }
      
      private static function initialiseStyle() : void
      {
         var Selector:String = "ActionButton";
         var Decl:CSSStyleDeclaration = StyleManager.getStyleDeclaration(Selector);
         if(Decl == null)
         {
            Decl = new CSSStyleDeclaration(Selector);
         }
         Decl.defaultFactory = function():void
         {
            this.backgroundImage = undefined;
            this.backgroundColor = 0;
            this.backgroundAlpha = 1;
            this.backgroundLabelColor = 16777215;
            this.overlayCooldownImage = undefined;
            this.overlayDisabledImage = undefined;
            this.overlayHighlightImage = undefined;
            this.paddingBottom = 2;
            this.paddingLeft = 2;
            this.paddingRight = 2;
            this.paddingTop = 2;
         };
         StyleManager.setStyleDeclaration(Selector,Decl,true);
      }
      
      private static function initializeStatic() : void
      {
         var _loc1_:int = ActionBarSet.NUM_LOCATIONS * ActionBar.NUM_ACTIONS;
         var _loc2_:TextFormat = new TextFormat("Verdana",10,16777215);
         _loc2_.kerning = true;
         _loc2_.letterSpacing = -1;
         s_OverlayTextCache = new TextFieldCache(ICON_SIZE,TextFieldCache.DEFAULT_HEIGHT,4 * _loc1_,false);
         s_OverlayTextCache.textFormat = _loc2_;
         s_LabelTextCache = new TextFieldCache(ICON_SIZE,TextFieldCache.DEFAULT_HEIGHT,_loc1_,false);
         s_LabelTextCache.textFormat = new TextFormat("Verdana",8,16777215);
         s_LabelTextCache.textFilters = null;
         s_TalkTextCache = new TalkActionIconCache(ICON_SIZE,ICON_SIZE,_loc1_,false);
         s_TalkTextCache.textFormat = new TextFormat("Verdana",8,16777215);
         s_TalkTextCache.textFilters = null;
      }
      
      private function set actionBar(param1:ActionBar) : void
      {
         if(this.m_ActionBar != param1)
         {
            this.m_ActionBar = param1;
            this.m_UncommittedActionBar = true;
            invalidateProperties();
         }
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Timer = null;
         var _loc2_:AppearanceStorage = null;
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         super.commitProperties();
         if(this.m_UncommittedAction)
         {
            this.m_ActionObject = null;
            this.m_ActionRune = null;
            this.m_ActionSpell = null;
            _loc1_ = Tibia.s_GetSecondaryTimer();
            _loc1_.removeEventListener(TimerEvent.TIMER,this.onTimer);
            _loc2_ = Tibia.s_GetAppearanceStorage();
            if(this.action is UseAction)
            {
               this.m_ActionObject = new ObjectInstance(UseAction(this.action).type.ID,UseAction(this.action).type,UseAction(this.action).data);
               this.m_ActionRune = SpellStorage.getRune(UseAction(this.action).type.ID);
            }
            else if(this.action is EquipAction)
            {
               this.m_ActionObject = new ObjectInstance(EquipAction(this.action).type.ID,EquipAction(this.action).type,EquipAction(this.action).data);
            }
            else if(this.action is SpellAction)
            {
               this.m_ActionSpell = SpellAction(this.action).spell;
            }
            if(this.m_ActionIconCacheMiss || this.m_ActionObject != null || this.m_ActionRune != null || this.m_ActionSpell != null)
            {
               _loc1_.addEventListener(TimerEvent.TIMER,this.onTimer,false,EventPriority.DEFAULT,true);
            }
            this.drawActionIcon();
            this.updateActionProperties();
            this.m_UncommittedAction = false;
         }
         if(this.m_UncommittedActionBar || this.m_UncommittedPosition)
         {
            this.drawLabel();
            this.m_UncommittedActionBar = false;
            this.m_UncommittedPosition = false;
         }
         if(this.m_UncommittedCooldownDelay)
         {
            if(this.cooldownDelay != null && this.cooldownDelay.contains(Tibia.s_FrameTibiaTimestamp))
            {
               _loc3_ = this.cooldownDelay.end - Tibia.s_FrameTibiaTimestamp;
               if(this.cooldownDelay.duration > 3000 && _loc3_ > 1000)
               {
                  _loc4_ = int(_loc3_ / 1000);
                  if(_loc4_ > 60)
                  {
                     this.overlayText = String(int(_loc4_ / 60)) + ":" + String("0" + _loc4_ % 60).substr(-2);
                  }
                  else
                  {
                     this.overlayText = String(_loc4_);
                  }
                  this.m_OverlayPosition = OVERLAY_TOP;
               }
               this.m_CooldownPhase = int((1 - _loc3_ / this.cooldownDelay.duration) * 60);
            }
            else
            {
               this.m_CooldownPhase = -1;
            }
            this.m_UncommittedCooldownDelay = false;
         }
         if(this.m_UncommittedOverlayText)
         {
            this.drawOverlayText();
            this.m_UncommittedOverlayText = false;
         }
      }
      
      private function updateSkin(param1:String) : IFlexDisplayObject
      {
         var _loc2_:DisplayObject = getChildByName(param1);
         var _loc3_:int = -1;
         if(_loc2_ != null)
         {
            _loc3_ = getChildIndex(_loc2_);
            removeChild(_loc2_);
            _loc2_ = null;
         }
         var _loc4_:Class = getStyle(param1) as Class;
         if(_loc4_ != null)
         {
            _loc2_ = DisplayObject(new _loc4_());
            _loc2_.name = param1;
            _loc2_.cacheAsBitmap = true;
         }
         if(_loc2_ != null)
         {
            if(_loc3_ != -1)
            {
               addChildAt(_loc2_,_loc3_);
            }
            else
            {
               addChild(_loc2_);
            }
         }
         return IFlexDisplayObject(_loc2_);
      }
      
      private function drawLabel() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:* = 0;
         var _loc4_:String = null;
         var _loc5_:Rectangle = null;
         var _loc1_:Graphics = this.m_UILabel.graphics;
         _loc1_.clear();
         s_Trans.a = 1;
         s_Trans.d = 1;
         if(this.actionBar != null)
         {
            _loc2_ = !!getStyle("backgroundLabelColor")?uint(getStyle("backgroundLabelColor")):uint(65280);
            _loc3_ = this.actionBar.location << 24 | this.position;
            _loc4_ = this.actionBar.getLabel(this.position);
            _loc5_ = s_LabelTextCache.getItem(_loc3_,_loc4_,_loc2_);
            s_Trans.tx = -_loc5_.x;
            s_Trans.ty = -_loc5_.y;
            _loc1_.beginBitmapFill(s_LabelTextCache,s_Trans,false);
            _loc1_.drawRect(0,0,_loc5_.width,_loc5_.height);
            _loc1_.endFill();
         }
      }
      
      private function set available(param1:Boolean) : void
      {
         if(this.m_Available != param1)
         {
            this.m_Available = param1;
            invalidateDisplayList();
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            this.m_UISkinBackground = this.updateSkin("backgroundImage");
            this.m_UISkinCooldown = this.updateSkin("overlayCooldownImage");
            this.m_UISkinDisabled = this.updateSkin("overlayDisabledImage");
            this.m_UISkinHighlight = this.updateSkin("overlayHighlightImage");
            this.m_UILabel = new FlexShape();
            this.m_UILabel.cacheAsBitmap = true;
            this.m_UILabel.name = "label";
            addChild(this.m_UILabel);
            this.m_UIActionIcon = new FlexShape();
            this.m_UIActionIcon.cacheAsBitmap = true;
            this.m_UIActionIcon.name = "action";
            addChild(this.m_UIActionIcon);
            this.m_UICooldownMask = new FlexShape();
            this.m_UICooldownMask.cacheAsBitmap = false;
            this.m_UICooldownMask.name = "cooldownMask";
            addChild(this.m_UICooldownMask);
            this.drawCooldownMask();
            this.m_UIOverlay = new FlexShape();
            this.m_UIOverlay.cacheAsBitmap = true;
            this.m_UIOverlay.name = "overlay";
            addChild(this.m_UIOverlay);
            this.m_UIConstructed = true;
         }
      }
      
      private function get overlayText() : String
      {
         return this.m_OverlayText;
      }
      
      public function get position() : int
      {
         return this.m_Position;
      }
      
      private function onTimer(param1:TimerEvent) : void
      {
         this.updateActionProperties();
      }
      
      private function drawActionIcon() : void
      {
         var _loc4_:CachedSpriteInformation = null;
         var _loc5_:uint = 0;
         var _loc6_:String = null;
         var _loc7_:Rectangle = null;
         var _loc1_:Graphics = this.m_UIActionIcon.graphics;
         _loc1_.clear();
         s_Trans.a = 1;
         s_Trans.d = 1;
         var _loc2_:BitmapData = null;
         var _loc3_:AppearanceType = null;
         if(this.m_ActionObject != null && (_loc3_ = this.m_ActionObject.type) != null)
         {
            _loc4_ = this.m_ActionObject.getSprite(-1,-1,-1,-1);
            this.m_ActionIconCacheMiss = _loc4_.cacheMiss;
            if(this.m_LocalAppearanceBitmapCache == null || this.m_LocalAppearanceBitmapCache.width < _loc4_.rectangle.width || this.m_LocalAppearanceBitmapCache.height < _loc4_.rectangle.height)
            {
               this.m_LocalAppearanceBitmapCache = new BitmapData(_loc4_.rectangle.width,_loc4_.rectangle.height);
            }
            this.m_LocalAppearanceBitmapCache.copyPixels(_loc4_.bitmapData,_loc4_.rectangle,s_ZeroPoint);
            s_Rect.setTo(0,0,_loc4_.rectangle.width,_loc4_.rectangle.height);
            s_Trans.a = s_Trans.d = ICON_SIZE / _loc3_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].exactSize;
            _loc2_ = this.m_LocalAppearanceBitmapCache;
         }
         else if(this.m_ActionSpell != null)
         {
            _loc2_ = this.m_ActionSpell.getIcon(s_Rect);
         }
         else if(this.action is TalkAction)
         {
            _loc5_ = !!getStyle("overlayLabelColor")?uint(getStyle("overlayLabelColor")):uint(65280);
            _loc6_ = TalkAction(this.action).text;
            _loc7_ = s_TalkTextCache.getItem(_loc6_,_loc6_,_loc5_);
            _loc2_ = s_TalkTextCache;
            s_Rect.x = _loc7_.x;
            s_Rect.y = _loc7_.y;
            s_Rect.width = _loc7_.width;
            s_Rect.height = _loc7_.height;
         }
         if(_loc2_ != null)
         {
            s_Trans.tx = -s_Rect.x * s_Trans.a;
            s_Trans.ty = -s_Rect.y * s_Trans.d;
            s_Rect.width = s_Rect.width * s_Trans.a;
            s_Rect.height = s_Rect.height * s_Trans.d;
            _loc1_.beginBitmapFill(_loc2_,s_Trans,false,false);
            _loc1_.drawRect(0,0,s_Rect.width,s_Rect.height);
            _loc1_.endFill();
         }
      }
      
      private function onActionBarChange(param1:PropertyChangeEvent) : void
      {
         if(param1.property == "actionBar")
         {
            this.actionBar = ActionBarWidget(owner).actionBar;
            this.drawLabel();
         }
      }
      
      private function set cooldownDelay(param1:Delay) : void
      {
         if(param1 != null && param1.duration == 0)
         {
            param1 = null;
         }
         if(this.m_CooldownDelay != param1)
         {
            this.m_CooldownDelay = param1;
            this.m_UncommittedCooldownDelay = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      private function drawOverlayText() : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Rectangle = null;
         var _loc1_:Graphics = this.m_UIOverlay.graphics;
         _loc1_.clear();
         if(this.overlayText != null)
         {
            _loc2_ = !!getStyle("overlayLabelColor")?uint(getStyle("overlayLabelColor")):uint(65280);
            _loc3_ = s_OverlayTextCache.getItem(this.overlayText,this.overlayText,_loc2_);
            s_Trans.tx = -_loc3_.x;
            s_Trans.ty = -_loc3_.y;
            _loc1_.beginBitmapFill(s_OverlayTextCache,s_Trans,false);
            _loc1_.drawRect(0,0,_loc3_.width,_loc3_.height);
            _loc1_.endFill();
         }
      }
      
      private function get highlight() : Boolean
      {
         return this.m_Highlight;
      }
      
      private function set overlayText(param1:String) : void
      {
         if(this.m_OverlayText != param1)
         {
            this.m_OverlayText = param1;
            this.m_OverlayPosition = OVERLAY_BOTTOM;
            this.m_UncommittedOverlayText = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      override public function styleChanged(param1:String) : void
      {
         switch(param1)
         {
            case "backgroundImage":
               this.m_UISkinBackground = this.updateSkin(param1);
               invalidateDisplayList();
               invalidateSize();
               break;
            case "overlayCooldownImage":
               this.m_UISkinCooldown = this.updateSkin(param1);
               this.drawCooldownMask();
               invalidateDisplayList();
               break;
            case "overlayDisabledImage":
               this.m_UISkinDisabled = this.updateSkin(param1);
               invalidateDisplayList();
               break;
            case "overlayHighlightImage":
               this.m_UISkinHighlight = this.updateSkin(param1);
               invalidateDisplayList();
               break;
            default:
               super.styleChanged(param1);
         }
      }
      
      public function set position(param1:int) : void
      {
         if(this.m_Position != param1)
         {
            this.m_Position = param1;
            this.m_UncommittedPosition = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      private function get available() : Boolean
      {
         return this.m_Available;
      }
      
      public function get action() : IAction
      {
         return this.m_Action;
      }
      
      private function get cooldownDelay() : Delay
      {
         return this.m_CooldownDelay;
      }
      
      private function drawCooldownMask() : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc1_:Graphics = this.m_UICooldownMask.graphics;
         _loc1_.clear();
         if(this.m_UISkinCooldown != null)
         {
            _loc2_ = this.m_UISkinCooldown.width / 60;
            _loc3_ = this.m_UISkinCooldown.height;
            _loc1_.beginFill(65280,1);
            _loc1_.drawRect(0,0,_loc2_,_loc3_);
            _loc1_.endFill();
         }
      }
      
      override public function set owner(param1:DisplayObjectContainer) : void
      {
         if(owner != param1)
         {
            if(owner is ActionBarWidget)
            {
               owner.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onActionBarChange);
            }
            super.owner = param1;
            if(owner is ActionBarWidget)
            {
               owner.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.onActionBarChange,false,EventPriority.DEFAULT,true);
            }
         }
      }
      
      private function updateActionProperties() : void
      {
         var _loc4_:AppearanceType = null;
         var _loc5_:int = 0;
         var _loc6_:BodyContainerView = null;
         var _loc7_:Delay = null;
         var _loc1_:ContainerStorage = Tibia.s_GetContainerStorage();
         var _loc2_:Player = Tibia.s_GetPlayer();
         var _loc3_:SpellStorage = Tibia.s_GetSpellStorage();
         if(_loc1_ == null || _loc2_ == null || _loc3_ == null)
         {
            return;
         }
         if(this.m_ActionObject != null)
         {
            _loc4_ = this.m_ActionObject.type;
            if(this.m_ActionIconCacheMiss || _loc4_ != null && (_loc4_.isAnimateAlways || _loc4_.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].isAnimation))
            {
               this.m_ActionObject.animate(Tibia.s_FrameTibiaTimestamp);
               this.drawActionIcon();
            }
            _loc5_ = _loc1_.getAvailableInventory(this.m_ActionObject.ID,this.m_ActionObject.data);
            _loc6_ = _loc1_.getBodyContainerView();
            this.available = (_loc5_ == -1 || _loc5_ > 0) && (this.m_ActionRune == null || _loc2_.getRuneUses(this.m_ActionRune) > 0);
            this.highlight = this.action is EquipAction && _loc6_ != null && _loc6_.isEquipped(this.m_ActionObject.ID);
            _loc7_ = null;
            if(this.action is UseAction && _loc4_.isMultiUse)
            {
               _loc7_ = Delay.merge(_loc1_.getMultiUseDelay(),this.m_ActionRune != null?_loc3_.getRuneDelay(this.m_ActionRune.ID):null);
            }
            this.cooldownDelay = _loc7_;
            if(_loc5_ >= 10000)
            {
               this.overlayText = String(int(_loc5_ / 1000)) + "k+";
            }
            else if(_loc5_ > 0)
            {
               this.overlayText = String(_loc5_);
            }
            else
            {
               this.overlayText = null;
            }
         }
         else if(this.m_ActionSpell != null)
         {
            this.available = _loc2_.getSpellCasts(this.m_ActionSpell) > 0;
            this.highlight = false;
            this.cooldownDelay = _loc3_.getSpellDelay(this.m_ActionSpell.ID);
            this.overlayText = null;
         }
         else
         {
            this.available = true;
            this.cooldownDelay = null;
            this.highlight = false;
            this.overlayText = null;
         }
      }
      
      public function set action(param1:IAction) : void
      {
         if(this.m_Action != param1)
         {
            this.m_Action = param1;
            this.m_UncommittedAction = true;
            invalidateDisplayList();
            invalidateProperties();
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.m_UISkinBackground != null)
         {
            measuredMinWidth = measuredWidth = this.m_UISkinBackground.width;
            measuredMinHeight = measuredHeight = this.m_UISkinBackground.height;
         }
         else
         {
            measuredMinWidth = measuredWidth = ICON_SIZE + getStyle("paddingLeft") + getStyle("paddingRight");
            measuredMinHeight = measuredHeight = ICON_SIZE + getStyle("paddingTop") + getStyle("paddingBottom");
         }
      }
      
      private function set highlight(param1:Boolean) : void
      {
         if(this.m_Highlight != param1)
         {
            this.m_Highlight = param1;
            invalidateDisplayList();
         }
      }
      
      private function get actionBar() : ActionBar
      {
         return this.m_ActionBar;
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc8_:* = false;
         super.updateDisplayList(param1,param2);
         var _loc3_:int = 0;
         if(this.m_UISkinBackground != null)
         {
            this.m_UISkinBackground.x = (param1 - this.m_UISkinBackground.width) / 2;
            this.m_UISkinBackground.y = (param2 - this.m_UISkinBackground.height) / 2;
            this.m_UISkinBackground.visible = true;
            setChildIndex(DisplayObject(this.m_UISkinBackground),_loc3_++);
         }
         var _loc4_:Number = param2 - getStyle("paddingBottom");
         var _loc5_:Number = getStyle("paddingLeft");
         var _loc6_:Number = param1 - getStyle("paddingRight");
         var _loc7_:Number = getStyle("paddingTop");
         if(this.m_UILabel != null)
         {
            this.m_UILabel.x = _loc5_;
            this.m_UILabel.y = _loc4_ - this.m_UILabel.height;
            this.m_UILabel.visible = this.action == null;
            setChildIndex(DisplayObject(this.m_UILabel),_loc3_++);
         }
         if(this.m_UIActionIcon != null)
         {
            this.m_UIActionIcon.x = _loc6_ - this.m_UIActionIcon.width;
            this.m_UIActionIcon.y = _loc4_ - this.m_UIActionIcon.height;
            this.m_UIActionIcon.visible = this.action != null;
            setChildIndex(DisplayObject(this.m_UIActionIcon),_loc3_++);
         }
         if(this.m_UISkinDisabled != null)
         {
            this.m_UISkinDisabled.x = (param1 - this.m_UISkinDisabled.width) / 2;
            this.m_UISkinDisabled.y = (param2 - this.m_UISkinDisabled.height) / 2;
            this.m_UISkinDisabled.visible = !this.available;
            setChildIndex(DisplayObject(this.m_UISkinDisabled),_loc3_++);
         }
         if(this.m_UICooldownMask != null && this.m_UISkinCooldown != null)
         {
            _loc8_ = this.m_CooldownPhase > -1;
            this.m_UICooldownMask.x = (param1 - this.m_UICooldownMask.width) / 2;
            this.m_UICooldownMask.y = (param2 - this.m_UICooldownMask.height) / 2;
            this.m_UICooldownMask.visible = _loc8_;
            setChildIndex(DisplayObject(this.m_UICooldownMask),_loc3_++);
            this.m_UISkinCooldown.mask = this.m_UICooldownMask;
            this.m_UISkinCooldown.x = this.m_UICooldownMask.x - this.m_CooldownPhase * this.m_UICooldownMask.width;
            this.m_UISkinCooldown.y = this.m_UICooldownMask.y;
            this.m_UISkinCooldown.visible = _loc8_;
            setChildIndex(DisplayObject(this.m_UISkinCooldown),_loc3_++);
         }
         if(this.m_UISkinHighlight != null)
         {
            this.m_UISkinHighlight.x = (param1 - this.m_UISkinDisabled.width) / 2;
            this.m_UISkinHighlight.y = (param2 - this.m_UISkinDisabled.height) / 2;
            this.m_UISkinHighlight.visible = this.highlight;
            setChildIndex(DisplayObject(this.m_UISkinHighlight),_loc3_++);
         }
         if(this.m_UIOverlay != null)
         {
            this.m_UIOverlay.x = _loc6_ - this.m_UIOverlay.width;
            this.m_UIOverlay.y = this.m_OverlayPosition == OVERLAY_BOTTOM?Number(_loc4_ - this.m_UIOverlay.height):Number(_loc7_);
            this.m_UIOverlay.visible = this.overlayText != null;
            setChildIndex(DisplayObject(this.m_UIOverlay),_loc3_++);
         }
      }
   }
}
