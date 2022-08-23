import 'dart:math';
import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:truviu_bvp/video_player/colors.dart';
import 'package:truviu_bvp/video_player/column_social_icon.dart';
import 'package:truviu_bvp/video_player/left_panel.dart';
import 'package:truviu_bvp/video_player/tiktok_icons.dart';

import 'data_json.dart';


class TestPage2 extends StatefulWidget {
  @override
  _TestPage2State createState() => _TestPage2State();
}

class _TestPage2State extends State<TestPage2>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _tabController = TabController(length: items.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return getBody();
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return RotatedBox(
      quarterTurns: 1,
      child: TabBarView(
        controller: _tabController,
        children: List.generate(items.length, (index) {
          return VideoPlayerItem(
            videoUrl: items[index]['videoUrl'],
            size: size,
            name: items[index]['name'],
            caption: items[index]['caption'],
            songName: items[index]['songName'],
            profileImg: items[index]['profileImg'],
            likes: items[index]['likes'],
            comments: items[index]['comments'],
            shares: items[index]['shares'],
            albumImg: items[index]['albumImg'],
          );
        }),
      ),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;
  final String name;
  final String caption;
  final String songName;
  final String profileImg;
  final String likes;
  final String comments;
  final String shares;
  final String albumImg;
  VideoPlayerItem(
      {Key? key,
        required this.size,
        required this.name,
        required this.caption,
        required this.songName,
        required this.profileImg,
        required this.likes,
        required this.comments,
        required this.shares,
        required this.albumImg,
        required this.videoUrl})
      : super(key: key);

  final Size size;

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  BetterPlayerController? _controller;
  bool _isPlaying = false;
  bool _disposed = false;

  Widget _playView(BuildContext context){
    final controller = _controller;
    if(controller!=null && controller.isVideoInitialized()!){
      return BetterPlayer(controller: controller);
    } else {
      return Center(
        child: Text("Loading...",
          style: TextStyle(
              fontSize: 20,
              color: Colors.white60
          ),),
      );
    }

  }
  @override
  void initState(){
    super.initState();
    _initializeVideo();
  }
  late BetterPlayerDataSource _betterPlayerDataSource;

  _initializeVideo() {
    _betterPlayerDataSource = BetterPlayerDataSource(BetterPlayerDataSourceType.network, widget.videoUrl);
    final controller = BetterPlayerController(BetterPlayerConfiguration(
      fullScreenByDefault: true,
      autoPlay: false,
      looping: true,
      // eventListener: _onControllerUpdate()
    ), betterPlayerDataSource: _betterPlayerDataSource);
    _controller = controller;
    setState((){});
    _controller?.setupDataSource(_betterPlayerDataSource);
    // controller..initialize().then((_) {
    //   _controller?.addListener(_onControllerUpdate);
    //   _controller?.play();
    //   setState(() {});
    // });
    // _controller?.setLooping(true);
  }

  @override
  void dispose() {
    _disposed=true;
    _controller?.pause();
    _controller?.dispose();
    _controller= null;
    super.dispose();


  }
  Widget isPlaying(){
    return _controller!.isPlaying()! && _isPlaying  ? Container() : Icon(Icons.play_arrow,size: 80,color: white.withOpacity(0.5),);
  }
  String convertTwo(int value){
    return value < 10 ? "0$value" : "$value";
  }
  @override
  Widget build(BuildContext context) {
    final duration = _duration?.inSeconds ?? 0;
    final head = _position?.inSeconds ?? 0;
    final remained = max(0, duration - head);
    final mins = convertTwo(remained ~/ 60.0);
    final secs = convertTwo(remained % 60);

    return InkWell(
      onTap: () {
        setState(() {
          _controller!.isPlaying()!
              ? _controller?.pause()
              : _controller?.play();
        });
      },
      child: RotatedBox(
        quarterTurns: -1,
        child: Container(
            height: widget.size.height,
            width: widget.size.width,
            child: Stack(
              children: <Widget>[
                Container(
                  height: widget.size.height,
                  width: widget.size.width,
                  decoration: BoxDecoration(color: black),
                  child: Stack(
                    children: <Widget>[
                      _playView(context),
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                          ),
                          child: isPlaying(),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom: 10,
                  child: Container(
                    height: widget.size.height,
                    width: widget.size.width,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 15, top: 20, bottom: 10),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            //HeaderHomePage(),
                            Expanded(
                                child: Row(
                                  children: <Widget>[
                                    LeftPanel(
                                      size: widget.size,
                                      name: "${widget.name}",
                                      caption: "${widget.caption}",
                                      songName: "${widget.songName}",
                                    ),
                                    RightPanel(
                                      size: widget.size,
                                      likes: "${widget.likes}",
                                      comments: "${widget.comments}",
                                      shares: "${widget.shares}",
                                      profileImg: "${widget.profileImg}",
                                      albumImg: "${widget.albumImg}",
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*0.865,
                  left: MediaQuery.of(context).size.width*0.85,
                  child: Text(
                    "$mins:$secs",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.white,
                        shadows: <Shadow>[
                          Shadow(
                              offset: Offset(0.0, 1.0),
                              blurRadius: 4.0,
                              color: Color.fromARGB(150, 0, 0, 0)
                          )
                        ]
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height*0.84,
                  child: SliderTheme(data: SliderTheme.of(context).copyWith(
                    activeTrackColor: Colors.white,
                    inactiveTrackColor: Colors.grey,
                    trackShape: RoundedRectSliderTrackShape(),
                    trackHeight: 2.0,
                    thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
                    thumbColor: Colors.white70,
                    overlayColor: Colors.white.withAlpha(32),
                    overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
                    tickMarkShape: RoundSliderTickMarkShape(),
                    activeTickMarkColor: Colors.white,
                    inactiveTickMarkColor: Colors.grey,
                    valueIndicatorShape: PaddleSliderValueIndicatorShape(),
                    valueIndicatorColor: Colors.white70,
                    valueIndicatorTextStyle: TextStyle(
                        color: Colors.black
                    ),
                  ),
                      child: Container(
                        width: MediaQuery.of(context).size.width*0.9,
                        child: Slider(
                          value: max(0, min(_progress * 100, 100)),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: _position?.toString().split(".")[0],
                          onChanged: (value) {
                            setState(() {
                              _progress = value * 0.01;
                            });
                          },
                          onChangeStart: (value) {
                            _controller?.pause();
                          },
                          onChangeEnd: (value) {
                            final duration = _controller?.videoPlayerController?.value.duration;
                            if(duration != null) {
                              var newValue = max(0, min(value, 99)) * 0.01;
                              var millis = (duration.inMilliseconds * newValue).toInt();
                              _controller?.seekTo(Duration(milliseconds: millis));
                              _controller?.play();
                            }
                          },
                        ),
                      )),
                )
              ],
            )),
      ),
    );
  }

  Duration? _duration;
  Duration? _position;
  var _progress=0.0;
  var _onUpdateControllerTime;
  _onControllerUpdate()async{
    if(_disposed){
      return;
    }
    _onUpdateControllerTime=0;
    final now = DateTime.now().microsecondsSinceEpoch;
    if(_onUpdateControllerTime>now){
      return;
    }
    _onUpdateControllerTime=now + 500;
    final controller = _controller;
    if(controller==null){
      debugPrint("Controller is null");
      return;
    }
    if(!controller.isVideoInitialized()!){
      debugPrint("Controller cannot be initialized");
      return;
    }
    if(_duration == null){
      _duration = _controller?.videoPlayerController?.value.duration;
    }
    var duration = _duration;
    if(duration == null) return;
    var position = await controller.videoPlayerController?.position;
    _position = position;
    final playing = controller.isPlaying();
    if(playing!){
      if (_disposed) return;
      setState(() {
        _progress = position!.inMilliseconds.ceilToDouble() / duration.inMilliseconds.ceilToDouble();
      });
    }
    _isPlaying = playing;
  }
}


class RightPanel extends StatelessWidget {
  final String likes;
  final String comments;
  final String shares;
  final String profileImg;
  final String albumImg;
  const RightPanel({
    Key? key,
    required this.size,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.profileImg,
    required this.albumImg,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: size.height,
        child: Column(
          children: <Widget>[
            Container(
              height: size.height * 0.5,
            ),
            Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getProfile(profileImg),
                    getIcons(TikTokIcons.heart, likes, 35.0),
                    getIcons(TikTokIcons.chat_bubble, comments, 35.0),
                    getIcons(TikTokIcons.reply, shares, 25.0),
                    getAlbum(albumImg)
                  ],
                ))
          ],
        ),
      ),
    );
  }
}