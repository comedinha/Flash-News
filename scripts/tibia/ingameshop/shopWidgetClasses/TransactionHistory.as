package tibia.ingameshop.shopWidgetClasses
{
   import flash.errors.IllegalOperationError;
   import flash.events.MouseEvent;
   import mx.collections.ArrayCollection;
   import mx.controls.Button;
   import mx.controls.Label;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.core.ClassFactory;
   import shared.controls.CustomDataGrid;
   import tibia.ingameshop.IngameShopEvent;
   import tibia.ingameshop.IngameShopHistoryEntry;
   import tibia.ingameshop.IngameShopManager;
   import tibia.ingameshop.IngameShopWidget;
   
   public class TransactionHistory extends CustomDataGrid implements IIngameShopWidgetComponent
   {
      
      private static const BUNDLE:String = "IngameShopWidget";
      
      private static const DISPLAY_MODE_ERROR:int = 1;
      
      private static const HISTORY_ENTRIES_PER_PAGE:int = 13;
      
      private static const DISPLAY_MODE_REGULAR:int = 0;
       
      
      private var m_UncommittedHistory:Boolean = false;
      
      private var m_UINextButton:Button;
      
      private var m_UncommittedDisplayMode:Boolean = true;
      
      private var m_UIPreviousButton:Button;
      
      private var m_DisplayMode:int = 0;
      
      private var m_UITransactionPageText:Label;
      
      private var m_HistoryData:ArrayCollection;
      
      private var m_ShopWindow:IngameShopWidget;
      
      private var m_UncommittedButtons:Boolean = false;
      
      public function TransactionHistory()
      {
         super();
         showDataTips = true;
         variableRowHeight = false;
         this.m_HistoryData = new ArrayCollection();
         var _loc1_:DataGridColumn = new DataGridColumn(resourceManager.getString(BUNDLE,"COL_DATE"));
         _loc1_.dataField = "timestamp";
         _loc1_.itemRenderer = new ClassFactory(DateRenderer);
         _loc1_.width = 50;
         var _loc2_:DataGridColumn = new DataGridColumn(resourceManager.getString(BUNDLE,"COL_BALANCE"));
         _loc2_.dataField = "creditChange";
         _loc2_.itemRenderer = new ClassFactory(CreditsRenderer);
         _loc2_.width = 42;
         var _loc3_:DataGridColumn = new DataGridColumn(resourceManager.getString(BUNDLE,"COL_PRODUCT"));
         _loc3_.dataField = "transactionName";
         _loc3_.dataTipField = "transactionName";
         var _loc4_:DataGridColumn = new DataGridColumn(resourceManager.getString(BUNDLE,"COL_ERROR"));
         _loc4_.dataField = "transactionName";
         _loc3_.dataTipField = "transactionName";
         _loc4_.visible = false;
         _loc4_.wordWrap = true;
         columns = [_loc1_,_loc2_,_loc3_,_loc4_];
         dataProvider = this.m_HistoryData;
         resizableColumns = false;
         draggableColumns = false;
         sortableColumns = false;
         editable = false;
         IngameShopManager.getInstance().addEventListener(IngameShopEvent.HISTORY_CHANGED,this.onHistoryChanged);
      }
      
      protected function get displayMode() : int
      {
         return this.m_DisplayMode;
      }
      
      protected function set displayMode(param1:int) : void
      {
         if(param1 != this.m_DisplayMode)
         {
            this.m_DisplayMode = param1;
            this.m_UncommittedDisplayMode = true;
            invalidateProperties();
         }
      }
      
      public function setControlledButtonsAndLabel(param1:Button, param2:Button, param3:Label) : void
      {
         if(this.m_UIPreviousButton != null)
         {
            this.m_UIPreviousButton.removeEventListener(MouseEvent.CLICK,this.onPreviousClicked);
         }
         if(this.m_UINextButton != null)
         {
            this.m_UINextButton.removeEventListener(MouseEvent.CLICK,this.onNextClicked);
         }
         this.m_UIPreviousButton = param1;
         this.m_UINextButton = param2;
         this.m_UITransactionPageText = param3;
         if(this.m_UIPreviousButton != null)
         {
            this.m_UIPreviousButton.addEventListener(MouseEvent.CLICK,this.onPreviousClicked);
         }
         if(this.m_UINextButton != null)
         {
            this.m_UINextButton.addEventListener(MouseEvent.CLICK,this.onNextClicked);
         }
         this.m_UncommittedButtons = true;
         invalidateProperties();
      }
      
      public function refreshTransactionHistory() : void
      {
         IngameShopManager.getInstance().refreshTransactionHistory(TransactionHistory.HISTORY_ENTRIES_PER_PAGE);
      }
      
      protected function onNextClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = IngameShopManager.getInstance().getHistoryPage() + 1;
         IngameShopManager.getInstance().pageTransactionHistory(_loc2_,TransactionHistory.HISTORY_ENTRIES_PER_PAGE);
         this.m_UINextButton.enabled = false;
         this.m_UIPreviousButton.enabled = false;
      }
      
      protected function onHistoryChanged(param1:IngameShopEvent) : void
      {
         this.displayMode = DISPLAY_MODE_REGULAR;
         this.m_UncommittedHistory = true;
         this.m_UncommittedButtons = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:Vector.<IngameShopHistoryEntry> = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:* = false;
         var _loc5_:* = false;
         var _loc6_:* = false;
         super.commitProperties();
         if(this.m_UncommittedHistory)
         {
            _loc1_ = IngameShopManager.getInstance().getHistory();
            _loc2_ = new Array();
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               _loc2_.push(_loc1_[_loc3_]);
               _loc3_++;
            }
            this.m_HistoryData.source = _loc2_;
            this.m_HistoryData.refresh();
            this.m_UncommittedHistory = false;
         }
         if(this.m_UncommittedButtons)
         {
            _loc4_ = IngameShopManager.getInstance().getHistoryPage() > 0;
            _loc5_ = IngameShopManager.getInstance().getHistoryPage() < IngameShopManager.getInstance().getNumberOfHistoryPages() - 1;
            if(this.m_UINextButton != null)
            {
               this.m_UINextButton.enabled = _loc5_;
            }
            if(this.m_UIPreviousButton != null)
            {
               this.m_UIPreviousButton.enabled = _loc4_;
            }
            this.m_UITransactionPageText.setVisible(IngameShopManager.getInstance().getNumberOfHistoryPages() > 1);
            this.m_UITransactionPageText.text = resourceManager.getString(BUNDLE,"LBL_TRANSACTION_HISTORY_PAGES",[IngameShopManager.getInstance().getHistoryPage() + 1,IngameShopManager.getInstance().getNumberOfHistoryPages()]);
            this.m_UncommittedButtons = false;
         }
         if(this.m_UncommittedDisplayMode)
         {
            variableRowHeight = this.displayMode == DISPLAY_MODE_ERROR;
            _loc3_ = 0;
            while(_loc3_ < columns.length)
            {
               _loc6_ = _loc3_ == columns.length - 1;
               columns[_loc3_].visible = this.displayMode == DISPLAY_MODE_ERROR?_loc6_:!_loc6_;
               _loc3_++;
            }
            this.m_UncommittedDisplayMode = false;
         }
      }
      
      protected function onPreviousClicked(param1:MouseEvent) : void
      {
         var _loc2_:int = Math.max(0,IngameShopManager.getInstance().getHistoryPage() - 1);
         IngameShopManager.getInstance().pageTransactionHistory(_loc2_,TransactionHistory.HISTORY_ENTRIES_PER_PAGE);
         this.m_UINextButton.enabled = false;
         this.m_UIPreviousButton.enabled = false;
      }
      
      public function dispose() : void
      {
         IngameShopManager.getInstance().removeEventListener(IngameShopEvent.HISTORY_CHANGED,this.onHistoryChanged);
         this.m_ShopWindow = null;
      }
      
      public function set shopWidget(param1:IngameShopWidget) : void
      {
         if(this.m_ShopWindow != null)
         {
            throw new IllegalOperationError("IngameShopOfferList.shopWidget: Attempted to set reference twice");
         }
         this.m_ShopWindow = param1;
      }
      
      public function displayTransactionHistoryError(param1:String) : void
      {
         this.displayMode = DISPLAY_MODE_ERROR;
         var _loc2_:Array = new Array();
         _loc2_.push(new IngameShopHistoryEntry(0,0,0,param1));
         this.m_HistoryData.source = _loc2_;
         this.m_HistoryData.refresh();
      }
   }
}

import mx.controls.Label;
import mx.core.IDataRenderer;
import mx.formatters.DateFormatter;
import tibia.ingameshop.IngameShopHistoryEntry;

class DateRenderer extends Label implements IDataRenderer
{
    
   
   private var m_UncommittedDate:Boolean;
   
   function DateRenderer()
   {
      super();
   }
   
   override protected function commitProperties() : void
   {
      var _loc1_:IngameShopHistoryEntry = null;
      var _loc2_:Date = null;
      var _loc3_:DateFormatter = null;
      if(this.m_UncommittedDate)
      {
         _loc1_ = data as IngameShopHistoryEntry;
         if(_loc1_ != null)
         {
            _loc2_ = new Date(_loc1_.timestamp * 1000);
            _loc3_ = new DateFormatter();
            _loc3_.formatString = "DD.MM.YYYY, HH:NN";
            _loc3_.formatString = "YYYY-MM-DD, HH:NN:SS";
            text = _loc3_.format(_loc2_);
         }
         else
         {
            text = "";
         }
         this.m_UncommittedDate = false;
      }
   }
   
   override public function set data(param1:Object) : void
   {
      if(super.data != param1)
      {
         super.data = param1;
         this.m_UncommittedDate = true;
         invalidateProperties();
      }
   }
}

import flash.display.Bitmap;
import mx.containers.HBox;
import mx.controls.Image;
import mx.controls.Label;
import mx.core.IDataRenderer;
import mx.core.ScrollPolicy;
import shared.utility.i18n.i18nFormatNumber;
import tibia.ingameshop.IngameShopHistoryEntry;
import tibia.ingameshop.shopWidgetClasses.CoinWidget;

class CreditsRenderer extends HBox implements IDataRenderer
{
   
   private static const BUNDLE:String = "IngameShopWidget";
   
   private static const COLOR_NEUTRAL:int = 4286945;
   
   private static const COLOR_POSITIVE_CHANGE:int = 65280;
   
   private static const COLOR_NEGATIVE_CHANGE:int = 16711680;
    
   
   private var m_UncommittedCredits:Boolean;
   
   private var m_UICoinsIcon:Image;
   
   private var m_UICoinsLabel:Label;
   
   function CreditsRenderer()
   {
      super();
   }
   
   private function getCoinsTextColor(param1:IngameShopHistoryEntry) : int
   {
      if(param1.isGift() || param1.isRefund())
      {
         return COLOR_NEUTRAL;
      }
      return param1.creditChange >= 0?int(COLOR_POSITIVE_CHANGE):int(COLOR_NEGATIVE_CHANGE);
   }
   
   override protected function commitProperties() : void
   {
      var _loc1_:IngameShopHistoryEntry = null;
      if(this.m_UncommittedCredits)
      {
         _loc1_ = data as IngameShopHistoryEntry;
         if(_loc1_ != null)
         {
            this.m_UICoinsIcon.visible = !(_loc1_.isGift() || _loc1_.isRefund());
            this.m_UICoinsIcon.includeInLayout = true;
            this.m_UICoinsLabel.text = this.getCoinsText(_loc1_);
            this.m_UICoinsLabel.setStyle("color",this.getCoinsTextColor(_loc1_));
         }
         else
         {
            this.m_UICoinsLabel.text = "";
            this.m_UICoinsIcon.visible = false;
            this.m_UICoinsIcon.includeInLayout = false;
         }
         this.m_UncommittedCredits = false;
      }
   }
   
   override public function set data(param1:Object) : void
   {
      if(param1 != super.data)
      {
         super.data = param1;
         this.m_UncommittedCredits = true;
         invalidateProperties();
      }
   }
   
   private function getCoinsText(param1:IngameShopHistoryEntry) : String
   {
      var _loc2_:String = null;
      if(param1.isGift())
      {
         return resourceManager.getString(BUNDLE,"TEXT_TRANSACTION_GIFT");
      }
      if(param1.isRefund())
      {
         return resourceManager.getString(BUNDLE,"TEXT_TRANSACTION_REFUND");
      }
      _loc2_ = param1.creditChange >= 0?"+":"";
      return _loc2_ + i18nFormatNumber(param1.creditChange);
   }
   
   override protected function createChildren() : void
   {
      super.createChildren();
      horizontalScrollPolicy = ScrollPolicy.OFF;
      this.m_UICoinsLabel = new Label();
      addChild(this.m_UICoinsLabel);
      this.m_UICoinsIcon = new Image();
      this.m_UICoinsIcon.addChild(new Bitmap(CoinWidget.ICON_COINS));
      this.m_UICoinsIcon.width = CoinWidget.ICON_COINS.width;
      this.m_UICoinsIcon.height = CoinWidget.ICON_COINS.height;
      addChild(this.m_UICoinsIcon);
      styleName = "ingameShopHistoryCredits";
   }
}
