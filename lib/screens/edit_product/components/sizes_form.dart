import 'package:bhop/common/custom_icon_button.dart';
import 'package:bhop/models/product.dart';
import 'package:bhop/models/product_size.dart';
import 'package:bhop/screens/edit_product/components/edit_item_size.dart';
import 'package:flutter/material.dart';

class SizesForm extends StatelessWidget {
  const SizesForm(this.product);
  final Product product;
  @override
  Widget build(BuildContext context) {
    return FormField<List<ProductSize>>(
      initialValue: product.sizes,
      validator: (sizes) {
        if (sizes.isEmpty) return 'Insira um tamanho';
        return null;
      },
      builder: (state) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    initialValue: product.subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                        border: InputBorder.none, hintText: 'Título'),
                    maxLines: null,
                    validator: (desc) {
                      if (desc.isEmpty) return 'Descrição muito curta';
                      return null;
                    },
                    onSaved: (sub) => product.subtitle = sub,
                  ),
                ),
                CustomIconButton(
                  iconData: Icons.add,
                  color: Colors.black,
                  onTap: () {
                    state.value.add(ProductSize());
                    state.didChange(state.value);
                  },
                )
              ],
            ),
            Column(
              children: state.value.map((size) {
                return EditItemSize(
                  key: ObjectKey(size),
                  size: size,
                  onRemove: () {
                    state.value.remove(size);
                    state.didChange(state.value);
                  },
                  onMoveUp: size != state.value.first
                      ? () {
                          final index = state.value.indexOf(size);
                          state.value.remove(size);
                          state.value.insert(index - 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                  onMoveDown: size != state.value.last
                      ? () {
                          final index = state.value.indexOf(size);
                          state.value.remove(size);
                          state.value.insert(index + 1, size);
                          state.didChange(state.value);
                        }
                      : null,
                );
              }).toList(),
            ),
            if (state.hasError)
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  state.errorText,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                  ),
                ),
              )
          ],
        );
      },
    );
  }
}
