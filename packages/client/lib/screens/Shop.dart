import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../widgets/shop/ShopItem.dart';

class Shop extends StatelessWidget {
  const Shop({super.key});

  static const route = '/shop';

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ShopItem(
        title: "Bio c'est bon",
        type: "Bon d'achat",
        image:
            "https://s3-alpha-sig.figma.com/img/3a1c/952c/4f1a4039d306f6c5af928492ead5bcba?Expires=1674432000&Signature=ezal~zgfVRdezh0BZ5agN05ej0cRolUSCWh98vDhUO3IbTg~fgEZFnx9mFSMuqLKTmnoRAq~Il66SFnZUGtfHoMftlTsjXqGhCnJiSrGWtQ6UBmmVe-FQqs7G6N~du4I0DEJVqPZ40uyJyr7-HOFmJbdsDf8vgSp4CJ23enoUOli5C0Kjfu8E-Fb6gIjpUNHNbJ08Zcu43A1oOGYPwoKzgXsqEkSNCzKBVLJYrtGSJIwm-KL585SXRjkns~ruh7iVccL7yPqMBCYhVC~iUdmJo~-FoMBiv5m7TYJ-OqvKN0J~61rzvhCO9OEZVtV4EDYyWwZ~8kANaiYokURc804JA__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
        value: 5,
        price: 50,
      ),
      ShopItem(
        title: "Concert caritatif",
        type: "Place",
        image:
            "https://s3-alpha-sig.figma.com/img/f93f/db5a/50be433f8daec32e16494996442e06f4?Expires=1674432000&Signature=SCKDnGpiyld2yAdj5cOkDJesLlHonMFU4RGjrM1IFKQMdRgdxLPyv0x1j6HGRvWi0PTwrA6yHXCE7CbBIrzdJUslkdPixC7tMPHH~zk5fJlFXZK4ZVWJJKspZw3IBjowa2RuBXdzcrU8LmIolrjeFysUbV8GgYu9GL17Dwx2TyQhGplUrfDdbTp5nJczZm8Uw2s-zt8Z97y9FAYSeH5qUfbx6MrwXygt2YwQ7UHUSQdIqoL87fdh9TyOog6nhQWPoeL4zD8bYqrQA1eVSX6Ef2-cQjVfCHd4W6al74E8hQQ3yJ~OhdpkyaCffn~CLDBRfxgZL8MeJrHmLqkkmStyRQ__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
        value: 20,
        price: 200,
      ),
      ShopItem(
        title: "Nature & Decouvertes",
        type: "Bon d'achat",
        image:
            "https://s3-alpha-sig.figma.com/img/0b79/9bb3/de3b9ceda610551bbfc9267d06960cdb?Expires=1674432000&Signature=fKFNzMMSayP7lGhhTslL0vGwn3XPVv7YZ9gZ2xMbpc2zO7ErZWsj4mo98RLl-Cl0j~Cb2vJ5BA4K8aRk70HiUygjIwxG3fr~t3BTR7P~kPE8SoV1EXBrDLbvzvC9-G6gBc79qrMLrmqMEmcbqBNZhzcsCn9uAqTviimjViQE2gR5AdnW3AxdC5H5Tobm2PzOspGIiebh2zkk5Dx0cON3HN9h6NCKHujYTTQ7YcWFSZLbksFLttVAcnZuTrGl9jjP2k3kmZaJqL-3Zn8UtWtCS4kc4PErFm13TcdLqYmKORnzLyNT7eOVINUP0jKHzdNXDgEQDg5zTo1YOF2v3CdwhA__&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4",
        value: 5,
        price: 50,
      )
    ]);
  }
}
