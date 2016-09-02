package tibia.premium.premiumWidgetClasses
{
   import tibia.sidebar.sideBarWidgetClasses.WidgetView;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import tibia.premium.PremiumEvent;
   import tibia.§sidebar:ns_sidebar_internal§.widgetCollapsed;
   import mx.containers.Grid;
   import tibia.premium.PremiumMessage;
   import mx.containers.GridRow;
   import mx.containers.GridItem;
   import mx.controls.Text;
   import flash.display.Bitmap;
   import mx.controls.Image;
   import tibia.premium.PremiumWidget;
   import mx.core.ScrollPolicy;
   
   public class PremiumWidgetView extends WidgetView
   {
      
      private static const BUNDLE:String = "PremiumWidget";
       
      
      private var m_TriggerExpiryTime:int = 0;
      
      private var m_UICollapsedStyleName:Object;
      
      private var m_UIGrid:Grid = null;
      
      private var m_TriggerHighlight:Boolean = false;
      
      private var m_UIConstructed:Boolean = false;
      
      private var m_LastTriggerTime:Number = 0;
      
      public function PremiumWidgetView()
      {
         super();
         titleText = resourceManager.getString(BUNDLE,"TITLE");
         verticalScrollPolicy = ScrollPolicy.OFF;
         horizontalScrollPolicy = ScrollPolicy.OFF;
         Tibia.s_GetPremiumManager().addEventListener(PremiumEvent.TRIGGER,this.onPremiumTrigger);
         Tibia.s_GetPremiumManager().addEventListener(PremiumEvent.HIGHLIGHT,this.onPremiumHighlightToggle);
         Tibia.s_GetSecondaryTimer().addEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
      }
      
      override function releaseInstance() : void
      {
         super.releaseInstance();
         m_UICollapseButton.removeEventListener(MouseEvent.CLICK,this.onCollapseButtonClick);
         m_UIHeader.removeEventListener(MouseEvent.DOUBLE_CLICK,this.onHeaderDoubleClick);
         Tibia.s_GetSecondaryTimer().removeEventListener(TimerEvent.TIMER,this.onSecondaryTimer);
         Tibia.s_GetPremiumManager().removeEventListener(PremiumEvent.TRIGGER,this.onPremiumTrigger);
         Tibia.s_GetPremiumManager().removeEventListener(PremiumEvent.HIGHLIGHT,this.onPremiumHighlightToggle);
      }
      
      public function stopTriggerHighlight() : void
      {
         this.m_TriggerHighlight = false;
         m_UICollapseButton.styleName = this.m_UICollapsedStyleName;
      }
      
      protected function onPremiumTrigger(param1:PremiumEvent) : void
      {
         this.updatePremiumBenefits(param1.messages);
         if(param1.highlight)
         {
            this.startTriggerHighlight(param1.highlightExpiry);
         }
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         m_UICollapseButton.selected = widgetCollapsed;
         m_UICloseButton.enabled = m_WidgetClosable;
      }
      
      protected function onCollapseButtonClick(param1:MouseEvent) : void
      {
         this.stopTriggerHighlight();
         invalidateProperties();
      }
      
      protected function onHeaderDoubleClick(param1:MouseEvent) : void
      {
         this.stopTriggerHighlight();
         invalidateProperties();
      }
      
      protected function onPremiumHighlightToggle(param1:PremiumEvent) : void
      {
         if(this.m_TriggerHighlight)
         {
            this.stopTriggerHighlight();
         }
         else
         {
            this.startTriggerHighlight(param1.highlightExpiry);
         }
      }
      
      private function updatePremiumBenefits(param1:Vector.<PremiumMessage>) : void
      {
         var _loc2_:PremiumMessage = null;
         var _loc3_:GridRow = null;
         var _loc4_:GridItem = null;
         var _loc5_:Text = null;
         var _loc6_:Bitmap = null;
         var _loc7_:Image = null;
         this.m_UIGrid.removeAllChildren();
         for each(_loc2_ in param1)
         {
            _loc3_ = new GridRow();
            _loc4_ = new GridItem();
            _loc4_.styleName = "premiumWidgetGridItem";
            if(_loc2_.icon != null)
            {
               _loc6_ = new Bitmap(_loc2_.icon);
               _loc7_ = new Image();
               _loc7_.source = _loc6_;
               _loc4_.addChild(_loc7_);
            }
            _loc3_.addChild(_loc4_);
            _loc4_ = new GridItem();
            _loc4_.styleName = "premiumWidgetGridItem";
            _loc5_ = new Text();
            _loc5_.htmlText = resourceManager.getString(BUNDLE,_loc2_.resourceText,[(m_WidgetInstance as PremiumWidget).premiumManager.premiumExpiryDays]);
            _loc4_.addChild(_loc5_);
            _loc3_.addChild(_loc4_);
            this.m_UIGrid.addChild(_loc3_);
         }
      }
      
      override protected function createChildren() : void
      {
         if(!this.m_UIConstructed)
         {
            super.createChildren();
            m_UICollapseButton.addEventListener(MouseEvent.CLICK,this.onCollapseButtonClick);
            this.m_UICollapsedStyleName = m_UICollapseButton.styleName;
            this.m_UIGrid = new Grid();
            this.m_UIGrid.percentWidth = 100;
            addChild(this.m_UIGrid);
            this.updatePremiumBenefits(Tibia.s_GetPremiumManager().premiumMessages);
            m_UIHeader.addEventListener(MouseEvent.DOUBLE_CLICK,this.onHeaderDoubleClick);
            this.m_UIConstructed = true;
         }
      }
      
      public function startTriggerHighlight(param1:int) : void
      {
         this.m_LastTriggerTime = Tibia.s_GetTibiaTimer();
         this.m_TriggerExpiryTime = param1;
         if(widgetCollapsed && !this.m_TriggerHighlight)
         {
            this.m_UICollapsedStyleName = m_UICollapseButton.styleName;
            m_UICollapseButton.styleName = "expandButtonPremiumTriggered";
         }
         this.m_TriggerHighlight = true;
      }
      
      protected function onSecondaryTimer(param1:TimerEvent) : void
      {
         var _loc2_:int = Tibia.s_GetTibiaTimer();
         if(this.m_TriggerHighlight && this.m_LastTriggerTime + this.m_TriggerExpiryTime < _loc2_)
         {
            this.stopTriggerHighlight();
         }
      }
   }
}
