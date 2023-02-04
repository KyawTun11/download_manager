import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:get/get.dart';
import '../widget/download.dart';
import '../controllers/home_controller.dart';
import '../widget/download_item.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    var downloadManager = DownloadManager();
    String url = "http://download.dcloud.net.cn/HBuilder.9.0.2.macosx_64.dmg";
        //"https://jsoncompare.org/LearningContainer/SampleFiles/Video/MP4/sample-mp4-file.mp4";
    return Scaffold(
      appBar: AppBar(
        title: const Text('Download Manager'),
        centerTitle: true,
      ),
      body:
      //Download(url:url),
      DownloadItem(
        url: url,
        onDownloadPlayPausedPressed: () => controller.onDownload(url),
        onDelete: () => controller.onDeleteDownload(url),
      ),
    );
  }
}
