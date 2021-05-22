import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String downloadMessage = 'Downloading...';

  bool _isDownloading = false;
  double _percentage = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:   Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                label: Text('Download'),
                icon: Icon(
                  Icons.download_rounded,
                ),
                onPressed: () async {
                  setState(() {
                    _isDownloading = !_isDownloading;
                  });
                  String urlPath = 'https://cafebazaar.ir/download/bazaar.apk';
                  var dir = await getExternalStorageDirectory();

                  Dio dio = Dio();
                  dio.download(urlPath, '${dir.path}/sample.apk',
                      onReceiveProgress: (actualByte, totalByte) {
                        var percentage = actualByte / totalByte * 100;

                        if (percentage < 100) {
                          _percentage = percentage / 100;
                          setState(() {
                            downloadMessage =
                            'Downloading... ${percentage.floor()} %';
                          });
                        } else {
                          downloadMessage = 'Download  Successfully';
                        }
                      });
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                downloadMessage ?? '',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: LinearProgressIndicator(value: _percentage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
