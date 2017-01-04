package mx.controls
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.HTTPStatusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import flash.system.ApplicationDomain;
   import flash.system.Capabilities;
   import flash.system.LoaderContext;
   import flash.system.SecurityDomain;
   import flash.utils.ByteArray;
   import mx.core.Application;
   import mx.core.FlexLoader;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.ISWFLoader;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.InterManagerRequest;
   import mx.events.InvalidateRequestData;
   import mx.events.SWFBridgeEvent;
   import mx.events.SWFBridgeRequest;
   import mx.managers.CursorManager;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManager;
   import mx.managers.SystemManagerGlobals;
   import mx.styles.ISimpleStyleClient;
   import mx.utils.LoaderUtil;
   
   use namespace mx_internal;
   
   public class SWFLoader extends UIComponent implements ISWFLoader
   {
      
      mx_internal static const VERSION:String = "3.6.0.21751";
       
      
      private var _loadForCompatibility:Boolean = false;
      
      private var _loaderContext:LoaderContext;
      
      private var requestedURL:URLRequest;
      
      private var _swfBridge:IEventDispatcher;
      
      private var _bytesTotal:Number = NaN;
      
      private var useUnloadAndStop:Boolean;
      
      private var flexContent:Boolean = false;
      
      private var explicitLoaderContext:Boolean = false;
      
      private var resizableContent:Boolean = false;
      
      private var brokenImageBorder:IFlexDisplayObject;
      
      private var _source:Object;
      
      private var _maintainAspectRatio:Boolean = true;
      
      private var mouseShield:Sprite;
      
      private var contentRequestID:String = null;
      
      private var _smoothBitmapContent:Boolean = false;
      
      mx_internal var contentHolder:DisplayObject;
      
      private var brokenImage:Boolean = false;
      
      private var _bytesLoaded:Number = NaN;
      
      private var _autoLoad:Boolean = true;
      
      private var _showBusyCursor:Boolean = false;
      
      private var _scaleContent:Boolean = true;
      
      private var isContentLoaded:Boolean = false;
      
      private var unloadAndStopGC:Boolean;
      
      private var smoothBitmapContentChanged:Boolean = false;
      
      private var _trustContent:Boolean = false;
      
      private var attemptingChildAppDomain:Boolean = false;
      
      private var scaleContentChanged:Boolean = false;
      
      private var contentChanged:Boolean = false;
      
      public function SWFLoader()
      {
         super();
         tabChildren = true;
         tabEnabled = false;
         addEventListener(FlexEvent.INITIALIZE,initializeHandler);
         addEventListener(Event.ADDED_TO_STAGE,addedToStageHandler);
         addEventListener(MouseEvent.CLICK,clickHandler);
         showInAutomationHierarchy = false;
      }
      
      public function get contentHeight() : Number
      {
         return !!contentHolder?Number(contentHolder.height):Number(NaN);
      }
      
      [Bindable("trustContentChanged")]
      public function get trustContent() : Boolean
      {
         return _trustContent;
      }
      
      public function set trustContent(param1:Boolean) : void
      {
         if(_trustContent != param1)
         {
            _trustContent = param1;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("trustContentChanged"));
         }
      }
      
      [Bindable("maintainAspectRatioChanged")]
      public function get maintainAspectRatio() : Boolean
      {
         return _maintainAspectRatio;
      }
      
      private function doScaleContent() : void
      {
         var interiorWidth:Number = NaN;
         var interiorHeight:Number = NaN;
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var x:Number = NaN;
         var y:Number = NaN;
         var newXScale:Number = NaN;
         var newYScale:Number = NaN;
         var scale:Number = NaN;
         var w:Number = NaN;
         var h:Number = NaN;
         var holder:Loader = null;
         var sizeSet:Boolean = false;
         var lInfo:LoaderInfo = null;
         if(!isContentLoaded)
         {
            return;
         }
         if(!resizableContent || maintainAspectRatio && !flexContent)
         {
            unScaleContent();
            interiorWidth = unscaledWidth;
            interiorHeight = unscaledHeight;
            contentWidth = contentHolderWidth;
            contentHeight = contentHolderHeight;
            x = 0;
            y = 0;
            newXScale = contentWidth == 0?Number(1):Number(interiorWidth / contentWidth);
            newYScale = contentHeight == 0?Number(1):Number(interiorHeight / contentHeight);
            if(_maintainAspectRatio)
            {
               if(newXScale > newYScale)
               {
                  x = Math.floor((interiorWidth - contentWidth * newYScale) * getHorizontalAlignValue());
                  scale = newYScale;
               }
               else
               {
                  y = Math.floor((interiorHeight - contentHeight * newXScale) * getVerticalAlignValue());
                  scale = newXScale;
               }
               contentHolder.scaleX = scale;
               contentHolder.scaleY = scale;
            }
            else
            {
               contentHolder.scaleX = newXScale;
               contentHolder.scaleY = newYScale;
            }
            contentHolder.x = x;
            contentHolder.y = y;
         }
         else
         {
            contentHolder.x = 0;
            contentHolder.y = 0;
            w = unscaledWidth;
            h = unscaledHeight;
            if(contentHolder is Loader)
            {
               holder = Loader(contentHolder);
               try
               {
                  if(getContentSize().x > 0)
                  {
                     sizeSet = false;
                     if(holder.contentLoaderInfo.contentType == "application/x-shockwave-flash")
                     {
                        if(childAllowsParent)
                        {
                           if(holder.content is IFlexDisplayObject)
                           {
                              IFlexDisplayObject(holder.content).setActualSize(w,h);
                              sizeSet = true;
                           }
                        }
                        if(!sizeSet && swfBridge)
                        {
                           swfBridge.dispatchEvent(new SWFBridgeRequest(SWFBridgeRequest.SET_ACTUAL_SIZE_REQUEST,false,false,null,{
                              "width":w,
                              "height":h
                           }));
                           sizeSet = true;
                        }
                     }
                     if(!sizeSet)
                     {
                        lInfo = holder.contentLoaderInfo;
                        if(lInfo)
                        {
                           contentHolder.scaleX = w / lInfo.width;
                           contentHolder.scaleY = h / lInfo.height;
                        }
                        else
                        {
                           contentHolder.width = w;
                           contentHolder.height = h;
                        }
                     }
                  }
                  else if(childAllowsParent && !(holder.content is IFlexDisplayObject))
                  {
                     contentHolder.width = w;
                     contentHolder.height = h;
                  }
               }
               catch(error:Error)
               {
                  contentHolder.width = w;
                  contentHolder.height = h;
               }
               if(!parentAllowsChild)
               {
                  contentHolder.scrollRect = new Rectangle(0,0,w / contentHolder.scaleX,h / contentHolder.scaleY);
               }
            }
            else
            {
               contentHolder.width = w;
               contentHolder.height = h;
            }
         }
      }
      
      private function unScaleContent() : void
      {
         contentHolder.scaleX = 1;
         contentHolder.scaleY = 1;
         contentHolder.x = 0;
         contentHolder.y = 0;
      }
      
      public function set maintainAspectRatio(param1:Boolean) : void
      {
         _maintainAspectRatio = param1;
         dispatchEvent(new Event("maintainAspectRatioChanged"));
      }
      
      override public function regenerateStyleCache(param1:Boolean) : void
      {
         var sm:ISystemManager = null;
         var recursive:Boolean = param1;
         super.regenerateStyleCache(recursive);
         try
         {
            sm = content as ISystemManager;
            if(sm != null)
            {
               Object(sm).regenerateStyleCache(recursive);
            }
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      private function get contentHolderHeight() : Number
      {
         var loaderInfo:LoaderInfo = null;
         var content:IFlexDisplayObject = null;
         var bridge:IEventDispatcher = null;
         var request:SWFBridgeRequest = null;
         var testContent:DisplayObject = null;
         if(contentHolder is Loader)
         {
            loaderInfo = Loader(contentHolder).contentLoaderInfo;
         }
         if(loaderInfo)
         {
            if(loaderInfo.contentType == "application/x-shockwave-flash")
            {
               try
               {
                  if(systemManager.swfBridgeGroup)
                  {
                     bridge = swfBridge;
                     if(bridge)
                     {
                        request = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                        bridge.dispatchEvent(request);
                        return request.data.height;
                     }
                  }
                  content = Loader(contentHolder).content as IFlexDisplayObject;
                  if(content)
                  {
                     return content.measuredHeight;
                  }
               }
               catch(error:Error)
               {
                  return contentHolder.height;
               }
            }
            else
            {
               try
               {
                  testContent = Loader(contentHolder).content;
               }
               catch(error:Error)
               {
                  return contentHolder.height;
               }
            }
            return loaderInfo.height;
         }
         if(contentHolder is IUIComponent)
         {
            return IUIComponent(contentHolder).getExplicitOrMeasuredHeight();
         }
         if(contentHolder is IFlexDisplayObject)
         {
            return IFlexDisplayObject(contentHolder).measuredHeight;
         }
         return contentHolder.height;
      }
      
      [Bindable("loaderContextChanged")]
      public function get loaderContext() : LoaderContext
      {
         return _loaderContext;
      }
      
      public function set showBusyCursor(param1:Boolean) : void
      {
         if(_showBusyCursor != param1)
         {
            _showBusyCursor = param1;
            if(_showBusyCursor)
            {
               CursorManager.registerToUseBusyCursor(this);
            }
            else
            {
               CursorManager.unRegisterToUseBusyCursor(this);
            }
         }
      }
      
      override public function notifyStyleChangeInChildren(param1:String, param2:Boolean) : void
      {
         var sm:ISystemManager = null;
         var styleProp:String = param1;
         var recursive:Boolean = param2;
         super.notifyStyleChangeInChildren(styleProp,recursive);
         try
         {
            sm = content as ISystemManager;
            if(sm != null)
            {
               Object(sm).notifyStyleChangeInChildren(styleProp,recursive);
            }
            return;
         }
         catch(error:Error)
         {
            return;
         }
      }
      
      private function getHorizontalAlignValue() : Number
      {
         var _loc1_:String = getStyle("horizontalAlign");
         if(_loc1_ == "left")
         {
            return 0;
         }
         if(_loc1_ == "right")
         {
            return 1;
         }
         return 0.5;
      }
      
      [Bindable("sourceChanged")]
      public function get source() : Object
      {
         return _source;
      }
      
      [Bindable("loadForCompatibilityChanged")]
      public function get loadForCompatibility() : Boolean
      {
         return _loadForCompatibility;
      }
      
      private function contentLoaderInfo_httpStatusEventHandler(param1:HTTPStatusEvent) : void
      {
         dispatchEvent(param1);
      }
      
      [Bindable("autoLoadChanged")]
      public function get autoLoad() : Boolean
      {
         return _autoLoad;
      }
      
      public function set source(param1:Object) : void
      {
         if(_source != param1)
         {
            _source = param1;
            contentChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("sourceChanged"));
         }
      }
      
      [Bindable("smoothBitmapContentChanged")]
      public function get smoothBitmapContent() : Boolean
      {
         return _smoothBitmapContent;
      }
      
      public function set loaderContext(param1:LoaderContext) : void
      {
         _loaderContext = param1;
         explicitLoaderContext = true;
         dispatchEvent(new Event("loaderContextChanged"));
      }
      
      private function get contentHolderWidth() : Number
      {
         var loaderInfo:LoaderInfo = null;
         var content:IFlexDisplayObject = null;
         var request:SWFBridgeRequest = null;
         var testContent:DisplayObject = null;
         if(contentHolder is Loader)
         {
            loaderInfo = Loader(contentHolder).contentLoaderInfo;
         }
         if(loaderInfo)
         {
            if(loaderInfo.contentType == "application/x-shockwave-flash")
            {
               try
               {
                  if(swfBridge)
                  {
                     request = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
                     swfBridge.dispatchEvent(request);
                     return request.data.width;
                  }
                  content = Loader(contentHolder).content as IFlexDisplayObject;
                  if(content)
                  {
                     return content.measuredWidth;
                  }
               }
               catch(error:Error)
               {
                  return contentHolder.width;
               }
            }
            else
            {
               try
               {
                  testContent = Loader(contentHolder).content;
               }
               catch(error:Error)
               {
                  return contentHolder.width;
               }
            }
            return loaderInfo.width;
         }
         if(contentHolder is IUIComponent)
         {
            return IUIComponent(contentHolder).getExplicitOrMeasuredWidth();
         }
         if(contentHolder is IFlexDisplayObject)
         {
            return IFlexDisplayObject(contentHolder).measuredWidth;
         }
         return contentHolder.width;
      }
      
      [Bindable("progress")]
      public function get bytesLoaded() : Number
      {
         return _bytesLoaded;
      }
      
      private function removeInitSystemManagerCompleteListener(param1:LoaderInfo) : void
      {
         var _loc2_:EventDispatcher = null;
         if(param1.contentType == "application/x-shockwave-flash")
         {
            _loc2_ = param1.sharedEvents;
            _loc2_.removeEventListener(SWFBridgeEvent.BRIDGE_NEW_APPLICATION,initSystemManagerCompleteEventHandler);
         }
      }
      
      public function set loadForCompatibility(param1:Boolean) : void
      {
         if(_loadForCompatibility != param1)
         {
            _loadForCompatibility = param1;
            contentChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("loadForCompatibilityChanged"));
         }
      }
      
      override protected function measure() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         super.measure();
         if(isContentLoaded)
         {
            _loc1_ = contentHolder.scaleX;
            _loc2_ = contentHolder.scaleY;
            contentHolder.scaleX = 1;
            contentHolder.scaleY = 1;
            measuredWidth = contentHolderWidth;
            measuredHeight = contentHolderHeight;
            contentHolder.scaleX = _loc1_;
            contentHolder.scaleY = _loc2_;
         }
         else if(!_source || _source == "")
         {
            measuredWidth = 0;
            measuredHeight = 0;
         }
      }
      
      private function contentLoaderInfo_initEventHandler(param1:Event) : void
      {
         dispatchEvent(param1);
         addInitSystemManagerCompleteListener(LoaderInfo(param1.target).loader.contentLoaderInfo);
      }
      
      public function set autoLoad(param1:Boolean) : void
      {
         if(_autoLoad != param1)
         {
            _autoLoad = param1;
            contentChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
            dispatchEvent(new Event("autoLoadChanged"));
         }
      }
      
      private function doScaleLoader() : void
      {
         if(!isContentLoaded)
         {
            return;
         }
         unScaleContent();
         var _loc1_:Number = unscaledWidth;
         var _loc2_:Number = unscaledHeight;
         if(contentHolderWidth > _loc1_ || contentHolderHeight > _loc2_ || !parentAllowsChild)
         {
            contentHolder.scrollRect = new Rectangle(0,0,_loc1_,_loc2_);
         }
         else
         {
            contentHolder.scrollRect = null;
         }
         contentHolder.x = (_loc1_ - contentHolderWidth) * getHorizontalAlignValue();
         contentHolder.y = (_loc2_ - contentHolderHeight) * getVerticalAlignValue();
      }
      
      public function get content() : DisplayObject
      {
         if(contentHolder is Loader)
         {
            return Loader(contentHolder).content;
         }
         return contentHolder;
      }
      
      public function unloadAndStop(param1:Boolean = true) : void
      {
         useUnloadAndStop = true;
         unloadAndStopGC = param1;
         source = null;
         if(!autoLoad)
         {
            load(null);
         }
      }
      
      public function set smoothBitmapContent(param1:Boolean) : void
      {
         if(_smoothBitmapContent != param1)
         {
            _smoothBitmapContent = param1;
            smoothBitmapContentChanged = true;
            invalidateDisplayList();
         }
         dispatchEvent(new Event("smoothBitmapContentChanged"));
      }
      
      private function dispatchInvalidateRequest(param1:Boolean, param2:Boolean, param3:Boolean) : void
      {
         var _loc4_:ISystemManager = systemManager;
         if(!_loc4_.useSWFBridge())
         {
            return;
         }
         var _loc5_:IEventDispatcher = _loc4_.swfBridgeGroup.parentBridge;
         var _loc6_:uint = 0;
         if(param1)
         {
            _loc6_ = _loc6_ | InvalidateRequestData.PROPERTIES;
         }
         if(param2)
         {
            _loc6_ = _loc6_ | InvalidateRequestData.SIZE;
         }
         if(param3)
         {
            _loc6_ = _loc6_ | InvalidateRequestData.DISPLAY_LIST;
         }
         var _loc7_:SWFBridgeRequest = new SWFBridgeRequest(SWFBridgeRequest.INVALIDATE_REQUEST,false,false,_loc5_,_loc6_);
         _loc5_.dispatchEvent(_loc7_);
      }
      
      private function contentLoaderInfo_progressEventHandler(param1:ProgressEvent) : void
      {
         _bytesTotal = param1.bytesTotal;
         _bytesLoaded = param1.bytesLoaded;
         dispatchEvent(param1);
      }
      
      public function getVisibleApplicationRect(param1:Boolean = false) : Rectangle
      {
         var _loc2_:Rectangle = getVisibleRect();
         if(param1)
         {
            _loc2_ = systemManager.getVisibleApplicationRect(_loc2_);
         }
         return _loc2_;
      }
      
      public function get showBusyCursor() : Boolean
      {
         return _showBusyCursor;
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return 0;
         }
         return super.baselinePosition;
      }
      
      private function initSystemManagerCompleteEventHandler(param1:Event) : void
      {
         var _loc3_:ISystemManager = null;
         var _loc2_:Object = Object(param1);
         if(contentHolder is Loader && _loc2_.data == Loader(contentHolder).contentLoaderInfo.sharedEvents)
         {
            _swfBridge = Loader(contentHolder).contentLoaderInfo.sharedEvents;
            _loc3_ = systemManager;
            _loc3_.addChildBridge(_swfBridge,this);
            removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
            _swfBridge.addEventListener(SWFBridgeRequest.INVALIDATE_REQUEST,invalidateRequestHandler);
         }
      }
      
      [Bindable("complete")]
      public function get bytesTotal() : Number
      {
         return _bytesTotal;
      }
      
      private function getVerticalAlignValue() : Number
      {
         var _loc1_:String = getStyle("verticalAlign");
         if(_loc1_ == "top")
         {
            return 0;
         }
         if(_loc1_ == "bottom")
         {
            return 1;
         }
         return 0.5;
      }
      
      private function contentLoaderInfo_unloadEventHandler(param1:Event) : void
      {
         var _loc2_:ISystemManager = null;
         isContentLoaded = false;
         dispatchEvent(param1);
         if(_swfBridge)
         {
            _swfBridge.removeEventListener(SWFBridgeRequest.INVALIDATE_REQUEST,invalidateRequestHandler);
            _loc2_ = systemManager;
            _loc2_.removeChildBridge(_swfBridge);
            _swfBridge = null;
         }
      }
      
      mx_internal function contentLoaderInfo_completeEventHandler(param1:Event) : void
      {
         if(LoaderInfo(param1.target).loader != contentHolder)
         {
            return;
         }
         dispatchEvent(param1);
         contentLoaded();
         if(contentHolder is Loader)
         {
            removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
         }
      }
      
      public function set scaleContent(param1:Boolean) : void
      {
         if(_scaleContent != param1)
         {
            _scaleContent = param1;
            scaleContentChanged = true;
            invalidateDisplayList();
         }
         dispatchEvent(new Event("scaleContentChanged"));
      }
      
      private function contentLoaderInfo_openEventHandler(param1:Event) : void
      {
         dispatchEvent(param1);
      }
      
      private function initializeHandler(param1:FlexEvent) : void
      {
         if(contentChanged)
         {
            contentChanged = false;
            if(_autoLoad)
            {
               load(_source);
            }
         }
      }
      
      protected function clickHandler(param1:MouseEvent) : void
      {
         if(!enabled)
         {
            param1.stopImmediatePropagation();
            return;
         }
      }
      
      private function addedToStageHandler(param1:Event) : void
      {
         systemManager.getSandboxRoot().addEventListener(InterManagerRequest.DRAG_MANAGER_REQUEST,mouseShieldHandler,false,0,true);
      }
      
      [Bindable("progress")]
      public function get percentLoaded() : Number
      {
         var _loc1_:Number = isNaN(_bytesTotal) || _bytesTotal == 0?Number(0):Number(100 * (_bytesLoaded / _bytesTotal));
         if(isNaN(_loc1_))
         {
            _loc1_ = 0;
         }
         return _loc1_;
      }
      
      private function doSmoothBitmapContent() : void
      {
         if(content is Bitmap)
         {
            (content as Bitmap).smoothing = _smoothBitmapContent;
         }
      }
      
      public function get swfBridge() : IEventDispatcher
      {
         return _swfBridge;
      }
      
      private function loadContent(param1:Object) : void
      {
         var child:DisplayObject = null;
         var cls:Class = null;
         var url:String = null;
         var byteArray:ByteArray = null;
         var loader:Loader = null;
         var lc:LoaderContext = null;
         var rootURL:String = null;
         var currentDomain:ApplicationDomain = null;
         var topmostDomain:ApplicationDomain = null;
         var message:String = null;
         var classOrString:Object = param1;
         if(classOrString is Class)
         {
            cls = Class(classOrString);
         }
         else if(classOrString is String)
         {
            try
            {
               cls = Class(systemManager.getDefinitionByName(String(classOrString)));
            }
            catch(e:Error)
            {
            }
            url = String(classOrString);
         }
         else if(classOrString is ByteArray)
         {
            byteArray = ByteArray(classOrString);
         }
         else
         {
            url = classOrString.toString();
         }
         if(cls)
         {
            contentHolder = child = new cls();
            addChild(child);
            contentLoaded();
         }
         else if(classOrString is DisplayObject)
         {
            contentHolder = child = DisplayObject(classOrString);
            addChild(child);
            contentLoaded();
         }
         else if(byteArray)
         {
            loader = new FlexLoader();
            contentHolder = child = loader;
            addChild(child);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,contentLoaderInfo_completeEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.INIT,contentLoaderInfo_initEventHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,contentLoaderInfo_ioErrorEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.UNLOAD,contentLoaderInfo_unloadEventHandler);
            loader.loadBytes(byteArray,loaderContext);
         }
         else if(url)
         {
            loader = new FlexLoader();
            contentHolder = child = loader;
            addChild(loader);
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,contentLoaderInfo_completeEventHandler);
            loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS,contentLoaderInfo_httpStatusEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.INIT,contentLoaderInfo_initEventHandler);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,contentLoaderInfo_ioErrorEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.OPEN,contentLoaderInfo_openEventHandler);
            loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,contentLoaderInfo_progressEventHandler);
            loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,contentLoaderInfo_securityErrorEventHandler);
            loader.contentLoaderInfo.addEventListener(Event.UNLOAD,contentLoaderInfo_unloadEventHandler);
            if(Capabilities.isDebugger == true && url.indexOf(".jpg") == -1 && LoaderUtil.normalizeURL(Application.application.systemManager.loaderInfo).indexOf("debug=true") > -1)
            {
               url = url + (url.indexOf("?") > -1?"&debug=true":"?debug=true");
            }
            if(!(url.indexOf(":") > -1 || url.indexOf("/") == 0 || url.indexOf("\\") == 0))
            {
               if(SystemManagerGlobals.bootstrapLoaderInfoURL != null && SystemManagerGlobals.bootstrapLoaderInfoURL != "")
               {
                  rootURL = SystemManagerGlobals.bootstrapLoaderInfoURL;
               }
               else if(root)
               {
                  rootURL = LoaderUtil.normalizeURL(root.loaderInfo);
               }
               else if(systemManager)
               {
                  rootURL = LoaderUtil.normalizeURL(DisplayObject(systemManager).loaderInfo);
               }
               if(rootURL)
               {
                  url = LoaderUtil.createAbsoluteURL(rootURL,url);
               }
            }
            requestedURL = new URLRequest(url);
            lc = loaderContext;
            if(!lc)
            {
               lc = new LoaderContext();
               _loaderContext = lc;
               if(loadForCompatibility)
               {
                  currentDomain = ApplicationDomain.currentDomain.parentDomain;
                  topmostDomain = null;
                  while(currentDomain)
                  {
                     topmostDomain = currentDomain;
                     currentDomain = currentDomain.parentDomain;
                  }
                  lc.applicationDomain = new ApplicationDomain(topmostDomain);
               }
               if(trustContent)
               {
                  lc.securityDomain = SecurityDomain.currentDomain;
               }
               else if(!loadForCompatibility)
               {
                  attemptingChildAppDomain = true;
                  lc.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
               }
            }
            loader.load(requestedURL,lc);
         }
         else
         {
            message = resourceManager.getString("controls","notLoadable",[source]);
            throw new Error(message);
         }
         invalidateDisplayList();
      }
      
      public function get contentWidth() : Number
      {
         return !!contentHolder?Number(contentHolder.width):Number(NaN);
      }
      
      [Bindable("scaleContentChanged")]
      public function get scaleContent() : Boolean
      {
         return _scaleContent;
      }
      
      public function get childAllowsParent() : Boolean
      {
         if(!isContentLoaded)
         {
            return false;
         }
         try
         {
            if(contentHolder is Loader)
            {
               return Loader(contentHolder).contentLoaderInfo.childAllowsParent;
            }
         }
         catch(error:Error)
         {
            return false;
         }
         return true;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(contentChanged)
         {
            contentChanged = false;
            if(_autoLoad)
            {
               load(_source);
            }
         }
      }
      
      private function contentLoaderInfo_securityErrorEventHandler(param1:SecurityErrorEvent) : void
      {
         var _loc2_:LoaderContext = null;
         if(attemptingChildAppDomain)
         {
            attemptingChildAppDomain = false;
            _loc2_ = new LoaderContext();
            _loaderContext = _loc2_;
            callLater(load);
            return;
         }
         dispatchEvent(param1);
         if(contentHolder is Loader)
         {
            removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
         }
      }
      
      private function sizeShield() : void
      {
         if(mouseShield && mouseShield.parent)
         {
            mouseShield.width = unscaledWidth;
            mouseShield.height = unscaledHeight;
         }
      }
      
      private function addInitSystemManagerCompleteListener(param1:LoaderInfo) : void
      {
         var _loc2_:EventDispatcher = null;
         if(param1.contentType == "application/x-shockwave-flash")
         {
            _loc2_ = param1.sharedEvents;
            _loc2_.addEventListener(SWFBridgeEvent.BRIDGE_NEW_APPLICATION,initSystemManagerCompleteEventHandler);
         }
      }
      
      private function invalidateRequestHandler(param1:Event) : void
      {
         if(param1 is SWFBridgeRequest)
         {
            return;
         }
         var _loc2_:SWFBridgeRequest = SWFBridgeRequest.marshal(param1);
         var _loc3_:uint = uint(_loc2_.data);
         if(_loc3_ & InvalidateRequestData.PROPERTIES)
         {
            invalidateProperties();
         }
         if(_loc3_ & InvalidateRequestData.SIZE)
         {
            invalidateSize();
         }
         if(_loc3_ & InvalidateRequestData.DISPLAY_LIST)
         {
            invalidateDisplayList();
         }
         dispatchInvalidateRequest((_loc3_ & InvalidateRequestData.PROPERTIES) != 0,(_loc3_ & InvalidateRequestData.SIZE) != 0,(_loc3_ & InvalidateRequestData.DISPLAY_LIST) != 0);
      }
      
      private function contentLoaded() : void
      {
         var loaderInfo:LoaderInfo = null;
         isContentLoaded = true;
         if(contentHolder is Loader)
         {
            loaderInfo = Loader(contentHolder).contentLoaderInfo;
         }
         resizableContent = false;
         if(loaderInfo)
         {
            if(loaderInfo.contentType == "application/x-shockwave-flash")
            {
               resizableContent = true;
            }
            if(resizableContent)
            {
               try
               {
                  if(Loader(contentHolder).content is IFlexDisplayObject)
                  {
                     flexContent = true;
                  }
                  else
                  {
                     flexContent = swfBridge != null;
                  }
               }
               catch(e:Error)
               {
                  flexContent = swfBridge != null;
               }
            }
         }
         try
         {
            if(tabChildren && contentHolder is Loader && (loaderInfo.contentType == "application/x-shockwave-flash" || Loader(contentHolder).content is DisplayObjectContainer))
            {
               Loader(contentHolder).tabChildren = true;
               DisplayObjectContainer(Loader(contentHolder).content).tabChildren = true;
            }
         }
         catch(e:Error)
         {
         }
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function getContentSize() : Point
      {
         var _loc3_:IEventDispatcher = null;
         var _loc4_:SWFBridgeRequest = null;
         var _loc1_:Point = new Point();
         if(!contentHolder is Loader)
         {
            return _loc1_;
         }
         var _loc2_:Loader = Loader(contentHolder);
         if(_loc2_.contentLoaderInfo.childAllowsParent)
         {
            _loc1_.x = _loc2_.content.width;
            _loc1_.y = _loc2_.content.height;
         }
         else
         {
            _loc3_ = swfBridge;
            if(_loc3_)
            {
               _loc4_ = new SWFBridgeRequest(SWFBridgeRequest.GET_SIZE_REQUEST);
               _loc3_.dispatchEvent(_loc4_);
               _loc1_.x = _loc4_.data.width;
               _loc1_.y = _loc4_.data.height;
            }
         }
         if(_loc1_.x == 0)
         {
            _loc1_.x = _loc2_.contentLoaderInfo.width;
         }
         if(_loc1_.y == 0)
         {
            _loc1_.y = _loc2_.contentLoaderInfo.height;
         }
         return _loc1_;
      }
      
      public function load(param1:Object = null) : void
      {
         var imageData:Bitmap = null;
         var request:SWFBridgeEvent = null;
         var url:Object = param1;
         if(url)
         {
            _source = url;
         }
         if(contentHolder)
         {
            if(isContentLoaded)
            {
               if(contentHolder is Loader)
               {
                  try
                  {
                     if(Loader(contentHolder).content is Bitmap)
                     {
                        imageData = Bitmap(Loader(contentHolder).content);
                        if(imageData.bitmapData)
                        {
                           imageData.bitmapData = null;
                        }
                     }
                  }
                  catch(error:Error)
                  {
                  }
                  if(_swfBridge)
                  {
                     request = new SWFBridgeEvent(SWFBridgeEvent.BRIDGE_APPLICATION_UNLOADING,false,false,_swfBridge);
                     _swfBridge.dispatchEvent(request);
                  }
                  if(childAllowsParent && content == SystemManager.lastSystemManager)
                  {
                     SystemManager.lastSystemManager = null;
                  }
                  removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
                  if(useUnloadAndStop && "unloadAndStop" in contentHolder)
                  {
                     contentHolder["unloadAndStop"](unloadAndStopGC);
                  }
                  else
                  {
                     Loader(contentHolder).unload();
                  }
                  if(!explicitLoaderContext)
                  {
                     _loaderContext = null;
                  }
               }
               else if(contentHolder is Bitmap)
               {
                  imageData = Bitmap(contentHolder);
                  if(imageData.bitmapData)
                  {
                     imageData.bitmapData = null;
                  }
               }
            }
            else if(contentHolder is Loader)
            {
               try
               {
                  Loader(contentHolder).close();
               }
               catch(error:Error)
               {
               }
            }
            try
            {
               if(contentHolder.parent == this)
               {
                  removeChild(contentHolder);
               }
            }
            catch(error:Error)
            {
               try
               {
                  removeChild(contentHolder);
               }
               catch(error1:Error)
               {
               }
            }
            contentHolder = null;
         }
         isContentLoaded = false;
         brokenImage = false;
         useUnloadAndStop = false;
         contentChanged = false;
         if(!_source || _source == "")
         {
            return;
         }
         loadContent(_source);
      }
      
      public function get parentAllowsChild() : Boolean
      {
         if(!isContentLoaded)
         {
            return false;
         }
         try
         {
            if(contentHolder is Loader)
            {
               return Loader(contentHolder).contentLoaderInfo.parentAllowsChild;
            }
         }
         catch(error:Error)
         {
            return false;
         }
         return true;
      }
      
      private function contentLoaderInfo_ioErrorEventHandler(param1:IOErrorEvent) : void
      {
         source = getStyle("brokenImageSkin");
         load();
         contentChanged = false;
         brokenImage = true;
         if(hasEventListener(param1.type))
         {
            dispatchEvent(param1);
         }
         if(contentHolder is Loader)
         {
            removeInitSystemManagerCompleteListener(Loader(contentHolder).contentLoaderInfo);
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         var _loc3_:Class = null;
         super.updateDisplayList(param1,param2);
         if(contentChanged)
         {
            contentChanged = false;
            if(_autoLoad)
            {
               load(_source);
            }
         }
         if(isContentLoaded)
         {
            if(_scaleContent && !brokenImage)
            {
               doScaleContent();
            }
            else
            {
               doScaleLoader();
            }
            scaleContentChanged = false;
            if(smoothBitmapContentChanged)
            {
               doSmoothBitmapContent();
               smoothBitmapContentChanged = false;
            }
         }
         if(brokenImage && !brokenImageBorder)
         {
            _loc3_ = getStyle("brokenImageBorderSkin");
            if(_loc3_)
            {
               brokenImageBorder = IFlexDisplayObject(new _loc3_());
               if(brokenImageBorder is ISimpleStyleClient)
               {
                  ISimpleStyleClient(brokenImageBorder).styleName = this;
               }
               addChild(DisplayObject(brokenImageBorder));
            }
         }
         else if(!brokenImage && brokenImageBorder)
         {
            removeChild(DisplayObject(brokenImageBorder));
            brokenImageBorder = null;
         }
         if(brokenImageBorder)
         {
            brokenImageBorder.setActualSize(param1,param2);
         }
         sizeShield();
      }
      
      private function mouseShieldHandler(param1:Event) : void
      {
         if(param1["name"] != "mouseShield")
         {
            return;
         }
         if(!isContentLoaded || parentAllowsChild)
         {
            return;
         }
         if(param1["value"])
         {
            if(!mouseShield)
            {
               mouseShield = new Sprite();
               mouseShield.graphics.beginFill(0,0);
               mouseShield.graphics.drawRect(0,0,100,100);
               mouseShield.graphics.endFill();
            }
            if(!mouseShield.parent)
            {
               addChild(mouseShield);
            }
            sizeShield();
         }
         else if(mouseShield && mouseShield.parent)
         {
            removeChild(mouseShield);
         }
      }
   }
}
