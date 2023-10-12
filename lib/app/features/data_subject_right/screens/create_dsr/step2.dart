import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pdpa/app/config/config.dart';
import 'package:pdpa/app/shared/widgets/customs/custom_icon_button.dart';
import 'package:pdpa/app/shared/widgets/templates/pdpa_app_bar.dart';

class DSRStep2Screen extends StatefulWidget {
  const DSRStep2Screen({super.key});

  @override
  State<DSRStep2Screen> createState() => _DSRStep2ScreenState();
}

class _DSRStep2ScreenState extends State<DSRStep2Screen> {
  bool? checkboxValue1 = false;
  bool? checkboxValue2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PdpaAppBar(
        leadingIcon: _buildPopButton(),
        title: const Text('แบบฟอร์มขอใช้สิทธิ์ตามกฏหมาย'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onBackground,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: UiConfig.lineSpacing),
              Text(
                'เอกสารพิสูจน์อำนาจดำเนินการแทน',
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Text(
                'ทั้งนี้ข้าพเจ้าได้แนบเอกสารดังต่อไปนี้เพื่อการตรวจสอบอำนาจตัวตนและถิ่นที่อยู่ของผู้ยื่นคำร้องและเจ้าของข้อมูลส่วนบุคคลเพื่อให้บริษัทสามารถดำเนินการตามสิทธิที่ร้องขอได้อย่างถูกต้อง',
                textAlign: TextAlign.left,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
              _checkfile(),
              Divider(
                color: Theme.of(context)
                    .colorScheme
                    .outlineVariant
                    .withOpacity(0.5),
              ),
              _checkOtherFile()
            ],
          ),
        ),
      ),
    );
  }

  CustomIconButton _buildPopButton() {
    return CustomIconButton(
      onPressed: () => context.pop(),
      icon: Ionicons.chevron_back_outline,
      iconColor: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.onBackground,
    );
  }

  _checkfile() {
    return Column(
      children: [
        CheckboxListTile(
          side: const BorderSide(color: Color(0xff2684FF)),
          controlAffinity: ListTileControlAffinity.leading,
          value: checkboxValue1,
          onChanged: (bool? value) {
            if (value != checkboxValue1) {
              setState(() {
                checkboxValue1 = value;
              });
            }
          },
          title: Transform.translate(
            offset: const Offset(-16, 0),
            child: Text("หนังสือมอบอำนาจ",
                style: checkboxValue1 == false
                    ? Theme.of(context).textTheme.bodySmall?.copyWith()
                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
          ),
        ),
        Visibility(
          visible: checkboxValue1 == true,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'ไฟล์สำเนา ',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  Text(
                    '*',
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.textSpacing),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 280,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.7),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: 'ไม่ได้เลือกไฟล์',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: UiConfig.textSpacing),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.upload),
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  _checkOtherFile() {
    return Column(
      children: [
        CheckboxListTile(
          side: const BorderSide(color: Color(0xff2684FF)),
          controlAffinity: ListTileControlAffinity.leading,
          value: checkboxValue2,
          onChanged: (bool? value) {
            if (value != checkboxValue2) {
              setState(() {
                checkboxValue2 = value;
              });
            }
          },
          title: Transform.translate(
            offset: const Offset(-16, 0),
            child: Text("อื่นๆ ถ้ามี(โปรดระบุ)",
                style: checkboxValue2 == false
                    ? Theme.of(context).textTheme.bodySmall?.copyWith()
                    : Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary)),
          ),
        ),
        Visibility(
          visible: checkboxValue2 == true,
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'ประเภทเอกสาร ',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  Text(
                    '*',
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.textSpacing),
              Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 280,
                    child: TextFormField(
                        decoration: InputDecoration(
                      hintText: "ประเภทเอกสาร",
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1.7,
                        ),
                      ),
                    )),
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.lineSpacing),
              Row(
                children: [
                  Text(
                    'ไฟล์สำเนา ',
                    textAlign: TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  Text(
                    '*',
                    textAlign: TextAlign.left,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Theme.of(context).colorScheme.error),
                  ),
                ],
              ),
              const SizedBox(height: UiConfig.textSpacing),
              Row(
                children: [
                  Container(
                    height: 50,
                    width: 280,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.7),
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      enabled: false,
                      decoration: const InputDecoration(
                        hintText: 'ไม่ได้เลือกไฟล์',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: UiConfig.textSpacing),
                  IconButton.filled(
                    onPressed: () {},
                    icon: const Icon(Icons.upload),
                    color: Theme.of(context).colorScheme.onPrimary,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
