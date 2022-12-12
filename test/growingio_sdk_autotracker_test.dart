import 'package:flutter_test/flutter_test.dart';
import 'package:growingio_sdk_autotracker/growingio_sdk_autotracker.dart';
import 'package:growingio_sdk_autotracker/growingio_sdk_autotracker_platform_interface.dart';
import 'package:growingio_sdk_autotracker/growingio_sdk_autotracker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGrowingioSdkAutotrackerPlatform
    with MockPlatformInterfaceMixin
    implements GrowingioSdkAutotrackerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GrowingioSdkAutotrackerPlatform initialPlatform = GrowingioSdkAutotrackerPlatform.instance;

  test('$MethodChannelGrowingioSdkAutotracker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGrowingioSdkAutotracker>());
  });

  test('getPlatformVersion', () async {
    GrowingioSdkAutotracker growingioSdkAutotrackerPlugin = GrowingioSdkAutotracker();
    MockGrowingioSdkAutotrackerPlatform fakePlatform = MockGrowingioSdkAutotrackerPlatform();
    GrowingioSdkAutotrackerPlatform.instance = fakePlatform;

    expect(await growingioSdkAutotrackerPlugin.getPlatformVersion(), '42');
  });
}
