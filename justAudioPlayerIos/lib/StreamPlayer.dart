import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import 'Seekbar.dart';
import 'main.dart';

///일시정지 기능 & 이전 곡 & 다음 곡 기능을 제공하는 클래스
class StreamPlayer extends StatefulWidget {
  const StreamPlayer({super.key});

  @override
  State<StreamPlayer> createState() => _StreamPlayerState();
}

class _StreamPlayerState extends State<StreamPlayer> {
  String imagePrefix = "https://app.jigpu.com:2142/image/hd/?image_path=";
  String mp3Prefix = "https://app.jigpu.com:2142/audio/mp3?audio_path=";
  List<String> keiserImageList = [
    "../../../data/[DBㅣ음원]/2019/2007-06-21ㅣ필윤 - E.J. Homage to Elvin Jones/필윤 - E.J. Homage to Elvin Jonesㅣ앨범커버.webp",
    "../../../data/[DBㅣ음원]/2020/2020-11-30ㅣStraight Ahead - New Time/Straight Ahead - New Timeㅣ앨범커버.webp",
    "../../../data/[DBㅣ음원]/2023/2023-12-20ㅣ강혜인 - Sky Above/강혜인 - Sky Aboveㅣ앨범커버ㅣ원본.webp",
    "../../../data/[DBㅣ음원]/2022/2022-01-01ㅣ곽윤찬 - OLIVET/곽윤찬 - OLIVETㅣ앨범커버.webp",
    "../../../data/[DBㅣ음원]/2022/2022-06-30ㅣ이은정 - 바다/이은정 - 바다ㅣ앨범커버.webp"
  ];
  // keiser 음원 (mp3) 배열
  List<String> keiserMp3List = [
    "../../../data/[DBㅣ음원]/2019/2007-06-21ㅣ필윤 - E.J. Homage to Elvin Jones/(음원)/5. E.J..mp3",
    "../../../data/[DBㅣ음원]/2020/2020-11-30ㅣStraight Ahead - New Time/(음원)/6. Floating On The River.mp3",
    "../../../data/[DBㅣ음원]/2023/2023-12-20ㅣ강혜인 - Sky Above/(음원)/mp3/6. Redeemed from the Earth.mp3",
    "../../../data/[DBㅣ음원]/2022/2022-01-01ㅣ곽윤찬 - OLIVET/(음원)/flac, mp3/01. Light Year.mp3",
    "../../../data/[DBㅣ음원]/2022/2022-06-30ㅣ이은정 - 바다/(음원)/01. 바다.mp3"
  ];
  int playingIndex = 0;

  late AudioPlayer player;
  bool isPlaying = false;
  double volume = 0.5;
  bool isVolumeDisabled = false;

  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    player.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
      debugPrint("Player state changed: playing = ${state.playing}");
    });

    //음원 끝에 도달하면 다음 곡 이동
    player.playbackEventStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        playingIndex++;
        if(playingIndex > keiserMp3List.length - 1) {
          playingIndex = 0;
        }
        _initialize(changeAudio: true);
      }
    });

    _initialize(changeAudio: true); //앱 실행 시 url 설정
  }

  void _initialize({bool changeAudio = false}) async {
    // 기존에 재생 중인 오디오를 정지
    await player.stop();

    if(changeAudio) {
      String url = mp3Prefix + keiserMp3List[playingIndex];
      await player.setUrl(url); // 스트리밍 URL 설정
      await player.setVolume(volume);

      // Seekbar를 0초로 이동
      await player.seek(Duration.zero);
    }

    setState(() {
      isPlaying = false; // 새로운 URL 설정 후 재생 상태 초기화
    });
    debugPrint("Initialization complete. isPlaying = $isPlaying");
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
    if (!isPlaying) {
      await player.play();
      if (player.playing) {  // 실제로 재생이 시작되었는지 확인
        setState(() {
          isPlaying = true;
        });
      }
    }
    debugPrint("_playAudio complete. isPlaying = $isPlaying");
  }

  void _pauseAudio() async {
    if(isPlaying) {
      await player.pause();
      if (!player.playing) {  // 실제로 일시정지되었는지 확인
        setState(() {
          isPlaying = false;
        });
      }
    }
    debugPrint("_pauseAudio complete. isPlaying = $isPlaying");
  }

  IconData _getPlayPauseIcon() {
    debugPrint("in _getPlayPauseIcon. isPlaying = $isPlaying");
    return isPlaying ? Icons.pause : Icons.play_arrow;
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 200,
            width: 300,
            child: Image.network(imagePrefix + keiserImageList[playingIndex]),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //이전 곡
              IconButton(
                onPressed: () {
                  playingIndex--;
                  if(playingIndex < 0) {
                    playingIndex = keiserMp3List.length - 1;
                  }
                  _initialize(changeAudio: true);
                },
                icon: Icon(Icons.chevron_left, size: 50, color: Colors.white),
              ),
              //일시정지
              IconButton(
                onPressed: () {
                  if (isPlaying) {
                    _pauseAudio();
                  } else {
                    _playAudio();
                  }
                },
                icon: Icon(_getPlayPauseIcon(), size: 50, color: Colors.white),
              ),
              //다음 곡
              IconButton(
                onPressed: () {
                  playingIndex++;
                  if(playingIndex > keiserMp3List.length - 1) {
                    playingIndex = 0;
                  }
                  _initialize(changeAudio: true);
                },
                icon: Icon(Icons.chevron_right, size: 50, color: Colors.white),
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
        ],
      ),
    );
  }
}
