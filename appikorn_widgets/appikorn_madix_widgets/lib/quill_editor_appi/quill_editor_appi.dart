library quill_editor_appi;

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
// import 'package:webviewx/webviewx.dart';

enum OutputType { data, text }

class QuillEditorAppi extends StatelessWidget {
  const QuillEditorAppi({super.key, this.editable, required this.onChanged, required this.outputType, this.prefillJson, this.prefillString});
  final bool? editable;
  final Map<String, dynamic>? prefillJson;
  final String? prefillString;
  final void Function(String?) onChanged;
  final OutputType outputType; // Use the enum as a parameter

  @override
  Widget build(BuildContext context) {
    // late WebViewXController webViewXController;

    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      double parentHeight = constraints.maxHeight;
return Container();
      // return WebViewX(
      //   dartCallBacks: {
      //     DartCallback(
      //       name: 'TestDartCallback',
      //       callBack: (msg) {
      //         try {
      //           webViewXController.callJsMethod(outputType == OutputType.text ? 'get_output_string' : 'get_output_data', []).then((result) {
      //             onChanged(result);
      //           });
      //         } catch (e) {
      //           if (kDebugMode) {
      //             print(e);
      //           }
      //         }
      //       },
      //     )
      //   },
      //   navigationDelegate: (NavigationRequest request) {
      //     // Handle the navigation request conditionally here
      //
      //     return NavigationDecision.navigate;
      //   },
      //   ignoreAllGestures: (editable ?? true) == true ? false : true,
      //   webSpecificParams: const WebSpecificParams(webAllowFullscreenContent: true),
      //   initialContent: """
      // <html lang="en">
      //     <body>
      // <div class="editor-layout">
      //     <div id="editor">
      //         <p></p>
      //     </div>
      // </div>
      //
      // <link href="https://cdn.quilljs.com/1.3.6/quill.snow.css" rel="stylesheet">
      //
      // <script src="https://cdn.quilljs.com/1.3.6/quill.js"></script>
      // <!-- <script src="https://cdn.quilljs.com/1.2.2/quill.min.js"></script> -->
      // <script src="https://cdn.rawgit.com/kensnyder/quill-image-resize-module/3411c9a7/image-resize.min.js"></script>
      // <script src="https://cdn.jsdelivr.net/npm/quill-image-drop-module@1.0.2/image-drop.min.js"></script>
      // <script src="https://unpkg.com/quill-magic-url@3.0.0/dist/index.js"></script>
      // <script src="https://unpkg.com/quill-image-compress@1.2.11/dist/quill.imageCompressor.min.js"></script>
      //
      // <script>
      //     var toolbarOptions = [
      //         ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
      //         ['blockquote', 'code-block'],
      //         [{ 'header': 1 }, { 'header': 2 }],               // custom button values
      //         [{ 'list': 'ordered' }, { 'list': 'bullet' }],
      //         // [{ 'script': 'sub' }, { 'script': 'super' }],      // superscript/subscript
      //         [{ 'indent': '-1' }, { 'indent': '+1' }],          // outdent/indent
      //         // [{ 'direction': 'rtl' }],                         // text direction
      //         [{ 'size': ['small', false, 'large', 'huge'] }],  // custom dropdown
      //         // [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
      //         [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
      //         [{ 'font': [] }],
      //         [{ 'align': [] }],
      //         ['clean'],
      //         ['image'],
      //         ['spanblock'],
      //     ];
      //
      //     Quill.register("modules/imageCompressor", imageCompressor);
      //
      //     var quill = new Quill('#editor', {
      //         theme: 'snow',
      //         modules: {
      //             imageCompressor: {
      //                 quality: 1.0,
      //                 maxWidth: 700, // default
      //                 maxHeight: 700, // default
      //             },
      //             imageResize: {
      //                 displaySize: true
      //             },
      //             imageDrop: true,
      //             magicUrl: true,
      //             toolbar: toolbarOptions
      //         },
      //     });
      //
      //     function set_json(dat) {
      //         var res = JSON.parse(dat);
      //         console.log("sdfkasifha")
      //         console.log(res)
      //         var ops = res;
      //         quill.setContents(ops, 'api');
      //     }
      //
      //     function set_string(dat) {
      //         var ops = [{ insert: dat }];
      //         quill.setContents(ops, 'api');
      //     }
      //
      //     quill.on('text-change', function(delta, oldDelta, source) {
      //         if (source === 'user') {
      //             TestDartCallback("sss");
      //
      //
      //         }
      //     });
      //
      //     function get_output_string() {
      //         var data = quill.getText();
      //
      //          return data;
      //     }
      //
      //     function get_output_data() {
      //          var data = quill.getContents();
      //          var json = JSON.stringify(data);
      //
      //          return json;
      //     }
      //
      //     // Set the height of the editor dynamically
      //     var editorHeight = ${parentHeight - 70}; // Replace with your dynamic height variable
      //       document.querySelector("#editor").style.height = editorHeight + "px";
      //   </script>
      //
      //   <style>
      //       .editor-layout {
      //           position: relative;
      //       }
      //
      //       #editor {
      //           font-size: 20px;
      //           overflow-y: scroll;
      //       }
      //
      //       .ql-container.ql-snow {
      //           border: none !important;
      //           font-size: 20px;
      //           padding-top: 15px;
      //       }
      //
      //       .ql-editor {
      //           overflow-y: auto;
      //           height: 100%;
      //       }
      //   </style>
      //     </body>
      // </html>
      //
      //   """,
      //   initialSourceType: SourceType.html,
      //   onWebViewCreated: (controller) => webViewXController = controller,
      //   height: constraints.maxHeight,
      //   width: MediaQuery.of(context).size.width * 1,
      //   onPageStarted: (s) {
      //     // print("ssssssssssss");
      //     try {
      //       Future.delayed(const Duration(milliseconds: 100), () {
      //         if (prefillJson != null) {
      //           webViewXController.callJsMethod('set_json', [json.encode(prefillJson)]).then((result) {
      //             if (kDebugMode) {
      //               print("prefilled successfully");
      //             }
      //           });
      //         }
      //         if (prefillString != null) {
      //           webViewXController.callJsMethod('set_string', [prefillString]).then((result) {
      //             if (kDebugMode) {
      //               print("prefilled successfully");
      //             }
      //           });
      //         }
      //       });
      //     } catch (e) {
      //       if (kDebugMode) {
      //         print("this is prefill error sdfkasifha $e");
      //       }
      //     }
      //   },
      // );
    });
  }
}
