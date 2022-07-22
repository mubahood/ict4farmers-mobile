import 'dart:ui';

import 'package:google_maps_flutter/google_maps_flutter.dart';


class ChartSampleData {
  ChartSampleData(
      {this.x,
        this.y,
        this.xValue,
        this.yValue,
        this.secondSeriesYValue,
        this.thirdSeriesYValue,
        this.pointColor,
        this.size,
        this.text,
        this.open,
        this.close,
        this.low,
        this.high,
        this.volume});

  final dynamic x;
  final num? y;
  final dynamic xValue;
  final num? yValue;
  final num? secondSeriesYValue;
  final num? thirdSeriesYValue;
  final Color? pointColor;
  final num? size;
  final String? text;
  final num? open;
  final num? close;
  final num? low;
  final num? high;
  final num? volume;
}

class Images {

    static List<LatLng> locations = [
        new LatLng(45.121563, -122.97743),
        new LatLng(45.121563, -122.777433),
        new LatLng(45.521563, -122.377433),
        new LatLng(45.721563, -122.377433),
        new LatLng(45.621563, -122.577433),
        new LatLng(45.621563, -122.817433),
        new LatLng(45.521500, -123.117433),
        new LatLng(45.421563, -124.817433),
        new LatLng(45.321500, -125.117433),
        new LatLng(45.221563, -126.817433),
        new LatLng(45.121500, -127.117433),
      ];
    static List<String> network_links = [
    'https://images.unsplash.com/photo-1645987646706-d9e75faf952f?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
    'https://images.unsplash.com/photo-1645797139008-fb3f46fad109?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
    'https://images.unsplash.com/photo-1646127513960-5bbfe67cb394?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=687&q=80',
    'https://images.unsplash.com/photo-1643713303437-7e040b8d6cd0?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=686&q=80',
    'https://images.unsplash.com/photo-1639502165457-b82e71265119?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=686&q=80',
    'https://images.unsplash.com/photo-1639499988424-bdff2b3e70d1?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=764&q=80',
    'https://images.unsplash.com/photo-1639494344274-3a9a9f525c10?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=686&q=80',
    'https://images.unsplash.com/photo-1589881787083-0fcfec1db918?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=532&q=80',
    'https://images.unsplash.com/photo-1515161318750-781d6122e367?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=676&q=80',
    'https://images.unsplash.com/photo-1531498681050-acee0b4825a3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=694&q=80',
    'https://images.unsplash.com/photo-1531498681050-acee0b4825a3?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=694&q=81',
  ];

  ///----------------- Brand -----------------------------------//
  static String brandLogo = 'assets/brand/flutkit.png';

  ///----------------- Profile Images ------------------------------//
  static String profile1 = 'assets/images/profiles/avatar_1.jpg';
  static String profile2 = 'assets/images/profiles/avatar_2.jpg';
  static String profile3 = 'assets/images/profiles/avatar_3.jpg';
  static String profile4 = 'assets/images/profiles/avatar_4.jpg';
  static String profile5 = 'assets/images/profiles/avatar_5.jpg';
  static String profile6 = 'assets/images/profiles/avatar_6.jpg';

  static List<String> profiles = [
    'assets/images/profiles/avatar_1.jpg',
    'assets/images/profiles/avatar_2.jpg',
    'assets/images/profiles/avatar_3.jpg',
    'assets/images/profiles/avatar_4.jpg',
    'assets/images/profiles/avatar_5.jpg',
    'assets/images/profiles/avatar_6.jpg',
  ];

  //------ Place Holder ------------------//
  static String profilePlaceholder =
      'assets/images/profiles/avatar_placeholder.png';

  //------- Banner ------------//
  static String profileBanner = 'assets/images/profiles/profile_banner.jpg';

  ///-------------------------------- Icons ---------------------------------//

  // ------- Home -----------//
  static String materialDesignIcon = 'assets/icons/material_design.svg';
  static String otherDesignIcon = 'assets/icons/other_design.svg';
  static String appIcon = 'assets/icons/apps.svg';
  static String homeIcon = 'assets/icons/home.svg';
  static String svg_home = 'assets/icons/svg_home.svg';
  static String svg_chats = 'assets/icons/svg_chats.svg';
  static String svg_user = 'assets/icons/svg_user.svg';
  static String app2Icon = 'assets/icons/apps_2.svg';
  static String svg_category = 'assets/icons/svg_category.svg';
  static String svg_add = 'assets/icons/svg_add.svg';

  static String changeLogIcon = 'assets/icons/document_1.png';
  static String documentationIcon = 'assets/icons/document_2.png';

  // ------ Widgets --------//
  static String basicIcon = 'assets/icons/shapes_outline.png';
  static String topAppBarIcon = 'assets/icons/appbar_outline.png';
  static String bottomSheetIcon = 'assets/icons/download_outline.png';
  static String buttonIcon = 'assets/icons/toggle_outline.png';
  static String cardIcon = 'assets/icons/tablet_landscape_outline.png';
  static String dialogIcon = 'assets/icons/albums_outline.png';
  static String loginIcon = 'assets/icons/login_outline.png';
  static String forgotPasswordIcon = 'assets/icons/forgot_password_outline.png';
  static String resetPasswordIcon = 'assets/icons/reset_password_outline.png';
  static String subscriptionIcon = 'assets/icons/subscription_outline.png';
  static String profileIcon = 'assets/icons/profile_outline.png';
  static String splashIcon = 'assets/icons/splash_outline.png';
  static String userRegisterIcon = 'assets/icons/user_logout_outline.png';
  static String layoutModuleIcon = 'assets/icons/layout_module_outline.png';

  static String listBulletsIcon = 'assets/icons/list_bullets_outline.png';
  static String navigationIcon = 'assets/icons/navigation_outline.png';
  static String advancedIcon = 'assets/icons/maps_pin_outline.png';

  static String carouselIcon = 'assets/icons/carousel_outline.png';

  static String expansionIcon = 'assets/icons/resize_outline.png';
  static String formIcon = 'assets/icons/reader_outline.png';
  static String progressIcon = 'assets/icons/hourglass_outline.png';
  static String cartesianBarIcon = 'assets/icons/cartesian_bars_outline.png';
  static String pieChartIcon = 'assets/icons/pie_chart_outline.png';
  static String cartesianBarSyncIcon =
      'assets/icons/cartesian_bars_sync_outline.png';
  static String calendarIcon = 'assets/icons/calendar_outline.png';
  static String gaugeIcon = 'assets/icons/gauge_outline.png';
  static String sliderHorizontalIcon =
      'assets/icons/slider_horizontal_outline.png';
  static String rangeSliderHorizontalIcon =
      'assets/icons/range_slider_horizontal_outline.png';
  static String rangeSelectorIcon = 'assets/icons/range_selector_outline.png';
  static String settingIcon = 'assets/icons/setting_outline.png';
  static String logo_1 = 'assets/project/logo_1.png';
  static String logo_2 = 'assets/project/logo_1.png';

  static final String darkModeOutline = "assets/project/moon_outline.png";
  static final String lightModeOutline = "assets/project/sun_outline.png";
  static final String languageOutline = "assets/project/global_outline.png";
  static final String paragraphRTLOutline =
      "assets/project/moon_outline.png";
  static final String paragraphLTROutline =
      "assets/project/moon_outline.png";

  ///----------------- Square images ------------------------------//

  static List<String> squares = [
    'assets/images/squares/1.jpg',
    'assets/images/squares/2.jpg',
    'assets/images/squares/3.jpg',
    'assets/images/squares/4.jpg',
    'assets/images/squares/5.jpg',
    'assets/images/squares/6.jpg',
    'assets/images/squares/7.jpg',
    'assets/images/squares/8.jpg',
    'assets/images/squares/9.jpg',
    'assets/images/squares/10.jpg',
    'assets/images/squares/11.jpg',
    'assets/images/squares/12.jpg',
    'assets/images/squares/13.jpg',
    'assets/images/squares/14.jpg',
    'assets/images/squares/15.jpg',
  ];

  static List<String> portraits = [
    'assets/images/portraits/1.jpg',
    'assets/images/portraits/2.jpg',
    'assets/images/portraits/3.jpg'
  ];

  static List<String> landscapes = [
    'assets/images/landscapes/1.jpg',
    'assets/images/landscapes/2.jpg',
    'assets/images/landscapes/3.jpg'
  ];

  static List<String> places = [
    'assets/images/places/cuba.jpg',
    'assets/images/places/london.jpg',
    'assets/images/places/paris.jpg'
  ];

  ///--------------------------- Apps -------------------------------------///

  //---------------------- Shopping ------------------------------------//

  static String shoppingBannerPhoto =
      'assets/images/apps/shopping/images/cover_poster_3.jpg';
  static String shoppingOrderSuccess =
      'assets/images/apps/shopping/images/order_success.png';
  static String shoppingSplash =
      'assets/images/apps/shopping/images/splash.png';
  static String apple = 'assets/images/apps/shopping/icons/apple.png';
  static String google = 'assets/images/apps/shopping/icons/google.png';
  static String facebook = 'assets/images/apps/shopping/icons/facebook.png';
  static String shoppingProfile =
      'assets/images/apps/shopping/images/profile.jpg';
  static String discountBubble =
      'assets/images/apps/shopping/icons/discount_bubble_outline.png';
  static String discountCoupon =
      'assets/images/apps/shopping/icons/discount_coupon_outline.png';
  static String discountCircle =
      'assets/images/apps/shopping/icons/discount_circle_outline.png';

  //---------------------- Learning ------------------------------------//

  static String learningProfile1 =
      'assets/images/apps/learning/images/profile1.jpg';
  static String learningProfile2 =
      'assets/images/apps/learning/images/profile2.jpg';
  static String learningProfile3 =
      'assets/images/apps/learning/images/profile3.jpg';
  static String learningProfile4 =
      'assets/images/apps/learning/images/profile4.jpg';
  static String learningProfile5 =
      'assets/images/apps/learning/images/profile5.jpg';
  static String learningProfile =
      'assets/images/apps/learning/images/profile.jpg';
  static String document1 = 'assets/images/apps/learning/icons/document_1.png';
  static String document2 = 'assets/images/apps/learning/icons/document_2.png';
  static String document3 = 'assets/images/apps/learning/icons/document_3.png';
  static String student = 'assets/images/apps/learning/icons/student.png';
  static String teacher = 'assets/images/apps/learning/icons/teacher.png';
  static String learningSplash =
      'assets/images/apps/learning/images/splash.png';
  static String forgotPassword =
      'assets/images/apps/learning/icons/forgot_password.png';
  static String courseBanner =
      'assets/images/apps/learning/images/course_photo.png';

  //---------------------- Fitness ------------------------------------//

  static String fitnessProfile =
      'assets/images/apps/fitness/images/profile.jpg';
  static String skipping = 'assets/images/apps/fitness/images/skipping.png';
  static String running = 'assets/images/apps/fitness/images/running.png';
  static String yoga = 'assets/images/apps/fitness/images/yoga.png';
  static String fitnessLogIn = 'assets/images/apps/fitness/images/login.png';
  static String fitnessRegister =
      'assets/images/apps/fitness/images/register.png';
  static String fitnessForgotPassword =
      'assets/images/apps/fitness/images/forgot_password.png';
  static String fitnessResetPassword =
      'assets/images/apps/fitness/images/reset_password.png';
  static String fitnessSplash = 'assets/images/apps/fitness/images/splash.png';

  //---------------------- Food ------------------------------------//

  static String foodBanner = 'assets/images/apps/food/images/food_banner.jpg';
  static String masterCard = 'assets/images/brand/master_card.png';
  static String foodProfile = 'assets/images/apps/food/images/profile.jpg';
  static String foodSplash = 'assets/images/apps/food/images/splash.png';
  static String foodOrderSuccess =
      'assets/images/apps/food/images/order_success.png';
  static String foodAuthentication = 'assets/images/apps/food/icons/food.png';
  static String foodMap = 'assets/images/apps/food/images/map.png';

  //---------------------- Medical ------------------------------------//

  static String medicalProfile =
      'assets/images/apps/medical/images/profile.jpg';
}
