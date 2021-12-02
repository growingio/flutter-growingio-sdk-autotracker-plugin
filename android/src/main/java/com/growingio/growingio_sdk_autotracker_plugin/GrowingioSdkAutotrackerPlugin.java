package com.growingio.growingio_sdk_autotracker_plugin;

import android.content.res.Configuration;
import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;

import androidx.annotation.NonNull;

import java.io.ByteArrayOutputStream;
import java.util.Map;
import java.util.logging.Logger;

import com.growingio.android.sdk.autotrack.GrowingAutotracker;
import com.growingio.android.sdk.TrackerContext;
import com.growingio.android.sdk.track.TrackMainThread;
import com.growingio.android.sdk.track.events.PageEvent;
import com.growingio.android.sdk.track.events.ViewElementEvent;
import com.growingio.android.sdk.track.events.AutotrackEventType;
import com.growingio.android.sdk.track.events.AutotrackEventType;
import com.growingio.android.circler.screenshot.GrowingFlutterPlugin;
import com.growingio.android.circler.screenshot.ScreenshotProvider;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** GrowingioSdkTrackerPlugin */
public class GrowingioSdkAutotrackerPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private FlutterPluginBinding binding;
  private boolean isWebcircle = false;
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    binding = flutterPluginBinding;
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "growingio_sdk_autotracker_plugin");
    channel.setMethodCallHandler(this);
    GrowingFlutterPlugin.getInstance().addNativeListener(new GrowingFlutterPlugin.OnNativeListener() {
      @Override
      public void onNativeCircleStart() {
        channel.invokeMethod("WebCircle",true);
        isWebcircle = true;
      }

      @Override
      public void onNativeCircleStop() {
        channel.invokeMethod("WebCircle",false);
        isWebcircle = false;
      }
    });
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("trackCustomEvent")){
      onTrackCustomEvent(call);
    }else if (call.method.equals("setConversionVariables")){
      onSetConversionVariables(call);
    }else if (call.method.equals("setLoginUserAttributes")){
      onSetLoginUserAttributes(call);
    }else if (call.method.equals("setVisitorAttributes")) {
      onSetVisitorAttributes(call);
    }else if (call.method.equals("cleanLoginUserId")){
      onCleanLoginUserId();
    }else if (call.method.equals("setLoginUserId")){
      onSetLoginUserId(call);
    }else if (call.method.equals("flutterClickEvent")) {
      onFlutterClickEvent(call);
    }else if (call.method.equals("flutterViewChangeEvent")) {
      onFlutterViewChangeEvent(call);
    }else if (call.method.equals("flutterPageEvent")) {
      onFlutterPageEvent(call);
    }else if (call.method.equals("flutterWebCircleEvent")) {
      onFlutterWebCircleEvent(call);
    }else {
      result.notImplemented();
      return;
    }
    result.success(null);
  }

  private void onFlutterViewChangeEvent(MethodCall call) {
    onFlutterViewElementEvent(call,AutotrackEventType.VIEW_CHANGE);
  }
  private void onFlutterClickEvent(MethodCall call){
    onFlutterViewElementEvent(call,AutotrackEventType.VIEW_CLICK);
  }
  /// view element event
  private void onFlutterViewElementEvent(MethodCall call, String EventType) {
    Map<String,Object> params = (Map<String, Object>)call.arguments;
    long ts = Long.parseLong(params.get("pageShowTimestamp").toString());
    int index = Integer.parseInt(params.get("index").toString());
    Object textobj = params.get("textValue");
    String textValue = "";
    if (textobj != null) {
      textValue = textobj.toString();
    }
    TrackMainThread.trackMain().postEventToTrackMain(
            new ViewElementEvent.Builder()
                    .setEventType(EventType)
                    .setPath(params.get("path").toString())
                    .setPageShowTimestamp(ts)
                    .setXpath(params.get("xpath").toString())
                    .setIndex(index)
                    .setTextValue(textValue)
    );
    if (isWebcircle) {
      this.updateScreenshot();
      ScreenshotProvider.get().refreshScreenshot();
    }
  }

  private void updateScreenshot() {
    try {
      Bitmap screenshotBitmap = binding.getFlutterEngine().getRenderer().getBitmap();
      ByteArrayOutputStream stream = new ByteArrayOutputStream();
      screenshotBitmap.compress(Bitmap.CompressFormat.JPEG, 100, stream);
      stream.flush();
      stream.close();
      screenshotBitmap.recycle();
      GrowingFlutterPlugin.getInstance().setSrceenshotBytes(stream.toByteArray());
    } catch (Exception e) {
      Log.e("updateScreenshot",e.toString());
    }
  }

  private void onFlutterWebCircleEvent(MethodCall call) {
    Map<String,Object> params = (Map<String, Object>)call.arguments;
    Log.d("TAG", "onFlutterWebCircleEvent: " + params);
    GrowingFlutterPlugin.getInstance().onFlutterCircleData(params);
    if (isWebcircle) {
      this.updateScreenshot();
      ScreenshotProvider.get().refreshScreenshot();
    }
  }

  private void onFlutterPageEvent(MethodCall call){
    Map<String,Object> params = (Map<String, Object>)call.arguments;
    Log.d("TAG", "onFlutterPageEvent: " + params);
    long ts = Long.parseLong(params.get("timestamp").toString());
    String orientation = TrackerContext.get().getApplicationContext().getResources().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT
            ? PageEvent.ORIENTATION_PORTRAIT : PageEvent.ORIENTATION_LANDSCAPE;
    TrackMainThread.trackMain().postEventToTrackMain(
            new PageEvent.Builder()
                    .setPath(params.get("path").toString())
                    .setTitle(params.get("title").toString())
                    .setTimestamp(ts)
                    .setOrientation(orientation)
    );
    if (isWebcircle) {
      this.updateScreenshot();
      ScreenshotProvider.get().refreshScreenshot();
    }
  }

  private void onSetConversionVariables(MethodCall call){
    GrowingAutotracker.get().setConversionVariables((Map<String, String>)call.arguments);
  }

  private void onSetLoginUserAttributes(MethodCall call){
    GrowingAutotracker.get().setLoginUserAttributes((Map<String, String>)call.arguments);
  }

  private void onSetLoginUserId(MethodCall call){
    GrowingAutotracker.get().setLoginUserId((String)call.argument("userId"));
  }

  private void onCleanLoginUserId(){
    GrowingAutotracker.get().cleanLoginUserId();
  }

  private void onSetVisitorAttributes(MethodCall call){
    GrowingAutotracker.get().setVisitorAttributes((Map<String, String>)call.arguments);
  }

  private void onTrackCustomEvent(MethodCall call){
    String eventId = (String) call.argument("eventId");
    if (call.hasArgument("variable")){
      Map<String, String> variable = call.argument("variable");
      if (variable == null) return;
      GrowingAutotracker.get().trackCustomEvent(eventId, (Map<String, String>) variable);
    }else{
      GrowingAutotracker.get().trackCustomEvent(eventId);
    }
  }


  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
