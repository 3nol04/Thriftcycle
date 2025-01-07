import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thriftcycle/main.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  double _x1 = 0;
  double _x2 = 0;
  double _heightLogo = 0;
  double _dgLogo = 2;
  double _opacity = 1;
  double _widthLogo = 0;
  double _heightContainer = 0;
  double _weidthContainer = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
          // Perhitungan berdasarkan lebar layar
          _x1 = 1090.0;
          _x2 = -1000.0;
        });

    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        _heightLogo = 300.0;
        _widthLogo = 300.0;
        _dgLogo = 0;
      });
    });
    Future.delayed(const Duration(milliseconds: 4500), () {
      setState(() {
        _heightContainer = 4000.0;
        _weidthContainer = 4000.0;
        _opacity = 1;
      });
    });
    Timer(const Duration(milliseconds: 6000), () {
      setState(() {
            Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            children: [
              Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 3500),
                    curve: Curves.fastLinearToSlowEaseIn,
                    child: Stack(
                      children: [
                        Stack(
                          children: [
                            Center(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 3500),
                                curve: Curves.fastLinearToSlowEaseIn,
                                height: _heightLogo,
                                width: _widthLogo, //_heightLogo,
                                transform: Matrix4.rotationX(_dgLogo),
                                child: const Image(
                                  image: AssetImage('image/logo.png'),
                                ),
                              ),
                            ),
                          ],
                        ),
                        AnimatedPositioned(
                            duration: const Duration(milliseconds: 9000),
                            curve: Curves.easeOut,
                            width: MediaQuery.of(context).size.width * 3,
                            height: MediaQuery.of(context).size.height * 3,
                            top: MediaQuery.of(context).size.height * -1,
                            left: MediaQuery.of(context).size.width * -1,
                            child: AnimatedOpacity(
                              opacity: _opacity,
                              duration: const Duration(milliseconds: 3500),
                              child: Center(
                                child: AnimatedContainer(
                                  height: _heightContainer,
                                  width: _weidthContainer,
                                  duration: const Duration(milliseconds: 5000),
                                  decoration: const BoxDecoration(
                                      color: Color(0xFF2C7C7D),
                                      shape: BoxShape.circle),
                                ),
                              ),
                            )),

                        ///TODO BAWAH
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 5000),
                          curve: Curves.easeIn,
                          top: MediaQuery.of(context).size.height * 0,
                          left: MediaQuery.of(context).size.width * 1,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 5000),
                            curve: Curves.ease,
                            height: MediaQuery.of(context).size.height * 2,
                            width: MediaQuery.of(context).size.width * 2,
                            color: const Color(0xFF2C7C7D),
                            transform: Matrix4.identity()
                              ..rotateZ(MediaQuery.of(context).size.height /
                                  2000) // Rotasi (dalam radian) untuk memiringkan container
                              ..translate(
                                  _x1,
                                  MediaQuery.of(context).size.height *
                                      -0.2), // Pindahkan posisi container
                          ),
                        ),
                        //TODO ATAS
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 5000),
                          curve: Curves.ease,
                          top:
                              MediaQuery.of(context).size.height * -0.78, //-700
                          left: MediaQuery.of(context).size.width * -0.42, //-530
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 5000),
                            curve: Curves.ease,
                            height: MediaQuery.of(context).size.height * 2,
                            width: MediaQuery.of(context).size.width * 2,
                            color: const Color(0xFF1B6061),
                            transform: Matrix4.identity()
                              ..rotateZ(MediaQuery.of(context).size.height /
                                  2000) // 1400 2000 Rotasi (dalam radian55) untuk memiringkan container
                              ..translate(
                                  _x2,
                                  MediaQuery.of(context).size.height *
                                      -0.2), // Pindahkan posisi container
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
