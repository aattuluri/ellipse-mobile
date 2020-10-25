import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SliderOpen { LEFT_TO_RIGHT, RIGHT_TO_LEFT, TOP_TO_BOTTOM }

class SliderMenuContainer extends StatefulWidget {
  final Widget sliderMenu;
  final Widget sliderMain;
  final int sliderAnimationTimeInMilliseconds;
  final double sliderMenuOpenOffset;
  final double sliderMenuCloseOffset;
  final bool isShadow;
  final Color shadowColor;
  final double shadowBlurRadius;
  final double shadowSpreadRadius;
  final Widget trailing;
  final SliderOpen sliderOpen;

  const SliderMenuContainer({
    Key key,
    this.sliderMenu,
    this.sliderMain,
    this.sliderAnimationTimeInMilliseconds = 200,
    this.sliderMenuOpenOffset = 265,
    this.trailing,
    this.sliderMenuCloseOffset = 0,
    this.sliderOpen = SliderOpen.LEFT_TO_RIGHT,
    this.isShadow = false,
    this.shadowColor = Colors.grey,
    this.shadowBlurRadius = 25.0,
    this.shadowSpreadRadius = 5.0,
  })  : assert(sliderMenu != null),
        assert(sliderMain != null),
        super(key: key);

  @override
  SliderMenuContainerState createState() => SliderMenuContainerState();
}

class SliderMenuContainerState extends State<SliderMenuContainer>
    with SingleTickerProviderStateMixin {
  double _slideBarXOffset = 0;
  double _slideBarYOffset = 0;
  bool _isSlideBarOpen = false;
  AnimationController _animationController;

  Widget drawerIcon;

  /// check whether drawer is open
  bool get isDrawerOpen => _isSlideBarOpen;

  /// Toggle drawer
  void toggle() {
    setState(() {
      _isSlideBarOpen
          ? _animationController.reverse()
          : _animationController.forward();
      if (widget.sliderOpen == SliderOpen.LEFT_TO_RIGHT ||
          widget.sliderOpen == SliderOpen.RIGHT_TO_LEFT) {
        _slideBarXOffset = _isSlideBarOpen
            ? widget.sliderMenuCloseOffset
            : widget.sliderMenuOpenOffset;
      } else {
        _slideBarYOffset = _isSlideBarOpen
            ? widget.sliderMenuCloseOffset
            : widget.sliderMenuOpenOffset;
      }

      _isSlideBarOpen = !_isSlideBarOpen;
    });
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// Open drawer
  void openDrawer() {
    setState(() {
      _animationController.forward();
      if (widget.sliderOpen == SliderOpen.LEFT_TO_RIGHT ||
          widget.sliderOpen == SliderOpen.RIGHT_TO_LEFT) {
        _slideBarXOffset = widget.sliderMenuOpenOffset;
      } else {
        _slideBarYOffset = widget.sliderMenuOpenOffset;
      }
      _isSlideBarOpen = true;
    });
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// Close drawer
  void closeDrawer() {
    setState(() {
      _animationController.reverse();
      if (widget.sliderOpen == SliderOpen.LEFT_TO_RIGHT ||
          widget.sliderOpen == SliderOpen.RIGHT_TO_LEFT) {
        _slideBarXOffset = widget.sliderMenuCloseOffset;
      } else {
        _slideBarYOffset = widget.sliderMenuCloseOffset;
      }
      _isSlideBarOpen = false;
    });
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration:
            Duration(milliseconds: widget.sliderAnimationTimeInMilliseconds));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(children: <Widget>[
      /// Display Menu
      menuWidget(),

      /// Displaying the  shadow
      if (widget.isShadow) ...[
        AnimatedContainer(
          duration:
              Duration(milliseconds: widget.sliderAnimationTimeInMilliseconds),
          curve: Curves.easeIn,
          width: double.infinity,
          height: double.infinity,
          transform: getTranslationValuesForShadow(widget.sliderOpen),
          decoration: BoxDecoration(shape: BoxShape.rectangle, boxShadow: [
            BoxShadow(
              color: widget.shadowColor,
              blurRadius: widget.shadowBlurRadius, // soften the shadow
              spreadRadius: widget.shadowSpreadRadius, //extend the shadow
              offset: Offset(
                15.0, // Move to right 10  horizontally
                15.0, // Move to bottom 10 Vertically
              ),
            )
          ]),
        ),
      ],

      /// Display Main Screen
      AnimatedContainer(
          duration:
              Duration(milliseconds: widget.sliderAnimationTimeInMilliseconds),
          curve: Curves.easeIn,
          width: double.infinity,
          height: double.infinity,
          color: Colors.white,
          transform: getTranslationValues(widget.sliderOpen),
          child: widget.sliderMain),
    ]));
  }

  /// Build and Align the Menu widget based on the slide open type
  menuWidget() {
    switch (widget.sliderOpen) {
      case SliderOpen.LEFT_TO_RIGHT:
        return Container(
          width: widget.sliderMenuOpenOffset,
          child: widget.sliderMenu,
        );
        break;
      case SliderOpen.RIGHT_TO_LEFT:
        return Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          child: Container(
            width: widget.sliderMenuOpenOffset,
            child: widget.sliderMenu,
          ),
        );
      case SliderOpen.TOP_TO_BOTTOM:
        return Positioned(
          right: 0,
          left: 0,
          top: 0,
          child: Container(
            width: widget.sliderMenuOpenOffset,
            child: widget.sliderMenu,
          ),
        );
        break;
    }
  }

  ///
  /// This method get Matrix4 data base on [sliderOpen] type
  ///
  Matrix4 getTranslationValues(SliderOpen sliderOpen) {
    switch (sliderOpen) {
      case SliderOpen.LEFT_TO_RIGHT:
        return Matrix4.translationValues(
            _slideBarXOffset, _slideBarYOffset, 1.0);
      case SliderOpen.RIGHT_TO_LEFT:
        return Matrix4.translationValues(
            -_slideBarXOffset, _slideBarYOffset, 1.0);

      case SliderOpen.TOP_TO_BOTTOM:
        return Matrix4.translationValues(0, _slideBarYOffset, 1.0);

      default:
        return Matrix4.translationValues(0, 0, 1.0);
    }
  }

  Matrix4 getTranslationValuesForShadow(SliderOpen sliderOpen) {
    switch (sliderOpen) {
      case SliderOpen.LEFT_TO_RIGHT:
        return Matrix4.translationValues(
            _slideBarXOffset - 30, _slideBarYOffset, 1.0);
      case SliderOpen.RIGHT_TO_LEFT:
        return Matrix4.translationValues(
            -_slideBarXOffset - 5, _slideBarYOffset, 1.0);

      case SliderOpen.TOP_TO_BOTTOM:
        return Matrix4.translationValues(0, _slideBarYOffset - 20, 1.0);

      default:
        return Matrix4.translationValues(0, 0, 1.0);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
