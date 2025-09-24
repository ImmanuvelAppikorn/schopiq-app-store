
class UploadModel{
  final String? uploadlink;
  final String? uploadImage;
  final String? uploadTitle;
  final String? uploadDescription;

  UploadModel({this.uploadlink, this.uploadImage, this.uploadTitle, this.uploadDescription});

UploadModel merge(UploadModel other){
    return UploadModel(
      uploadlink: other.uploadlink ?? uploadlink,
      uploadImage: other.uploadImage ?? uploadImage,
      uploadTitle: other.uploadTitle ?? uploadTitle,
      uploadDescription: other.uploadDescription ?? uploadDescription,
    );
}


}