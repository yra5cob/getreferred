import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ReferAll/helper/UiUtilt.dart';

import 'helper/Util.dart';

class JDViewer extends StatelessWidget {
  final String jdlink;
  final String jdContent;

  const JDViewer({Key key, this.jdlink, this.jdContent}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        Navigator.pop(context);
      },
      child: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.black54,
          ),
          // height: MediaQuery.of(context).size.height,
          // width: MediaQuery.of(context).size.width,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadiusDirectional.circular(15),
                color: Colors.white),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(15),
                      color: Colors.white),
                  child: Material(
                    borderRadius: BorderRadiusDirectional.circular(15),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                            icon: ShaderMask(
                              blendMode: BlendMode.srcATop,
                              shaderCallback: (bounds) => RadialGradient(
                                center: Alignment.center,
                                radius: 0.5,
                                colors: [Util.getColor1(), Util.getColor2()],
                                tileMode: TileMode.mirror,
                              ).createShader(bounds),
                              child: Icon(
                                Icons.arrow_back_ios,
                                size: 28.0,
                                color: Colors.cyan,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        Expanded(
                            child: Text(
                          "Job Description",
                          style: TextStyle(
                              foreground: UIUtil.getTextGradient(),
                              fontSize: 20),
                        ))
                      ],
                    ),
                  ),
                ),
                if (jdlink != null)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.circular(15)),
                    height: MediaQuery.of(context).size.height * 0.75,
                    child: FutureBuilder(
                        future: Util.saveFileLocally(jdlink, "jd.pdf"),
                        builder: (context, snap) {
                          if (snap.hasData)
                            return PDFView(
                              filePath: snap.data.path,
                              enableSwipe: true,
                              swipeHorizontal: false,
                              autoSpacing: false,
                              pageFling: false,
                              onRender: (_pages) {
                                // setState(() {
                                //   pages = _pages;
                                //   isReady = true;
                                // });
                              },
                              onError: (error) {
                                print(error.toString());
                              },
                              onPageError: (page, error) {
                                print('$page: ${error.toString()}');
                              },
                              onViewCreated:
                                  (PDFViewController pdfViewController) {
                                // _controller.complete(pdfViewController);
                              },
                              onPageChanged: (int page, int total) {
                                print('page change: $page/$total');
                              },
                            );
                          else
                            return Center(child: CircularProgressIndicator());
                        }),
                  ),
                if (jdContent != null)
                  Container(
                    height: 600,
                    child: Markdown(
                      selectable: true,
                      data: jdContent,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
