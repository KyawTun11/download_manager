import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:path_provider/path_provider.dart';

class Download extends StatefulWidget {
  Download({
    Key? key,
    required this.url,
  }) : super(key: key);
  String url;

  @override
  State<Download> createState() => _DownloadState();
}

class _DownloadState extends State<Download> {
  var downloadManager = DownloadManager();
  var savedDir = "";
  DownloadTask? downloadTask;

  @override
  void initState() {
    getApplicationSupportDirectory().then((value) => savedDir = value.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    downloadTask = downloadManager.getDownload(widget.url);

    onDownloadPlayPausedPressed(url) async {
      setState(() {
        var task = downloadManager.getDownload(url);

        if (task != null && !task.status.value.isCompleted) {
          switch (task.status.value) {
            case DownloadStatus.downloading:
              downloadManager.pauseDownload(url);
              break;
            case DownloadStatus.paused:
              downloadManager.resumeDownload(url);
              break;
            case DownloadStatus.queued:
              // TODO: Handle this case.
              break;
            case DownloadStatus.completed:
              // TODO: Handle this case.
              break;
            case DownloadStatus.failed:
              // TODO: Handle this case.
              break;
            case DownloadStatus.canceled:
              // TODO: Handle this case.
              break;
          }
        } else {
          downloadManager.addDownload(
              url, "$savedDir/${downloadManager.getFileNameFromUrl(url)}");
        }
      });
    }

    onDelete(url) {
      var fileName = "$savedDir/${downloadManager.getFileNameFromUrl(url)}";
      var file = File(fileName);
      file.delete();

      downloadManager.removeDownload(url);
      setState(() {});
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.url,
                  overflow: TextOverflow.ellipsis,
                ),
                if (downloadTask != null)
                  ValueListenableBuilder(
                      valueListenable: downloadTask!.status,
                      builder: (context, value, child) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text("$value", style: const TextStyle(fontSize: 16)),
                        );
                      }),
              ],
            )),
            downloadTask != null
                ? ValueListenableBuilder(
                    valueListenable: downloadTask!.status,
                    builder: (context, value, child) {
                      switch (downloadTask!.status.value) {
                        case DownloadStatus.downloading:
                          return IconButton(
                              onPressed: () {
                                onDownloadPlayPausedPressed(widget.url);
                              },
                              icon: const Icon(Icons.pause));
                        case DownloadStatus.paused:
                          return IconButton(
                              onPressed: () {
                                onDownloadPlayPausedPressed(widget.url);
                              },
                              icon: const Icon(Icons.play_arrow));
                        case DownloadStatus.completed:
                          return IconButton(
                              onPressed: () {
                                onDelete(widget.url);
                              },
                              icon: const Icon(Icons.delete));
                        case DownloadStatus.failed:
                        case DownloadStatus.canceled:
                          return IconButton(
                              onPressed: () {
                                onDownloadPlayPausedPressed(widget.url);
                              },
                              icon: const Icon(Icons.download));
                        case DownloadStatus.queued:
                          // TODO: Handle this case.
                          break;
                      }
                      return Text("$value", style: const TextStyle(fontSize: 16));
                    })
                : IconButton(
                    onPressed: () {
                      onDownloadPlayPausedPressed(widget.url);
                    },
                    icon: const Icon(Icons.download))
          ],
        ), // if (widget.item.isDownloadingOrPaused)
        if (downloadTask != null && !downloadTask!.status.value.isCompleted)
          ValueListenableBuilder(
              valueListenable: downloadTask!.progress,
              builder: (context, value, child) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${value / 100} %"),
                          Text("$value%"),
                        ],
                      ),
                      SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: value ,
                        color:
                            downloadTask!.status.value == DownloadStatus.paused
                                ? Colors.grey
                                : Colors.blue,
                      ),
                    ],
                  ),
                );
              }),
      ],
    );
  }
}
