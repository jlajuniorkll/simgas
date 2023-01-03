import 'package:dartt_shop/src/config/custom_colors.dart';
import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  OrderStatusWidget({Key? key, required this.status, required this.isOverDue})
      : super(key: key);

  final String status;
  final bool isOverDue;

  final Map<String, int> allStatus = <String, int>{
    'pending_payment': 0,
    'refunded': 1,
    'paid': 2,
    'preparing_purchase': 3,
    'shipping': 4,
    'delivered': 5,
  };

  int get currentStatus => allStatus[status]!;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const StatusDot(isActive: true, title: "Aguardando Pagamento"),
        const CustomDivider(),
        if (currentStatus == 1) ...[
          const StatusDot(
            isActive: true,
            title: "Pix Estornado",
            backgroundColor: Colors.orange,
          ),
        ] else if (isOverDue) ...[
          const StatusDot(
            isActive: true,
            title: "Pix vencido",
            backgroundColor: Colors.red,
          )
        ] else ...[
          StatusDot(isActive: currentStatus >= 2, title: "Pix Pago"),
          const CustomDivider(),
          StatusDot(isActive: currentStatus >= 3, title: "Preparando"),
          const CustomDivider(),
          StatusDot(isActive: currentStatus >= 4, title: "Envio"),
          const CustomDivider(),
          StatusDot(isActive: currentStatus >= 5, title: "Entregue"),
        ]
      ],
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 10,
      width: 2,
      color: Colors.grey.shade300,
    );
  }
}

class StatusDot extends StatelessWidget {
  const StatusDot(
      {Key? key,
      required this.isActive,
      required this.title,
      this.backgroundColor})
      : super(key: key);
  final bool isActive;
  final String title;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: CustomColors.customSwatchColor),
              color: isActive
                  ? backgroundColor ?? CustomColors.customSwatchColor
                  : Colors.transparent),
          child: isActive
              ? const Icon(
                  Icons.check,
                  size: 13,
                  color: Colors.white,
                )
              : const SizedBox.shrink(),
        ),
        const SizedBox(
          width: 5,
        ),
        Expanded(
            child: Text(
          title,
          style: const TextStyle(fontSize: 12.0),
        ))
      ],
    );
  }
}
