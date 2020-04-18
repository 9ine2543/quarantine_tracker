import 'package:flutter/material.dart';
class dashBoardMain extends StatefulWidget {
  final String name, surname, hospital;
  final days, log;
  final int total_away, total_lost;
  final List listData, areaData;

  dashBoardMain({this.name, this.surname, this.hospital, this.days, this.listData, this.total_away, this.total_lost, this.log, this.areaData});
  @override
  _dashBoardMainState createState() => _dashBoardMainState();
}

class _dashBoardMainState extends State<dashBoardMain> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.1,
              0.3,
              0.5,
              0.7,
            ],
            colors: [
              Color(0xFFFFA24C), 
              Color(0xFFFF8122),
              Color(0xFFFF6204),
              Color(0xFFF25300)
            ]
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0,-0.84),
              child: Container(
                child: Text(
                  'สวัสดี',
                  style: TextStyle(
                    color: Color(0xFF6B6B6B),
                    fontSize: 24
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment(0,-0.775),
              child: Container(
                child: Text(
                  'คุณ ${widget.name} ${widget.surname}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    letterSpacing: -2 
                  ),
                  ),
              )
            ),
            widget.hospital != null ? Align(
              alignment: Alignment(0,-0.64),
              child: Container(
                child: Text(
                  'โรงพยาบาล${widget.hospital}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    letterSpacing: -2,
                    fontWeight: FontWeight.w300 
                  ),
                ),
              )
            ):PreferredSize(
                child: Container(),
                preferredSize: Size(0.0, 0.0),
              ),
            Align(
              alignment: Alignment(0,-0.48),
              child: Container(
                child: Transform.scale(scale: 0.8, child: Image.asset('assets/logo/Union.png'))
              )
            ),
            Align(
              alignment: Alignment(0,-0.52),
              child: Container(
                child: Text(
                  'วันที่กักตัว',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Prompt',
                    fontSize: 20,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w100 
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment(0,-0.435),
              child: Container(
                child: Text(
                  '${widget.days.toString()}',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Prompt',
                    fontSize: 90,
                    // fontSize: 20,
                    letterSpacing: -1,
                    fontWeight: FontWeight.w100 
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment(-0.64,-0.165),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white 
                ),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => outOfAreaMain(name: widget.name,surname: widget.surname,areaData: widget.areaData)));
                  },
                  child: Stack(
                    children: <Widget>[
                        Align(
                          alignment: Alignment(0, -0.75),
                          child: Text(
                            'ออกนอก',
                            style: TextStyle(
                              color: Color(0xFF5B5B5B),
                              letterSpacing: -0.5,
                              fontSize: 13
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0, -0.4),
                          child: Text(
                            'เขตบ้าน',
                            style: TextStyle(
                              color: Color(0xFF5B5B5B),
                              letterSpacing: -0.5,
                              fontSize: 13
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment(0, 1.89),
                          child: Text(
                            '${widget.total_away}',
                            style: TextStyle(
                              color: Color(0xFF5B5B5B),
                              fontFamily: 'Prompt',
                              letterSpacing: -0.5,
                              fontSize: 48
                            ),
                          ),
                        )
                    ], 
                  ),
                  shape: new CircleBorder(),
                  elevation: 0,
                  fillColor: Colors.white,
                )
              )
            ),
            Align(
              alignment: Alignment(0.64,-0.165),
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white 
                ),
                child: Stack(
                 children: <Widget>[
                    Align(
                      alignment: Alignment(0, -0.75),
                      child: Text(
                        'ขาดการ',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          letterSpacing: -0.5,
                          fontSize: 13
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.4),
                      child: Text(
                        'เชื่อมต่อ',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          letterSpacing: -0.5,
                          fontSize: 13
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, 1.89),
                      child: Text(
                        '${widget.total_lost}',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          fontFamily: 'Prompt',
                          letterSpacing: -0.5,
                          fontSize: 48
                        ),
                      ),
                    )
                 ], 
                ),
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(60))
                ),
                padding: EdgeInsets.symmetric(horizontal: 21),
                child: ListView(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'วันที่',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFF6204),
                            fontWeight: FontWeight.w600
                          ),
                          ),
                        Spacer(flex: 10,),
                        Text(
                          'วันที่',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFF6204),
                            fontWeight: FontWeight.w600
                          ),
                          ),
                        Spacer(flex: 10,),
                        Text(
                          'ออกนอกบ้าน',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFF6204),
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1
                          ),
                          ),
                        Spacer(flex: 2,),
                        Text(
                          'ขาดการเชื่อมต่อ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFFF6204),
                            fontWeight: FontWeight.w600,
                            letterSpacing: -1
                          ),
                          ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/3,
                      color: Colors.transparent,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.listData.length,
                        itemBuilder: (BuildContext ctxt, int index){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 26,
                            padding: EdgeInsets.only(bottom: 10),
                            child: Stack(
                              children: <Widget>[
                                Align(alignment: Alignment(-0.94,0), child: Text(widget.listData[index][0],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B)))),
                                Align(alignment: Alignment(-0.7,0),child: Text(widget.listData[index][1],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B)))),
                                Align(alignment: Alignment(0.04,0),child: Text(widget.listData[index][2],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B)))),
                                Align(alignment: Alignment(0.68,0),child: Text(widget.listData[index][3],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B))))
                              ],
                            )
                          );
                        },
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        widget.log
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class outOfAreaMain extends StatefulWidget {
  final String name, surname;
  final List areaData;
  outOfAreaMain({this.name, this.surname, this.areaData});
  @override
  _outOfAreaMainState createState() => _outOfAreaMainState();
}

class _outOfAreaMainState extends State<outOfAreaMain> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [
              0.1,
              0.3,
              0.5,
              0.7,
            ],
            colors: [
              Color(0xFFFFA24C), 
              Color(0xFFFF8122),
              Color(0xFFFF6204),
              Color(0xFFF25300)
            ]
          ),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(0,-0.84),
              child: Container(
                child: Text(
                  'สวัสดี',
                  style: TextStyle(
                    color: Color(0xFF6B6B6B),
                    fontSize: 24
                  ),
                ),
              )
            ),
            Align(
              alignment: Alignment(0,-0.775),
              child: Container(
                child: Text(
                  'คุณ ${widget.name} ${widget.surname}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    letterSpacing: -2 
                  ),
                  ),
              )
            ),
            Align(
              alignment: Alignment(-0.89,-0.89),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white 
                ),
                child: RawMaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back_ios),
                  shape: new CircleBorder(),
                  elevation: 0,
                  fillColor: Colors.white,
                )
              )
            ),
            Align(
              alignment: Alignment(0,-0.45),
              child: Container(
                height: 140,
                width: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white 
                ),
                child: Stack(
                 children: <Widget>[
                    Align(
                      alignment: Alignment(0, -0.75),
                      child: Text(
                        'ออกนอก',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          letterSpacing: -0.5,
                          fontSize: 16
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0, -0.4),
                      child: Text(
                        'เขตบ้าน',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          letterSpacing: -0.5,
                          fontSize: 16
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment(0,1.4),
                      child: Text(
                        // '${widget.total_away}',
                        '0',
                        style: TextStyle(
                          color: Color(0xFF5B5B5B),
                          fontFamily: 'Prompt',
                          letterSpacing: -0.5,
                          fontSize: 72
                        ),
                      ),
                    )
                 ], 
                ),
              )
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/1.75,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(60))
                ),
                padding: EdgeInsets.symmetric(horizontal: 21),
                child: ListView(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Align(alignment: Alignment(-0.95,0), child: Text('ครั้งที่',style: TextStyle(fontSize: 16,color: Color(0xFFFF6204),fontWeight: FontWeight.w600))),
                        Align(alignment: Alignment(-0.45,0), child: Text('วันที่',style: TextStyle(fontSize: 16,color: Color(0xFFFF6204),fontWeight: FontWeight.w600))),
                        Align(alignment: Alignment(0,0), child: Text('เวลา',style: TextStyle(fontSize: 16,color: Color(0xFFFF6204),fontWeight: FontWeight.w600,))),
                        Align(alignment: Alignment(0.5,0), child: Text('สถานะ',style: TextStyle(fontSize: 16,color: Color(0xFFFF6204),fontWeight: FontWeight.w600,))),
                        Align(alignment: Alignment(0.9,0), child: Text('ระยะ',style: TextStyle(fontSize: 16,color: Color(0xFFFF6204),fontWeight: FontWeight.w600,))),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height/2.1,
                      // color: Colors.red,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: widget.areaData.length,
                        itemBuilder: (BuildContext ctxt, int index){
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            height: 26,
                            padding: EdgeInsets.only(bottom: 10),
                            child: Stack(
                              children: <Widget>[
                                // Align(alignment: Alignment(-0.85,0), child: Text(widget.areaData[index][0],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B)))),
                                // Align(alignment: Alignment(-0.58,0),child: Text(widget.areaData[index][1],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B)))),
                                // Align(alignment: Alignment(0,0),child: Text(widget.areaData[index][2],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B)))),
                                // Align(alignment: Alignment(0.43,0),child: Text(widget.areaData[index][3],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B)))),
                                // Align(alignment: Alignment(0.87,0),child: Text(widget.areaData[index][4],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B))))
                                Align(alignment: Alignment(-0.85,0), child: Text(widget.areaData[index][5],style: TextStyle(fontSize: 16,color: Color(0xFF5B5B5B)))),
                                Align(alignment: Alignment(-0.65,0), child: Text(widget.areaData[index][0],style: TextStyle(fontSize: 12,color: Color(0xFF5B5B5B)))),
                                Align(alignment: Alignment(-0.05,0),child: Text(widget.areaData[index][1],style: TextStyle(fontSize: 12,color: Color(0xFF5B5B5B)))),
                                Align(alignment: Alignment(0.4,0),child: Text(widget.areaData[index][2],style: TextStyle(fontSize: 12,color: Color(0xFF5B5B5B)))),
                                Align(alignment: Alignment(0.58,0),child: Text(widget.areaData[index][3],style: TextStyle(fontSize: 12,color: Color(0xFF5B5B5B)))),
                                Align(alignment: Alignment(0.87,0),child: Text(widget.areaData[index][4],style: TextStyle(fontSize: 12,color: Color(0xFF5B5B5B))))
                              ],
                            )
                          );
                        },
                      ),
                    ),
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   child: Text(
                    //     widget.log
                    //   ),
                    // )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}