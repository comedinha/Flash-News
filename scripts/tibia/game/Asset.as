package tibia.game
{
   import tibia.appearances.AppearancesAsset;
   import tibia.options.OptionsAsset;
   import tibia.sessiondump.SessiondumpAsset;
   import tibia.sessiondump.hints.SessiondumpHintsAsset;
   import tibia.tutorial.TutorialProgressServiceAsset;
   import flash.system.System;
   import flash.utils.ByteArray;
   import shared.utility.SharedObjectManager;
   import flash.net.SharedObject;
   import flash.utils.setTimeout;
   import flash.events.Event;
   import flash.net.URLLoader;
   
   public class Asset extends AssetBase
   {
       
      
      private var m_RawBytes:ByteArray = null;
      
      protected var m_SaveAsLSO:Boolean = true;
      
      public function Asset(param1:String, param2:int)
      {
         super(param1,param2);
      }
      
      public static function s_FromXML(param1:XML) : AssetBase
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Vector.<int> = null;
         var _loc11_:uint = 0;
         var _loc12_:int = 0;
         var _loc2_:String = param1 != null?param1.localName():null;
         var _loc3_:XMLList = null;
         if(_loc2_ == "appearances" || _loc2_ == "binary" || _loc2_ == "currentOptions" || _loc2_ == "defaultOptions" || _loc2_ == "defaultOptionsTutorial" || _loc2_ == "tutorialProgressService" || _loc2_ == "sprites" || _loc2_ == "tutorialSessiondump" || _loc2_ == "tutorialSessiondumpHints" || _loc2_ == "tutorialProgressService")
         {
            if((_loc3_ = param1.url) == null || _loc3_.length() != 1)
            {
               return null;
            }
            _loc4_ = _loc3_[0].toString();
            _loc5_ = 0;
            if((_loc3_ = param1.size) != null && _loc3_.length() == 1 && _loc3_[0].toString().match(/^[1-9[0-9]*$/) != null)
            {
               _loc5_ = int(_loc3_[0].toString());
            }
            _loc6_ = 0;
            if((_loc3_ = param1.version) != null && _loc3_.length() == 1 && _loc3_[0].toString().match(/^[1-9[0-9]*$/) != null)
            {
               _loc6_ = int(_loc3_[0].toString());
            }
            if(_loc2_ != "currentOptions" && _loc2_ != "defaultOptions" && _loc2_ != "defaultOptionsTutorial" && _loc2_ != "tutorialProgressService" && _loc5_ < 1)
            {
               return null;
            }
            if(_loc2_ == "appearances")
            {
               return new AppearancesAsset(_loc4_,_loc5_,_loc6_);
            }
            if(_loc2_ == "binary")
            {
               return new GameBinaryAsset(_loc4_,_loc5_);
            }
            if(_loc2_ == "currentOptions")
            {
               return new OptionsAsset(_loc4_,_loc5_,"application/json",false,false);
            }
            if(_loc2_ == "defaultOptions")
            {
               return new OptionsAsset(_loc4_,_loc5_,"text/xml",true,false);
            }
            if(_loc2_ == "defaultOptionsTutorial")
            {
               return new OptionsAsset(_loc4_,_loc5_,"text/xml",true,true);
            }
            if(_loc2_ == "sprites")
            {
               _loc7_ = -1;
               if((_loc3_ = param1.firstSpriteID) != null && _loc3_.length() == 1 && _loc3_[0].toString().match(/^[0-9]+$/) != null)
               {
                  _loc7_ = int(_loc3_[0].toString());
               }
               _loc8_ = -1;
               if((_loc3_ = param1.lastSpriteID) != null && _loc3_.length() == 1 && _loc3_[0].toString().match(/^[0-9]+$/) != null)
               {
                  _loc8_ = int(_loc3_[0].toString());
               }
               _loc9_ = -1;
               if((_loc3_ = param1.spriteType) != null && _loc3_.length() == 1 && _loc3_[0].toString().match(/^[0-9]+$/) != null)
               {
                  _loc9_ = int(_loc3_[0].toString());
               }
               _loc10_ = new Vector.<int>();
               if((_loc3_ = param1.area) != null && _loc3_.length() > 0)
               {
                  _loc11_ = 0;
                  while(_loc11_ < _loc3_.length())
                  {
                     if(_loc3_[_loc11_].toString().match(/^[0-9]+$/) != null)
                     {
                        _loc12_ = int(_loc3_[_loc11_].toString());
                        _loc10_.push(_loc12_);
                     }
                     _loc11_++;
                  }
               }
               return new SpritesAsset(_loc4_,_loc5_,_loc7_,_loc8_,_loc9_,_loc10_);
            }
            if(_loc2_ == "tutorialSessiondump")
            {
               return new SessiondumpAsset(_loc4_,_loc5_);
            }
            if(_loc2_ == "tutorialSessiondumpHints")
            {
               return new SessiondumpHintsAsset(_loc4_,_loc5_);
            }
            if(_loc2_ == "tutorialProgressService")
            {
               return new TutorialProgressServiceAsset(_loc4_,_loc5_,"application/json");
            }
            return null;
         }
         return null;
      }
      
      override protected function resetDownloadedData() : void
      {
         this.m_RawBytes = null;
         System.pauseForGCIfCollectionImminent(0.95);
      }
      
      public function get rawBytes() : ByteArray
      {
         return this.m_RawBytes;
      }
      
      override public function load() : void
      {
         var _SharedObjectManager:SharedObjectManager = null;
         var _SharedObject:SharedObject = null;
         this.resetDownloadedData();
         if(this.m_SaveAsLSO)
         {
            _SharedObjectManager = SharedObjectManager.s_GetInstance();
            if(SharedObjectManager.s_SharedObjectsAvailable() && _SharedObjectManager != null)
            {
               try
               {
                  _SharedObject = _SharedObjectManager.getLocal(name);
                  this.m_RawBytes = _SharedObject.data.RAW_BYTES;
               }
               catch(e:*)
               {
               }
            }
            if(this.m_RawBytes != null && (size == 0 || this.m_RawBytes.length == size))
            {
               setTimeout(dispatchEvent,0,new Event(Event.COMPLETE,false,false));
            }
            else
            {
               super.load();
            }
         }
         else
         {
            super.load();
         }
      }
      
      override public function get loaded() : Boolean
      {
         return this.m_RawBytes != null || optional == true;
      }
      
      override protected function processDownloadedData(param1:URLLoader) : Boolean
      {
         var _SharedObject:SharedObject = null;
         var a_Loader:URLLoader = param1;
         this.m_RawBytes = a_Loader.data;
         var _SharedObjectManager:SharedObjectManager = SharedObjectManager.s_GetInstance();
         if(this.m_SaveAsLSO && SharedObjectManager.s_SharedObjectsAvailable() && _SharedObjectManager != null)
         {
            try
            {
               _SharedObject = _SharedObjectManager.getLocal(name);
               _SharedObject.data.RAW_BYTES = this.m_RawBytes;
               _SharedObject.flush();
               _SharedObjectManager.syncListing();
            }
            catch(e:*)
            {
            }
         }
         return true;
      }
   }
}
