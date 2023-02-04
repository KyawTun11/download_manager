import 'package:download_manager_demo/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:get/get.dart';

import 'button_widget.dart';

class DownloadItem extends StatelessWidget {
  DownloadItem({
    Key? key,
    required this.url,
    required this.onDownloadPlayPausedPressed,
    required this.onDelete,
  }) : super(key: key);

  VoidCallback onDownloadPlayPausedPressed;
  VoidCallback onDelete;
  String url = "";

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(builder: (controller) {
      return Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                url,
                overflow: TextOverflow.ellipsis,
              ),
              if (controller.task != null)
                ValueListenableBuilder(
                    valueListenable: controller.task!.status,
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text("$value", style: TextStyle(fontSize: 16)),
                      );
                    }),
            ],
          ),
          // if (widget.item.isDownloadingOrPaused)
          if (controller.task != null &&
              !controller.task!.status.value.isCompleted)
            ValueListenableBuilder(
                valueListenable: controller.task!.progress,
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
                          value: value,
                          color: controller.task!.status.value ==
                                  DownloadStatus.paused
                              ? Colors.grey
                              : Colors.blue,
                        ),
                      ],
                    ),
                  );
                }),
          controller.task != null
              ? ValueListenableBuilder(
                  valueListenable: controller.task!.status,
                  builder: (context, value, child) {
                    switch (controller.task!.status.value) {
                      case DownloadStatus.downloading:
                        return ButtonWidget(
                          title: 'Paused',
                          onPressed: onDownloadPlayPausedPressed,
                          icon: Icons.pause,
                        );
                      case DownloadStatus.paused:
                        return ButtonWidget(
                          title: 'Resume',
                          onPressed: onDownloadPlayPausedPressed,
                          icon: Icons.play_arrow,
                        );
                      case DownloadStatus.completed:
                        return ButtonWidget(
                          title: 'Delete',
                          onPressed: onDownloadPlayPausedPressed,
                          icon: Icons.delete,
                        );
                      case DownloadStatus.failed:
                      case DownloadStatus.canceled:
                        return ButtonWidget(
                          title: 'Download',
                          onPressed: onDownloadPlayPausedPressed,
                          icon: Icons.download,
                        );
                      case DownloadStatus.queued:
                        // TODO: Handle this case.
                        break;
                    }
                    return Text("$value", style: TextStyle(fontSize: 16));
                  })
              : ButtonWidget(
                  title: 'Download',
                  onPressed: onDownloadPlayPausedPressed,
                  icon: Icons.download,
                ),
        ],
      );
    });
  }
}
