package tibia.appearances
{
   import tibia.appearances.widgetClasses.CachedSpriteInformation;
   import shared.utility.Colour;
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.filters.GlowFilter;
   import flash.filters.BitmapFilterQuality;
   
   public class TextualEffectInstance extends AppearanceInstance
   {
      
      protected static const PHASE_DURATION:Number = 100;
      
      protected static const PHASE_COUNT:int = 10;
       
      
      private const m_TempSpriteInformation:CachedSpriteInformation = new CachedSpriteInformation();
      
      protected var m_Colour:Colour = null;
      
      var m_Phase:uint = 0;
      
      var m_InstanceCache:Boolean = false;
      
      var m_InstanceBitmap:BitmapData = null;
      
      protected var m_Text:String = null;
      
      protected var m_LastPhaseChange:Number = 0;
      
      var m_InstanceRectangle:Rectangle = null;
      
      private var m_UncomittedRebuildCache:Boolean = true;
      
      protected var m_Value:Number = NaN;
      
      public function TextualEffectInstance(param1:int, param2:AppearanceType, param3:int, param4:Number)
      {
         super(-1,null);
         this.m_Colour = Colour.s_FromEightBit(param3);
         this.m_Value = param4;
         this.m_Text = null;
         this.m_Phase = 0;
         this.m_LastPhaseChange = Tibia.s_FrameTibiaTimestamp;
         this.m_UncomittedRebuildCache = true;
      }
      
      public function get colour() : Colour
      {
         return this.m_Colour;
      }
      
      override public function getSprite(param1:int, param2:int, param3:int, param4:int, param5:Boolean = false) : CachedSpriteInformation
      {
         this.rebuildCache();
         if(this.m_InstanceCache)
         {
            this.m_TempSpriteInformation.setCachedSpriteInformationTo(0,this.m_InstanceBitmap,this.m_InstanceRectangle,false);
            return this.m_TempSpriteInformation;
         }
         return null;
      }
      
      public function get width() : Number
      {
         this.rebuildCache();
         return this.m_InstanceRectangle.width;
      }
      
      override public function animate(param1:Number, param2:int = 0) : Boolean
      {
         var _loc3_:Number = NaN;
         _loc3_ = Math.abs(param1 - this.m_LastPhaseChange);
         var _loc4_:int = int(_loc3_ / PHASE_DURATION);
         this.m_Phase = this.m_Phase + _loc4_;
         this.m_LastPhaseChange = this.m_LastPhaseChange + _loc4_ * PHASE_DURATION;
         return this.m_Phase < PHASE_COUNT;
      }
      
      override public function drawTo(param1:BitmapData, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         this.rebuildCache();
         if(this.m_InstanceCache)
         {
            s_TempPoint.setTo(param2 - this.m_InstanceRectangle.width,param3 - this.m_InstanceRectangle.height);
            param1.copyPixels(this.m_InstanceBitmap,this.m_InstanceRectangle,s_TempPoint,null,null,true);
         }
      }
      
      public function get height() : Number
      {
         this.rebuildCache();
         return this.m_InstanceRectangle.height;
      }
      
      public function get text() : String
      {
         return this.m_Text;
      }
      
      public function rebuildCache() : void
      {
         var _loc1_:TextField = null;
         if(this.m_UncomittedRebuildCache == true)
         {
            this.m_UncomittedRebuildCache = false;
            this.m_Text = this.m_Value.toFixed(0);
            _loc1_ = new TextField();
            _loc1_.autoSize = TextFieldAutoSize.LEFT;
            _loc1_.defaultTextFormat = new TextFormat("Verdana",11,this.m_Colour.ARGB,true);
            _loc1_.text = this.m_Text;
            _loc1_.filters = [new GlowFilter(0,1,2,2,4,BitmapFilterQuality.MEDIUM,false,false)];
            if(this.m_InstanceBitmap != null)
            {
               this.m_InstanceBitmap.dispose();
               this.m_InstanceBitmap = null;
            }
            this.m_InstanceRectangle = new Rectangle(0,0,_loc1_.width,_loc1_.height);
            this.m_InstanceBitmap = new BitmapData(this.m_InstanceRectangle.width,this.m_InstanceRectangle.height,true,65280);
            this.m_InstanceBitmap.draw(_loc1_);
            this.m_InstanceCache = true;
         }
      }
      
      public function get value() : Number
      {
         return this.m_Value;
      }
      
      public function merge(param1:AppearanceInstance) : Boolean
      {
         var _loc2_:TextualEffectInstance = param1 as TextualEffectInstance;
         if(_loc2_ != null && _loc2_.m_Phase <= 0 && this.m_Phase <= 0 && _loc2_.m_Colour == this.m_Colour)
         {
            this.m_Value = this.m_Value + _loc2_.m_Value;
            this.m_UncomittedRebuildCache = true;
            return true;
         }
         return false;
      }
      
      override public function get phase() : int
      {
         return this.m_Phase;
      }
   }
}
