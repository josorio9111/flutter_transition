import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(useMaterial3: true),
        home: const MyPageView());
  }
}

class MyPageView extends StatefulWidget {
  const MyPageView({super.key});

  @override
  State<MyPageView> createState() => _MyPageViewState();
}

class _MyPageViewState extends State<MyPageView> {
  List lista = [];
  PageController controller = PageController();
  ValueNotifier<int> currentPage = ValueNotifier(0);
  ValueNotifier<bool> tapFavorite = ValueNotifier(false);
  ValueNotifier<bool> animateFavorite = ValueNotifier(false);

  @override
  void initState() {
    lista.add(["Primero", Colors.blue]);
    lista.add(["Segundo", Colors.amber]);
    lista.add(["Tercero", Colors.green]);
    super.initState();
  }

  void _updatePage(int value) {
    if ((currentPage.value == 0 && value == -1) ||
        (currentPage.value == lista.length - 1 && value == 1)) {
      return;
    }
    currentPage.value = (controller.page?.round() ?? 0) + value;
    controller.animateToPage(currentPage.value,
        duration: const Duration(milliseconds: 300), curve: Curves.linear);
  }

  Future delayFavorite() async {
    await Future.delayed(const Duration(seconds: 1));
    animateFavorite.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onVerticalDragEnd: (details) {
              double velocity = details.primaryVelocity ?? 0.0;
              if (velocity > 0) {
                // print("abajo");
                _updatePage(-1);
              } else {
                // print("arriba");
                _updatePage(1);
              }
            },
            onHorizontalDragEnd: (details) {
              double velocity = details.primaryVelocity ?? 0.0;
              if (velocity > 0) {
                // print("left");
                Navigator.push(context, navegarSlideLeft(const LeftPage()));
              } else {
                // print("rigth");
                Navigator.push(context, navegarSlideRigth(const RigthPage()));
              }
            },
            onTap: () async {
              print("tap");
              tapFavorite.value = tapFavorite.value ? false : true;
              animateFavorite.value = true;
              await delayFavorite();
            },
            child: PageView(
              scrollDirection: Axis.vertical,
              physics: const NeverScrollableScrollPhysics(),
              controller: controller,
              children: lista
                  .map<Widget>((e) => Container(
                        color: e[1] as Color,
                        child: Center(child: Text(e[0].toString())),
                      ))
                  .toList(),
            ),
          ),
          Positioned(
              top: kToolbarHeight,
              left: 8,
              child: IconButton(
                  onPressed: () {
                    Navigator.push(context, navegarSlideLeft(const LeftPage()));
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white70,
                    size: 35,
                  ))),
          Positioned(
              right: 8,
              bottom: kBottomNavigationBarHeight + 100,
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: tapFavorite,
                    builder: (_, value, __) {
                      return IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.favorite_border_outlined,
                              size: 35,
                              color: value ? Colors.red : Colors.white70));
                    },
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.messenger_outline,
                          size: 35, color: Colors.white70)),
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz,
                          size: 35, color: Colors.white70)),
                ],
              )),
          ValueListenableBuilder(
            valueListenable: animateFavorite,
            builder: (_, value, __) {
              return AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: value ? 1 : 0,
                child: const Center(
                  child: Icon(
                    Icons.favorite,
                    color: Colors.red,
                    size: 100,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class LeftPage extends StatelessWidget {
  const LeftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("LeftPage"),
      ),
    );
  }
}

class RigthPage extends StatelessWidget {
  const RigthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text("RigthPage"),
      ),
    );
  }
}

Route navegarFadeIn(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, _, child) => FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      ),
      child: child,
    ),
  );
}

Route navegarSlideRigth(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, _, child) => SlideTransition(
      position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
          .animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      ),
      child: child,
    ),
  );
}

Route navegarSlideLeft(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => page,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, _, child) => SlideTransition(
      position: Tween<Offset>(
              begin: const Offset(1.0, 0.0), end: const Offset(0.0, 0.0))
          .animate(
        CurvedAnimation(parent: animation, curve: Curves.easeOut),
      ),
      textDirection: TextDirection.rtl,
      child: child,
    ),
  );
}
