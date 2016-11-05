package tibia.prey.preyWidgetClasses
{
   import mx.containers.HBox;
   import flash.display.BitmapData;
   import flash.display.Bitmap;
   import mx.controls.Image;
   import tibia.appearances.widgetClasses.SimpleAppearanceRenderer;
   import shared.controls.ShapeWrapper;
   import tibia.prey.PreyData;
   import mx.utils.StringUtil;
   import tibia.appearances.AppearanceInstance;
   import mx.containers.VBox;
   import mx.controls.Label;
   
   public class PreyMonsterDisplay extends HBox
   {
      
      private static const PREY_NO_BONUS_CLASS:Class = PreyMonsterDisplay_PREY_NO_BONUS_CLASS;
      
      private static const PREY_DAMAGE_REDUCTION_CLASS:Class = PreyMonsterDisplay_PREY_DAMAGE_REDUCTION_CLASS;
      
      private static const PREY_NO_PREY_CLASS:Class = PreyMonsterDisplay_PREY_NO_PREY_CLASS;
      
      public static const PREY_IMPROVED_XP:BitmapData = Bitmap(new PREY_IMPROVED_XP_CLASS()).bitmapData;
      
      private static const PREY_IMPROVED_LOOT_CLASS:Class = PreyMonsterDisplay_PREY_IMPROVED_LOOT_CLASS;
      
      public static const PREY_DAMAGE_REDUCTION:BitmapData = Bitmap(new PREY_DAMAGE_REDUCTION_CLASS()).bitmapData;
      
      public static const PREY_IMPROVED_LOOT:BitmapData = Bitmap(new PREY_IMPROVED_LOOT_CLASS()).bitmapData;
      
      private static const PREY_DAMAGE_BOOST_CLASS:Class = PreyMonsterDisplay_PREY_DAMAGE_BOOST_CLASS;
      
      public static const PREY_NO_BONUS:BitmapData = Bitmap(new PREY_NO_BONUS_CLASS()).bitmapData;
      
      public static const PREY_NO_PREY:BitmapData = Bitmap(new PREY_NO_PREY_CLASS()).bitmapData;
      
      private static const PREY_IMPROVED_XP_CLASS:Class = PreyMonsterDisplay_PREY_IMPROVED_XP_CLASS;
      
      public static const PREY_DAMAGE_BOOST:BitmapData = Bitmap(new PREY_DAMAGE_BOOST_CLASS()).bitmapData;
       
      
      private var m_UIBonusImage:Image = null;
      
      private var m_UICompleted:Boolean = false;
      
      private var m_BonusType:uint = 4;
      
      private var m_UncommittedMonster:Boolean = false;
      
      private var m_BonusValue:uint = 0;
      
      private var m_UIMonsterDisplay:SimpleAppearanceRenderer = null;
      
      private var m_PreyMonster:AppearanceInstance = null;
      
      private var m_UINoMonster:Image = null;
      
      private var m_UncommittedBonus:Boolean = false;
      
      private var m_UIBonusText:Label = null;
      
      public function PreyMonsterDisplay()
      {
         super();
      }
      
      override protected function commitProperties() : void
      {
         var _loc1_:BitmapData = null;
         super.commitProperties();
         if(this.m_UncommittedMonster)
         {
            this.m_UIMonsterDisplay.appearance = this.m_PreyMonster;
            this.m_UIMonsterDisplay.patternX = 2;
            this.m_UIMonsterDisplay.patternY = 0;
            this.m_UIMonsterDisplay.patternZ = 0;
            (this.m_UIMonsterDisplay.parent as ShapeWrapper).visible = this.m_PreyMonster != null;
            (this.m_UIMonsterDisplay.parent as ShapeWrapper).includeInLayout = this.m_PreyMonster != null;
            (this.m_UIMonsterDisplay.parent as ShapeWrapper).invalidateSize();
            (this.m_UIMonsterDisplay.parent as ShapeWrapper).invalidateDisplayList();
            if(this.m_PreyMonster != null)
            {
               if(contains(this.m_UINoMonster))
               {
                  removeChild(this.m_UINoMonster);
               }
            }
            else
            {
               addChildAt(this.m_UINoMonster,0);
            }
            this.m_UncommittedMonster = false;
         }
         if(this.m_UncommittedBonus)
         {
            this.m_UIBonusImage.removeChildren();
            _loc1_ = this.getBonusTypeBitmapData();
            this.m_UIBonusImage.addChild(new Bitmap(_loc1_));
            this.m_UIBonusImage.width = _loc1_.width;
            this.m_UIBonusImage.height = _loc1_.height;
            if(this.m_BonusType == PreyData.BONUS_NONE)
            {
               this.m_UIBonusText.text = "+??%";
            }
            else
            {
               this.m_UIBonusText.text = StringUtil.substitute("+{0}%",this.m_BonusValue);
            }
            this.m_UncommittedBonus = false;
         }
      }
      
      public function setMonster(param1:AppearanceInstance) : void
      {
         this.m_PreyMonster = param1;
         this.m_UncommittedMonster = true;
         invalidateProperties();
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:int = 0;
         var _loc2_:ShapeWrapper = null;
         var _loc3_:VBox = null;
         super.createChildren();
         if(!this.m_UICompleted)
         {
            _loc1_ = 128;
            this.m_UIMonsterDisplay = new SimpleAppearanceRenderer();
            this.m_UIMonsterDisplay.scale = 2;
            _loc2_ = new ShapeWrapper();
            _loc2_.explicitWidth = _loc1_;
            _loc2_.explicitHeight = _loc1_;
            _loc2_.setStyle("horizontalAlign","right");
            _loc2_.setStyle("verticalAlign","bottom");
            _loc2_.addChild(this.m_UIMonsterDisplay);
            addChild(_loc2_);
            this.m_UINoMonster = new Image();
            this.m_UINoMonster.addChild(new Bitmap(PREY_NO_PREY));
            this.m_UINoMonster.explicitWidth = _loc1_;
            this.m_UINoMonster.explicitHeight = _loc1_;
            this.m_UINoMonster.setStyle("horizontalAlign","center");
            this.m_UINoMonster.setStyle("verticalAlign","middle");
            _loc3_ = new VBox();
            addChild(_loc3_);
            this.m_UIBonusImage = new Image();
            _loc3_.addChild(this.m_UIBonusImage);
            this.m_UIBonusText = new Label();
            this.m_UIBonusText.percentWidth = 100;
            this.m_UIBonusText.setStyle("textAlign","center");
            this.m_UIBonusText.setStyle("fontWeight","bold");
            _loc3_.addChild(this.m_UIBonusText);
            this.m_UICompleted = true;
         }
      }
      
      private function getBonusTypeBitmapData() : BitmapData
      {
         if(this.m_BonusType == PreyData.BONUS_DAMAGE_BOOST)
         {
            return PREY_DAMAGE_BOOST;
         }
         if(this.m_BonusType == PreyData.BONUS_DAMAGE_REDUCTION)
         {
            return PREY_DAMAGE_REDUCTION;
         }
         if(this.m_BonusType == PreyData.BONUS_IMPROVED_LOOT)
         {
            return PREY_IMPROVED_LOOT;
         }
         if(this.m_BonusType == PreyData.BONUS_XP_BONUS)
         {
            return PREY_IMPROVED_XP;
         }
         return PREY_NO_BONUS;
      }
      
      public function setBonus(param1:uint, param2:uint) : void
      {
         this.m_BonusType = param1;
         this.m_BonusValue = param2;
         this.m_UncommittedBonus = true;
         invalidateProperties();
      }
   }
}
