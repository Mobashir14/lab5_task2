import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Animation Demo',
      home: AnimationDemo(),
    );
  }
}

class AnimationDemo extends StatefulWidget {
  const AnimationDemo({super.key});

  @override
  _AnimationDemoState createState() => _AnimationDemoState();
}

class _AnimationDemoState extends State<AnimationDemo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();

    // Initializing the AnimationController with 2 seconds duration
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Defining a Tween from 0 (start position) to 1 (end position)
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {}); // Rebuild to reflect animation changes
      })
      ..addStatusListener((status) {
        // Reverse the animation when it reaches the end
        if (status == AnimationStatus.completed) {
          _controller.reverse(); // Start the reverse animation
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward(); // Start the forward animation
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when the widget is removed
    super.dispose();
  }

  // Method to start/stop the animation
  void _toggleAnimation() {
    setState(() {
      if (isAnimating) {
        _controller.stop(); // Stop animation
      } else {
        if (_controller.status == AnimationStatus.reverse) {
          _controller.reverse();
        }
        else {
          _controller.forward();
        }
      }
      isAnimating = !isAnimating;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bounce Animation Example'),
      ),
      body: Stack(
        children: [
          Positioned(
            // Interpolating the animation value to move the container horizontally
            left: _animation.value * (MediaQuery.of(context).size.width - 50),
            top: MediaQuery.of(context).size.height / 2 - 25, // Center vertically
            child: Container(
              width: 50,
              height: 50,
              color: Colors.blue, // Animated box
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleAnimation, // Start or stop the animation
        child: Icon(isAnimating ? Icons.pause : Icons.play_arrow),
      ),
    );
  }
}
