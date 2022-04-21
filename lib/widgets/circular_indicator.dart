import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CircIndicator extends StatefulWidget {
  final double leve;
  const CircIndicator({Key? key, required this.leve}) : super(key: key);

  @override
  State<CircIndicator> createState() => _CircIndicatorState();
}

class _CircIndicatorState extends State<CircIndicator> {
  late Stream wsData;
  double num = 40;

  @override
  Widget build(BuildContext context) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(
          minimum: 0,
          maximum: 100,
          showLabels: false,
          showTicks: false,
          axisLineStyle: AxisLineStyle(
            thickness: 0.2,
            cornerStyle: CornerStyle.bothCurve,
            color: Color.fromARGB(30, 0, 169, 181),
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          pointers: <GaugePointer>[
            RangePointer(
              value: widget.leve,
              cornerStyle: CornerStyle.bothCurve,
              width: 0.2,
              sizeUnit: GaugeSizeUnit.factor,
            )
          ],
          annotations: <GaugeAnnotation>[
            GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Text(
                  widget.leve.toInt().toString() + '  /  100',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ))
          ]),
    ]);
  }
}
