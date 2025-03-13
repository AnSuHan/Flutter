import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'Seekbar.dart';
import 'main.dart';

///일시정지 기능만 제공하고 다음 곡 선택 대신 dropdown button으로 처리하는 클래스
class StreamPlayer extends StatefulWidget {
  const StreamPlayer({super.key});

  @override
  State<StreamPlayer> createState() => _StreamPlayerState();
}

class _StreamPlayerState extends State<StreamPlayer> {
  String imgUrl =
      'https://firebasestorage.googleapis.com/v0/b/new-ml-6c02d.appspot.com/o/lessonAssets%2Fcs3%2Fch7%2Fls4%2Fearth.jpeg?alt=media&token=b9ce6139-5e08-495d-b74f-9dfce09e86e2';

  // Google Drive에서 생성한 직접 다운로드 링크
  String mp3Url = 'https://drive.google.com/uc?export=download&id=1SlS1Xn7r9sfgAtZOMxMxwB0P6_IeAX6s';
  String wavUrl = "https://drive.google.com/uc?export=download&id=1oyoDu3pbG_PSVBA1Fd1dmZmVPrUNgMWv";
  String opusUrl = "https://drive.google.com/uc?export=download&id=10UI16A-VLFzndCYp7YTyhwWXPknN8b6s";
  String oggUrl = "https://drive.google.com/uc?export=download&id=1arq0BfPyXqbjDRQrcEHr_jHotg-cUyiD";
  String flacUrl = "https://drive.google.com/uc?export=download&id=1LS06sSZ3e NSpW2Jz41DbSLbR3IgAAhrV";
  String keiserMp3Url = 'https://app.jigpu.com:2142/audio/mp3?audio_path=../../../data/[DBㅣ음원]/2019/2007-06-21ㅣ필윤 - E.J. Homage to Elvin Jones/(음원)/1. Nardis.mp3';
  String keiserMp3UrlCBR = 'https://app.jigpu.com:2142/audio/mp3?audio_path=../../../data/[DBㅣ음원]/2025/2025-02-25ㅣ강혜인 - CHARIS/(음원)/CBR/1. Slient Snow.mp3';

  late AudioPlayer player;
  bool isPlaying = false;
  double volume = 0.5;
  bool isVolumeDisabled = false;

  //dropdown button
  ///도메인(domain) : mp3, wav, opus, ogg, flac, mp3_keiser, mp3_cbr_keiser
  String currentFileExtension = "mp3";

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    _initialize("mp3");
  }

  void _initialize(String extension) async {
    // 기존에 재생 중인 오디오를 정지
    await player.stop();

    String url = "";
    switch(extension) {
      case "mp3":
        url = mp3Url;
        break;
      case "wav":
        url = wavUrl;
        break;
      case "opus":
        url = opusUrl;
        break;
      case "ogg":
        url = oggUrl;
        break;
      case "flac":
        url = flacUrl;
        break;
      case "mp3_keiser":
        url = keiserMp3Url;
        break;
      case "mp3_cbr_keiser":
        url = keiserMp3UrlCBR;
        break;
      default:
        url = mp3Url;
    }
    await player.setUrl(url); // 스트리밍 URL 설정
    await player.setVolume(volume);

    setState(() {
      isPlaying = false; // 새로운 URL 설정 후 재생 상태 초기화
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void _disableVolume() async {
    await player.setVolume(0);
    setState(() {
      if (volume > 0) {
        isVolumeDisabled = true;
      }
    });
  }

  void _activateVolume() async {
    await player.setVolume(volume);
    setState(() {
      isVolumeDisabled = false;
    });
  }

  IconData _getVolumeIcon() {
    return (player.volume == 0) ? Icons.volume_off : Icons.volume_up_rounded;
  }

  void _playAudio() async {
    setState(() {
      isPlaying = true;
    });
    await player.play();
  }

  void _pauseAudio() async {
    setState(() {
      isPlaying = false;
    });
    await player.pause();
  }

  IconData _getPlayPauseIcon() {
    return (player.playing) ? Icons.pause : Icons.play_arrow;
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
              (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Just Audio Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 300,
            child: Image.network(imgUrl),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  switch (isPlaying) {
                    case true:
                      return _pauseAudio();
                    default:
                      return _playAudio();
                  }
                },
                icon: Icon(_getPlayPauseIcon(), size: 50, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder<PositionData>(
            stream: _positionDataStream,
            builder: (context, snapshot) {
              final positionData = snapshot.data;
              Duration remaining = (positionData?.duration != null &&
                  positionData?.position != null)
                  ? positionData!.duration - positionData.position
                  : Duration.zero;
              return Row(
                children: [
                  Expanded(
                    child: SeekBar(
                      duration: positionData?.duration ?? Duration.zero,
                      position: positionData?.position ?? Duration.zero,
                      bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                      onChangeEnd: player.seek,
                    ),
                  ),
                  Text(
                    RegExp(r'((^0*[1-9]d*:)?d{2}:d{2}).d+$')
                        .firstMatch("$remaining")
                        ?.group(1) ??
                        '$remaining',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.white),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              IconButton(
                onPressed: () {
                  switch (isVolumeDisabled) {
                    case true:
                      return _activateVolume();
                    default:
                      return _disableVolume();
                  }
                },
                icon: Icon(_getVolumeIcon(), size: 30, color: Colors.white),
              ),
              Expanded(
                child: Slider(
                  value: player.volume,
                  max: 1,
                  min: 0,
                  onChanged: (value) async {
                    setState(() {
                      volume = value;
                    });
                    await player.setVolume(value);
                  },
                ),
              ),
            ],
          ),
          Center(
            child: DropdownButton<String>(
              dropdownColor: Colors.grey,
              value: currentFileExtension, // 현재 선택된 값
              items: const [
                DropdownMenuItem(
                  value: 'mp3',
                  child: Text('mp3', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'wav',
                  child: Text('wav', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'opus',
                  child: Text('opus', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'ogg',
                  child: Text('ogg', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'flac',
                  child: Text('flac', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'mp3_keiser',
                  child: Text('mp3_keiser', style: TextStyle(color: Colors.white)),
                ),
                DropdownMenuItem(
                  value: 'mp3_cbr_keiser',
                  child: Text('mp3_cbr_keiser', style: TextStyle(color: Colors.white)),
                ),
              ],
              onChanged: (String? newValue) {
                setState(() {
                  currentFileExtension = newValue!;
                  _initialize(currentFileExtension);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
