import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';

class Video extends StatefulWidget {
  final session_link;

  const Video({Key key, this.session_link}) : super(key: key);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.session_link)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : Container(),
          ),
          Row(
            children: [
              Controls(
                icon: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                ),
                onpressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
              ),
             Controls(icon:Icon(Icons.volume_down_rounded),onpressed: (){ setState(() {
               _controller.setVolume(2.5);
             });},),
             Text(_controller.value.duration.inMinutes.toString())
            ],
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class Controls extends StatelessWidget {
  final Function onpressed;
  final Icon icon;

  const Controls({Key key, this.onpressed, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onpressed,
      icon: icon,
    );
  }
}
