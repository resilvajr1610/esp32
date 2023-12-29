import 'dart:async';
import 'package:esp32/main.dart';
import 'package:flutter/material.dart';
import 'package:gesture_zoom_box/gesture_zoom_box.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Home extends StatefulWidget {
  final WebSocketChannel channel;

  Home({
    required this.channel,
  });

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var _globalKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Câmera ESP32'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.8,
              width: MediaQuery.of(context).size.width*0.9,
              color: Colors.black,
              child: StreamBuilder(
                stream: widget.channel.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    Future.delayed(Duration(milliseconds: 100)).then((_) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      );
                    });
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    );
                  } else {
                    return  RepaintBoundary(
                      key: _globalKey,
                      child: GestureZoomBox(
                        maxScale: 5.0,
                        doubleTapScale: 2.0,
                        duration: Duration(milliseconds: 200),
                        child: Image.memory(
                          snapshot.data,
                          gaplessPlayback: true,
                          width: 350,
                          height: 150,
                        ),
                      ),
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.channel.sink.close();
    super.dispose();
  }
}

