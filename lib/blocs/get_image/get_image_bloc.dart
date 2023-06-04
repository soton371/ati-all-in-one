import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'get_image_event.dart';
part 'get_image_state.dart';

class GetImageBloc extends Bloc<GetImageEvent, GetImageState> {
  GetImageBloc() : super(GetImageInitial()) {
    on<PickImageEvent>((event, emit) async {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: event.imageSource == 0 ? ImageSource
            .gallery : ImageSource.camera, // You can also use ImageSource.camera to open the camera
      );

      // Do something with the picked file, for example:
      if (pickedFile != null) {
        final File file = File(pickedFile.path);
        emit(GetImageSuccessState(file));
      }else{
        emit(GetImageFailedState());
      }
    });
  }
}
