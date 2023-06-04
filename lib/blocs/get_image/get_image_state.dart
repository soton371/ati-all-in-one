part of 'get_image_bloc.dart';

abstract class GetImageState extends Equatable {
  const GetImageState();
  
  @override
  List<Object> get props => [];
}

class GetImageInitial extends GetImageState {}


class GetImageSuccessState extends GetImageState {
  final File imageFile;
  const GetImageSuccessState(this.imageFile);
  @override
  List<Object> get props => [imageFile];
}


class GetImageFailedState extends GetImageState {}
