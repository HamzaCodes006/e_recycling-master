import 'dart:collection';

import 'package:e_recycling/model/detail.dart';
import 'package:e_recycling/user/choose_swimming_pool_water.dart';
import 'package:e_recycling/user/more_services.dart';
import 'package:e_recycling/user/choose_glass.dart';
import 'package:e_recycling/user/choose_metal.dart';
import 'package:e_recycling/user/choose_organic.dart';
import 'package:e_recycling/user/choose_paper.dart';
import 'package:e_recycling/user/choose_plastic.dart';
import 'package:e_recycling/user/details_page.dart';
import 'package:e_recycling/user/home_screen.dart';
import 'package:flutter/material.dart';

class DetailScreenProvider extends ChangeNotifier {
  int _index = 0;
  double _slider_value = 0;
  int _slider_value_int = 0;

  int get index => _index;
  int get slider_value => _slider_value_int;

  void setIndex(int value, var context) {
    if (value == 5) {
      _index=value;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MoreServices()),
      );
    }
    // else if(value==6){
    //   _index=value;
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => ChooseSwimmingPoolWater()),
    //   );
    // }

    else
     {
      _index = value;
      if (_index == 0) {
        //notifyListeners();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Details()),
        );
      }
      if (_index == 1) {
        //notifyListeners();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Details()),
        );
      }
      if (_index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Details()),
        );
      }
      if (_index == 3) {
        //notifyListeners();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Details()),
        );
      }
      if (_index == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Details()),
        );
      }
    }
  }

  void navTo(BuildContext context) {
    if (_index == 5) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MoreServices()),
      );
    } else {
      if (_index == 0) {
        //notifyListeners();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChoosePlasticAndCalculate()),
        );
      }
      if (_index == 1) {
        //notifyListeners();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChooseOrganicAndCalculate()),
        );
      }
      if (_index == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChooseGlassAndCalculate()),
        );
      }
      if (_index == 3) {
        //notifyListeners();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChooseMetalAndCalculate()),
        );
      }
      if (_index == 4) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChoosePaperAndCalculate()),
        );
      }
    }
  }

  List<DetailScreen> detail = [
    DetailScreen(
        'Plastic',
        'images/plastic_bag2.jpg',
        'Plastic bags start out as fossil fuels and end up as deadly waste in landfills and the ocean.'
            ' Birds often mistake shredded plastic bags for food, filling their stomachs with toxic debris. For hungry sea turtles,'
            ' its nearly impossible to distinguish between jellyfish and floating plastic shopping bags. '
            ' '
            'Fish eat thousands of tons of plastic a year, transferring it up the food chain to bigger fish and marine mammals. '
            'Microplastics are also consumed by people through food and in the air. It’s estimated that globally, '
            'people consume the equivalent of a credit card of plastic every week,1 and it’s expected that there will be more plastic than fish in the sea by 2050. '),
    DetailScreen(
        'Organic',
        'images/organic_image.jpg',
        'Organic waste is any material that is biodegradable and comes from either a plant or an animal. Biodegradable waste is organic material that can be broken'
            'into carbon dioxide, methane or simple organic molecules. Examples of organic waste include green waste, food waste, food-soiled paper, non-hazardous'
            'wood waste, green waste, and landscape and pruning waste'
            'Organic waste in landfills generates, methane, a potent greenhouse gas. By composting wasted food and other organics, methane emissions are significantly reduced. '
            'Compost reduces and in some cases eliminates the need for chemical fertilizers. '
            'Compost promotes higher yields of agricultural crops'),
    DetailScreen(
        'Glass',
        'images/glass_waste2.jpg',
        'The major environmental impact of glass production is caused by atmospheric emissions from melting activities '
            'The combustion of natural gas/fuel oil and the decomposition of raw materials during the melting lead to the emission of CO2. This is the only greenhouse gas emitted during the production of glass.'
            'Sulphur dioxide (SO2) from the fuel and/or from decomposition of sulphate in the batch materials can contribute to acidification.'
            'Nitrogen oxides (NOx) due to the high melting temperatures and in some cases due to decomposition of nitrogen compounds in the batch materials also contribute to acidification and formation of smog.'),
    DetailScreen(
        'Metal',
        'images/metal_waste.jpg',
        'Heavy metals are well-known environmental pollutants due to their toxicity, persistence in the environment,and bioaccumulative nature.'
            'Mining and industrial processing for extraction of mineral resources and their subsequent applications for industrial, agricultural, and economic development '
            'has led to an increase in the mobilization of these elements in the environment and disturbance of their biogeochemical cycles. '
            'Contamination of aquatic and terrestrial ecosystems with toxic heavy metals is an environmental problem of public health concern. '
            'Accumulation of potentially toxic heavy metals in biota causes a potential health threat to their consumers including humans'),
    DetailScreen(
        'Paper',
        'images/paper_waste.jpg',
        'Deforestation is the primary effect of our mindless use of paper'
            'Paper pollution is another effect of paper waste and it’s a serious problem. It is estimated that by 2020, '
            'paper mills will be producing 500,000,000 tons of paper and paperboard each year! '
            'We obviously need this product and a reduction of use is not in the horizon. '
            'Pulp and paper is the 3rd largest industrial polluter of air, water and soil. '
            'Chlorine-based bleaches are used during production which results in toxic materials being released into our water, air and soil.'
            ' When paper rots, it emits methane gas which is 25 times more toxic than CO2'
            'Producing 42 million tons of paper require'
            '712 million trees'
            '1,165 millions tons of water'
            '78 million tons of oil')
  ];

  UnmodifiableListView<DetailScreen> get _detail =>
      UnmodifiableListView(detail);

  addDetail(DetailScreen detailScreen) {
    detail.add(detailScreen);
    notifyListeners();
  }

  double responsive_home(double height, double width) {
    if (height < 700) {
      return 0;
    } else if (height > 700 && height < 750) {
      return 20;
    } else {
      return 50;
    }
  }

  double responsive_detailPage_expandedHeight(double height) {
    if (height < 700) {
      return 220;
    } else if (height > 700 && height < 750) {
      return 220;
    } else if (height > 750 && height < 850) {
      return 220;
    } else {
      return 300;
    }
  }

  setSliderValue(double value) {
    _slider_value = value;
    _slider_value_int = _slider_value.round();

    notifyListeners();
  }

  double chooseImageAsset(double height, double width) {
    if (height < 300) {
      return 80;
    } else if (height > 700 && height < 750) {
      return 80;
    } else if (height > 750 && height < 800) {
      return 90;
    } else if (height > 800 && height < 850) {
      return 110;
    } else {
      return 120;
    }
  }

  double chooseMargin(double height) {
    if (height < 300) {
      return 10;
    } else if (height > 300 && height < 350) {
      return 15;
    } else if (height > 350 && height < 400) {
      return 20;
    } else if (height > 400 && height < 450) {
      return 25;
    } else {
      return 28;
    }
  }

  double user_profile_sizeBox(double height) {
    if (height < 700) {
      return 50;
    } else if (height > 700 && height < 750) {
      return 50;
    } else if (height > 750 && height < 850) {
      return 80;
    } else {
      return 120;
    }
  }

  // double cart_screen_icon(double height) {
  //   if (height < 700) {
  //     return 40;
  //   } else if (height > 700 && height < 750) {
  //     return 85;
  //   } else if (height > 750 && height < 850) {
  //     return 60;
  //   } else {
  //     return 90;
  //   }
  //}
double cart_width_icon(double width){
 if(width<300){
   return 40;
 }
 else if(width>300 && width<320){
   return 45;
 }
 else if(width>320 && width<340){
   return 50;
 }
 else if(width>340 && width<350){
   return 55;
 }
 else if(width>350 && width<=365){
   return 85;
 }
 else if(width>365 && width<395){
   return 50;
 }
 else if(width>400 && width<413){
   return 147;
 }
 else{
   return 90;
 }
}
}
