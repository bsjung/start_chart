import 'candle_entity.dart';

class InfoWindowEntity {
  KLineEntity kLineEntity;
  bool isLeft = false;

  InfoWindowEntity(this.kLineEntity, this.isLeft);
}
