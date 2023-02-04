import 'dart:io';

import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class HomeController extends GetxController {
  var startDownload = false.obs;
  var savedDir = "";
  String url="";
  var dl = DownloadManager();
  DownloadTask? task;

  @override
  void onInit() {
   getApplicationSupportDirectory().then((value) => savedDir = value.path);
   super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}

  onDownload(url) async {
    task = dl.getDownload(url);
    if (task != null && !task!.status.value.isCompleted) {
      switch (task!.status.value) {
        case DownloadStatus.downloading:
          dl.pauseDownload(url);
          break;
        case DownloadStatus.paused:
          dl.resumeDownload(url);
          break;
        case DownloadStatus.queued:
          break;
        case DownloadStatus.completed:
          break;
        case DownloadStatus.failed:
          break;
        case DownloadStatus.canceled:
          break;
      }
    } else {
      dl.addDownload(
          url, "$savedDir/${dl.getFileNameFromUrl(url)}");
    }
    update();
  }

  onDeleteDownload(url) {
    var fileName = "$savedDir/${dl.getFileNameFromUrl(url)}";
    var file = File(fileName);
    file.delete();
    dl.removeDownload(url);
    update();
  }
}
