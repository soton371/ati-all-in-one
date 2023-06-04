part of 'get_image_bloc.dart';

abstract class GetImageEvent extends Equatable {
  const GetImageEvent();

  @override
  List<Object> get props => [];
}

class PickImageEvent extends GetImageEvent {
  final int imageSource;
  const PickImageEvent(this.imageSource);
  @override
  List<Object> get props => [imageSource];
}
