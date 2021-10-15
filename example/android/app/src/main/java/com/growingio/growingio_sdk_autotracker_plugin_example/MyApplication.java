package com.growingio.growingio_sdk_autotracker_plugin_example;

import com.growingio.android.sdk.autotrack.CdpAutotrackConfiguration;
import com.growingio.android.sdk.autotrack.GrowingAutotracker;
import io.flutter.app.FlutterApplication;

public class MyApplication extends FlutterApplication {
    private static CdpAutotrackConfiguration sConfiguration;
    @Override
    public void onCreate() {
        super.onCreate();
        if (sConfiguration == null) {
            sConfiguration = new CdpAutotrackConfiguration("bfc5d6a3693a110d", "growing.d80871b41ef40518")
                    .setUploadExceptionEnabled(false)
                    .setDataSourceId("8deb3a4737d7aa00")
                    .setDebugEnabled(true);
        }
        GrowingAutotracker.startWithConfiguration(this, sConfiguration);
    }
}
