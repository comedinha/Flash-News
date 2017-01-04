package tibia.appearances
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import tibia.appearances.widgetClasses.CachedSpriteInformation;
   import tibia.appearances.widgetClasses.MarksView;
   import tibia.§appearances:ns_appearance_internal§.m_ID;
   import tibia.§appearances:ns_appearance_internal§.m_Type;
   
   public class ObjectInstance extends AppearanceInstance
   {
      
      private static var s_ObjectMarksView:MarksView = null;
      
      private static var s_HelperRect:Rectangle = new Rectangle();
      
      {
         s_InitialiseMarksViews();
      }
      
      protected var m_Hang:int = 0;
      
      protected var m_SpecialPatternY:int = 0;
      
      protected var m_Marks:Marks = null;
      
      protected var m_SpecialPatternX:int = 0;
      
      protected var m_Data:int = 0;
      
      protected var m_HasSpecialPattern:Boolean = false;
      
      public function ObjectInstance(param1:int, param2:AppearanceType, param3:int)
      {
         super(param1,param2);
         this.m_Data = param3;
         this.m_Marks = new Marks();
         this.updateSpecialPattern();
      }
      
      private static function s_InitialiseMarksViews() : void
      {
         s_ObjectMarksView = new MarksView(0);
         s_ObjectMarksView.addMarkToView(Marks.MARK_TYPE_PERMANENT,MarksView.MARK_THICKNESS_THIN);
      }
      
      public function get marks() : Marks
      {
         return this.m_Marks;
      }
      
      protected function updateSpecialPattern() : void
      {
         var _loc1_:int = 0;
         this.m_HasSpecialPattern = false;
         if(m_Type == null || m_ID == AppearanceInstance.CREATURE)
         {
            return;
         }
         if(m_Type.isCumulative)
         {
            this.m_HasSpecialPattern = true;
            if(this.m_Data < 2)
            {
               this.m_SpecialPatternX = 0;
               this.m_SpecialPatternY = 0;
            }
            else if(this.m_Data == 2)
            {
               this.m_SpecialPatternX = 1;
               this.m_SpecialPatternY = 0;
            }
            else if(this.m_Data == 3)
            {
               this.m_SpecialPatternX = 2;
               this.m_SpecialPatternY = 0;
            }
            else if(this.m_Data == 4)
            {
               this.m_SpecialPatternX = 3;
               this.m_SpecialPatternY = 0;
            }
            else if(this.m_Data < 10)
            {
               this.m_SpecialPatternX = 0;
               this.m_SpecialPatternY = 1;
            }
            else if(this.m_Data < 25)
            {
               this.m_SpecialPatternX = 1;
               this.m_SpecialPatternY = 1;
            }
            else if(this.m_Data < 50)
            {
               this.m_SpecialPatternX = 2;
               this.m_SpecialPatternY = 1;
            }
            else
            {
               this.m_SpecialPatternX = 3;
               this.m_SpecialPatternY = 1;
            }
            this.m_SpecialPatternX = this.m_SpecialPatternX % m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].patternWidth;
            this.m_SpecialPatternY = this.m_SpecialPatternY % m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].patternHeight;
         }
         else if(m_Type.isLiquidPool || m_Type.isLiquidContainer)
         {
            this.m_HasSpecialPattern = true;
            _loc1_ = 0;
            switch(this.m_Data)
            {
               case 0:
                  _loc1_ = 0;
                  break;
               case 1:
                  _loc1_ = 1;
                  break;
               case 2:
                  _loc1_ = 7;
                  break;
               case 3:
                  _loc1_ = 3;
                  break;
               case 4:
                  _loc1_ = 3;
                  break;
               case 5:
                  _loc1_ = 2;
                  break;
               case 6:
                  _loc1_ = 4;
                  break;
               case 7:
                  _loc1_ = 3;
                  break;
               case 8:
                  _loc1_ = 5;
                  break;
               case 9:
                  _loc1_ = 6;
                  break;
               case 10:
                  _loc1_ = 7;
                  break;
               case 11:
                  _loc1_ = 2;
                  break;
               case 12:
                  _loc1_ = 5;
                  break;
               case 13:
                  _loc1_ = 3;
                  break;
               case 14:
                  _loc1_ = 5;
                  break;
               case 15:
                  _loc1_ = 6;
                  break;
               case 16:
                  _loc1_ = 3;
                  break;
               case 17:
                  _loc1_ = 3;
                  break;
               default:
                  _loc1_ = 1;
            }
            this.m_SpecialPatternX = (_loc1_ & 3) % m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].patternWidth;
            this.m_SpecialPatternY = (_loc1_ >> 2) % m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].patternHeight;
         }
         else if(m_Type.isHangable)
         {
            this.m_HasSpecialPattern = true;
            if(this.m_Hang == AppearanceStorage.FLAG_HOOKSOUTH)
            {
               this.m_SpecialPatternX = m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].patternWidth >= 2?1:0;
               this.m_SpecialPatternY = 0;
            }
            else if(this.m_Hang == AppearanceStorage.FLAG_HOOKEAST)
            {
               this.m_SpecialPatternX = m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].patternWidth >= 3?2:0;
               this.m_SpecialPatternY = 0;
            }
            else
            {
               this.m_SpecialPatternX = 0;
               this.m_SpecialPatternY = 0;
            }
         }
      }
      
      public function get isCreature() : Boolean
      {
         return m_Type.isCreature;
      }
      
      public function get data() : int
      {
         return this.m_Data;
      }
      
      public function set hang(param1:int) : void
      {
         if(this.m_Hang != param1)
         {
            this.m_Hang = param1;
            this.updateSpecialPattern();
         }
      }
      
      public function get hasMark() : Boolean
      {
         return this.marks.isMarkSet(Marks.MARK_TYPE_PERMANENT);
      }
      
      override public function drawTo(param1:BitmapData, param2:int, param3:int, param4:int, param5:int, param6:int) : void
      {
         var _loc9_:CachedSpriteInformation = null;
         var _loc11_:BitmapData = null;
         var _loc7_:int = param4;
         var _loc8_:int = param5;
         if(this.m_HasSpecialPattern)
         {
            _loc7_ = -1;
            _loc8_ = -1;
         }
         _loc9_ = getSprite(-1,_loc7_,_loc8_,param6,m_Type.FrameGroups[FrameGroup.FRAME_GROUP_DEFAULT].isAnimation);
         m_CacheDirty = _loc9_.cacheMiss;
         var _loc10_:Rectangle = _loc9_.rectangle;
         s_TempPoint.setTo(param2 - _loc10_.width - m_Type.displacementX,param3 - _loc10_.height - m_Type.displacementY);
         param1.copyPixels(_loc9_.bitmapData,_loc10_,s_TempPoint,null,null,true);
         if(this.hasMark)
         {
            _loc11_ = s_ObjectMarksView.getMarksBitmap(this.marks,s_HelperRect);
            s_TempPoint.setTo(param2 - s_HelperRect.width - m_Type.displacementX,param3 - s_HelperRect.height - m_Type.displacementY);
            param1.copyPixels(_loc11_,s_HelperRect,s_TempPoint,null,null,true);
         }
      }
      
      public function get hang() : int
      {
         return this.m_Hang;
      }
      
      override public function getSpriteIndex(param1:int, param2:int, param3:int, param4:int) : uint
      {
         var _loc5_:int = param2 >= 0?int(param2):int(this.m_SpecialPatternX);
         var _loc6_:int = param3 >= 0?int(param3):int(this.m_SpecialPatternY);
         return super.getSpriteIndex(param1,_loc5_,_loc6_,param4);
      }
      
      public function set data(param1:int) : void
      {
         if(this.m_Data != param1)
         {
            this.m_Data = param1;
            this.updateSpecialPattern();
         }
      }
   }
}
